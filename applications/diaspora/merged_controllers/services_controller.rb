#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.
class ServicesController < ApplicationController
  # We need to take a raw POST from an omniauth provider with no authenticity token.
  # See https://github.com/intridea/omniauth/issues/203
  # See also http://www.communityguides.eu/articles/16
  skip_before_action :verify_authenticity_token, :only => :create
  before_action :authenticate_user!
  before_action :abort_if_already_authorized, :abort_if_read_only_access, :only => :create

  respond_to :html
  respond_to :json, :only => :inviter

  def index
    @services = current_user.services
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
 content_for :page_title do 
 t(".edit_services") 
 end 
  t("settings") 
 current_page?(edit_profile_path) 
 link_to t("profile"), edit_profile_path 
 current_page?(edit_user_path) 
 link_to t("account"), edit_user_path 
 current_page?(privacy_settings_path) 
 link_to t("privacy"), privacy_settings_path 
 current_page?(services_path) 
 link_to t("_services"), services_path 
 
  if AppConfig.configured_services.count > 0 
 AppConfig.configured_services.each do |provider| 
 if AppConfig.show_service?(provider, current_user) 
 t("services.provider.") 
 services_for_provider = @services.select{|x| x.provider == provider.to_s} 
 if services_for_provider.count > 0 
 services_for_provider.each do |service| 
 raw(t("services.index.logged_in_as", nickname: content_tag(:strong, service.nickname ))) 
 link_to t("services.index.disconnect"),                    service_path(service),                    data: {},                    method: :delete 
 end 
 else 
 t("services.index.not_logged_in") 
 link_to(t("services.index.connect"), "/auth/") 
 end 
 end 
 end 
 else 
 t("services.index.no_services_available") 
 end 
 
 t(".services_explanation") 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def create
    service = Service.initialize_from_omniauth( omniauth_hash )

    if current_user.services << service
      no_profile_image_before_update = no_profile_image?
      current_user.update_profile_with_omniauth(service.info)
      fetch_photo(service) if no_profile_image_before_update

      flash[:notice] = I18n.t 'services.create.success'
    else
      flash[:error] = I18n.t 'services.create.failure'
    end
    redirect_to_origin
  end

  def failure
    logger.info "error in oauth #{params.inspect}"
    flash[:error] = t('services.failure.error')
    redirect_to services_url
  end

  def destroy
    @service = current_user.services.find(params[:id])
    @service.destroy
    flash[:notice] = I18n.t 'services.destroy.success'
    redirect_to services_url
  end

  private

  def abort_if_already_authorized
    if service = Service.where(uid: omniauth_hash['uid']).first
      flash[:error] =  I18n.t( 'services.create.already_authorized',
                                  diaspora_id:  service.user.profile.diaspora_handle,
                                  service_name: service.provider.camelize )
      redirect_to_origin
    end
  end

  def abort_if_read_only_access
    if omniauth_hash['provider'] == 'twitter' && twitter_access_level == 'read'
      flash[:error] =  I18n.t( 'services.create.read_only_access' )
      redirect_to_origin
    end
  end

  def redirect_to_origin
    if origin
      redirect_to origin
    else
      render(text: "<script>window.close()</script>")
    end
  end

  def no_profile_image?
    current_user.profile[:image_url].blank?
  end

  def fetch_photo(service)
    Workers::FetchProfilePhoto.perform_async(current_user.id, service.id, service.info["image"])
  end

  def origin
    request.env['omniauth.origin']
  end

  def omniauth_hash
    request.env['omniauth.auth']
  end

  def twitter_access_token
    omniauth_hash['extra']['access_token']
  end

  #https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema #=> normalized hash
  #https://gist.github.com/oliverbarnes/6096959 #=> hash with twitter specific extra
  def twitter_access_level
    twitter_access_token.response.header['x-access-level']
  end
end
