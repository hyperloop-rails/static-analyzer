# == Schema Information
# Schema version: 20110604174521
#
# Table name: events
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  description     :text
#  start_time      :datetime
#  url             :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  venue_id        :integer
#  source_id       :integer
#  duplicate_of_id :integer
#  end_time        :datetime
#  version         :integer
#  rrule           :string(255)
#  venue_details   :text
#

require "calagator/blacklist_validator"
require "calagator/duplicate_checking"
require "calagator/decode_html_entities_hack"
require "calagator/strip_whitespace"
require "calagator/url_prefixer"
require "paper_trail"
require "loofah-activerecord"
require "loofah/activerecord/xss_foliate"
require "active_model/sequential_validator"

# == Event
#
# A model representing a calendar event.

class Event < ActiveRecord::Base
  self.table_name = "events"

  has_paper_trail
  acts_as_taggable #solved

  xss_foliate strip: [:title, :description, :venue_details]

  include DecodeHtmlEntitiesHack

  # Associations
  belongs_to :venue, :counter_cache => true
  belongs_to :source

  # Validations
  validates :title, :description, :url, blacklist: true
  validates :start_time, :end_time, sequential: true
  validates :title, :start_time, presence: true
  validates_format_of :url,
    :with => /\Ahttps?:\/\/(\w+:?\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?\Z/,
    :allow_blank => true,
    :allow_nil => true

  before_destroy { !locked } # prevent locked events from being destroyed

  # Duplicates
  include DuplicateChecking
  duplicate_checking_ignores_attributes    :source_id, :version, :venue_id
  duplicate_squashing_ignores_associations :tags, :base_tags, :taggings
  duplicate_finding_scope -> { future.order(:id) }
  after_squashing_duplicates ->(master) { master.venue.try(:update_events_count!) }

  # Named scopes
  scope :after_date, lambda { |date|
    where(["start_time >= ?", date]).order(:start_time)
  }
  scope :on_or_after_date, lambda { |date|
    time = date.beginning_of_day
    where("(events.start_time >= :time) OR (events.end_time IS NOT NULL AND events.end_time > :time)",
      :time => time).order(:start_time)
  }
  scope :before_date, lambda { |date|
    time = date.beginning_of_day
    where("start_time < :time", :time => time).order(start_time: :desc)
  }
  scope :future, lambda { on_or_after_date(Time.zone.today) }
  scope :past, lambda { before_date(Time.zone.today) }
  scope :within_dates, lambda { |start_date, end_date|
    if start_date == end_date
      end_date = end_date + 1.day
    end
    on_or_after_date(start_date).before_date(end_date)
  }

  # Expand the simple sort order names from the URL into more intelligent SQL order strings
  scope :ordered_by_ui_field, lambda { |ui_field|
    scope = case ui_field
    when 'name'
      order('lower(events.title)')
    when 'venue'
      includes(:venue).order('lower(venues.title)').references(:venues)
    else
      all
    end
    scope.order('start_time')
  }
		has_many :taggings, :dependent => :destroy, :foreign_key => 'taggable_id' # :as => :taggable, #:include => :tag, 
    has_many :tags, :through => :taggings

    before_save :save_cached_tag_list
    after_save :save_tags

		def self.after_date
lambda { |date|
    where(["start_time >= ?", date]).order(:start_time)
  }
end

def self.on_or_after_date
lambda { |date|
    time = date.beginning_of_day
    where("(events.start_time >= :time) OR (events.end_time IS NOT NULL AND events.end_time > :time)",
      :time => time).order(:start_time)
  }
end

def self.before_date
lambda { |date|
    time = date.beginning_of_day
    where("start_time < :time", :time => time).order(start_time: :desc)
  }
end

def self.future
lambda { on_or_after_date(Time.zone.today) }
end

def self.past
lambda { before_date(Time.zone.today) }
end

def self.within_dates
lambda { |start_date, end_date|
    if start_date == end_date
      end_date = end_date + 1.day
    end
    on_or_after_date(start_date).before_date(end_date)
  }
end

def self.ordered_by_ui_field
lambda { |ui_field|
    scope = case ui_field
    when 'name'
      order('lower(events.title)')
    when 'venue'
      includes(:venue).order('lower(venues.title)').references(:venues)
    else
      all
    end
    scope.order('start_time')
  }
end

def self.after_date
lambda { |date|
    where(["start_time >= ?", date]).order(:start_time)
  }
end

def self.on_or_after_date
lambda { |date|
    time = date.beginning_of_day
    where("(events.start_time >= :time) OR (events.end_time IS NOT NULL AND events.end_time > :time)",
      :time => time).order(:start_time)
  }
end

def self.before_date
lambda { |date|
    time = date.beginning_of_day
    where("start_time < :time", :time => time).order(start_time: :desc)
  }
end

def self.future
lambda { on_or_after_date(Time.zone.today) }
end

def self.past
lambda { before_date(Time.zone.today) }
end

def self.within_dates
lambda { |start_date, end_date|
    if start_date == end_date
      end_date = end_date + 1.day
    end
    on_or_after_date(start_date).before_date(end_date)
  }
end

def self.ordered_by_ui_field
lambda { |ui_field|
    scope = case ui_field
    when 'name'
      order('lower(events.title)')
    when 'venue'
      includes(:venue).order('lower(venues.title)').references(:venues)
    else
      all
    end
    scope.order('start_time')
  }
end

def self.after_date
lambda { |date|
    where(["start_time >= ?", date]).order(:start_time)
  }
end

def self.on_or_after_date
lambda { |date|
    time = date.beginning_of_day
    where("(events.start_time >= :time) OR (events.end_time IS NOT NULL AND events.end_time > :time)",
      :time => time).order(:start_time)
  }
end

def self.before_date
lambda { |date|
    time = date.beginning_of_day
    where("start_time < :time", :time => time).order(start_time: :desc)
  }
end

def self.future
lambda { on_or_after_date(Time.zone.today) }
end

def self.past
lambda { before_date(Time.zone.today) }
end

def self.within_dates
lambda { |start_date, end_date|
    if start_date == end_date
      end_date = end_date + 1.day
    end
    on_or_after_date(start_date).before_date(end_date)
  }
end

def self.ordered_by_ui_field
lambda { |ui_field|
    scope = case ui_field
    when 'name'
      order('lower(events.title)')
    when 'venue'
      includes(:venue).order('lower(venues.title)').references(:venues)
    else
      all
    end
    scope.order('start_time')
  }
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

    def reload_with_tag_list(*args) #:nodoc:
      @tag_list = nil
      reload_without_tag_list(*args)
    end

  #---[ Overrides ]-------------------------------------------------------

  def url=(value)
    super UrlPrefixer.prefix(value)
  end

  # Set the start_time to the given +value+, which could be a Time, Date,
  # DateTime, String, Array of Strings, or nil.
  def start_time=(value)
    super time_for(value)
  rescue ArgumentError
    errors.add :start_time, "is invalid"
    super nil
  end

  # Set the end_time to the given +value+, which could be a Time, Date,
  # DateTime, String, Array of Strings, or nil.
  def end_time=(value)
    super time_for(value)
  rescue ArgumentError
    errors.add :end_time, "is invalid"
    super nil
  end

  def time_for(value)
    value = value.to_s if value.kind_of?(Date)
    value = Time.zone.parse(value) if value.kind_of?(String) # this will throw ArgumentError if invalid
    value
  end
  private :time_for

  #---[ Lock toggling ]---------------------------------------------------

  def lock_editing!
    update_attribute(:locked, true)
  end

  def unlock_editing!
    update_attribute(:locked, false)
  end

  #---[ Searching ]-------------------------------------------------------

  def self.search_tag(tag, opts={})
    includes(:venue).tagged_with(tag).ordered_by_ui_field(opts[:order])
  end

  def self.search(query, opts={})
    SearchEngine.search(query, opts)
  end

  #---[ Date related ]----------------------------------------------------

  def current?
    (end_time || start_time) >= Date.today.to_time
  end

  def old?
    (end_time || start_time + 1.hour) <= Time.zone.now.beginning_of_day
  end

  def ongoing?
    return unless end_time && start_time
    (start_time..end_time).cover?(Date.today.to_time)
  end

  def duration
    return 0 unless end_time && start_time
    (end_time - start_time)
  end
end

