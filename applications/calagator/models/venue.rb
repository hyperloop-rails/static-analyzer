# == Schema Information
# Schema version: 20110604174521
#
# Table name: venues
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  description     :text
#  address         :string(255)
#  url             :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  street_address  :string(255)
#  locality        :string(255)
#  region          :string(255)
#  postal_code     :string(255)
#  country         :string(255)
#  latitude        :decimal(, )
#  longitude       :decimal(, )
#  email           :string(255)
#  telephone       :string(255)
#  source_id       :integer
#  duplicate_of_id :integer
#  version         :integer
#  closed          :boolean
#  wifi            :boolean
#  access_notes    :text
#  events_count    :integer
#
require "calagator/decode_html_entities_hack"
require "calagator/strip_whitespace"
require "calagator/url_prefixer"
require "paper_trail"
require "loofah-activerecord"
require "loofah/activerecord/xss_foliate"
require "validate_url"


class Venue < ActiveRecord::Base
  self.table_name = "venues"

  include StripWhitespace

  has_paper_trail
  acts_as_taggable #solved

  xss_foliate :sanitize => [:description, :access_notes]
  include DecodeHtmlEntitiesHack

  # Associations
  has_many :events, -> { non_duplicates }, dependent: :nullify
  belongs_to :source

  # Triggers
  strip_whitespace! :title, :description, :address, :url, :street_address, :locality, :region, :postal_code, :country, :email, :telephone
  before_save :geocode!

  # Validations
  validates :title, presence: true
  validates :url, url: { allow_blank: true }
  validates :latitude, inclusion: { in: -90..90, allow_nil: true }
  validates :longitude, inclusion: { in: -180..180, allow_nil: true }
  validates :title, :description, :address, :url, :street_address, :locality, :region, :postal_code, :country, :email, :telephone, blacklist: true

  # Duplicates
  include DuplicateChecking
  duplicate_checking_ignores_attributes    :source_id, :version, :closed, :wifi, :access_notes
  duplicate_squashing_ignores_associations :tags, :base_tags, :taggings
  duplicate_finding_scope -> { non_duplicates.order(:title, :id) }

  # Named scopes
  scope :masters,          -> { non_duplicates.includes(:source, :events, :tags, :taggings) }
  scope :with_public_wifi, -> { where(wifi: true) }
  scope :in_business,      -> { where(closed: false) }
  scope :out_of_business,  -> { where(closed: true) }

		has_many :taggings, :dependent => :destroy, :foreign_key => 'taggable_id' # :as => :taggable, #:include => :tag, 
    has_many :tags, :through => :taggings

    before_save :save_cached_tag_list
    after_save :save_tags

		def self.masters
non_duplicates.includes(:source, :events, :tags, :taggings)
end

def self.with_public_wifi
where(wifi: true)
end

def self.in_business
where(closed: false)
end

def self.out_of_business
where(closed: true)
end

def self.masters
non_duplicates.includes(:source, :events, :tags, :taggings)
end

def self.with_public_wifi
where(wifi: true)
end

def self.in_business
where(closed: false)
end

def self.out_of_business
where(closed: true)
end

def self.masters
non_duplicates.includes(:source, :events, :tags, :taggings)
end

def self.with_public_wifi
where(wifi: true)
end

def self.in_business
where(closed: false)
end

def self.out_of_business
where(closed: true)
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
      self.class.tag_counts({ :conditions => self.class.send(:tags_condition, tag_list) }.reverse_merge!(options))
    end


  def self.search(query, opts={})
    SearchEngine.search(query, opts)
  end

  def url=(value)
    super UrlPrefixer.prefix(value)
  end

  # Display a single line address.
  def full_address
    full_address = "#{street_address}, #{locality} #{region} #{postal_code} #{country}"
    full_address.strip != "," && full_address
  end

  # Get an address we can use for geocoding
  def geocode_address
    full_address or address
  end

  # Return this venue's latitude/longitude location,
  # or nil if it doesn't have one.
  def location
    location = [latitude, longitude]
    location.all?(&:present?) && location
  end

  attr_accessor :force_geocoding

  def geocode!
    Geocoder.geocode(self)
    true # Try to geocode, but don't complain if we can't.
  end

  def update_events_count!
    update_attribute(:events_count, events.non_duplicates.count)
  end
end

