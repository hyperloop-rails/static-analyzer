class Admin::CommunitiesController < ApplicationController
  include CommunitiesHelper

  before_filter :ensure_is_admin
  before_filter :ensure_is_superadmin, :only => [:payment_gateways, :update_payment_gateway, :create_payment_gateway]
  before_filter :ensure_white_label_plan, only: [:create_sender_address]

  def getting_started
    @selected_left_navi_link = "getting_started"
    @community = @current_community
    render locals: {paypal_enabled: PaypalHelper.paypal_active?(@current_community.id)}
  end

  def edit_look_and_feel
    @selected_left_navi_link = "tribe_look_and_feel"
    @community = @current_community
    flash.now[:notice] = t("layouts.notifications.stylesheet_needs_recompiling") if @community.stylesheet_needs_recompile?
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
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.edit_details.community_look_and_feel") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.edit_details.community_look_and_feel") 
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
  
  
 t(".edit_community_look_and_feel", :community_name => @community.name(I18n.locale)) 
 form_for @community, :url => edit_look_and_feel_admin_community_path(@community), :method => :put do |form| 
 form.label :wide_logo, t(".community_logo"), :class => "input" 
  icon_tag("information") 
 text 
 
 form.file_field(:wide_logo, :class => "file_field") 
 form.label :logo, t(".community_logo_icon"), :class => "input" 
  icon_tag("information") 
 text 
 
 form.file_field(:logo, :class => "file_field") 
 form.label :cover_photo, t(".community_cover_photo"), :class => "input" 
  icon_tag("information") 
 text 
 
 form.file_field(:cover_photo, :class => "file_field") 
 form.label :small_cover_photo, t(".small_community_cover_photo"), :class => "input" 
  icon_tag("information") 
 text 
 
 form.file_field(:small_cover_photo, :class => "file_field") 
  icon_tag("information") 
 text 
 
 form.label :favicon, t(".favicon"), :class => "input" 
  icon_tag("information") 
 text 
 
 form.file_field(:favicon, :class => "file_field") 
 form.label :custom_color1, t(".community_custom_color1"), :class => "input" 
  icon_tag("information") 
 text 
 
 form.text_field :custom_color1, :maxlength => "6", :class => "text_field" 
 form.label :custom_color2, t(".community_custom_color2"), :class => "input" 
  icon_tag("information") 
 text 
 
 form.text_field :custom_color2, :maxlength => "6", :class => "text_field" 
 form.label :default_browse_view, t(".default_browse_view") 
  icon_tag("information") 
 text 
 
 form.select :default_browse_view, [[t(".grid"), "grid"], [t(".list"), "list"], [t(".map"), "map"]] 
 form.label :name_display_type, t(".name_display_type") 
  icon_tag("information") 
 text 
 
 form.select :name_display_type, [[t(".full_name"), "full_name"], [t(".first_name_with_initial"), "first_name_with_initial"], [t(".first_name_only"), "first_name_only"]] 
 form.label :custom_head_script, t(".custom_head_script") 
  icon_tag("information") 
 text 
 
 form.text_area :custom_head_script, class: "text_area_code", placeholder: "<script src=\"http://example.com/customscript.js\"></script>" 
 form.button t("admin.communities.edit_details.update_information"), :id => "edit_community_button", :class => "send_button" 
 end 
  render :layout => "layouts/lightbox", locals: {id: field, field: field} do 
 unless field.eql?("terms") 
 t("people.help_texts.#{field}_title") 
 end 
 render :partial => "people/help_texts/#{field}" 
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

  def edit_text_instructions
    @selected_left_navi_link = "text_instructions"
    @community = @current_community
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
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
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

  def edit_welcome_email
    @selected_left_navi_link = "welcome_email"
    @community = @current_community
    @recipient = @current_user
    @url_params = {
      :host => @current_community.full_domain,
      :ref => "welcome_email",
      :locale => @current_user.locale
    }

    sender_address = EmailService::API::Api.addresses.get_sender(community_id: @current_community.id).data
    user_defined_address = EmailService::API::Api.addresses.get_user_defined(community_id: @current_community.id).data

    enqueue_status_sync!(user_defined_address)

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
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
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
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
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

  def create_sender_address
    res = EmailService::API::Api.addresses.create(
      community_id: @current_community.id,
      address: {
        name: params[:name],
        email: params[:email]
      })

    if res.success
      flash[:notice] =
        t("admin.communities.outgoing_email.successfully_saved")

      redirect_to action: :edit_welcome_email
    else
      error_message =
        case Maybe(res.data)[:error_code]
        when Some(:invalid_email)
          t("admin.communities.outgoing_email.invalid_email_error", email: res.data[:email])
        when Some(:invalid_domain)
          kb_link = view_context.link_to(t("admin.communities.outgoing_email.invalid_email_domain_read_more_link"), "#{APP_CONFIG.knowledge_base_url}/articles/686493", class: "flash-error-link")
          t("admin.communities.outgoing_email.invalid_email_domain", email: res.data[:email], domain: res.data[:domain], invalid_email_domain_read_more_link: kb_link).html_safe
        else
          t("admin.communities.outgoing_email.unknown_error")
        end

      flash[:error] = error_message
      redirect_to action: :edit_welcome_email
    end

  end

  def check_email_status
    res = EmailService::API::Api.addresses.get_user_defined(community_id: @current_community.id)

    if res.success
      address = res.data

      if params[:sync]
        enqueue_status_sync!(address)
      end

      render json: HashUtils.camelize_keys(address.merge(translated_verification_sent_time_ago: time_ago(address[:verification_requested_at])))
    else
      render json: {error: res.error_msg }, status: 500
    end

  end

  def resend_verification_email
    EmailService::API::Api.addresses.enqueue_verification_request(community_id: @current_community.id, id: params[:address_id])
    render json: {}, status: 200
  end

  def social_media
    @selected_left_navi_link = "social_media"
    @community = @current_community
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
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.social_media.social_media") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.social_media.social_media") 
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
  
  
 t(".social_media") 
 form_for @community, :url => social_media_admin_community_path(@community), :method => :put do |form| 
 t(".twitter_handle") 
 if display_knowledge_base_articles 
 twitter_instructions_link = link_to(t("admin.communities.social_media.twitter_instructions_link_text"), "#{knowledge_base_url}/articles/437993-how-to-configure-twitter-mention" ) 
  icon_tag("information") 
 text 
 
 else 
  icon_tag("information") 
 text 
 
 end 
 form.text_field :twitter_handle, :maxlength => "15", :class => "text_field", :placeholder => t(".twitter_handle_placeholder") 
 if @community.errors.any? 
 @community.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 t('.facebook_connect') 
 if display_knowledge_base_articles 
 facebook_instructions_link = link_to(t("admin.communities.social_media.facebook_instructions_link_text"), "#{knowledge_base_url}/articles/412490-how-to-configure-facebook-connect" ) 
  icon_tag("information") 
 text 
 
 else 
  icon_tag("information") 
 text 
 
 end 
 form.label :facebook_connect_id, t(".facebook_connect_id"), :class => "input" 
 form.text_field :facebook_connect_id, :maxlength => "16", :class => "text_field", :placeholder => "1234567890123456" 
 form.label :facebook_connect_secret, t(".facebook_connect_secret"), :class => "input" 
 form.text_field :facebook_connect_secret, :maxlength => "32", :class => "text_field", :placeholder => "#{Digest::MD5.hexdigest('1')}" 
 form.button t("admin.communities.social_media.save") 
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
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.social_media.social_media") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.social_media.social_media") 
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
  
  
 t(".social_media") 
 form_for @community, :url => social_media_admin_community_path(@community), :method => :put do |form| 
 t(".twitter_handle") 
 if display_knowledge_base_articles 
 twitter_instructions_link = link_to(t("admin.communities.social_media.twitter_instructions_link_text"), "#{knowledge_base_url}/articles/437993-how-to-configure-twitter-mention" ) 
  icon_tag("information") 
 text 
 
 else 
  icon_tag("information") 
 text 
 
 end 
 form.text_field :twitter_handle, :maxlength => "15", :class => "text_field", :placeholder => t(".twitter_handle_placeholder") 
 if @community.errors.any? 
 @community.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 t('.facebook_connect') 
 if display_knowledge_base_articles 
 facebook_instructions_link = link_to(t("admin.communities.social_media.facebook_instructions_link_text"), "#{knowledge_base_url}/articles/412490-how-to-configure-facebook-connect" ) 
  icon_tag("information") 
 text 
 
 else 
  icon_tag("information") 
 text 
 
 end 
 form.label :facebook_connect_id, t(".facebook_connect_id"), :class => "input" 
 form.text_field :facebook_connect_id, :maxlength => "16", :class => "text_field", :placeholder => "1234567890123456" 
 form.label :facebook_connect_secret, t(".facebook_connect_secret"), :class => "input" 
 form.text_field :facebook_connect_secret, :maxlength => "32", :class => "text_field", :placeholder => "#{Digest::MD5.hexdigest('1')}" 
 form.button t("admin.communities.social_media.save") 
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

  def analytics
    @selected_left_navi_link = "analytics"
    @community = @current_community
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
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.analytics.analytics") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.analytics.analytics") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   
  
 t(".analytics", :community_name => @community.name(I18n.locale)) 
 form_for @community, :url => analytics_admin_community_path(@community), :method => :put do |form| 
 t(".google_analytics_key") 
 if display_knowledge_base_articles 
 instructions_link = link_to(t("admin.communities.analytics.google_analytics_instructions_link_text"), "#{knowledge_base_url}/articles/412735-how-to-configure-google-analytics" ) 
  icon_tag("information") 
 text 
 
 else 
  icon_tag("information") 
 text 
 
 end 
 form.text_field :google_analytics_key, :maxlength => "15", :class => "text_field", :placeholder => "UA-12345-12" 
 form.button t("admin.communities.analytics.save") 
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
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.analytics.analytics") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.analytics.analytics") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   
  
 t(".analytics", :community_name => @community.name(I18n.locale)) 
 form_for @community, :url => analytics_admin_community_path(@community), :method => :put do |form| 
 t(".google_analytics_key") 
 if display_knowledge_base_articles 
 instructions_link = link_to(t("admin.communities.analytics.google_analytics_instructions_link_text"), "#{knowledge_base_url}/articles/412735-how-to-configure-google-analytics" ) 
  icon_tag("information") 
 text 
 
 else 
  icon_tag("information") 
 text 
 
 end 
 form.text_field :google_analytics_key, :maxlength => "15", :class => "text_field", :placeholder => "UA-12345-12" 
 form.button t("admin.communities.analytics.save") 
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

  def menu_links
    @selected_left_navi_link = "menu_links"
    @community = @current_community
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
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
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

  def update_menu_links
    @community = @current_community

    update(@community,
            Maybe(params)[:menu_links].or_else({menu_link_attributes: {}}),
            menu_links_admin_community_path(@community),
            :menu_links)
  end

  # This is currently only for superadmins, quick and hack solution
  def payment_gateways
    # Redirect if payment gateway in use but it's not braintree
    redirect_to edit_details_admin_community_path(@current_community) if @current_community.payment_gateway && !@current_community.braintree_in_use?

    @selected_left_navi_link = "payment_gateways"
    @community = @current_community
    @payment_gateway = Maybe(@current_community).payment_gateway.or_else { BraintreePaymentGateway.new }

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
 t("layouts.admin.admin") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   
  
 t(".braintree_payment_gateway", :community_name => @community.name(I18n.locale)) 
 if @payment_gateway.configured? 
 hook_url = "#{request.protocol}webhooks.#{APP_CONFIG.domain}/webhooks/braintree?community_id=#{@current_community.id}" 
 link_to hook_url, hook_url 
 end 
 form_tag payment_gateways_admin_community_path(@community), :method => (@payment_gateway.new_record? ? :post : :put) do 
 fields_for :payment_gateway, @payment_gateway do |form| 
 form.label :braintree_environment, t(".environment"), :class => "input" 
 form.select :braintree_environment, [["Sandbox", "sandbox"], ["Production", "production"]] 
 form.label :braintree_public_key, t(".public_key"), :class => "input" 
 form.text_field :braintree_public_key, :class => "text_field" 
 form.label :braintree_private_key, t(".private_key"), :class => "input" 
 form.text_field :braintree_private_key, :class => "text_field" 
 form.label :braintree_merchant_id, t(".merchant_id"), :class => "input" 
 form.text_field :braintree_merchant_id, :class => "text_field" 
 form.label :braintree_master_merchant_id, t(".master_merchant_id"), :class => "input" 
 form.text_field :braintree_master_merchant_id, :class => "text_field" 
 form.label :braintree_client_side_encryption_key, t(".client_side_encryption_key"), :class => "input" 
 form.text_area :braintree_client_side_encryption_key, :class => "text_field" 
 end 
 fields_for :community, @current_community do |form| 
 form.label :commission_from_seller, t(".commission_from_seller"), :class => "input" 
 form.number_field :commission_from_seller, in: 0..100 
 end 
 button_tag t("admin.communities.social_media.save") 
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

  def update_payment_gateway
    # Redirect if payment gateway in use but it's not braintree
    redirect_to edit_details_admin_community_path(@current_community) if @current_community.payment_gateway && !@current_community.braintree_in_use?

    braintree_params = params[:payment_gateway]
    community_params = params[:community]

    unless @current_community.update_attributes(community_params)
      flash.now[:error] = t("layouts.notifications.community_update_failed")
      return render :payment_gateways
    end

    update(@current_community.payment_gateway,
      braintree_params,
      payment_gateways_admin_community_path(@current_community),
      :payment_gateways)
  end

  def create_payment_gateway
    @current_community.payment_gateway = BraintreePaymentGateway.create(params[:payment_gateway].merge(community: @current_community))
    update_payment_gateway
  end

  def test_welcome_email
    PersonMailer.welcome_email(@current_user, @current_community, true, true).deliver
    flash[:notice] = t("layouts.notifications.test_welcome_email_delivered_to", :email => @current_user.confirmed_notification_email_to)
    redirect_to edit_welcome_email_admin_community_path(@current_community)
  end

  def settings
    @selected_left_navi_link = "admin_settings"

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
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.settings.settings") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.settings.settings") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   
  
 form_for @current_community, :url => update_settings_admin_community_path(@current_community), :method => :put do |form| 
 t(".settings") 
 Maybe(@current_community).payment_gateway.each do 
 t(".general") 
 form.check_box :testimonials_in_use 
 form.label :testimonials_in_use, t(".users_can_review_each_other_after_transaction"), :class => "settings-checkbox-label" 
 end 
 t(".access") 
 form.check_box :join_with_invite_only 
 form.label :join_with_invite_only, t(".join_with_invite_only"), :class => "settings-checkbox-label" 
 form.check_box :users_can_invite_new_users 
 form.label :users_can_invite_new_users, t(".users_can_invite_new_users"), :class => "settings-checkbox-label" 
 form.check_box :private 
 form.label :private, t(".private"), :class => "settings-checkbox-label" 
 form.check_box :require_verification_to_post_listings 
 form.label :require_verification_to_post_listings, t(".require_verification_to_post_listings"), :class => "settings-checkbox-label" 
 t(".listing_preferences") 
 form.check_box :show_category_in_listing_list 
 form.label :show_category_in_listing_list, t(".show_category_in_listing_list"), :class => "settings-checkbox-label" 
 form.check_box :show_listing_publishing_date 
 form.label :show_listing_publishing_date, t(".show_listing_publishing_date"), :class => "settings-checkbox-label" 
 form.check_box :hide_expiration_date 
 form.label :hide_expiration_date, t(".hide_expiration_date"), :class => "settings-checkbox-label" 
 form.check_box :listing_comments_in_use 
 form.label :listing_comments_in_use, t(".listing_comments_in_use"), :class => "settings-checkbox-label" 
 if @current_community.payments_in_use? 
 t(".transaction_preferences") 
 day_dropdown = form.select :automatic_confirmation_after_days, (1..100), {}, :class => "inline-select" 
 if supports_escrow 
 t(".automatically_confirmed", :days_dropdown => day_dropdown).html_safe 
 else 
 t(".automatically_confirmed_no_escrow", :days_dropdown => day_dropdown).html_safe 
 end 
 end 
 t(".email_preferences") 
 form.check_box :automatic_newsletters 
 form.label :automatic_newsletters, t(".automatic_newsletters"), :class => "settings-checkbox-label" 
 frequence_dropdown = form.select :default_min_days_between_community_updates, [[t(".newsletter_daily"), 1], [t(".newsletter_weekly"), 7]], {}, :class => "inline-select" 
 t(".automatic_newsletter_frequency", :frequency_dropdown => frequence_dropdown).html_safe 
 form.check_box :email_admins_about_new_members 
 form.label :email_admins_about_new_members, t(".email_admins_about_new_members"), :class => "settings-checkbox-label" 
 form.button t(".update_settings") 
 end 
 content_for :extra_javascript do 
 end 
 if can_delete_marketplace 
 icon_tag("alert", ["icon-fix"]) 
 t("admin.communities.settings.delete_marketplace_title") 
 t("admin.communities.settings.once_you_delete") 
 button_tag t("admin.communities.settings.delete_this_marketplace"), class: "delete-button js-delete-marketplace-button" 
 form_tag delete_marketplace_admin_community_path(@current_community), method: :delete, class: "hidden js-delete-marketplace-confirmation-form" do 
 t("admin.communities.settings.are_you_sure") 
 if delete_redirect_url 
 t("admin.communities.settings.you_will_be_redirected_to", destination: delete_redirect_url) 
 end 
 t("admin.communities.settings.last_community_updates") 
 t("admin.communities.settings.type_marketplace_domain", domain: delete_confirmation) 
 text_field_tag :delete_confirmation, nil, placeholder: t("admin.communities.settings.type_marketplace_domain_placeholder"), class: "js-delete-marketplace-confirmation-domain" 
 button_tag t("admin.communities.settings.i_understand_button"), class: "delete-button js-confirmation-button" 
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
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.settings.settings") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.settings.settings") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   
  
 form_for @current_community, :url => update_settings_admin_community_path(@current_community), :method => :put do |form| 
 t(".settings") 
 Maybe(@current_community).payment_gateway.each do 
 t(".general") 
 form.check_box :testimonials_in_use 
 form.label :testimonials_in_use, t(".users_can_review_each_other_after_transaction"), :class => "settings-checkbox-label" 
 end 
 t(".access") 
 form.check_box :join_with_invite_only 
 form.label :join_with_invite_only, t(".join_with_invite_only"), :class => "settings-checkbox-label" 
 form.check_box :users_can_invite_new_users 
 form.label :users_can_invite_new_users, t(".users_can_invite_new_users"), :class => "settings-checkbox-label" 
 form.check_box :private 
 form.label :private, t(".private"), :class => "settings-checkbox-label" 
 form.check_box :require_verification_to_post_listings 
 form.label :require_verification_to_post_listings, t(".require_verification_to_post_listings"), :class => "settings-checkbox-label" 
 t(".listing_preferences") 
 form.check_box :show_category_in_listing_list 
 form.label :show_category_in_listing_list, t(".show_category_in_listing_list"), :class => "settings-checkbox-label" 
 form.check_box :show_listing_publishing_date 
 form.label :show_listing_publishing_date, t(".show_listing_publishing_date"), :class => "settings-checkbox-label" 
 form.check_box :hide_expiration_date 
 form.label :hide_expiration_date, t(".hide_expiration_date"), :class => "settings-checkbox-label" 
 form.check_box :listing_comments_in_use 
 form.label :listing_comments_in_use, t(".listing_comments_in_use"), :class => "settings-checkbox-label" 
 if @current_community.payments_in_use? 
 t(".transaction_preferences") 
 day_dropdown = form.select :automatic_confirmation_after_days, (1..100), {}, :class => "inline-select" 
 if supports_escrow 
 t(".automatically_confirmed", :days_dropdown => day_dropdown).html_safe 
 else 
 t(".automatically_confirmed_no_escrow", :days_dropdown => day_dropdown).html_safe 
 end 
 end 
 t(".email_preferences") 
 form.check_box :automatic_newsletters 
 form.label :automatic_newsletters, t(".automatic_newsletters"), :class => "settings-checkbox-label" 
 frequence_dropdown = form.select :default_min_days_between_community_updates, [[t(".newsletter_daily"), 1], [t(".newsletter_weekly"), 7]], {}, :class => "inline-select" 
 t(".automatic_newsletter_frequency", :frequency_dropdown => frequence_dropdown).html_safe 
 form.check_box :email_admins_about_new_members 
 form.label :email_admins_about_new_members, t(".email_admins_about_new_members"), :class => "settings-checkbox-label" 
 form.button t(".update_settings") 
 end 
 content_for :extra_javascript do 
 end 
 if can_delete_marketplace 
 icon_tag("alert", ["icon-fix"]) 
 t("admin.communities.settings.delete_marketplace_title") 
 t("admin.communities.settings.once_you_delete") 
 button_tag t("admin.communities.settings.delete_this_marketplace"), class: "delete-button js-delete-marketplace-button" 
 form_tag delete_marketplace_admin_community_path(@current_community), method: :delete, class: "hidden js-delete-marketplace-confirmation-form" do 
 t("admin.communities.settings.are_you_sure") 
 if delete_redirect_url 
 t("admin.communities.settings.you_will_be_redirected_to", destination: delete_redirect_url) 
 end 
 t("admin.communities.settings.last_community_updates") 
 t("admin.communities.settings.type_marketplace_domain", domain: delete_confirmation) 
 text_field_tag :delete_confirmation, nil, placeholder: t("admin.communities.settings.type_marketplace_domain_placeholder"), class: "js-delete-marketplace-confirmation-domain" 
 button_tag t("admin.communities.settings.i_understand_button"), class: "delete-button js-confirmation-button" 
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

  def update_look_and_feel
    @community = @current_community
    @selected_left_navi_link = "tribe_look_and_feel"

    params[:community][:custom_color1] = nil if params[:community][:custom_color1] == ""
    params[:community][:custom_color2] = nil if params[:community][:custom_color2] == ""

    permitted_params = [
      :wide_logo, :logo,:cover_photo, :small_cover_photo, :favicon, :custom_color1,
      :custom_color2, :default_browse_view, :name_display_type
    ]
    permitted_params << :custom_head_script
    params.require(:community).permit(*permitted_params)
    update(@current_community,
           params[:community].merge(stylesheet_needs_recompile: regenerate_css?(params, @current_community)),
           edit_look_and_feel_admin_community_path(@current_community),
           :edit_look_and_feel) {
      Delayed::Job.enqueue(CompileCustomStylesheetJob.new(@current_community.id), priority: 3)
    }
  end

  def update_social_media
    @community = @current_community
    @selected_left_navi_link = "social_media"

    [:twitter_handle,
     :facebook_connect_id,
     :facebook_connect_secret].each do |param|
      params[:community][param] = nil if params[:community][param] == ""
    end

    params.require(:community).permit(
      :twitter_handle, :facebook_connect_id, :facebook_connect_secret
    )

    update(@current_community,
            params[:community],
            social_media_admin_community_path(@current_community),
            :social_media)
  end

  def update_analytics
    @community = @current_community
    @selected_left_navi_link = "analytics"

    params[:community][:google_analytics_key] = nil if params[:community][:google_analytics_key] == ""
    params.require(:community).permit(:google_analytics_key)
    update(@current_community,
            params[:community],
            analytics_admin_community_path(@current_community),
            :analytics)
  end

  def update_settings
    @selected_left_navi_link = "settings"

    permitted_params = [
      :join_with_invite_only, :users_can_invite_new_users, :private,
      :require_verification_to_post_listings,
      :show_category_in_listing_list, :show_listing_publishing_date,
      :hide_expiration_date, :listing_comments_in_use,
      :automatic_confirmation_after_days, :automatic_newsletters,
      :default_min_days_between_community_updates,
      :email_admins_about_new_members
    ]
    permitted_params << :testimonials_in_use if @current_community.payment_gateway
    params.require(:community).permit(*permitted_params)

    maybe_update_payment_settings(@current_community.id, params[:community][:automatic_confirmation_after_days])

    update(@current_community,
            params[:community],
            settings_admin_community_path(@current_community),
            :settings)
  end

  def delete_marketplace
    if can_delete_marketplace?(@current_community.id) && params[:delete_confirmation] == @current_community.ident
      @current_community.update_attributes(deleted: true)

      redirect_to Maybe(delete_redirect_url(APP_CONFIG)).or_else(:community_not_found)
    else
      flash[:error] = "Could not delete marketplace."
      redirect_to action: :settings
    end

  end

  private

  def enqueue_status_sync!(address)
    Maybe(address)
      .reject { |addr| addr[:verification_status] == :verified }
      .each { |addr|
      EmailService::API::Api.addresses.enqueue_status_sync(
        community_id: addr[:community_id],
        id: addr[:id])
    }
  end

  def regenerate_css?(params, community)
    params[:community][:custom_color1] != community.custom_color1 ||
    params[:community][:custom_color2] != community.custom_color2 ||
    !params[:community][:cover_photo].nil? ||
    !params[:community][:small_cover_photo].nil? ||
    !params[:community][:wide_logo].nil? ||
    !params[:community][:logo].nil? ||
    !params[:community][:favicon].nil?
  end

  def update(model, params, path, action, &block)
    if model.update_attributes(params)
      flash[:notice] = t("layouts.notifications.community_updated")
      yield if block_given? #on success, call optional block
      redirect_to path
    else
      flash.now[:error] = t("layouts.notifications.community_update_failed")
      render action
    end
  end

  # TODO The home of this setting should be in payment settings but
  # those are only used with paypal for now. During the transition
  # period we simply mirror community setting to payment settings in
  # case of paypal.
  def maybe_update_payment_settings(community_id, automatic_confirmation_after_days)
    return unless automatic_confirmation_after_days

    p_set = Maybe(payment_settings_api.get(
                   community_id: community_id,
                   payment_gateway: :paypal,
                   payment_process: :preauthorize))
            .map {|res| res[:success] ? res[:data] : nil}
            .or_else(nil)

    payment_settings_api.update(p_set.merge({confirmation_after_days: automatic_confirmation_after_days.to_i})) if p_set
  end

  def payment_settings_api
    TransactionService::API::Api.settings
  end

  def escrow_payments?(community)
    MarketplaceService::Community::Query.payment_type(community.id) == :braintree
  end

  def delete_redirect_url(configs)
    Maybe(configs).community_not_found_redirect.or_else(nil)
  end

  def can_delete_marketplace?(community_id)
    PlanService::API::Api.plans.get_current(community_id: community_id).data[:plan_level] == PlanUtils::FREE
  end

  def can_set_sender_address(plan)
    PlanUtils.valid_plan_at_least?(plan, PlanUtils::PRO)
  end

  def ensure_white_label_plan
    unless can_set_sender_address(@current_plan)
      flash[:error] = "Not available for your plan" # User shouldn't
                                                    # normally come
                                                    # here because
                                                    # access is
                                                    # restricted in
                                                    # front-end. Thus,
                                                    # no need to
                                                    # translate.

      redirect_to action: :edit_welcome_email
    end
  end

end
