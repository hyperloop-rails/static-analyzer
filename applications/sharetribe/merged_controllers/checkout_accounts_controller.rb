class CheckoutAccountsController < ApplicationController
  before_filter do |controller|
    controller.ensure_logged_in "You need to be logged in in order to change payment details."
  end

  CheckoutAccountForm = FormUtils.define_form("CheckoutAccountForm", :company_id_or_personal_id, :organization_address, :phone_number, :organization_website)
    .with_validations do
      validates_presence_of :organization_address, :phone_number
      validates_format_of :company_id_or_personal_id, with: /^(\d{7}\-\d)$|^(\d{6}\D\d{3}\w)$/, allow_nil: false
    end

  def new
    redirect_to action: :show and return if @current_user.checkout_account

    @selected_left_navi_link = "payments"
    render(locals: { checkout_account: CheckoutAccountForm.new({ phone_number: @current_user.phone_number }),
                     form_action: person_checkout_account_path(@current_user) })
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
 
   
 content_for :javascript do 
 end 
 t("organizations.form.merhcant_registration_detailed_instructions", locale: :fi).html_safe 
 form_for checkout_account, url: form_action, :html => { :id => "payment_settings_form"} do |form| 
 hidden_field_tag :payment_settings, true 
 form.label :company_id_or_personal_id, t("organizations.form.company_id_or_personal_id", locale: :fi), :class => "input" 
 form.text_field :company_id_or_personal_id, :class => :text_field, :maxlenght => "11" 
 form.label :organization_address, t("organizations.form.organization_address", locale: :fi), :class => "input" 
 form.text_field :organization_address, :class => :text_field 
 form.label :phone_number, t("organizations.form.phone_number", locale: :fi) 
 form.text_field :phone_number, :class => "text_field", :maxlength => "25" 
 form.label :organization_website, t("organizations.form.organization_website", locale: :fi), :class => "input" 
 form.text_field :organization_website, :class => :text_field 
 form.button t("settings.save_information", locale: :fi), :class => "send_button" 
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

  def show
    redirect_to action: :new and return unless @current_user.checkout_account

    @selected_left_navi_link = "payments"
    render(locals: {person: @current_user})
  end

  def create
    checkout_account_form = CheckoutAccountForm.new(params[:checkout_account_form])

    if checkout_account_form.valid?
      payment_gateway = @current_community.payment_gateway
      # If updating payout details, check that they are valid
      registering_successful = payment_gateway.register_payout_details(@current_user, checkout_account_form)
      redirect_to action: :show
    else
      flash[:error] = checkout_account_form.errors.full_messages
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
 
   
 content_for :javascript do 
 end 
 t("organizations.form.merhcant_registration_detailed_instructions", locale: :fi).html_safe 
 form_for checkout_account, url: form_action, :html => { :id => "payment_settings_form"} do |form| 
 hidden_field_tag :payment_settings, true 
 form.label :company_id_or_personal_id, t("organizations.form.company_id_or_personal_id", locale: :fi), :class => "input" 
 form.text_field :company_id_or_personal_id, :class => :text_field, :maxlenght => "11" 
 form.label :organization_address, t("organizations.form.organization_address", locale: :fi), :class => "input" 
 form.text_field :organization_address, :class => :text_field 
 form.label :phone_number, t("organizations.form.phone_number", locale: :fi) 
 form.text_field :phone_number, :class => "text_field", :maxlength => "25" 
 form.label :organization_website, t("organizations.form.organization_website", locale: :fi), :class => "input" 
 form.text_field :organization_website, :class => :text_field 
 form.button t("settings.save_information", locale: :fi), :class => "send_button" 
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
end
