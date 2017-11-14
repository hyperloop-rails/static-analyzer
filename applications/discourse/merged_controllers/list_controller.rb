require_dependency 'topic_list_responder'

class ListController < ApplicationController
  include TopicListResponder

  skip_before_filter :check_xhr

  before_filter :set_category, only: [
    # filtered topics lists
    Discourse.filters.map { |f| :"category_#{f}" },
    Discourse.filters.map { |f| :"category_none_#{f}" },
    Discourse.filters.map { |f| :"parent_category_category_#{f}" },
    Discourse.filters.map { |f| :"parent_category_category_none_#{f}" },
    # top summaries
    :category_top,
    :category_none_top,
    :parent_category_category_top,
    # top pages (ie. with a period)
    TopTopic.periods.map { |p| :"category_top_#{p}" },
    TopTopic.periods.map { |p| :"category_none_top_#{p}" },
    TopTopic.periods.map { |p| :"parent_category_category_top_#{p}" },
    # category feeds
    :category_feed,
  ].flatten

  before_filter :ensure_logged_in, except: [
    :topics_by,
    # anonymous filters
    Discourse.anonymous_filters,
    Discourse.anonymous_filters.map { |f| "#{f}_feed" },
    # anonymous categorized filters
    Discourse.anonymous_filters.map { |f| :"category_#{f}" },
    Discourse.anonymous_filters.map { |f| :"category_none_#{f}" },
    Discourse.anonymous_filters.map { |f| :"parent_category_category_#{f}" },
    Discourse.anonymous_filters.map { |f| :"parent_category_category_none_#{f}" },
    # category feeds
    :category_feed,
    # top summaries
    :top,
    :category_top,
    :category_none_top,
    :parent_category_category_top,
    # top pages (ie. with a period)
    TopTopic.periods.map { |p| :"top_#{p}" },
    TopTopic.periods.map { |p| :"category_top_#{p}" },
    TopTopic.periods.map { |p| :"category_none_top_#{p}" },
    TopTopic.periods.map { |p| :"parent_category_category_top_#{p}" },
  ].flatten

  # Create our filters
  Discourse.filters.each do |filter|
    define_method(filter) do |options = nil|
      list_opts = build_topic_list_options
      list_opts.merge!(options) if options
      user = list_target_user

      if params[:category].blank?
        if filter == :latest
          list_opts[:no_definitions] = true
        end
        if filter.to_s == current_homepage
          list_opts[:exclude_category_ids] = get_excluded_category_ids(list_opts[:category])
        end
      end

      list = TopicQuery.new(user, list_opts).public_send("list_#{filter}")

      list.more_topics_url = construct_url_with(:next, list_opts)
      list.prev_topics_url = construct_url_with(:prev, list_opts)
      if Discourse.anonymous_filters.include?(filter)
        @description = SiteSetting.site_description
        @rss = filter

        # Note the first is the default and we don't add a title
        if (filter.to_s != current_homepage) && use_crawler_layout?
          filter_title = I18n.t("js.filters.#{filter.to_s}.title", count: 0)
          if list_opts[:category]
            @title = I18n.t('js.filters.with_category', filter: filter_title, category: Category.find(list_opts[:category]).name)
          else
            @title = I18n.t('js.filters.with_topics', filter: filter_title)
          end
        end
      end

      respond_with_list(list)
    end

    define_method("category_#{filter}") do
      canonical_url "#{Discourse.base_url_no_prefix}#{@category.url}"
      self.send(filter, category: @category.id)
    end

    define_method("category_none_#{filter}") do
      self.send(filter, category: @category.id, no_subcategories: true)
    end

    define_method("parent_category_category_#{filter}") do
      canonical_url "#{Discourse.base_url_no_prefix}#{@category.url}"
      self.send(filter, category: @category.id)
    end

    define_method("parent_category_category_none_#{filter}") do
      self.send(filter, category: @category.id)
    end
  end

  [:topics_by, :private_messages, :private_messages_sent, :private_messages_unread, :private_messages_archive, :private_messages_group, :private_messages_group_archive].each do |action|
    define_method("#{action}") do
      list_opts = build_topic_list_options
      target_user = fetch_user_from_params(include_inactive: current_user.try(:staff?))
      guardian.ensure_can_see_private_messages!(target_user.id) unless action == :topics_by
      list = generate_list_for(action.to_s, target_user, list_opts)
      url_prefix = "topics" unless action == :topics_by
      list.more_topics_url = url_for(construct_url_with(:next, list_opts, url_prefix))
      list.prev_topics_url = url_for(construct_url_with(:prev, list_opts, url_prefix))
      respond_with_list(list)
    end
  end

  def latest_feed
    discourse_expires_in 1.minute

    @title = "#{SiteSetting.title} - #{I18n.t("rss_description.latest")}"
    @link = "#{Discourse.base_url}/latest"
    @atom_link = "#{Discourse.base_url}/latest.rss"
    @description = I18n.t("rss_description.latest")
    @topic_list = TopicQuery.new(nil, order: 'created').list_latest

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if include_crawler_content? 
 if @category 
 if @category.parent_category 
 link_to @category.parent_category.url, itemprop: 'item' do 
 @category.parent_category.name 
 end 
 end 
 link_to @category.url, itemprop: 'item' do 
 @category.name 
 end 
 end 
 @list.topics.each_with_index do |t,i| 
 t.url 
 t.relative_url 
 t.title 
 page_links(t) 
 if (!@category || @category.has_children?) && t.category 
 t.category.url 
 t.category.name 
 end 
 t 'posts' 
