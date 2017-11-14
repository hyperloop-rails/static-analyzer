# -*- encoding : utf-8 -*-
require_dependency 'email'
require_dependency 'enum'
require_dependency 'user_name_suggester'

class Users::OmniauthCallbacksController < ApplicationController

  BUILTIN_AUTH = [
    Auth::FacebookAuthenticator.new,
    Auth::GoogleOAuth2Authenticator.new,
    Auth::OpenIdAuthenticator.new("yahoo", "https://me.yahoo.com", trusted: true),
    Auth::GithubAuthenticator.new,
    Auth::TwitterAuthenticator.new,
    Auth::InstagramAuthenticator.new
  ]

  skip_before_filter :redirect_to_login_if_required

  layout false

  def self.types
    @types ||= Enum.new(:facebook, :instagram, :twitter, :google, :yahoo, :github, :persona, :cas)
  end

  # need to be able to call this
  skip_before_filter :check_xhr

  # this is the only spot where we allow CSRF, our openid / oauth redirect
  # will not have a CSRF token, however the payload is all validated so its safe
  skip_before_filter :verify_authenticity_token, only: :complete

  def complete
    auth = request.env["omniauth.auth"]
    auth[:session] = session

    authenticator = self.class.find_authenticator(params[:provider])
    provider = Discourse.auth_providers && Discourse.auth_providers.find{|p| p.name == params[:provider]}

    @auth_result = authenticator.after_authenticate(auth)

    origin = request.env['omniauth.origin']
    if origin.present?
      parsed = URI.parse(@origin) rescue nil
      if parsed
        @origin = parsed.path
      end
    end

    unless @origin.present?
      @origin = Discourse.base_uri("/")
    end

    if @auth_result.failed?
      flash[:error] = @auth_result.failed_reason.html_safe
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
if flash[:error].present? 
flash[:error]
else
 t 'login.omniauth_error_unknown' 
end

end

    else
      @auth_result.authenticator_name = authenticator.name
      complete_response_data

      if provider && provider.full_screen_login
        cookies['_bypass_cache'] = true
        flash[:authentication_data] = @auth_result.to_client_hash.to_json
        redirect_to @origin
      else
        respond_to do |format|
          format.html
          format.json { render json: @auth_result.to_client_hash }
        end
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 SiteSetting.title 
t "login.close_window" 
@auth_result.to_client_hash.to_json.html_safe

end

  end

  def failure
    flash[:error] = I18n.t("login.omniauth_error")
    render layout: 'no_ember'
  end


  def self.find_authenticator(name)
    BUILTIN_AUTH.each do |authenticator|
      if authenticator.name == name
        raise Discourse::InvalidAccess.new("provider is not enabled") unless SiteSetting.send("enable_#{name}_logins?")
        return authenticator
      end
    end

    Discourse.auth_providers.each do |provider|
      return provider.authenticator if provider.name == name
    end

    raise Discourse::InvalidAccess.new("provider is not found")
  end

  protected

  def complete_response_data
    if @auth_result.user
      user_found(@auth_result.user)
    elsif SiteSetting.invite_only?
      @auth_result.requires_invite = true
    else
      session[:authentication] = @auth_result.session_data
    end
  end

  def user_found(user)
    # automatically activate any account if a provider marked the email valid
    if !user.active && @auth_result.email_valid
      user.toggle(:active).save
    end

    if ScreenedIpAddress.should_block?(request.remote_ip)
      @auth_result.not_allowed_from_ip_address = true
    elsif ScreenedIpAddress.block_admin_login?(user, request.remote_ip)
      @auth_result.admin_not_allowed_from_ip_address = true
    elsif Guardian.new(user).can_access_forum? && user.active # log on any account that is active with forum access
      log_on_user(user)
      Invite.invalidate_for_email(user.email) # invite link can't be used to log in anymore
      session[:authentication] = nil # don't carry around old auth info, perhaps move elsewhere
      @auth_result.authenticated = true
    else
      if SiteSetting.must_approve_users? && !user.approved?
        @auth_result.awaiting_approval = true
      else
        @auth_result.awaiting_activation = true
      end
    end
  end

end
