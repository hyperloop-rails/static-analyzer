class Post < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  acts_as_taggable #solved

  has_many                :comments, :dependent => :destroy
  has_many                :approved_comments, :class_name => 'Comment'

  before_validation       :generate_slug
  before_validation       :set_dates
  before_save             :apply_filter

  validates               :title, :slug, :body, :presence => true

  validate                :validate_published_at_natural
		##################################
		#### acts_as_taggable begin ######

		has_many :taggings, :dependent => :destroy, :foreign_key => 'taggable_id' # :as => :taggable, #:include => :tag, 
    has_many :tags, :through => :taggings

    before_save :save_cached_tag_list
    after_save :save_tags

		def tag_list
      return @tag_list if @tag_list

      if self.class.caching_tag_list? and !(cached_value = send(self.class.cached_tag_list_column_name)).nil?
        @tag_list = TagList.from(cached_value)
      else
        @tag_list = TagList.new(*tags.map(&:name))
      end
    end

    def tag_list=(value)
      @tag_list = TagList.from(value)
    end

    def save_cached_tag_list
      if self.class.caching_tag_list?
        self[self.class.cached_tag_list_column_name] = tag_list.to_s
      end
    end

    def save_tags
      return unless @tag_list

      new_tag_names = @tag_list - tags.map(&:name)
      old_taggings = taggings.reject { |tagging| @tag_list.include?(tagging.tag.name) }

      self.class.transaction do
        old_taggings.each {|tag| taggings.destroy(tag)}

        new_tag_names.each do |new_tag_name|
          tags << Tag.find_or_create_with_like_by_name(new_tag_name)
        end
      end

      true
		end

    # Calculate the tag counts for the tags used by this model.
    #
    # The possible options are the same as the tag_counts class method, excluding :conditions.
    def tag_counts(options = {})
			Tag.find(:all, find_options_for_tag_counts(options))
    end

  def validate_published_at_natural
    if published_at_natural.present? && !published?
      errors.add("published_at_natural", "Unable to parse time")
    end
  end

  attr_accessor :minor_edit
  def minor_edit
    @minor_edit ||= "1"
  end

  def minor_edit?
    self.minor_edit == "1"
  end

  def published?
    published_at?
  end

  attr_accessor :published_at_natural
  def published_at_natural
    @published_at_natural ||= published_at.send_with_default(:strftime, '', "%Y-%m-%d %H:%M")
  end

  class << self
    def build_for_preview(params)
      post = Post.new(params)
      post.generate_slug
      post.set_dates
      post.apply_filter
      TagList.from(params[:tag_list]).each do |tag|
        post.tags << Tag.new(:name => tag)
      end
      post
    end

    def find_recent(options = {})
      tag = options.delete(:tag)
      include_tags = options[:include] == :tags
      order = 'published_at DESC'
      conditions = ['published_at < ?', Time.zone.now]
      limit = options[:limit] ||= DEFAULT_LIMIT

      options = {
        :order      => order,
        :conditions => conditions,
        :limit      => limit
      }.merge(options)

      if tag
        find_tagged_with(tag, options)
      else
        result = where(conditions)
        result = result.includes(:tags) if include_tags
        result.order(order).limit(limit)
      end
    end

    def find_by_permalink(year, month, day, slug, options = {})
      begin
        day = Time.parse([year, month, day].collect(&:to_i).join("-")).midnight
        result = where(['slug = ?', slug])

        if !options.empty? && options[:include].present?
          result = result.includes(:approved_comments) if options[:include].include?(:approved_comments)
          result = result.includes(:tags) if options[:include].include?(:tags)
        end

        post = result.detect do |post|
          [:year, :month, :day].all? {|time|
            post.published_at.send(time) == day.send(time)
          }
        end
      rescue ArgumentError # Invalid time
        post = nil
      end
      post || raise(ActiveRecord::RecordNotFound)
    end

    def find_all_grouped_by_month
      posts = where(['published_at < ?', Time.now]).order('published_at DESC')
      month = Struct.new(:date, :posts)
      posts.group_by(&:month).inject([]) {|a, v| a << month.new(v[0], v[1])}
    end
  end

  def destroy_with_undo
    transaction do
      undo = DeletePostUndo.create_undo(self)
      self.destroy
      return undo
    end
  end

  def month
    published_at.beginning_of_month
  end

  def apply_filter
    self.body_html = EnkiFormatter.format_as_xhtml(self.body)
  end

  def set_dates
    self.edited_at = Time.now if self.edited_at.nil? || !minor_edit?
    unless self.published_at_natural.nil?
      if self.published_at_natural.blank?
        self.published_at = nil
      elsif new_published_at = Chronic.parse(self.published_at_natural)
        self.published_at = new_published_at
      end
    end
  end

  def denormalize_comments_count!
    update_column(:approved_comments_count, self.approved_comments.count)
  end

  def generate_slug
    self.slug = self.title.dup if self.slug.blank?
    self.slug.slugorize!
  end

  def tag_list=(value)
    value = value.split(',') if value.is_a?(String)
    value.map!{ |tag_name| Tag::filter_name(tag_name) }

    # TODO: Contribute this back to acts_as_taggable_on_steroids plugin
    value = value.join(", ") if value.respond_to?(:join)
    super(value)
  end
end
