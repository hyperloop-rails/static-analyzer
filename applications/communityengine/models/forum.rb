class Forum < ActiveRecord::Base
  acts_as_taggable #resoved
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


  acts_as_list

  validates_presence_of :name

  has_many :moderatorships, :dependent => :destroy
  has_many :moderators, :through => :moderatorships, :source => :user

  has_many :topics, :dependent => :destroy

  has_many :sb_posts

  belongs_to :owner, :polymorphic => true

  format_attribute :description
  
  def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end
  
end
