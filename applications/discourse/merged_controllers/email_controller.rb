class EmailController < ApplicationController
  skip_before_filter :check_xhr, :preload_json
  layout 'no_ember'

  before_filter :ensure_logged_in, only: :preferences_redirect
  skip_before_filter :redirect_to_login_if_required

  def preferences_redirect
    redirect_to(email_preferences_path(current_user.username_lower))
  end

  def unsubscribe
    @user = DigestUnsubscribeKey.user_for_key(params[:key])
    RateLimiter.new(@user, "unsubscribe_via_email", 3, 1.day).performed! unless @user && @user.staff?

    # Don't allow the use of a key while logged in as a different user
    if current_user.present? && (@user != current_user)
      @different_user = true
      return
    end

    if @user.blank?
      @not_found = true
      return
    end

    if params[:from_all]
      @user.user_option.update_columns(email_always: false,
                                       email_digests: false,
                                       email_direct: false,
                                       email_private_messages: false)
    else
      @user.user_option.update_column(:email_digests, false)
    end

    @success = true
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 SiteSetting.default_locale 
SiteSetting.title
  Discourse::VERSION::STRING 
 Discourse.git_version 
 if SiteSetting.favicon_url.present? 
SiteSetting.favicon_url
 end 
 if SiteSetting.apple_touch_icon_url.present? 
SiteSetting.apple_touch_icon_url
 end 
 if (SiteSetting.apple_touch_icon_url != "/images/default-apple-touch-icon.png") && SiteSetting.apple_touch_icon_url.present? 
SiteSetting.apple_touch_icon_url
 end 
 ColorScheme.hex_for_name('header_background') 
 canonical_link_tag 
 
  font_domain = "#{request.protocol}#{request.host_with_port}&2" 
asset_path "fontawesome-webfont.eot" 
 font_domain 
asset_path "fontawesome-webfont.eot" 
 font_domain 
asset_path "fontawesome-webfont.woff2" 
 font_domain 
asset_path "fontawesome-webfont.woff" 
 font_domain 
asset_path "fontawesome-webfont.ttf" 
 font_domain 
 
  if rtl? 
 DiscourseStylesheets.stylesheet_link_tag(mobile_view? ? :mobile_rtl : :desktop_rtl) 
 else 
 DiscourseStylesheets.stylesheet_link_tag(mobile_view? ? :mobile : :desktop) 
 end 
 if staff? 
 DiscourseStylesheets.stylesheet_link_tag(:admin) 
 end 
 unless customization_disabled? 
 SiteCustomization.custom_stylesheet(session[:preview_style], mobile_view? ? :mobile : :desktop) 
 end 
 
 discourse_csrf_tags 
 unless customization_disabled? 
 raw SiteCustomization.custom_head_tag(session[:preview_style]) 
 end 
 yield(:no_ember_head) 
 unless customization_disabled? 
 SiteCustomization.custom_header(session[:preview_style], mobile_view? ? :mobile : :desktop) 
 end 
  path "/" 
 if application_logo_url.present? 
 application_logo_url 
 SiteSetting.title 
 else 
 SiteSetting.title 
 end 
 unless current_user 
 path "/login"
 I18n.t('log_in') 
 end 
 
 @container_class ? @container_class : 'wrap' 
 if @success 
 t :'unsubscribed.title' 
 t :'unsubscribed.description' 
 t :'unsubscribed.oops' 
 form_tag(email_resubscribe_path(key: params[:key])) do 
 submit_tag t(:'resubscribe.action'), class: 'btn btn-danger' 
 end 
 else 
 t :'unsubscribed.error' 
 if @different_user 
 t :'unsubscribed.different_user_description' 
 end 
 if @not_found 
 t :'unsubscribed.not_found_description' 
 end 
raw(t :'unsubscribed.preferences_link') 
 end 
 unless customization_disabled? 
 SiteCustomization.custom_footer(session[:preview_style], mobile_view? ? :mobile : :desktop) 
 end 

end

  end

  def resubscribe
    @user = DigestUnsubscribeKey.user_for_key(params[:key])
    raise Discourse::NotFound unless @user.present?
    @user.user_option.update_column(:email_digests, true)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 SiteSetting.default_locale 
SiteSetting.title
  Discourse::VERSION::STRING 
 Discourse.git_version 
 if SiteSetting.favicon_url.present? 
SiteSetting.favicon_url
 end 
 if SiteSetting.apple_touch_icon_url.present? 
SiteSetting.apple_touch_icon_url
 end 
 if (SiteSetting.apple_touch_icon_url != "/images/default-apple-touch-icon.png") && SiteSetting.apple_touch_icon_url.present? 
SiteSetting.apple_touch_icon_url
 end 
 ColorScheme.hex_for_name('header_background') 
 canonical_link_tag 
 
  font_domain = "#{request.protocol}#{request.host_with_port}&2" 
asset_path "fontawesome-webfont.eot" 
 font_domain 
asset_path "fontawesome-webfont.eot" 
 font_domain 
asset_path "fontawesome-webfont.woff2" 
 font_domain 
asset_path "fontawesome-webfont.woff" 
 font_domain 
asset_path "fontawesome-webfont.ttf" 
 font_domain 
 
  if rtl? 
 DiscourseStylesheets.stylesheet_link_tag(mobile_view? ? :mobile_rtl : :desktop_rtl) 
 else 
 DiscourseStylesheets.stylesheet_link_tag(mobile_view? ? :mobile : :desktop) 
 end 
 if staff? 
 DiscourseStylesheets.stylesheet_link_tag(:admin) 
 end 
 unless customization_disabled? 
 SiteCustomization.custom_stylesheet(session[:preview_style], mobile_view? ? :mobile : :desktop) 
 end 
 
 discourse_csrf_tags 
 unless customization_disabled? 
 raw SiteCustomization.custom_head_tag(session[:preview_style]) 
 end 
 yield(:no_ember_head) 
 unless customization_disabled? 
 SiteCustomization.custom_header(session[:preview_style], mobile_view? ? :mobile : :desktop) 
 end 
  path "/" 
 if application_logo_url.present? 
 application_logo_url 
 SiteSetting.title 
 else 
 SiteSetting.title 
 end 
 unless current_user 
 path "/login"
 I18n.t('log_in') 
 end 
 
 @container_class ? @container_class : 'wrap' 
 t :'resubscribe.title' 
 t :'resubscribe.description' 
 unless customization_disabled? 
 SiteCustomization.custom_footer(session[:preview_style], mobile_view? ? :mobile : :desktop) 
 end 

end

  end

end
