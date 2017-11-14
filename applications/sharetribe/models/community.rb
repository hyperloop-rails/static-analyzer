# == Schema Information
#
# Table name: communities
#
#  id                                         :integer          not null, primary key
#  ident                                      :string(255)
#  domain                                     :string(255)
#  use_domain                                 :boolean          default(FALSE), not null
#  created_at                                 :datetime
#  updated_at                                 :datetime
#  settings                                   :text
#  consent                                    :string(255)
#  transaction_agreement_in_use               :boolean          default(FALSE)
#  email_admins_about_new_members             :boolean          default(FALSE)
#  use_fb_like                                :boolean          default(FALSE)
#  real_name_required                         :boolean          default(TRUE)
#  feedback_to_admin                          :boolean          default(TRUE)
#  automatic_newsletters                      :boolean          default(TRUE)
#  join_with_invite_only                      :boolean          default(FALSE)
#  use_captcha                                :boolean          default(FALSE)
#  allowed_emails                             :text
#  users_can_invite_new_users                 :boolean          default(TRUE)
#  private                                    :boolean          default(FALSE)
#  label                                      :string(255)
#  show_date_in_listings_list                 :boolean          default(FALSE)
#  all_users_can_add_news                     :boolean          default(TRUE)
#  custom_frontpage_sidebar                   :boolean          default(FALSE)
#  event_feed_enabled                         :boolean          default(TRUE)
#  slogan                                     :string(255)
#  description                                :text
#  category                                   :string(255)      default("other")
#  country                                    :string(255)
#  members_count                              :integer          default(0)
#  user_limit                                 :integer
#  monthly_price_in_euros                     :float
#  logo_file_name                             :string(255)
#  logo_content_type                          :string(255)
#  logo_file_size                             :integer
#  logo_updated_at                            :datetime
#  cover_photo_file_name                      :string(255)
#  cover_photo_content_type                   :string(255)
#  cover_photo_file_size                      :integer
#  cover_photo_updated_at                     :datetime
#  small_cover_photo_file_name                :string(255)
#  small_cover_photo_content_type             :string(255)
#  small_cover_photo_file_size                :integer
#  small_cover_photo_updated_at               :datetime
#  custom_color1                              :string(255)
#  custom_color2                              :string(255)
#  stylesheet_url                             :string(255)
#  stylesheet_needs_recompile                 :boolean          default(FALSE)
#  service_logo_style                         :string(255)      default("full-logo")
#  available_currencies                       :text
#  facebook_connect_enabled                   :boolean          default(TRUE)
#  vat                                        :integer
#  commission_from_seller                     :integer
#  minimum_price_cents                        :integer
#  testimonials_in_use                        :boolean          default(TRUE)
#  hide_expiration_date                       :boolean          default(FALSE)
#  facebook_connect_id                        :string(255)
#  facebook_connect_secret                    :string(255)
#  google_analytics_key                       :string(255)
#  name_display_type                          :string(255)      default("first_name_with_initial")
#  twitter_handle                             :string(255)
#  use_community_location_as_default          :boolean          default(FALSE)
#  preproduction_stylesheet_url               :string(255)
#  show_category_in_listing_list              :boolean          default(FALSE)
#  default_browse_view                        :string(255)      default("grid")
#  wide_logo_file_name                        :string(255)
#  wide_logo_content_type                     :string(255)
#  wide_logo_file_size                        :integer
#  wide_logo_updated_at                       :datetime
#  only_organizations                         :boolean
#  listing_comments_in_use                    :boolean          default(FALSE)
#  show_listing_publishing_date               :boolean          default(FALSE)
#  require_verification_to_post_listings      :boolean          default(FALSE)
#  show_price_filter                          :boolean          default(FALSE)
#  price_filter_min                           :integer          default(0)
#  price_filter_max                           :integer          default(100000)
#  automatic_confirmation_after_days          :integer          default(14)
#  favicon_file_name                          :string(255)
#  favicon_content_type                       :string(255)
#  favicon_file_size                          :integer
#  favicon_updated_at                         :datetime
#  default_min_days_between_community_updates :integer          default(7)
#  listing_location_required                  :boolean          default(FALSE)
#  custom_head_script                         :text
#  follow_in_use                              :boolean          default(TRUE), not null
#  logo_processing                            :boolean
#  wide_logo_processing                       :boolean
#  cover_photo_processing                     :boolean
#  small_cover_photo_processing               :boolean
#  favicon_processing                         :boolean
#  dv_test_file_name                          :string(64)
#  dv_test_file                               :string(64)
#  deleted                                    :boolean
#
# Indexes
#
#  index_communities_on_domain  (domain)
#  index_communities_on_ident   (ident)
#

