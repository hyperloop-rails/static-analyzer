class PaypalAccountsController < ApplicationController
  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_settings")
  end

  before_filter :ensure_paypal_enabled

  DataTypePermissions = PaypalService::DataTypes::Permissions

  def index
    m_account = accounts_api.get(
      community_id: @current_community.id,
      person_id: @current_user.id
    ).maybe

    @selected_left_navi_link = "payments"

    community_ready_for_payments = PaypalHelper.community_ready_for_payments?(@current_community)
    unless community_ready_for_payments
      flash.now[:warning] = t("paypal_accounts.admin_account_not_connected",
                            contact_admin_link: view_context.link_to(
                              t("paypal_accounts.contact_admin_link_text"),
                                new_user_feedback_path)).html_safe
    end

    community_currency = @current_community.default_currency
    payment_settings = payment_settings_api.get_active(community_id: @current_community.id).maybe.get
    community_country_code = LocalizationUtils.valid_country_code(@current_community.country)

    render(locals: {
      next_action: next_action(m_account[:state].or_else("")),
      community_ready_for_payments: community_ready_for_payments,
      left_hand_navigation_links: settings_links_for(@current_user, @current_community),
      order_permission_action: ask_order_permission_person_paypal_account_path(@current_user),
      billing_agreement_action: ask_billing_agreement_person_paypal_account_path(@current_user),
      paypal_account_email: m_account[:email].or_else(""),
      commission_from_seller: t("paypal_accounts.commission", commission: payment_settings[:commission_from_seller]),
      minimum_commission: Money.new(payment_settings[:minimum_transaction_fee_cents], community_currency),
      commission_type: payment_settings[:commission_type],
      currency: community_currency,
      paypal_fees_url: PaypalCountryHelper.fee_link(community_country_code),
      create_url: PaypalCountryHelper.create_paypal_account_url(community_country_code),
      receive_funds_info_label_tr_key: PaypalCountryHelper.receive_funds_info_label_tr_key(community_country_code),
      upgrade_url: "https://www.paypal.com/#{community_country_code}/upgrade"
    })
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
 
   
 t("paypal_accounts.payout_info_title") 
 if community_ready_for_payments 
 create_paypal_link = link_to(t("paypal_accounts.create_paypal_account_link_text"),                                   create_url, target: "_blank") 
 upgrade_paypal_link = link_to(t("paypal_accounts.upgrade_paypal_account_link_text"),                                    upgrade_url, target: "_blank") 
 paypal_redirect_link = "<a href='#' id='ask_paypal_permissions_redirect'>#{t("paypal_accounts.redirect_link_text")}</a>" 
  t("paypal_accounts.payout_info_paypal", create_paypal_account_link: create_paypal_account_link).html_safe 
 if commission_required 
 t("paypal_accounts.commission_permission_needed") 
 end 
 unless paypal_account_linked 
 icon_tag("alert") 
 t(receive_funds_info_label_tr_key) 
 t("paypal_accounts.paypal_receive_funds_info", upgrade_paypal_account_link: upgrade_paypal_account_link).html_safe 
 end 
 
 if next_action == :ask_order_permission 
 content_for :javascript do 
 end 
 t("paypal_accounts.new.follow_steps") 
 t("paypal_accounts.new.connect_paypal_account_title_with_step", current_step: 1, total_steps: 2) 
 t("paypal_accounts.new.connect_paypal_account_instructions") 
 t("paypal_accounts.new.connect_paypal_account") 
 t("paypal_accounts.redirect_message", redirect_link: paypal_redirect_link).html_safe 
 elsif next_action == :ask_billing_agreement 
 content_for :javascript do 
 end 
 if commission_type != :none # only warn if the marketplace charges a commission 
 t("paypal_accounts.new.follow_steps") 
 end 
  icon_tag("check", ["icon-fix"]) 
 t("paypal_accounts.paypal_account_connected_title") 
 t("paypal_accounts.paypal_account_connected", :email => paypal_account_email) 
 t("paypal_accounts.change_account") 
 paypal_redirect_link = "<a href='#' id='ask_paypal_permissions_redirect'>#{t("paypal_accounts.redirect_link_text")}</a>" 
 t("paypal_accounts.redirect_message", redirect_link: paypal_redirect_link).html_safe 
 
 t("paypal_accounts.new.paypal_account_billing_agreement_with_step", current_step: 2, total_steps: 2) 
 paypal_info_link = "<a id='paypal_fee_info_link' href='#'>#{t("paypal_accounts.new.paypal_info_link_text")}</a>" 
 if commission_type == :both # TODO: Tweak copy 
  icon_tag("information") 
 text 
 
 elsif commission_type == :relative 
  icon_tag("information") 
 text 
 
 elsif commission_type == :fixed 
  icon_tag("information") 
 text 
 
 else # no commission fee 
  icon_tag("information") 
 text 
 
 end 
 t("paypal_accounts.new.billing_agreement") 
 paypal_redirect_link = "<a href='#' id='ask_billing_agreement_redirect'>#{t("paypal_accounts.redirect_link_text")}</a>" 
 t("paypal_accounts.redirect_message", redirect_link: paypal_redirect_link).html_safe 
 render layout: "layouts/lightbox", locals: { id: "paypal_fee_info_content"} do 
 t("common.paypal_fee_info.title") 
 text_with_line_breaks_html_safe do 
 link_to_paypal = link_to(t("common.paypal_fee_info.link_to_paypal_text"), paypal_fees_url, target: "_blank") 
 t("common.paypal_fee_info.body_text", link_to_paypal: link_to_paypal).html_safe 
 end 
 end 
 content_for :extra_javascript do 
 end 
 else 
 content_for :javascript do 
 end 
 t("paypal_accounts.paypal_account_all_set_up") 
 t("paypal_accounts.can_receive_payments") 
 icon_tag("check", ["icon-fix", "paypal-success-mark"]) 
 t("paypal_accounts.paypal_account_connected_summary", :email => paypal_account_email) 
 icon_tag("check", ["icon-fix", "paypal-success-mark"]) 
 t("paypal_accounts.paypal_permission_granted_summary") 
 t("paypal_accounts.change_account") 
 paypal_redirect_link = "<a href='#' id='ask_paypal_permissions_redirect'>#{t("paypal_accounts.redirect_link_text")}</a>" 
 t("paypal_accounts.redirect_message", redirect_link: paypal_redirect_link).html_safe 
 end 
 else 
 t("paypal_accounts.admin_account_not_connected",        contact_admin_link: link_to(t("paypal_accounts.contact_admin_link_text"),                                    new_user_feedback_path)).html_safe 
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

  def ask_order_permission
    return redirect_to action: :index unless PaypalHelper.community_ready_for_payments?(@current_community)

    community_country_code = LocalizationUtils.valid_country_code(@current_community.country)
    response = accounts_api.request(
      body: PaypalService::API::DataTypes.create_create_account_request(
      {
        community_id: @current_community.id,
        person_id: @current_user.id,
        callback_url: permissions_verified_person_paypal_account_url,
        country: community_country_code
      }),
      flow: :old)

    permissions_url = response.data[:redirect_url]

    if permissions_url.blank?
      flash[:error] = t("paypal_accounts.new.could_not_fetch_redirect_url")
      return redirect_to action: :index
    else
      render json: {redirect_url: permissions_url}
    end
  end

  def ask_billing_agreement
    return redirect_to action: :index unless PaypalHelper.community_ready_for_payments?(@current_community)

    account_response = accounts_api.get(
      community_id: @current_community.id,
      person_id: @current_user.id
    )
    m_account = account_response.maybe

    case m_account[:order_permission_state]
    when Some(:verified)

      response = accounts_api.billing_agreement_request(
        community_id: @current_community.id,
        person_id: @current_user.id,
        body: PaypalService::API::DataTypes.create_create_billing_agreement_request(
          {
            description: t("paypal_accounts.new.billing_agreement_description"),
            success_url:  billing_agreement_success_person_paypal_account_url,
            cancel_url:   billing_agreement_cancel_person_paypal_account_url
          }
        ))

      billing_agreement_url = response.data[:redirect_url]

      if billing_agreement_url.blank?
        flash[:error] = t("paypal_accounts.new.could_not_fetch_redirect_url")
        return redirect_to action: :index
      else
        render json: {redirect_url: billing_agreement_url}
      end

    else
      redirect_to action: ask_order_permission
    end
  end

  def permissions_verified

    unless params[:verification_code].present?
      return flash_error_and_redirect_to_settings(error_msg: t("paypal_accounts.new.permissions_not_granted"))
    end

    response = accounts_api.create(
      community_id: @current_community.id,
      person_id: @current_user.id,
      order_permission_request_token: params[:request_token],
      body: PaypalService::API::DataTypes.create_account_permission_verification_request(
        {
          order_permission_verification_code: params[:verification_code]
        }
      ),
      flow: :old)

    if response[:success]
      redirect_to paypal_account_settings_payment_path(@current_user.username)
    else
      flash_error_and_redirect_to_settings(error_response: response) unless response[:success]
    end
  end

  def billing_agreement_success
    response = accounts_api.billing_agreement_create(
      community_id: @current_community.id,
      person_id: @current_user.id,
      billing_agreement_request_token: params[:token]
    )

    if response[:success]
      redirect_to paypal_account_settings_payment_path(@current_user.username)
    else
      case response.error_msg
      when :billing_agreement_not_accepted
        flash_error_and_redirect_to_settings(error_msg: t("paypal_accounts.new.billing_agreement_not_accepted"))
      when :wrong_account
        flash_error_and_redirect_to_settings(error_msg: t("paypal_accounts.new.billing_agreement_wrong_account"))
      else
        flash_error_and_redirect_to_settings(error_response: response)
      end
    end
  end

  def billing_agreement_cancel
    accounts_api.delete_billing_agreement(
      community_id: @current_community.id,
      person_id: @current_user.id
    )

    flash[:error] = t("paypal_accounts.new.billing_agreement_canceled")
    redirect_to paypal_account_settings_payment_path(@current_user.username)
  end


  private

  def next_action(paypal_account_state)
    if paypal_account_state == :verified
      :none
    elsif paypal_account_state == :connected
      :ask_billing_agreement
    else
      :ask_order_permission
    end
  end

  # Before filter
  def ensure_paypal_enabled
    unless PaypalHelper.paypal_active?(@current_community.id)
      flash[:error] = t("paypal_accounts.new.paypal_not_enabled")
      redirect_to person_settings_path(@current_user)
    end
  end

  def flash_error_and_redirect_to_settings(error_response: nil, error_msg: nil)
    error_msg =
      if (error_msg)
        error_msg
      elsif (error_response && error_response[:error_code] == "570058")
        t("paypal_accounts.new.account_not_verified")
      elsif (error_response && error_response[:error_code] == "520009")
        t("paypal_accounts.new.account_restricted")
      else
        t("paypal_accounts.new.something_went_wrong")
      end

    flash[:error] = error_msg
    redirect_to action: error_redirect_action
  end

  def error_redirect_action
    :index
  end

  def payment_gateway_commission(community_id)
    p_set =
      Maybe(payment_settings_api.get_active(community_id: community_id))
      .map {|res| res[:success] ? res[:data] : nil}
      .select {|set| set[:payment_gateway] == :paypal }
      .or_else(nil)

    raise ArgumentError.new("No active paypal gateway for community: #{community_id}.") if p_set.nil?

    p_set[:commission_from_seller]
  end

  def paypal_minimum_commissions_api
    PaypalService::API::Api.minimum_commissions
  end

  def payment_settings_api
    TransactionService::API::Api.settings
  end

  def accounts_api
    PaypalService::API::Api.accounts_api
  end

end