t.last_post_url
 t.posts_count 
 end 
 if @list.topics.length > 0 && @list.more_topics_url 
 if params[:page].to_i > 0 
 @list.prev_topics_url 
 t 'prev_page' 
 end 
 @list.more_topics_url 
 t 'next_page' 
 end 
 end 
 if @rss 
 content_for :head do 
 auto_discovery_link_tag(:rss, "#{Discourse.base_url}/posts.rss", title: I18n.t("rss_description.posts")) 
 auto_discovery_link_tag(:rss, { action: "#{@rss}_feed" }, title: I18n.t("rss_description.#{@rss}")) 
 end 
 end 
 if @category 
 content_for :head do 
 auto_discovery_link_tag(:rss, { action: :category_feed }, title: t('rss_topics_in_category', category: @category.name)) 
 raw crawlable_meta_data(title: @category.name, description: @category.description) 
 end 
 end 
 if @title 
 content_for :title do 
 @title 
 end 
 elsif @category 
 content_for :title do 
 @category.name 
 end 
 elsif params[:page] 
 content_for :title do 
t 'page_num', num: params[:page].to_i + 1 
 end 
 end 

end

  end

  def top_feed
    discourse_expires_in 1.minute

    @title = "#{SiteSetting.title} - #{I18n.t("rss_description.top")}"
    @link = "#{Discourse.base_url}/top"
    @atom_link = "#{Discourse.base_url}/top.rss"
    @description = I18n.t("rss_description.top")
    @topic_list = TopicQuery.new(nil).list_top_for("monthly")

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if include_crawler_content? 
 if @category 
 if @category.parent_category 
 link_to @category.parent_category.url, itemprop: 'item' do 
 @category.parent_category.name 
 end 
 end 
 link_to @category.url, itemprop: 'item' do 
 @category.name 
 end 
 end 
 @list.topics.each_with_index do |t,i| 
 t.url 
 t.relative_url 
 t.title 
 page_links(t) 
 if (!@category || @category.has_children?) && t.category 
 t.category.url 
 t.category.name 
 end 
 t 'posts' 
t.last_post_url
 t.posts_count 
 end 
 if @list.topics.length > 0 && @list.more_topics_url 
 if params[:page].to_i > 0 
 @list.prev_topics_url 
 t 'prev_page' 
 end 
 @list.more_topics_url 
 t 'next_page' 
 end 
 end 
 if @rss 
 content_for :head do 
 auto_discovery_link_tag(:rss, "#{Discourse.base_url}/posts.rss", title: I18n.t("rss_description.posts")) 
 auto_discovery_link_tag(:rss, { action: "#{@rss}_feed" }, title: I18n.t("rss_description.#{@rss}")) 
 end 
 end 
 if @category 
 content_for :head do 
 auto_discovery_link_tag(:rss, { action: :category_feed }, title: t('rss_topics_in_category', category: @category.name)) 
 raw crawlable_meta_data(title: @category.name, description: @category.description) 
 end 
 end 
 if @title 
 content_for :title do 
 @title 
 end 
 elsif @category 
 content_for :title do 
 @category.name 
 end 
 elsif params[:page] 
 content_for :title do 
