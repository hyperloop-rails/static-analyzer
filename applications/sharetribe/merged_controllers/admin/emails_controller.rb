# encoding: utf-8
class Admin::EmailsController < ApplicationController

  before_filter :ensure_is_admin

  def new
    @selected_tribe_navi_tab = "admin"
    @selected_left_navi_link = "email_members"
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
 t("admin.emails.new.send_email_to_members") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.emails.new.send_email_to_members") 
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
  
  
 t(".send_email_to_members_title") 
 form_for :email, :url => admin_community_emails_path(:community_id => @current_community.id), :html => { :id => "new_member_email" } do |form| 
 form.label :subject, t(".email_subject") 
 form.text_field :subject 
 form.label :content, t(".email_content") 
 form.text_area :content, :placeholder => t(".email_content_placeholder"), :class => "email_members_text_area" 
 if available_locales.size > 1 
 label_tag "email_language", t(".email_language") 
  text 
 
 options = [[t(".any_language"), "any"]] | available_locales 
 select_tag "email[locale]", options_for_select(options, "any") 
 else 
 form.hidden_field :locale, :value => "any" 
 end 
 button_tag t(".send_email"), :class => "send_button" 
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
    content = params[:email][:content].gsub(/[”“]/, '"') if params[:email][:content] # Fix UTF-8 quotation marks
    Delayed::Job.enqueue(CreateMemberEmailBatchJob.new(@current_user.id, @current_community.id, params[:email][:subject], content, params[:email][:locale]))
    flash[:notice] = t("admin.emails.new.email_sent")
    redirect_to :action => :new
  end

end
