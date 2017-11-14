require 'friendly_id'

  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, :use => [:slugged, :finders]

    has_many :forums
    validates :name, :presence => true
    validates :position, numericality: { only_integer: true }

    scope :by_position, -> { order(:position) }

    def self.by_position
order(:position)
end

def self.by_position
order(:position)
end

def self.by_position
order(:position)
end

def self.by_position
order(:position)
end

def to_s
      name
    end

  end
