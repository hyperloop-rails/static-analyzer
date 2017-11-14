class Photo < ActiveRecord::Base
  include UrlUpload

  acts_as_moderated_commentable
  belongs_to :album

  has_attached_file :photo, configatron.photo.paperclip_options.to_hash
  validates_attachment_presence :photo, :unless => Proc.new{|record| record.photo_remote_url }
  validates_attachment_content_type :photo, :content_type => configatron.photo.validation_options.content_type
  validates_attachment_size :photo, :less_than => configatron.photo.validation_options.max_size.to_i.megabytes

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :photo_remote_url
  after_update :reprocess_photo, :if => :cropping?

  acts_as_taggable #resolved
		##################################
		#### acts_as_taggable begin ######

		has_many :taggings, :dependent => :destroy, :foreign_key => 'taggable_id' # :as => :taggable, #:include => :tag, 
    has_many :tags, :through => :taggings

    before_save :save_cached_tag_list
    after_save :save_tags

		def self.recent
lambda { order("photos.created_at DESC") }
end

def self.new_this_week
lambda { order("photos.created_at DESC").where("photos.created_at > ?", 7.days.ago.iso8601) }
end

def self.recent
lambda { order("photos.created_at DESC") }
end

def self.new_this_week
lambda { order("photos.created_at DESC").where("photos.created_at > ?", 7.days.ago.iso8601) }
end

def self.recent
lambda { order("photos.created_at DESC") }
end

def self.new_this_week
lambda { order("photos.created_at DESC").where("photos.created_at > ?", 7.days.ago.iso8601) }
end

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

    def reload_with_tag_list(*args) #:nodoc:
      @tag_list = nil
      reload_without_tag_list(*args)
    end

		##################################
		#### acts_as_taggable end ######

  acts_as_activity :user, :if => Proc.new{|record| record.album_id.nil?}

  validates_presence_of :user

  belongs_to :user
  has_one :user_as_avatar, :class_name => "User", :foreign_key => "avatar_id", :inverse_of => :avatar

  #Named scopes
  scope :recent, lambda { order("photos.created_at DESC") }
  scope :new_this_week, lambda { order("photos.created_at DESC").where("photos.created_at > ?", 7.days.ago.iso8601) }

  def display_name
    (self.name && self.name.length>0) ? self.name : "#{:created_at.l.downcase}: #{I18n.l(self.created_at, :format => :published_date)}"
  end

  def description_for_rss
    "<a href='#{self.link_for_rss}' title='#{self.name}'><img src='#{self.photo.url(:large)}' alt='#{self.name}' /><br />#{self.description}</a>"
  end

  def owner
    self.user
  end

  def previous_photo
    self.user.photos.where('created_at < ?', created_at).first
  end
  def next_photo
    self.user.photos.where('created_at > ?', created_at).last
  end

  def previous_in_album
    return nil unless self.album
    self.user.photos.where('created_at < ? and album_id = ?', created_at, self.album.id).first
  end
  def next_in_album
    return nil unless self.album
    self.user.photos.where('created_at > ? and album_id = ?', created_at, self.album_id).last
  end


  def self.find_recent(options = {:limit => 3})
    self.new_this_week.limit(options[:limit])
  end

  def self.find_related_to(photo, options = {})
    options.reverse_merge!({:limit => 8,
        :order => 'created_at DESC',
        :conditions => ['photos.id != ?', photo.id]
    })
    limit(options[:limit]).order(options[:order]).where(options[:conditions]).tagged_with(photo.tags.collect{|t| t.name }, :any => true)
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def photo_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(photo.path(style))
  end

  def photo_remote_url=(url_value)
    data = self.data_from_url(url_value)
    self.photo = data
  end

  private

  def reprocess_photo
    photo.assign(photo)
    photo.save
  end

end