class Community < ActiveRecord::Base
  require 'compass'
  require 'sass/plugin'

  include EmailHelper

  has_many :community_memberships, :dependent => :destroy
  has_many :members, :through => :community_memberships, :conditions => ['community_memberships.status = ?', 'accepted'], :source => :person
  has_many :admins, :through => :community_memberships, :conditions => ['community_memberships.admin = ? AND community_memberships.status <> ?', true, 'banned'], :source => :person
  has_many :invitations, :dependent => :destroy
  has_one :location, :dependent => :destroy
  has_many :community_customizations, :dependent => :destroy
  has_many :menu_links, :dependent => :destroy, :order => "sort_priority"

  has_many :categories, :order => "sort_priority"
  has_many :top_level_categories, :class_name => "Category", :conditions => ["parent_id IS NULL"], :order => "sort_priority"
  has_many :subcategories, :class_name => "Category", :conditions => ["parent_id IS NOT NULL"], :order => "sort_priority"

  has_many :conversations
  has_many :transactions
  has_many :payments

  has_many :listings

  has_one :marketplace_settings, dependent: :destroy
  has_one :payment_gateway, :dependent => :destroy
  has_one :paypal_account # Admin paypal account

  has_many :custom_fields, :dependent => :destroy
  has_many :custom_dropdown_fields, :class_name => "CustomField", :conditions => ["type = 'DropdownField'"], :dependent => :destroy
  has_many :custom_numeric_fields, :class_name => "NumericField", :conditions => ["type = 'NumericField'"], :dependent => :destroy

  after_create :initialize_settings

  monetize :minimum_price_cents, :allow_nil => true, :with_model_currency => :default_currency

  validates_length_of :ident, :in => 2..50
  validates_format_of :ident, :with => /\A[A-Z0-9_\-\.]*\z/i
  validates_uniqueness_of :ident
  validates_length_of :slogan, :in => 2..100, :allow_nil => true
  validates_format_of :custom_color1, :with => /\A[A-F0-9_-]{6}\z/i, :allow_nil => true
  validates_format_of :custom_color2, :with => /\A[A-F0-9_-]{6}\z/i, :allow_nil => true

  VALID_BROWSE_TYPES = %{grid map list}
  validates_inclusion_of :default_browse_view, :in => VALID_BROWSE_TYPES

  VALID_NAME_DISPLAY_TYPES = %{first_name_only first_name_with_initial full_name}
  validates_inclusion_of :name_display_type, :in => VALID_NAME_DISPLAY_TYPES

  # The settings hash contains some community specific settings:
  # locales: which locales are in use, the first one is the default

  serialize :settings, Hash

  DEFAULT_LOGO = ActionController::Base.helpers.asset_path("logos/mobile/default.png")
  DEFAULT_WIDE_LOGO = ActionController::Base.helpers.asset_path("logos/full/default.png")

  has_attached_file :logo,
                    :styles => {
                      :header => "192x192#",
                      :header_icon => "40x40#",
                      :header_icon_highres => "80x80#",
                      :apple_touch => "152x152#",
                      :original => "600x600>"
                    },
                    :convert_options => {
                      # iOS makes logo background black if there's an alpha channel
                      # And the options has to be in correct order! First background, then flatten. Otherwise it will
                      # not work.
                      :apple_touch => "-background white -flatten"
                    },
                    :default_url => DEFAULT_LOGO

  validates_attachment_content_type :logo,
                                    :content_type => ["image/jpeg",
                                                      "image/png",
                                                      "image/gif",
                                                      "image/pjpeg",
                                                      "image/x-png"]
  process_in_background :logo

  has_attached_file :wide_logo,
                    :styles => {
                      :header => "168x40#",
                      :paypal => "190x60>", # This logo is shown in PayPal checkout page. It has to be 190x60 according to PayPal docs.
                      :header_highres => "336x80#",
                      :original => "600x600>"
                    },
                    :convert_options => {
                      # The size for paypal logo will be exactly 190x60. No cropping, instead the canvas is extended with white background
                      :paypal => "-background white -gravity center -extent 190x60"
                    },
                    :default_url => DEFAULT_WIDE_LOGO

  validates_attachment_content_type :wide_logo,
                                    :content_type => ["image/jpeg",
                                                      "image/png",
                                                      "image/gif",
                                                      "image/pjpeg",
                                                      "image/x-png"]
  process_in_background :wide_logo

  has_attached_file :cover_photo,
                    :styles => {
                      :header => "1600x195#",
                      :hd_header => "1920x450#",
                      :original => "3840x3840>"
                    },
                    :default_url => ActionController::Base.helpers.asset_path("cover_photos/header/default.jpg"),
                    :keep_old_files => true # Temporarily to make preprod work aside production

  validates_attachment_content_type :cover_photo,
                                    :content_type => ["image/jpeg",
                                                      "image/png",
                                                      "image/gif",
                                                      "image/pjpeg",
                                                      "image/x-png"]
  process_in_background :cover_photo

  has_attached_file :small_cover_photo,
                    :styles => {
                      :header => "1600x195#",
                      :hd_header => "1920x96#",
                      :original => "3840x3840>"
                    },
                    :default_url => ActionController::Base.helpers.asset_path("cover_photos/header/default.jpg"),
                    :keep_old_files => true # Temporarily to make preprod work aside production

  validates_attachment_content_type :small_cover_photo,
                                    :content_type => ["image/jpeg",
                                                      "image/png",
                                                      "image/gif",
                                                      "image/pjpeg",
                                                      "image/x-png"]
  process_in_background :small_cover_photo

  has_attached_file :favicon,
                    :styles => {
                      :favicon => "32x32#"
                    },
                    :default_style => :favicon,
                    :convert_options => {
                      :favicon => "-depth 32",
                      :favicon => "-strip"
                    },
                    :default_url => ActionController::Base.helpers.asset_path("favicon.ico")

  validates_attachment_content_type :favicon,
                                    :content_type => ["image/jpeg",
                                                      "image/png",
                                                      "image/gif",
                                                      "image/x-icon",
                                                      "image/vnd.microsoft.icon"]
  process_in_background :favicon

  validates_format_of :twitter_handle, with: /\A[A-Za-z0-9_]{1,15}\z/, allow_nil: true

  validates :facebook_connect_id, numericality: { only_integer: true }, allow_nil: true
  validates :facebook_connect_id, length: {maximum: 16}, allow_nil: true

  validates_format_of :facebook_connect_secret, with: /\A[a-f0-9]{32}\z/, allow_nil: true

  attr_accessor :terms

  def self.columns
    super.reject { |c| ["only_public_listings"].include?(c.name) }
  end

  def name(locale)
    customization = Maybe(community_customizations.where(locale: locale).first).or_else {
      # We should not end up in a situation where the given locale is not found.
      # However, currently that is likely to happend, because:
      # - User has one locale
      # - User can join to multiple communities, which may not have user's locale available
      fallback_customisation = community_customizations.where(locale: default_locale).first
      if !(fallback_customisation && fallback_customisation.name)
        # Corner case: switching default language to a language without localisation.
        fallback_customisation = community_customizations.where("name IS NOT NULL").order(:updated_at).last
      end
      fallback_customisation
    }

    if customization
      customization.name
    else
      raise ArgumentError.new("Cannot find translation for marketplace name community_id: #{id}, locale: #{locale}")
    end
  end

  def full_name(locale)
    name(locale)
  end

  # If community name has several words, add an extra space
  # to the end to make Finnish translation look better.
  def name_with_separator(locale)
    (name(locale).include?(" ") && locale.to_s.eql?("fi")) ? "#{name(locale)} " : name(locale)
  end

  # If community full name has several words, add an extra space
  # to the end to make Finnish translation look better.
  def full_name_with_separator(locale)
    (full_name(locale).include?(" ") && locale.to_s.eql?("fi")) ? "#{full_name(locale)} " : full_name(locale)
  end

  def address
    location ? location.address : nil
  end

  def default_locale
    if settings && !settings["locales"].blank?
      return settings["locales"].first
    else
      return APP_CONFIG.default_locale
    end
  end

  def locales
   if settings && !settings["locales"].blank?
      return settings["locales"]
    else
      # if locales not set, return the short locales from the default list
      return Sharetribe::AVAILABLE_LOCALES.map { |l| l[:ident] }
    end
  end

  # Returns the emails of admins in an array
  def admin_emails
    admins.collect { |p| p.confirmed_notification_email_addresses } .flatten
  end

  def allows_user_to_send_invitations?(user)
    (users_can_invite_new_users && user.member_of?(self)) || user.has_admin_rights_in?(self)
  end

  def has_customizations?
    custom_color1 || custom_color2 || cover_photo.present? || small_cover_photo.present? || wide_logo.present? || logo.present?
  end

  def has_custom_stylesheet?
    if APP_CONFIG.preproduction
      preproduction_stylesheet_url.present?
    else
      stylesheet_url.present?
    end
  end

  def custom_stylesheet_url
    if APP_CONFIG.preproduction
      self.preproduction_stylesheet_url
    else
      self.stylesheet_url
    end
  end

  def self.with_customizations
    customization_columns = [
      "custom_color1",
      "custom_color2",
      "cover_photo_file_name",
      "small_cover_photo_file_name",
      "wide_logo_file_name",
      "logo_file_name"
    ]

    sql = customization_columns.map { |column_name| column_name + " IS NOT NULL" }.join(" OR ")

    where(sql)
  end

  def menu_link_attributes=(attributes)
    ids = []

    attributes.each_with_index do |(id, value), i|
      if menu_link = menu_links.find_by_id(id)
        menu_link.update_attributes(value.merge(sort_priority: i))
        ids << menu_link.id
      else
        menu_links.build(value.merge(sort_priority: i))
      end
    end

    links_to_destroy = menu_links.reject { |menu_link| menu_link.id.nil? || ids.include?(menu_link.id) }
    links_to_destroy.each { |link| link.destroy }
  end

  def self.find_by_email_ending(email)
    Community.all.each do |community|
      return community if community.allowed_emails && community.email_allowed?(email)
    end
    return nil
  end

  def new_members_during_last(time)
    community_memberships.where(:created_at => time.ago..Time.now).collect(&:person)
  end

  # Returns the full domain with default protocol in front
  def full_url
    full_domain(:with_protocol => true)
  end

  #returns full domain without protocol
  def full_domain(options= {})
    # assume that if port is used in domain config, it should
    # be added to the end of the full domain for links to work
    # This concerns usually mostly testing and development
    default_host, default_port = APP_CONFIG.domain.split(':')
    port_string = options[:port] || default_port

    if domain.present? && use_domain? # custom domain
      dom = domain
    else # just a subdomain specified
      dom = "#{self.ident}.#{default_host}"
      dom += ":#{port_string}" unless port_string.blank?
    end

    if options[:with_protocol]
      dom = "#{(APP_CONFIG.always_use_ssl ? "https://" : "http://")}#{dom}"
    end

    return dom

  end

  # returns the community specific service name if such is in use
  # otherwise returns the global default
  def service_name
    if settings && settings["service_name"].present?
      settings["service_name"]
    else
      APP_CONFIG.global_service_name || "Sharetribe"
    end
  end

  def has_new_listings_since?(time)
    return listings.where("created_at > ?", time).present?
  end

  def get_new_listings_to_update_email(person)
    latest = person.last_community_updates_at

    selected_listings = listings
      .currently_open
      .where("updates_email_at > ? AND updates_email_at > created_at", latest)
      .order("updates_email_at DESC")
      .to_a

    additional_listings = 10 - selected_listings.length
    new_listings =
      if additional_listings > 0
        listings
          .currently_open
          .where("updates_email_at > ? AND updates_email_at = created_at", latest)
          .order("updates_email_at DESC")
          .limit(additional_listings)
          .to_a
      else
        []
      end

     selected_listings
      .concat(new_listings)
      .sort_by { |listing| listing.updates_email_at}
      .reverse
  end

  def self.find_by_allowed_email(email)
    email_ending = "@#{email.split('@')[1]}"
    where("allowed_emails LIKE ?", "%#{email_ending}%")
  end

  # Check if communities with this category are email restricted
  # TODO Is this still in use?
  def self.email_restricted?(community_category)
    ["company", "university"].include?(community_category)
  end

  # Returns all the people who are admins in at least one tribe.
  def self.all_admins
    Person.joins(:community_memberships).where("community_memberships.admin = '1'").group("people.id")
  end

  def self.stylesheet_needs_recompile!
    Community.with_customizations.update_all(:stylesheet_needs_recompile => true)
  end

  # approves a membership pending email if one is found
  # if email is given, only approves if email is allowed
  # returns true if membership was now approved
  # false if it wasn't allowed or if already a member
  def approve_pending_membership(person, email_address=nil)
    membership = community_memberships.where(:person_id => person.id, :status => "pending_email_confirmation").first
    if membership && (email_address.nil? || email_allowed?(email_address))
      membership.update_attribute(:status, "accepted")
      return true
    end
    return false
  end

  def main_categories
    top_level_categories
  end

  def leaf_categories
    categories.reject { |c| !c.children.empty? }
  end

  # is it possible to pay for this listing via the payment system
  def payment_possible_for?(listing)
    listing.price && listing.price > 0 && payments_in_use?
  end

  # Deprecated
  #
  # There is a method `payment_type` is community service. Use that instead.
  def payments_in_use?
    if MarketplaceService::Community::Query.payment_type(id) == :paypal
      true
    else
      payment_gateway.present? && payment_gateway.configured?
    end
  end

  # Testimonials can be used only if payments are used and `testimonials_in_use` value
  # is true. `testimonials_in_use` doesn't have any effect, if there are no payments
  def testimonials_in_use
    read_attribute(:testimonials_in_use) && payments_in_use?
  end

  def default_currency
    if available_currencies
      available_currencies.gsub(" ","").split(",").first
    else
      MoneyRails.default_currency
    end
  end

  def self.all_with_custom_fb_login
    begin
      where("facebook_connect_id IS NOT NULL")
    rescue Mysql2::Error
      # in some environments (e.g. Travis CI) the tables are not yet loaded when this is called
      # so return empty array, as it shouldn't matter in those cases
      return []
    end
  end

  def braintree_in_use?
    payment_gateway.present? && payment_gateway.type == "BraintreePaymentGateway"
  end

  # Return either minimum price defined by this community or the absolute
  # platform default minimum price.
  def absolute_minimum_price(currency)
    Money.new(minimum_price_cents || 100, currency || "EUR")
  end

  def invoice_form_type_for(listing)
    payment_possible_for?(listing) && payments_in_use? ? payment_gateway.invoice_form_type : "no_form"
  end

  def email_notification_types
    valid_types = Person::EMAIL_NOTIFICATION_TYPES.dup
    if !follow_in_use?
      valid_types.delete "email_about_new_listings_by_followed_people"
    end
    valid_types
  end

  def close_listings_by_author(author)
    listings.where(:author_id => author.id).update_all(:open => false)
  end

  def images_processing?
    logo.processing? ||
    wide_logo.processing? ||
    cover_photo.processing? ||
    small_cover_photo.processing? ||
    favicon.processing?
  end

  # Finds a community by the given identifier(s)
  #
  # Communities have 3 values that can used individually to
  # uniquely identify a community.
  #
  # Those are (in the order of priority):
  #
  # - id
  # - ident
  # - domain
  #
  def self.find_by_identifier(identifiers)
    priority = [:id, :ident, :domain]

    identifier_to_use = priority.find { |identifier| identifiers[identifier].present? }

    if identifier_to_use.nil?
      nil
    else
      Community.where({ identifier_to_use => identifiers[identifier_to_use]}).first
    end
  end

  private

  def initialize_settings
    update_attribute(:settings,{"locales"=>[APP_CONFIG.default_locale]}) if self.settings.blank?
  end
end
