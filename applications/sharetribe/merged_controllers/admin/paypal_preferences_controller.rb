class Admin::PaypalPreferencesController < ApplicationController
  before_filter :ensure_is_admin
  before_filter :ensure_paypal_provisioned

  PaypalAccountForm = FormUtils.define_form("PaypalAccountForm", :paypal_email, :commission_from_seller)
    .with_validations { validates_presence_of :paypal_email }

  MIN_COMMISSION_PERCENTAGE = 0
  MAX_COMMISSION_PERCENTAGE = 100

  PaypalPreferencesForm = FormUtils.define_form("PaypalPreferencesForm",
    :commission_from_seller,
    :minimum_listing_price,
    :minimum_commission,
    :minimum_transaction_fee
    ).with_validations do
      validates_numericality_of(
        :commission_from_seller,
        only_integer: true,
        allow_nil: false,
        greater_than_or_equal_to: MIN_COMMISSION_PERCENTAGE,
        less_than_or_equal_to: MAX_COMMISSION_PERCENTAGE)

      validate do |prefs|
        if minimum_listing_price.nil? || minimum_listing_price < minimum_commission
          prefs.errors[:base] << I18n.t("admin.paypal_accounts.minimum_listing_price_below_min",
                                        { minimum_commission: minimum_commission })
        elsif minimum_transaction_fee && minimum_listing_price < minimum_transaction_fee
          prefs.errors[:base] << I18n.t("admin.paypal_accounts.minimum_listing_price_below_tx_fee",
                                        { minimum_transaction_fee: minimum_transaction_fee })
        end
      end
    end

  def index
    @selected_left_navi_link = "paypal_account"
    paypal_account = accounts_api.get(community_id: @current_community.id).maybe
    currency = @current_community.default_currency
    minimum_commission = paypal_minimum_commissions_api.get(currency)

    tx_settings =
      Maybe(tx_settings_api.get(community_id: @current_community.id, payment_gateway: :paypal, payment_process: :preauthorize))
      .select { |result| result[:success] }
      .map { |result| result[:data] }
      .or_else({})

    paypal_prefs_form = PaypalPreferencesForm.new(
      minimum_commission: minimum_commission,
      commission_from_seller: tx_settings[:commission_from_seller],
      minimum_listing_price: Money.new(tx_settings[:minimum_price_cents], @current_community.default_currency),
      minimum_transaction_fee: Money.new(tx_settings[:minimum_transaction_fee_cents], @current_community.default_currency)
    )

    community_country_code = LocalizationUtils.valid_country_code(@current_community.country)

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
 t("admin.communities.paypal_account.paypal_admin_account") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.paypal_account.paypal_admin_account") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  content_for :extra_javascript do 
 end 
  
  
 content_for :extra_javascript do 
 end 
 t("admin.paypal_accounts.marketplace_paypal_integration") 
 t("admin.paypal_accounts.marketplace_currency_used", currency: "<strong>#{currency}</strong>",        contact_support_link: link_to(t("admin.paypal_accounts.contact_support_link_text"), "mailto:support@sharetribe.com")).html_safe 
 t("admin.paypal_accounts.integration_info_text").html_safe 
 if display_knowledge_base_articles 
 link_to t("admin.paypal_accounts.read_more_about_paypal"), "#{knowledge_base_url}/articles/501684" 
 end 
 t("admin.paypal_accounts.link_paypal_personal_account_label") 
 t("admin.paypal_accounts.link_paypal_personal_account",        personal_payment_preferences_link: link_to(t("admin.paypal_accounts.personal_payment_preferences_link_text"),          paypal_account_settings_payment_path(@current_user.username))).html_safe 
 if paypal_account_email.present? # has linked their PayPal account 
 paypal_redirect_link = "<a href='#' id='ask_paypal_permissions_redirect'>#{t("paypal_accounts.redirect_link_text")}</a>" 
  icon_tag("check", ["icon-fix"]) 
 t("paypal_accounts.paypal_account_connected_title") 
 t("paypal_accounts.paypal_account_connected", :email => paypal_account_email) 
 t("paypal_accounts.change_account") 
 paypal_redirect_link = "<a href='#' id='ask_paypal_permissions_redirect'>#{t("paypal_accounts.redirect_link_text")}</a>" 
 t("paypal_accounts.redirect_message", redirect_link: paypal_redirect_link).html_safe 
 
 form_for paypal_prefs_form, url: paypal_prefs_form_action, html: { id: "paypal_preferences_form" } do |form| 
 if paypal_prefs_valid 
 icon_tag("check", ["icon-fix", "paypal-success-mark"]) 
 end 
 t("admin.paypal_accounts.set_minimum_price_and_fee") 
 form.label :minimum_listing_price, t("admin.paypal_accounts.minimum_listing_price_label"), class: "paypal-horizontal-input-label" 
 form.text_field :minimum_listing_price, class: "paypal-preferences-input" 
 currency 
 form.label :commission_from_seller, t("admin.paypal_accounts.transaction_fee_label"), class: "paypal-horizontal-input-label" 
 form.text_field :commission_from_seller, class: "paypal-preferences-input" 
 "%" 
 form.label :minimum_transaction_fee, t("admin.paypal_accounts.minimum_transaction_fee_label"), class: "paypal-horizontal-input-label" 
 form.text_field :minimum_transaction_fee, class: "paypal-preferences-input" 
 currency 
 form.button t("admin.paypal_accounts.save_settings") 
 end 
 else # no PayPal account connected 
 t("paypal_accounts.new.connect_paypal_account_title") 
 t("paypal_accounts.new.connect_paypal_account_instructions") 
 t("paypal_accounts.new.connect_paypal_account") 
 paypal_redirect_link = "<a href='#' id='ask_paypal_permissions_redirect'>#{t("paypal_accounts.redirect_link_text")}</a>" 
 t("paypal_accounts.redirect_message", redirect_link: paypal_redirect_link).html_safe 
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
 t("admin.communities.paypal_account.paypal_admin_account") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.paypal_account.paypal_admin_account") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  content_for :extra_javascript do 
 end 
  
  
 content_for :extra_javascript do 
 end 
 t("admin.paypal_accounts.marketplace_paypal_integration") 
 t("admin.paypal_accounts.marketplace_currency_used", currency: "<strong>#{currency}</strong>",        contact_support_link: link_to(t("admin.paypal_accounts.contact_support_link_text"), "mailto:support@sharetribe.com")).html_safe 
 t("admin.paypal_accounts.integration_info_text").html_safe 
 if display_knowledge_base_articles 
 link_to t("admin.paypal_accounts.read_more_about_paypal"), "#{knowledge_base_url}/articles/501684" 
 end 
 t("admin.paypal_accounts.link_paypal_personal_account_label") 
 t("admin.paypal_accounts.link_paypal_personal_account",        personal_payment_preferences_link: link_to(t("admin.paypal_accounts.personal_payment_preferences_link_text"),          paypal_account_settings_payment_path(@current_user.username))).html_safe 
 if paypal_account_email.present? # has linked their PayPal account 
 paypal_redirect_link = "<a href='#' id='ask_paypal_permissions_redirect'>#{t("paypal_accounts.redirect_link_text")}</a>" 
  icon_tag("check", ["icon-fix"]) 
 t("paypal_accounts.paypal_account_connected_title") 
 t("paypal_accounts.paypal_account_connected", :email => paypal_account_email) 
 t("paypal_accounts.change_account") 
 paypal_redirect_link = "<a href='#' id='ask_paypal_permissions_redirect'>#{t("paypal_accounts.redirect_link_text")}</a>" 
 t("paypal_accounts.redirect_message", redirect_link: paypal_redirect_link).html_safe 
 
 form_for paypal_prefs_form, url: paypal_prefs_form_action, html: { id: "paypal_preferences_form" } do |form| 
 if paypal_prefs_valid 
 icon_tag("check", ["icon-fix", "paypal-success-mark"]) 
 end 
 t("admin.paypal_accounts.set_minimum_price_and_fee") 
 form.label :minimum_listing_price, t("admin.paypal_accounts.minimum_listing_price_label"), class: "paypal-horizontal-input-label" 
 form.text_field :minimum_listing_price, class: "paypal-preferences-input" 
 currency 
 form.label :commission_from_seller, t("admin.paypal_accounts.transaction_fee_label"), class: "paypal-horizontal-input-label" 
 form.text_field :commission_from_seller, class: "paypal-preferences-input" 
 "%" 
 form.label :minimum_transaction_fee, t("admin.paypal_accounts.minimum_transaction_fee_label"), class: "paypal-horizontal-input-label" 
 form.text_field :minimum_transaction_fee, class: "paypal-preferences-input" 
 currency 
 form.button t("admin.paypal_accounts.save_settings") 
 end 
 else # no PayPal account connected 
 t("paypal_accounts.new.connect_paypal_account_title") 
 t("paypal_accounts.new.connect_paypal_account_instructions") 
 t("paypal_accounts.new.connect_paypal_account") 
 paypal_redirect_link = "<a href='#' id='ask_paypal_permissions_redirect'>#{t("paypal_accounts.redirect_link_text")}</a>" 
 t("paypal_accounts.redirect_message", redirect_link: paypal_redirect_link).html_safe 
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

  def preferences_update
    currency = @current_community.default_currency
    minimum_commission = paypal_minimum_commissions_api.get(currency)

    paypal_prefs_form = PaypalPreferencesForm.new(
      parse_preferences(params[:paypal_preferences_form], currency).merge(minimum_commission: minimum_commission))

    if paypal_prefs_form.valid?
      tx_settings_api.update({community_id: @current_community.id,
                              payment_gateway: :paypal,
                              payment_process: :preauthorize,
                              commission_from_seller: paypal_prefs_form.commission_from_seller.to_i,
                              minimum_price_cents: paypal_prefs_form.minimum_listing_price.cents,
                              minimum_transaction_fee_cents: paypal_prefs_form.minimum_transaction_fee.cents})

      flash[:notice] = t("admin.paypal_accounts.preferences_updated")
    else
      flash[:error] = paypal_prefs_form.errors.full_messages.join(", ")
    end

    redirect_to action: :index
  end

  def account_create
    community_country_code = LocalizationUtils.valid_country_code(@current_community.country)
    response = accounts_api.request(
      body: PaypalService::API::DataTypes.create_create_account_request(
      {
        community_id: @current_community.id,
        callback_url: admin_paypal_preferences_permissions_verified_url,
        country: community_country_code
      }))
    permissions_url = response.data[:redirect_url]

    if permissions_url.blank?
      flash[:error] = t("paypal_accounts.new.could_not_fetch_redirect_url")
      return redirect_to action: :index
    else
      render json: {redirect_url: permissions_url}
    end
  end

  def permissions_verified
    unless params[:verification_code].present?
      flash[:error] = t("paypal_accounts.new.permissions_not_granted")
      return redirect_to action: :index
    end

    response = accounts_api.create(
      community_id: @current_community.id,
      order_permission_request_token: params[:request_token],
      body: PaypalService::API::DataTypes
        .create_account_permission_verification_request(
          {
            order_permission_verification_code: params[:verification_code]
          }))

    if response[:success]
      redirect_to action: :index
    else
      flash_error_and_redirect_to_settings(error_response: response)
    end
  end

  private

  def parse_preferences(params, currency)
    {
      minimum_listing_price: MoneyUtil.parse_str_to_money(params[:minimum_listing_price], currency),
      minimum_transaction_fee: MoneyUtil.parse_str_to_money(params[:minimum_transaction_fee], currency),
      commission_from_seller: params[:commission_from_seller]
    }
  end

  # Before filter
  def ensure_paypal_provisioned
    unless PaypalHelper.paypal_provisioned?(@current_community.id)
      flash[:error] = t("paypal_accounts.new.paypal_not_enabled")
      redirect_to edit_details_admin_community_path(@current_community)
    end
  end

  def flash_error_and_redirect_to_settings(error_response: nil)
    error =
      if (error_response && error_response[:error_code] == "570058")
        t("paypal_accounts.new.account_not_verified")
      elsif (error_response && error_response[:error_code] == "520009")
        t("paypal_accounts.new.account_restricted")
      else
        t("paypal_accounts.new.something_went_wrong")
      end

    flash[:error] = error
    redirect_to action: :index
  end

  def paypal_minimum_commissions_api
    PaypalService::API::Api.minimum_commissions_api
  end

  def tx_settings_api
    TransactionService::API::Api.settings
  end

  def accounts_api
    PaypalService::API::Api.accounts_api
  end

end
