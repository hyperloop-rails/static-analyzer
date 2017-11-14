require 'rest_client'

class SessionsController < ApplicationController

  skip_filter :check_email_confirmation
  skip_filter :cannot_access_without_joining, :only => [ :destroy, :confirmation_pending ]

  # For security purposes, Devise just authenticates an user
  # from the params hash if we explicitly allow it to. That's
  # why we need to call the before filter below.
  before_filter :allow_params_authentication!, :only => :create

  def new
    @selected_tribe_navi_tab = "members"
    @facebook_merge = session["devise.facebook_data"].present?
    if @facebook_merge
      @facebook_email = session["devise.facebook_data"]["email"]
      @facebook_name = "#{session["devise.facebook_data"]["given_name"]} #{session["devise.facebook_data"]["family_name"]}"
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 @facebook_merge ? t('.connect_your_facebook_to_kassi') : t('.login_to_kassi') 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 @facebook_merge ? t('.connect_your_facebook_to_kassi') : t('.login_to_kassi') 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  content_for :javascript do 
 end 
  
 if @facebook_merge 
 icon_tag("facebook", ["fb-icon"]) 
 t(".facebook_account", :name => @facebook_name, :email => @facebook_email ) 
 "#{@facebook_name} (#{@facebook_email})" 
 t('.log_in_to_link_account') 
 t('.you_can_also_create_new_account', :accont_creation_link => link_to(t(".account_creation_link_text"), create_facebook_based_people_path, :method => :post)).html_safe 
 t(".cancle_facebook_connect", :cancel_link => link_to(t(".facebook_cancel_link_text"), cancel_person_registration_path)).html_safe 
 t(".we_will_not_post_without_asking_you") 
 end 
 if facebook_connect_in_use? 
  person_omniauth_authorize_path(:facebook) 
 icon_tag("facebook", ["fb-icon"]) 
 button_text 
 
 end 
 form_tag("#{APP_CONFIG.login_domain}#{sessions_path}",:action => "create") do 
 username_or_email_label + ":" 
 text_field_tag "person[login]", nil, :value => session[:form_login], :class => :text_field, :id => :main_person_login, :autofocus => true 
 t('common.password') + ":" 
 password_field_tag "person[password]", nil, :class => :text_field, :id => :main_person_password 
 button_tag(t('.login'), :class => "send_button", :id => :main_log_in_button) 
 unless @facebook_merge 
 link_to t('.create_new_account'), (@current_community ? sign_up_path : new_tribe_path), :class => "green_part_link" 
 end 
 link_to t('.i_forgot_my_password'), "#", :id => "password_forgotten_link", :class => "green_part_link" 
 end 
  t('.password_recovery_instructions') 
 form_tag request_new_password_sessions_path do 
 t('.email') 
 text_field_tag("email", params[:q], :class => "text_field request_password") 
 button_tag t('.request_new_password'), :class => "send_button" 
 end 
 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def create

    session[:form_login] = params[:person][:login]

    # Start a session with Devise

    # In case of failure, set the message already here and
    # clear it afterwards, if authentication worked.
    flash.now[:error] = t("layouts.notifications.login_failed")

    # Since the authentication happens in the rack layer,
    # we need to tell Devise to call the action "sessions#new"
    # in case something goes bad.
    person = authenticate_person!(:recall => "sessions#new")
    flash[:error] = nil
    @current_user = person

    # Store Facebook ID and picture if connecting with FB
    if session["devise.facebook_data"]
      @current_user.update_attribute(:facebook_id, session["devise.facebook_data"]["id"])
      # FIXME: Currently this doesn't work for very unknown reason. Paper clip seems to be processing, but no pic
      if @current_user.image_file_size.nil?
        @current_user.store_picture_from_facebook
      end
    end

    sign_in @current_user

    session[:form_login] = nil

    if @current_user
      @current_user.update_attribute(:active, true) unless @current_user.active?
    end

    unless @current_user && (!@current_user.communities.include?(@current_community) || @current_community.consent.eql?(@current_user.consent(@current_community)) || @current_user.is_admin?)
      # Either the user has succesfully logged in, but is not found in Sharetribe DB
      # or the user is a member of this community but the terms of use have changed.

      sign_out @current_user
      session[:temp_cookie] = "pending acceptance of new terms"
      session[:temp_person_id] =  @current_user.id
      session[:temp_community_id] = @current_community.id
      session[:consent_changed] = true if @current_user
      redirect_to terms_path and return
    end

    session[:person_id] = current_person.id

    if not @current_community
      redirect_to new_tribe_path
    elsif @current_user.communities.include?(@current_community) || @current_user.is_admin?
      flash[:notice] = t("layouts.notifications.login_successful", :person_name => view_context.link_to(@current_user.given_name_or_username, person_path(@current_user))).html_safe
      if session[:return_to]
        redirect_to session[:return_to]
        session[:return_to] = nil
      elsif session[:return_to_content]
        redirect_to session[:return_to_content]
        session[:return_to_content] = nil
      else
        redirect_to root_path
      end
    else
      redirect_to new_tribe_membership_path
    end
  end

  def destroy
    sign_out
    session[:person_id] = nil
    flash[:notice] = t("layouts.notifications.logout_successful")
    redirect_to root
  end

  def index
    redirect_to login_path
  end

  def request_new_password
    if person = Person.find_by_email(params[:email])
      person.reset_password_token_if_needed
      PersonMailer.reset_password_instructions(person,params[:email], @current_community).deliver
      flash[:notice] = t("layouts.notifications.password_recovery_sent")
    else
      flash[:error] = t("layouts.notifications.email_not_found")
    end

    redirect_to login_path
  end

  def facebook
    @person = Person.find_for_facebook_oauth(request.env["omniauth.auth"], @current_user)

    I18n.locale = URLUtils.extract_locale_from_url(request.env['omniauth.origin']) if request.env['omniauth.origin']

    if @person
      flash[:notice] = t("devise.omniauth_callbacks.success", :kind => "Facebook")
      sign_in_and_redirect @person, :event => :authentication
    else
      data = request.env["omniauth.auth"].extra.raw_info

      if data.email.blank?
        flash[:error] = t("layouts.notifications.could_not_get_email_from_facebook")
        redirect_to sign_up_path and return
      end

      facebook_data = {"email" => data.email,
                       "given_name" => data.first_name,
                       "family_name" => data.last_name,
                       "username" => data.username,
                       "id"  => data.id}

      session["devise.facebook_data"] = facebook_data
      redirect_to :action => :create_facebook_based, :controller => :people
    end
  end

  #Facebook setup phase hook, that is used to dynamically set up a omniauth strategy for facebook on customer basis
  def facebook_setup
    request.env["omniauth.strategy"].options[:client_id] = @current_community.facebook_connect_id || APP_CONFIG.fb_connect_id
    request.env["omniauth.strategy"].options[:client_secret] = @current_community.facebook_connect_secret || APP_CONFIG.fb_connect_secret
    request.env["omniauth.strategy"].options[:iframe] = true
    request.env["omniauth.strategy"].options[:scope] = "public_profile,email"
    request.env["omniauth.strategy"].options[:info_fields] = "name,email,last_name,first_name"

    render :text => "Setup complete.", :status => 404 #This notifies the ominauth to continue
  end

  # Callback from Omniauth failures
  def failure
    I18n.locale = URLUtils.extract_locale_from_url(request.env['omniauth.origin']) if request.env['omniauth.origin']
    error_message = params[:error_reason] || "login error"
    kind = env["omniauth.error.strategy"].name.to_s || "Facebook"
    flash[:error] = t("devise.omniauth_callbacks.failure",:kind => kind.humanize, :reason => error_message.humanize)
    redirect_to root
  end

  # This is used if user has not confirmed her email address
  def confirmation_pending
    if @current_user.blank?
      redirect_to root
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t("sessions.confirmation_pending.confirm_your_email") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("sessions.confirmation_pending.confirm_your_email") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   
  content_for :javascript do 
 end 
 email_to_confirm = @current_user.latest_pending_email_address(@current_community) 
 if @current_user.has_admin_rights_in?(@current_community) 
 t("sessions.confirmation_pending.account_confirmation_instructions_title_admin") 
 t("sessions.confirmation_pending.your_marketplace_has_now_been_created") 
 t("sessions.confirmation_pending.account_confirmation_instructions_admin") 
 else 
 t("sessions.confirmation_pending.account_confirmation_instructions") 
 end 
 form_for(Person, :as => "person", :url => confirmation_path(:locale => I18n.locale), :html => { :method => :post, :id => "change_mistyped_email_form"} ) do |form| 
 form.hidden_field :id, :value => @current_user.id 
 form.button t("sessions.confirmation_pending.resend_confirmation_instructions"), :class => "resend_email_confirmation_button send_button" 
 t("sessions.confirmation_pending.your_current_email_is", :email => email_to_confirm).html_safe 
 link_to t('sessions.confirmation_pending.change_email'), "#", :id => "mistyped_email_link", :class => "green_part_link" 
  form_for @current_user, :html => {:id => 'change_mistyped_email_form'} do |form| 
 t('settings.account.new_email') + ":" 
 form.text_field(:email, :value => email_to_confirm, :class => "text_field text_field_account", :maxlenght => "255") 
 hidden_field_tag "request_new_email_confirmation", true 
 button_tag t('settings.account.change'), :class => "send_button" 
 end 
 
 end 
 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

end
