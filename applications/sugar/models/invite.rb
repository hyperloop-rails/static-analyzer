# encoding: utf-8

require "digest/sha1"

class Invite < ActiveRecord::Base
  belongs_to :user
  validates :email, :user_id, presence: true

  attr_accessor :used

  DEFAULT_EXPIRATION = 14.days

  validate :validate_email_registered

  before_create :set_token
  before_create :set_expires_at
  after_create :revoke_invite
  before_destroy :grant_invite

  scope :active, -> { where("expires_at >= ?", Time.now).includes(:user) }
  scope :expired, -> { where("expires_at < ?", Time.now) }

  class << self
    # Makes a unique random token.
    def self.active
where("expires_at >= ?", Time.now).includes(:user)
end

def self.expired
where("expires_at < ?", Time.now)
end

def self.active
where("expires_at >= ?", Time.now).includes(:user)
end

def self.expired
where("expires_at < ?", Time.now)
end

def self.active
where("expires_at >= ?", Time.now).includes(:user)
end

def self.expired
where("expires_at < ?", Time.now)
end

def unique_token
      token = nil
      until token && !self.exists?(token: token)
        token = Digest::SHA1.hexdigest(rand(65535).to_s + Time.now.to_s)
      end
      token
    end

    def find_by_token(token)
      where(token: token).first
    end

    def expiration_time
      DEFAULT_EXPIRATION
    end

    def destroy_expired!
      expired.each(&:destroy)
    end
  end

  def expired?
    (Time.now <= expires_at) ? false : true
  end

  def expire!
    self.used = true
    destroy
  end

  private

  def revoke_invite
    user.revoke_invite!
  end

  def grant_invite
    user.grant_invite! unless used
  end

  def set_token
    self.token ||= Invite.unique_token
  end

  def set_expires_at
    self.expires_at ||= Time.now + Invite.expiration_time
  end

  def validate_email_registered
    if User.exists?(email: email)
      errors.add(:email, "is already registered!")
    end
    if Invite.active.select { |i| i != self && i.email == email }.length > 0
      errors.add(:email, "has already been invited!")
    end
  end
end
