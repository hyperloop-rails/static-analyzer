class AcceptConversationsController < ApplicationController

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_accept_or_reject")
  end

  before_filter :fetch_conversation
  before_filter :fetch_listing

  before_filter :ensure_is_author

  # Skip auth token check as current jQuery doesn't provide it automatically
  skip_before_filter :verify_authenticity_token

  MessageForm = Form::Message

  def accept
    prepare_accept_or_reject_form
    @action = "accept"
    path_to_payment_settings = payment_settings_path(@current_community.payment_gateway.gateway_type, @current_user)
    render(locals: { path_to_payment_settings: path_to_payment_settings, message_form: MessageForm.new })
  end

  def reject
    prepare_accept_or_reject_form
    @action = "reject"
    path_to_payment_settings = payment_settings_path(@current_community.payment_gateway.gateway_type, @current_user)
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

  # Handles accept and reject forms
  def acceptance
    # Update first everything else than the status, so that the payment is in correct
    # state before the status change callback is called
    if @listing_conversation.update_attributes(params[:listing_conversation].except(:status))
      message = MessageForm.new(params[:message].merge({ sender_id: @current_user.id, conversation_id: @listing_conversation.id }))
      if(message.valid?)
        @listing_conversation.conversation.messages.create({content: message.content, sender_id: message.sender_id})
      end

      MarketplaceService::Transaction::Command.transition_to(@listing_conversation.id, params[:listing_conversation][:status])
      MarketplaceService::Transaction::Command.mark_as_unseen_by_other(@listing_conversation.id, @current_user.id)

      flash[:notice] = t("layouts.notifications.request_#{params[:listing_conversation][:status]}")
      redirect_to person_transaction_path(:person_id => @current_user.id, :id => @listing_conversation.id)
    else
      flash[:error] = t("layouts.notifications.something_went_wrong")
      redirect_to person_transaction_path(@current_user, @listing_conversation)
    end
  end

  private

  def prepare_accept_or_reject_form
    @payment = @current_community.payment_gateway.new_payment
    @payment.community = @current_community
    @payment.default_sum(@listing_conversation.listing, Maybe(@current_community).vat.or_else(0))

    @payout_registration_missing = PaymentRegistrationGuard.new(@current_community, @current_user, @listing).requires_registration_before_accepting?
  end

  def ensure_is_author
    unless @listing.author == @current_user
      flash[:error] = "Only listing author can perform the requested action"
      redirect_to (session[:return_to_content] || root)
    end
  end

  def fetch_listing
    @listing = @listing_conversation.listing
  end

  def fetch_conversation
    @listing_conversation = Transaction.find(params[:id])
  end
end
