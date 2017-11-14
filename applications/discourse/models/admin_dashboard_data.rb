require_dependency 'mem_info'

class AdminDashboardData
  include StatsCacheable

  GLOBAL_REPORTS ||= [
    'visits',
    'signups',
    'profile_views',
    'topics',
    'posts',
    'time_to_first_response',
    'topics_with_no_response',
    'likes',
    'flags',
    'bookmarks',
    'emails',
  ]

  PAGE_VIEW_REPORTS ||= ['page_view_total_reqs'] + ApplicationRequest.req_types.keys.select { |r| r =~ /^page_view_/ && r !~ /mobile/ }.map { |r| r + "_reqs" }

  PRIVATE_MESSAGE_REPORTS ||= [
    'user_to_user_private_messages',
    'system_private_messages',
    'notify_moderators_private_messages',
    'notify_user_private_messages',
    'moderator_warning_private_messages',
  ]

  HTTP_REPORTS ||= ApplicationRequest.req_types.keys.select { |r| r =~ /^http_/ }.map { |r| r + "_reqs" }.sort

  USER_REPORTS ||= ['users_by_trust_level']

  MOBILE_REPORTS ||= ['mobile_visits'] + ApplicationRequest.req_types.keys.select {|r| r =~ /mobile/}.map { |r| r + "_reqs" }

  def self.add_problem_check(*syms, &blk)
    @problem_syms.push(*syms) if syms
    @problem_blocks << blk if blk
  end
  class << self; attr_reader :problem_syms, :problem_blocks; end

  def problems
    problems = []
    AdminDashboardData.problem_syms.each do |sym|
      problems << send(sym)
    end
    AdminDashboardData.problem_blocks.each do |blk|
      problems << instance_exec(&blk)
    end
    problems.compact
  end

  # used for testing
  def self.reset_problem_checks
    @problem_syms = []
    @problem_blocks = []

    add_problem_check :rails_env_check, :ruby_version_check, :host_names_check,
                      :gc_checks, :ram_check, :google_oauth2_config_check,
                      :facebook_config_check, :twitter_config_check,
                      :github_config_check, :s3_config_check, :image_magick_check,
                      :failing_emails_check, :default_logo_check, :contact_email_check,
                      :send_consumer_email_check, :title_check,
                      :site_description_check, :site_contact_username_check,
                      :notification_email_check, :subfolder_ends_in_slash_check,
                      :pop3_polling_configuration

    add_problem_check do
      sidekiq_check || queue_size_check
    end
  end
  reset_problem_checks

  def self.fetch_stats
    AdminDashboardData.new.as_json
  end

  def self.stats_cache_key
    'dash-stats'
  end

  def self.fetch_problems
    AdminDashboardData.new.problems
  end

  def as_json(_options = nil)
    @json ||= {
      global_reports: AdminDashboardData.reports(GLOBAL_REPORTS),
      page_view_reports: AdminDashboardData.reports(PAGE_VIEW_REPORTS),
      private_message_reports: AdminDashboardData.reports(PRIVATE_MESSAGE_REPORTS),
      http_reports: AdminDashboardData.reports(HTTP_REPORTS),
      user_reports: AdminDashboardData.reports(USER_REPORTS),
      mobile_reports: AdminDashboardData.reports(MOBILE_REPORTS),
      admins: User.admins.count,
      moderators: User.moderators.count,
      suspended: User.suspended.count,
      blocked: User.blocked.count,
      top_referrers: IncomingLinksReport.find('top_referrers').as_json,
      top_traffic_sources: IncomingLinksReport.find('top_traffic_sources').as_json,
      top_referred_topics: IncomingLinksReport.find('top_referred_topics').as_json,
      updated_at: Time.zone.now.as_json
    }
  end

  def self.reports(source)
    source.map { |type| Report.find(type).as_json }
  end

  def rails_env_check
    I18n.t("dashboard.rails_env_warning", env: Rails.env) unless Rails.env.production?
  end

  def host_names_check
    I18n.t("dashboard.host_names_warning") if ['localhost', 'production.localhost'].include?(Discourse.current_hostname)
  end

  def gc_checks
    I18n.t("dashboard.gc_warning") if ENV['RUBY_GC_MALLOC_LIMIT'].nil?
  end

  def sidekiq_check
    last_job_performed_at = Jobs.last_job_performed_at
    I18n.t('dashboard.sidekiq_warning') if Jobs.queued > 0 and (last_job_performed_at.nil? or last_job_performed_at < 2.minutes.ago)
  end

  def queue_size_check
    queue_size = Jobs.queued
    I18n.t('dashboard.queue_size_warning', queue_size: queue_size) unless queue_size < 100_000
  end

  def ram_check
    I18n.t('dashboard.memory_warning') if MemInfo.new.mem_total and MemInfo.new.mem_total < 1_000_000
  end

  def google_oauth2_config_check
    I18n.t('dashboard.google_oauth2_config_warning') if SiteSetting.enable_google_oauth2_logins && (SiteSetting.google_oauth2_client_id.blank? || SiteSetting.google_oauth2_client_secret.blank?)
  end

  def facebook_config_check
    I18n.t('dashboard.facebook_config_warning') if SiteSetting.enable_facebook_logins && (SiteSetting.facebook_app_id.blank? || SiteSetting.facebook_app_secret.blank?)
  end

  def twitter_config_check
    I18n.t('dashboard.twitter_config_warning') if SiteSetting.enable_twitter_logins and (SiteSetting.twitter_consumer_key.blank? or SiteSetting.twitter_consumer_secret.blank?)
  end

  def github_config_check
    I18n.t('dashboard.github_config_warning') if SiteSetting.enable_github_logins and (SiteSetting.github_client_id.blank? or SiteSetting.github_client_secret.blank?)
  end

  def s3_config_check
    bad_keys = (SiteSetting.s3_access_key_id.blank? or SiteSetting.s3_secret_access_key.blank?) and !SiteSetting.s3_use_iam_profile

    return I18n.t('dashboard.s3_config_warning') if SiteSetting.enable_s3_uploads and (bad_keys or SiteSetting.s3_upload_bucket.blank?)
    return I18n.t('dashboard.s3_backup_config_warning') if SiteSetting.enable_s3_backups and (bad_keys or SiteSetting.s3_backup_bucket.blank?)
    nil
  end

  def image_magick_check
    I18n.t('dashboard.image_magick_warning') if SiteSetting.create_thumbnails and !system("command -v convert >/dev/null;")
  end

  def failing_emails_check
    num_failed_jobs = Jobs.num_email_retry_jobs
    I18n.t('dashboard.failing_emails_warning', num_failed_jobs: num_failed_jobs) if num_failed_jobs > 0
  end

  def default_logo_check
    if SiteSetting.logo_url =~ /#{SiteSetting.defaults[:logo_url].split('/').last}/ or
        SiteSetting.logo_small_url =~ /#{SiteSetting.defaults[:logo_small_url].split('/').last}/ or
        SiteSetting.favicon_url =~ /#{SiteSetting.defaults[:favicon_url].split('/').last}/
      I18n.t('dashboard.default_logo_warning')
    end
  end

  def contact_email_check
    return I18n.t('dashboard.contact_email_missing') if !SiteSetting.contact_email.present?
    return I18n.t('dashboard.contact_email_invalid') if !(SiteSetting.contact_email =~ User::EMAIL)
  end

  def title_check
    I18n.t('dashboard.title_nag') if SiteSetting.title == SiteSetting.defaults[:title]
  end

  def site_description_check
    I18n.t('dashboard.site_description_missing') if !SiteSetting.site_description.present?
  end

  def send_consumer_email_check
    I18n.t('dashboard.consumer_email_warning') if Rails.env.production? and ActionMailer::Base.smtp_settings[:address] =~ /gmail\.com|live\.com|yahoo\.com/
  end

  def site_contact_username_check
    I18n.t('dashboard.site_contact_username_warning') if !SiteSetting.site_contact_username.present? || SiteSetting.site_contact_username == SiteSetting.defaults[:site_contact_username]
  end

  def notification_email_check
    I18n.t('dashboard.notification_email_warning') if !SiteSetting.notification_email.present? || SiteSetting.notification_email == SiteSetting.defaults[:notification_email]
  end

  def ruby_version_check
    I18n.t('dashboard.ruby_version_warning') if RUBY_VERSION == '2.0.0' and RUBY_PATCHLEVEL < 247
  end

  def subfolder_ends_in_slash_check
    I18n.t('dashboard.subfolder_ends_in_slash') if Discourse.base_uri =~ /\/$/
  end

  def pop3_polling_configuration
    POP3PollingEnabledSettingValidator.new.error_message if SiteSetting.pop3_polling_enabled
  end

end
