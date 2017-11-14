class Clipping < ActiveRecord::Base

  acts_as_moderated_commentable
  belongs_to :user
  validates_presence_of :user
  validates_presence_of :url
  validates_presence_of :image_url

  before_validation :add_image
  validates_associated :image
  validates_presence_of :image
  after_save :save_image

  has_one  :image, :as => :attachable, :class_name => "ClippingImage", :dependent => :destroy
  has_many :favorites, :as => :favoritable, :dependent => :destroy

  acts_as_taggable  #resolved
		##################################
		#### acts_as_taggable begin ######

		has_many :taggings, :dependent => :destroy, :foreign_key => 'taggable_id' # :as => :taggable, #:include => :tag, 
    has_many :tags, :through => :taggings

    before_save :save_cached_tag_list
    after_save :save_tags

		def self.recent
lambda { order('clippings.created_at DESC') }
end

def self.recent
lambda { order('clippings.created_at DESC') }
end

def self.recent
lambda { order('clippings.created_at DESC') }
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
  acts_as_activity :user

  scope :recent, lambda { order('clippings.created_at DESC') }

  def self.find_related_to(clipping, options = {})
    options.reverse_merge!({:limit => 8,
        :order => 'created_at DESC',
        :conditions => [ 'clippings.id != ?', clipping.id ]
    })

    limit(options[:limit]).
      order(options[:order]).
      where(options[:conditions]).
      tagged_with(clipping.tags.collect{|t| t.name }, :any => true)
  end

  def self.find_recent(options = {:limit => 5})
    where("created_at > '#{7.days.ago.iso8601}'").order("created_at DESC").limit(options[:limit])
  end

  def previous_clipping
    self.user.clippings.order('created_at DESC').where('created_at < ?', self.created_at).first
  end
  def next_clipping
    self.user.clippings.where('created_at > ?', self.created_at).order('created_at ASC').first
  end

  def owner
    self.user
  end

  def image_uri(size = '')
    image && image.asset.url(size) || image_url
  end

  def title_for_rss
    description.empty? ? created_at.to_formatted_s(:long) : description
  end

  def has_been_favorited_by(user = nil, remote_ip = nil)
    f = Favorite.find_by_user_or_ip_address(self, user, remote_ip)
    return f
  end

  def add_image
    begin
      clipping_image = ClippingImage.new
      uploaded_data = clipping_image.data_from_url(self.image_url)
      clipping_image.asset = uploaded_data
      self.image = clipping_image
    rescue
      nil
    end
  end

  def save_image
    if valid? && image
      image.attachable = self
      image.save
    end
  end

end
