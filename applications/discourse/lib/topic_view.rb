require_dependency 'guardian'
require_dependency 'topic_query'
require_dependency 'filter_best_posts'
require_dependency 'gaps'

class TopicView

  attr_reader :topic, :posts, :guardian, :filtered_posts, :chunk_size
  attr_accessor :draft, :draft_key, :draft_sequence, :user_custom_fields, :post_custom_fields

  def self.slow_chunk_size
    10
  end

  def self.chunk_size
    20
  end

  def self.default_post_custom_fields
    @default_post_custom_fields ||= ["action_code_who"]
  end

  def self.post_custom_fields_whitelisters
    @post_custom_fields_whitelisters ||= Set.new
  end

  def self.add_post_custom_fields_whitelister(&block)
    post_custom_fields_whitelisters << block
  end

  def self.whitelisted_post_custom_fields(user)
    wpcf = default_post_custom_fields + post_custom_fields_whitelisters.map { |w| w.call(user) }
    wpcf.flatten.uniq
  end

  def initialize(topic_id, user=nil, options={})
    @user = user
    @guardian = Guardian.new(@user)
    @topic = find_topic(topic_id)
    check_and_raise_exceptions

    options.each do |key, value|
      self.instance_variable_set("@#{key}".to_sym, value)
    end

    @page = 1 if (!@page || @page.zero?)
    @chunk_size = options[:slow_platform] ? TopicView.slow_chunk_size : TopicView.chunk_size
    @limit ||= @chunk_size

    setup_filtered_posts

    @initial_load = true
    @index_reverse = false

    filter_posts(options)

    if SiteSetting.public_user_custom_fields.present? && @posts
      @user_custom_fields = User.custom_fields_for_ids(@posts.map(&:user_id), SiteSetting.public_user_custom_fields.split('|'))
    end

    if @guardian.is_staff? && SiteSetting.staff_user_custom_fields.present? && @posts
      @user_custom_fields ||= {}
      @user_custom_fields.deep_merge!(User.custom_fields_for_ids(@posts.map(&:user_id), SiteSetting.staff_user_custom_fields.split('|')))
    end

    whitelisted_fields = TopicView.whitelisted_post_custom_fields(@user)
    if whitelisted_fields.present? && @posts
      @post_custom_fields = Post.custom_fields_for_ids(@posts.map(&:id), whitelisted_fields)
    end

    @draft_key = @topic.draft_key
    @draft_sequence = DraftSequence.current(@user, @draft_key)
  end

  def canonical_path
    path = @topic.relative_url
    path << if @post_number
      page = ((@post_number.to_i - 1) / @limit) + 1
      (page > 1) ? "?page=#{page}" : ""
    else
      (@page && @page.to_i > 1) ? "?page=#{@page}" : ""
    end
    path
  end

  def contains_gaps?
    @contains_gaps
  end

  def gaps
    return unless @contains_gaps
    Gaps.new(filtered_post_ids, unfiltered_posts.order(:sort_order).pluck(:id))
  end

  def last_post
    return nil if @posts.blank?
    @last_post ||= @posts.last
  end

  def prev_page
    if @page && @page > 1 && posts.length > 0
      @page - 1
    else
      nil
    end
  end

  def next_page
    @next_page ||= begin
      if last_post && (@topic.highest_post_number > last_post.post_number)
        @page + 1
      end
    end
  end

  def prev_page_path
    if prev_page > 1
      "#{@topic.relative_url}?page=#{prev_page}"
    else
      @topic.relative_url
    end
  end

  def next_page_path
    "#{@topic.relative_url}?page=#{next_page}"
  end

  def absolute_url
    "#{Discourse.base_url}#{@topic.relative_url}"
  end

  def relative_url
    @topic.relative_url
  end

  def page_title
    title = @topic.title
    if @topic.category_id != SiteSetting.uncategorized_category_id && @topic.category_id && @topic.category
      title += " - #{topic.category.name}"
    end
    title
  end

  def title
    @topic.title
  end

  def desired_post
    return @desired_post if @desired_post.present?
    return nil if posts.blank?

    @desired_post = posts.detect {|p| p.post_number == @post_number.to_i}
    @desired_post ||= posts.first
    @desired_post
  end

  def summary
    return nil if desired_post.blank?
    # TODO, this is actually quite slow, should be cached in the post table
    excerpt = desired_post.excerpt(500, strip_links: true, text_entities: true)
    (excerpt || "").gsub(/\n/, ' ').strip
  end

  def read_time
    return nil if @post_number.present? && @post_number.to_i != 1 # only show for topic URLs
    (@topic.word_count/SiteSetting.read_time_word_count).floor if @topic.word_count
  end

  def like_count
    return nil if @post_number.present? && @post_number.to_i != 1 # only show for topic URLs
    @topic.like_count
  end

  def image_url
    @topic.image_url || SiteSetting.default_opengraph_image_url
  end

  def filter_posts(opts = {})
    return filter_posts_near(opts[:post_number].to_i) if opts[:post_number].present?
    return filter_posts_by_ids(opts[:post_ids]) if opts[:post_ids].present?
    return filter_best(opts[:best], opts) if opts[:best].present?

    filter_posts_paged(@page)
  end

  def primary_group_names
    return @group_names if @group_names

    primary_group_ids = Set.new
    @posts.each do |p|
      primary_group_ids << p.user.primary_group_id if p.user.try(:primary_group_id)
    end

    result = {}
    unless primary_group_ids.empty?
      Group.where(id: primary_group_ids.to_a).pluck(:id, :name).each do |g|
        result[g[0]] = g[1]
      end
    end

    @group_names = result
  end

  # Find the sort order for a post in the topic
  def sort_order_for_post_number(post_number)
    posts = Post.where(topic_id: @topic.id, post_number: post_number).with_deleted
    posts = filter_post_types(posts)
    posts.select(:sort_order).first.try(:sort_order)
  end

  # Filter to all posts near a particular post number
  def filter_posts_near(post_number)
    min_idx, max_idx = get_minmax_ids(post_number)
    filter_posts_in_range(min_idx, max_idx)
  end


  def filter_posts_paged(page)
    page = [page, 1].max
    min = @limit * (page - 1)

    # Sometimes we don't care about the OP, for example when embedding comments
    min = 1 if min == 0 && @exclude_first

    max = (min + @limit) - 1

    filter_posts_in_range(min, max)
  end

  def filter_best(max, opts={})
    filter = FilterBestPosts.new(@topic, @filtered_posts, max, opts)
    @posts = filter.posts
    @filtered_posts = filter.filtered_posts
  end

  def read?(post_number)
    return true unless @user
    read_posts_set.include?(post_number)
  end

  def has_deleted?
    @predelete_filtered_posts.with_deleted
                             .where("posts.deleted_at IS NOT NULL")
                             .where("posts.post_number > 1")
                             .exists?
  end

  def topic_user
    @topic_user ||= begin
      return nil if @user.blank?
      @topic.topic_users.find_by(user_id: @user.id)
    end
  end

  def post_counts_by_user
    @post_counts_by_user ||= Post.where(topic_id: @topic.id)
                                 .where("user_id IS NOT NULL")
                                 .group(:user_id)
                                 .order("count_all DESC")
                                 .limit(24)
                                 .count
  end

  def participants
    @participants ||= begin
      participants = {}
      User.where(id: post_counts_by_user.map {|k,v| k}).each {|u| participants[u.id] = u}
      participants
    end
  end

  def all_post_actions
    @all_post_actions ||= PostAction.counts_for(@posts, @user)
  end

  def all_active_flags
    @all_active_flags ||= PostAction.active_flags_counts_for(@posts)
  end

  def links
    @links ||= TopicLink.topic_map(guardian, @topic.id)
  end

  def link_counts
    @link_counts ||= TopicLink.counts_for(guardian,@topic, posts)
  end

  # Are we the initial page load? If so, we can return extra information like
  # user post counts, etc.
  def initial_load?
    @initial_load
  end

  def suggested_topics
    @suggested_topics ||= TopicQuery.new(@user).list_suggested_for(topic)
  end

  # This is pending a larger refactor, that allows custom orders
  #  for now we need to look for the highest_post_number in the stream
  #  the cache on topics is not correct if there are deleted posts at
  #  the end of the stream (for mods), nor is it correct for filtered
  #  streams
  def highest_post_number
    @highest_post_number ||= @filtered_posts.maximum(:post_number)
  end

  def recent_posts
    @filtered_posts.by_newest.with_user.first(25)
  end


  def current_post_ids
    @current_post_ids ||= if @posts.is_a?(Array)
      @posts.map {|p| p.id }
    else
      @posts.pluck(:post_number)
    end
  end

  def filtered_post_ids
    @filtered_post_ids ||= filter_post_ids_by(:sort_order)
  end

  protected

  def read_posts_set
    @read_posts_set ||= begin
      result = Set.new
      return result unless @user.present?
      return result unless topic_user.present?

      post_numbers = PostTiming
                .where(topic_id: @topic.id, user_id: @user.id)
                .where(post_number: current_post_ids)
                .pluck(:post_number)

      post_numbers.each {|pn| result << pn}
      result
    end
  end

  private

  def filter_post_types(posts)
    visible_types = Topic.visible_post_types(@user)

    if @user.present?
      posts.where("user_id = ? OR post_type IN (?)", @user.id, visible_types)
    else
      posts.where(post_type: visible_types)
    end
  end

  def filter_posts_by_ids(post_ids)
    # TODO: Sort might be off
    @posts = Post.where(id: post_ids, topic_id: @topic.id)
                 .includes(:user, :reply_to_user)
                 .order('sort_order')
    @posts = filter_post_types(@posts)
    @posts = @posts.with_deleted if @guardian.can_see_deleted_posts?
    @posts
  end

  def filter_posts_in_range(min, max)
    post_count = (filtered_post_ids.length - 1)

    max = [max, post_count].min

    return @posts = [] if min > max

    min = [[min, max].min, 0].max

    @posts = filter_posts_by_ids(filtered_post_ids[min..max])
    @posts
  end

  def find_topic(topic_id)
    # with_deleted covered in #check_and_raise_exceptions
    finder = Topic.with_deleted.where(id: topic_id).includes(:category)
    finder.first
  end

  def unfiltered_posts
    result = filter_post_types(@topic.posts)
    result = result.with_deleted if @guardian.can_see_deleted_posts?
    result = @topic.posts.where("user_id IS NOT NULL") if @exclude_deleted_users
    result
  end

  def setup_filtered_posts
    # Certain filters might leave gaps between posts. If that's true, we can return a gap structure
    @contains_gaps = false
    @filtered_posts = unfiltered_posts

    # Filters
    if @filter == 'summary'
      @filtered_posts = @filtered_posts.summary(@topic.id)
      @contains_gaps = true
    end

    if @best.present?
      @filtered_posts = @filtered_posts.where('posts.post_type = ?', Post.types[:regular])
      @contains_gaps = true
    end

    # Username filters
    if @username_filters.present?
      usernames = @username_filters.map{|u| u.downcase}
      @filtered_posts = @filtered_posts.where('post_number = 1 OR posts.user_id IN (SELECT u.id FROM users u WHERE username_lower IN (?))', usernames)
      @contains_gaps = true
    end

    # Deleted
    # This should be last - don't want to tell the admin about deleted posts that clicking the button won't show
    # copy the filter for has_deleted? method
    @predelete_filtered_posts = @filtered_posts.spawn
    if @guardian.can_see_deleted_posts? && !@show_deleted && has_deleted?
      @filtered_posts = @filtered_posts.where("deleted_at IS NULL OR post_number = 1")
      @contains_gaps = true
    end

  end

  def check_and_raise_exceptions
    raise Discourse::NotFound if @topic.blank?
    # Special case: If the topic is private and the user isn't logged in, ask them
    # to log in!
    if @topic.present? && @topic.private_message? && @user.blank?
      raise Discourse::NotLoggedIn.new
    end
    raise Discourse::InvalidAccess.new("can't see #{@topic}", @topic) unless guardian.can_see?(@topic)
  end


  def filter_post_ids_by(sort_order)
    @filtered_posts.order(sort_order).pluck(:id)
  end

  def get_minmax_ids(post_number)
    # Find the closest number we have
    closest_index = closest_post_to(post_number)
    return nil if closest_index.nil?

    # Make sure to get at least one post before, even with rounding
    posts_before = (@limit.to_f / 4).floor
    posts_before = 1 if posts_before.zero?

    min_idx = closest_index - posts_before
    min_idx = 0 if min_idx < 0
    max_idx = min_idx + (@limit - 1)

    # Get a full page even if at the end
    ensure_full_page(min_idx, max_idx)
  end

  def ensure_full_page(min, max)
    upper_limit = (filtered_post_ids.length - 1)
    if max >= upper_limit
      return (upper_limit - @limit) + 1, upper_limit
    else
      return min, max
    end
  end

  def closest_post_to(post_number)
    # happy path
    closest_post = @filtered_posts.where("post_number = ?", post_number).limit(1).pluck(:id)

    if closest_post.empty?
      # less happy path, missing post
      closest_post = @filtered_posts.order("@(post_number - #{post_number})").limit(1).pluck(:id)
    end

    return nil if closest_post.empty?

    filtered_post_ids.index(closest_post.first) || filtered_post_ids[0]
  end

end
