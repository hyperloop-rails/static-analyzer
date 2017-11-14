# == Strip Attribute module
#
# Contains functionality to clean attributes before validation
#
# Usage:
#
#     class Milestone < ActiveRecord::Base
#       strip_attributes :title
#     end
#
#
module StripAttribute
  extend ActiveSupport::Concern

  module ClassMethods
    def strip_attributes(*attrs)
      strip_attrs.concat(attrs)
    end

    def strip_attrs
      @strip_attrs ||= []
    end
  end

  included do
    before_validation :strip_attributes
  end

  def strip_attributes
    self.class.strip_attrs.each do |attr|
      self[attr].strip! if self[attr] && self[attr].respond_to?(:strip!)
    end
  end
end