t 'page_num', num: params[:page].to_i + 1 
 end 
 end 

end

  end

  def category_feed
    guardian.ensure_can_see!(@category)
    discourse_expires_in 1.minute

    @title = @category.name
    @link = "#{Discourse.base_url}#{@category.url}"
    @atom_link = "#{Discourse.base_url}#{@category.url}.rss"
    @description = "#{I18n.t('topics_in_category', category: @category.name)} #{@category.description}"
    @topic_list = TopicQuery.new.list_new_in_category(@category)

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if include_crawler_content? 
 if @category 
 if @category.parent_category 
 link_to @category.parent_category.url, itemprop: 'item' do 
 @category.parent_category.name 
 end 
 end 
 link_to @category.url, itemprop: 'item' do 
 @category.name 
 end 
 end 
 @list.topics.each_with_index do |t,i| 
 t.url 
 t.relative_url 
 t.title 
 page_links(t) 
 if (!@category || @category.has_children?) && t.category 
 t.category.url 
 t.category.name 
 end 
 t 'posts' 
t.last_post_url
 t.posts_count 
 end 
 if @list.topics.length > 0 && @list.more_topics_url 
 if params[:page].to_i > 0 
 @list.prev_topics_url 
 t 'prev_page' 
 end 
 @list.more_topics_url 
 t 'next_page' 
 end 
 end 
 if @rss 
 content_for :head do 
 auto_discovery_link_tag(:rss, "#{Discourse.base_url}/posts.rss", title: I18n.t("rss_description.posts")) 
 auto_discovery_link_tag(:rss, { action: "#{@rss}_feed" }, title: I18n.t("rss_description.#{@rss}")) 
 end 
 end 
 if @category 
 content_for :head do 
 auto_discovery_link_tag(:rss, { action: :category_feed }, title: t('rss_topics_in_category', category: @category.name)) 
 raw crawlable_meta_data(title: @category.name, description: @category.description) 
 end 
 end 
 if @title 
 content_for :title do 
 @title 
 end 
 elsif @category 
 content_for :title do 
 @category.name 
 end 
 elsif params[:page] 
 content_for :title do 
t 'page_num', num: params[:page].to_i + 1 
 end 
 end 

