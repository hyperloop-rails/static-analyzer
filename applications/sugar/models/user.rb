# encoding: utf-8

require "digest/sha1"

# = User accounts
#
# === Trusted users
# Users with the <tt>trusted</tt> flag can see the trusted discussions.
# Admin users also count as trusted.

class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Authenticable
  include Inviter
  include ExchangeParticipant
  include UserScopes

  belongs_to :avatar, dependent: :destroy
  accepts_nested_attributes_for :avatar
  validates_associated :avatar

  before_create :check_for_first_user
  before_validation :ensure_last_active_is_set
  before_update :check_username_change

  validates :username,
            presence: true,
            uniqueness: {
              case_sensitive: false,
              message: "is already registered"
            },
            format: { with: /\A[^\?]+\Z/, message: "is not valid" }

  validates :email,
            email: true,
            uniqueness: {
              case_sensitive: false,
              message: "is already registered"
            },
            if: :email?

  validates :email,
            presence: { case_sensitive: false },
            unless: Proc.new { |u| u.openid_url? || u.facebook? }

  def name_and_email
    self.realname? ? "#{realname} <#{email}>" : email
  end

  def realname_or_username
    self.realname? ? realname : username
  end

  def online?
    (last_active && last_active > 15.minutes.ago) ? true : false
  end

  def trusted?
    (self[:trusted] || admin? || user_admin? || moderator?)
  end

  def user_admin?
    (self[:user_admin] || admin?)
  end

  def moderator?
    (self[:moderator] || admin?)
  end

  def previous_usernames
    (self[:previous_usernames] || "").split("\n")
  end

  # Returns admin flags as strings
  def admin_labels
    labels = []
    if self.admin?
      labels << "Admin"
    else
      labels << "User Admin" if self.user_admin?
      labels << "Moderator" if self.moderator?
    end
    labels
  end

  def theme
    self.theme? ? attributes["theme"] : Sugar.config.default_theme
  end

  def mark_active!
    if !last_active || last_active < 10.minutes.ago
      update_columns(last_active: Time.now)
    end
  end

  def mobile_theme
    if self.mobile_theme?
      attributes["mobile_theme"]
    else
      Sugar.config.default_mobile_theme
    end
  end

  def gamertag_avatar_url
    if self.gamertag?
      "http://avatar.xboxlive.com/avatar/" +
        URI.escape(gamertag) +
        "/avatarpic-l.png"
    end
  end

  def serializable_params
    [
      :id, :username, :realname, :latitude, :longitude, :inviter_id,
      :last_active, :created_at, :description, :admin,
      :moderator, :user_admin,
      :location, :gamertag, :twitter, :flickr, :instagram, :website,
      :msn, :gtalk, :last_fm, :facebook_uid, :banned_until,
      :sony, :nintendo, :steam, :battlenet
    ]
  end

  def serializable_methods
    [:active, :banned]
  end

  def as_json(options = {})
    super(
      {
        only: serializable_params, methods: serializable_methods
      }.merge(options)
    )
  end

  def to_xml(options = {})
    super(
      {
        only: serializable_params, methods: serializable_methods
      }.merge(options)
    )
  end

  protected

  def ensure_last_active_is_set
    self.last_active ||= Time.now
  end

  def check_for_first_user
    unless User.any?
      self.admin = true
    end
  end

  def check_username_change
    if self.username_changed?
      self[:previous_usernames] =
        ([username_was] + previous_usernames).join("\n")
    end
  end
end
