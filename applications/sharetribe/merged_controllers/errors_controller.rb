class ErrorsController < ActionController::Base

  layout 'blank_layout'
  before_filter :current_community
  before_filter :set_locale

  def server_error
    error_id = airbrake_error_id
    # error_id = 12341234153 # uncomment this to test the last text paragraph
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 locals(local_assigns, :title) 
 Maybe(@current_community).favicon.each do |favicon| 
 favicon 
 end 
  t('error_pages.error_500.temporary_unavailable') 
 t('error_pages.error_500.unable_to_process') 
 t('error_pages.error_500.we_hate_this') 
 if error_id.present? 
 t('error_pages.error_500.refer_to_error_id', error_id: error_id) 
 end 
 t('error_pages.back_to_kassi_front_page') 

end

  end

  def not_found
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 locals(local_assigns, :title) 
 Maybe(@current_community).favicon.each do |favicon| 
 favicon 
 end 
  t('error_pages.error_404.page_can_not_be_found') 
 t('error_pages.error_404.page_you_requested_can_not_be_found') 
 t('error_pages.back_to_kassi_front_page') 

end
end

  def gone
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 locals(local_assigns, :title) 
 Maybe(@current_community).favicon.each do |favicon| 
 favicon 
 end 
  t('error_pages.error_410.page_removed') 
 t('error_pages.error_410.page_you_requested_has_been_removed') 
 t('error_pages.error_410.page_removed_reason') 
 t('error_pages.back_to_kassi_front_page') 

end
end

  def community_not_found
    render status: 404, locals: { status: 404, title: "Marketplace not found", host: request.host }
  end

  private

  def current_community
    @current_community ||= ApplicationController.find_community(community_identifiers)
  end

  def community_identifiers
    app_domain = URLUtils.strip_port_from_host(APP_CONFIG.domain)
    ApplicationController.parse_community_identifiers_from_host(request.host, app_domain)
  end

  def title(status)
    community_name = Maybe(@current_community).map { |c|
      c.name(community_locale)
    }.or_else(nil)

    [community_name, t("error_pages.error_#{status}_title")].compact.join(' - ')
  end

  def community_locale
    Maybe(@current_community).default_locale.or_else(nil)
  end

  def set_locale
    # TODO We should set also the community here and allow I18n
    # backend to work even if community is not set
    I18n.locale = community_locale || "en"
  end

  def exception
    env["action_dispatch.exception"]
  end

  def airbrake_error_id
    env['airbrake.error_id'] if error_id_present?(env['airbrake.error_id'])
  end

  def can_notify_airbrake
    Airbrake && Airbrake.respond_to?(:notify)
  end

  def use_airbrake
    APP_CONFIG && APP_CONFIG.use_airbrake
  end

  # For some weird reason, Airbrake gem returns true, if error is not sent
  # (e.g. due to missing api key). So, make sure the error_id is present
  # (i.e. not empty), but return false if the id is true
  def error_id_present?(error_id)
    error_id.present? && error_id != true
  end
end
