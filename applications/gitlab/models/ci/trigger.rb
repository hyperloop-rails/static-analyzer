module Ci
  class Trigger < ActiveRecord::Base
    extend Ci::Model

    acts_as_paranoid

    belongs_to :project, class_name: '::Project', foreign_key: :gl_project_id
    has_many :trigger_requests, dependent: :destroy, class_name: 'Ci::TriggerRequest'

    validates_presence_of :token
    validates_uniqueness_of :token

    before_validation :set_default_values

    def set_default_values
      self.token = SecureRandom.hex(15) if self.token.blank?
    end

    def last_trigger_request
      trigger_requests.last
    end

    def last_used
      last_trigger_request.try(:created_at)
    end

    def short_token
      token[0...10]
    end
  end
end