end

  end

  def top(options=nil)
    options ||= {}
    period = ListController.best_period_for(current_user.try(:previous_visit_at), options[:category])
    send("top_#{period}", options)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def category_top
    top(category: @category.id)
  end

  def category_none_top
    top(category: @category.id, no_subcategories: true)
  end

  def parent_category_category_top
    top(category: @category.id)
  end

  TopTopic.periods.each do |period|
    define_method("top_#{period}") do |options = nil|
      top_options = build_topic_list_options
      top_options.merge!(options) if options
      top_options[:per_page] = SiteSetting.topics_per_period_in_top_page

      if "top".freeze == current_homepage
        top_options[:exclude_category_ids] = get_excluded_category_ids(top_options[:category])
      end

      user = list_target_user
      list = TopicQuery.new(user, top_options).list_top_for(period)
      list.for_period = period
      list.more_topics_url = construct_url_with(:next, top_options)
      list.prev_topics_url = construct_url_with(:prev, top_options)
      @rss = "top"

      if use_crawler_layout?
        @title = I18n.t("js.filters.top.#{period}.title")
      end

      respond_with_list(list)
    end

    define_method("category_top_#{period}") do
      self.send("top_#{period}", category: @category.id)
    end

    define_method("category_none_top_#{period}") do
      self.send("top_#{period}", category: @category.id, no_subcategories: true)
    end

    define_method("parent_category_category_top_#{period}") do
      self.send("top_#{period}", category: @category.id)
    end
  end

  protected

  def next_page_params(opts = nil)
    page_params(opts).merge(page: params[:page].to_i + 1)
  end

  def prev_page_params(opts = nil)
    pg = params[:page].to_i
    if pg > 1
      page_params(opts).merge(page: pg - 1)
    else
      page_params(opts).merge(page: nil)
    end
  end

  private

  def page_params(opts = nil)
    opts ||= {}
    route_params = { format: 'json' }
    route_params[:category]        = @category.slug_for_url                 if @category
    route_params[:parent_category] = @category.parent_category.slug_for_url if @category && @category.parent_category
    route_params[:order]           = opts[:order]                           if opts[:order].present?
    route_params[:ascending]       = opts[:ascending]                       if opts[:ascending].present?
    route_params
  end

  def set_category
    slug_or_id = params.fetch(:category)
    parent_slug_or_id = params[:parent_category]
    id = params[:id].to_i

    parent_category_id = nil
    if parent_slug_or_id.present?
      parent_category_id = Category.query_parent_category(parent_slug_or_id)
      redirect_or_not_found and return if parent_category_id.blank? && !id
    end

    @category = Category.query_category(slug_or_id, parent_category_id)

    # Redirect if we have `/c/:parent_category/:category/:id`
    if id
      category = Category.find_by_id(id)
      (redirect_to category.url, status: 301) && return if category
    end

    redirect_or_not_found and return if !@category

    @description_meta = @category.description_text
    raise Discourse::NotFound unless guardian.can_see?(@category)
  end

  def build_topic_list_options
    options = {
      page: params[:page],
      topic_ids: param_to_integer_list(:topic_ids),
      exclude_category_ids: params[:exclude_category_ids],
      category: params[:category],
      order: params[:order],
      ascending: params[:ascending],
      min_posts: params[:min_posts],
      max_posts: params[:max_posts],
      status: params[:status],
      filter: params[:filter],
      state: params[:state],
      search: params[:search],
      q: params[:q],
      group_name: params[:group_name]
    }
    options[:no_subcategories] = true if params[:no_subcategories] == 'true'
    options[:slow_platform] = true if slow_platform?

    options
  end

  def list_target_user
    if params[:user_id] && guardian.is_staff?
      User.find(params[:user_id].to_i)
    else
      current_user
    end
  end

  def generate_list_for(action, target_user, opts)
    TopicQuery.new(current_user, opts).send("list_#{action}", target_user)
  end

  def construct_url_with(action, opts, url_prefix = nil)
    method = url_prefix.blank? ? "#{action_name}_path" : "#{url_prefix}_#{action_name}_path"
    url = if action == :prev
      public_send(method, opts.merge(prev_page_params(opts)))
    else # :next
      public_send(method, opts.merge(next_page_params(opts)))
    end
    url.sub('.json?','?')
  end

  def get_excluded_category_ids(current_category=nil)
    exclude_category_ids = Category.where(suppress_from_homepage: true)
    exclude_category_ids = exclude_category_ids.where.not(id: current_category) if current_category
    exclude_category_ids.pluck(:id)
  end

  def self.best_period_for(previous_visit_at, category_id=nil)
    best_periods_for(previous_visit_at).each do |period|
      top_topics = TopTopic.where("#{period}_score > 0")
      top_topics = top_topics.joins(:topic).where("topics.category_id = ?", category_id) if category_id
      return period if top_topics.count >= SiteSetting.topics_per_period_in_top_page
    end
    # default period is yearly
    SiteSetting.top_page_default_timeframe
  end

  def self.best_periods_for(date)
    date ||= 1.year.ago
    periods = []
    periods << :daily   if date >   8.days.ago
    periods << :weekly  if date >  35.days.ago
    periods << :monthly if date > 180.days.ago
    periods << :yearly
    periods
  end

  def redirect_or_not_found
    url = request.fullpath
    permalink = Permalink.find_by_url(url)

    if permalink.present?
      # permalink present, redirect to that URL
      if permalink.external_url
        redirect_to permalink.external_url, status: :moved_permanently
      elsif permalink.target_url
        redirect_to "#{Discourse::base_uri}#{permalink.target_url}", status: :moved_permanently
      else
        raise Discourse::NotFound
      end
    else
      # redirect to 404
      raise Discourse::NotFound
    end
  end

end
