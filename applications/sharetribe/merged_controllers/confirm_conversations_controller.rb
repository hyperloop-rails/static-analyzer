class ConfirmConversationsController < ApplicationController

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_confirm_or_cancel")
  end

  before_filter :fetch_conversation
  before_filter :fetch_listing

  before_filter :ensure_is_starter

  MessageForm = Form::Message

  def confirm
    unless in_valid_pre_state(@listing_transaction)
      return redirect_to person_transaction_path(person_id: @current_user.id, message_id: @listing_transaction.id)
    end

    conversation =      MarketplaceService::Conversation::Query.conversation_for_person(@listing_transaction.conversation.id, @current_user.id, @current_community.id)
    can_be_confirmed =  MarketplaceService::Transaction::Query.can_transition_to?(@listing_transaction, :confirmed)
    other_person =      query_person_entity(@listing_transaction.other_party(@current_user).id)

    render(locals: {
      action_type: "confirm",
      message_form: MessageForm.new,
      listing_transaction: @listing_transaction,
      can_be_confirmed: can_be_confirmed,
      other_person: other_person,
      status: @listing_transaction.status,
      form: @listing_transaction # TODO fix me, don't pass objects
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

  def cancel
    unless in_valid_pre_state(@listing_transaction)
      return redirect_to person_transaction_path(person_id: @current_user.id, message_id: @listing_transaction.id)
    end

    conversation =      MarketplaceService::Conversation::Query.conversation_for_person(@listing_transaction.conversation.id, @current_user.id, @current_community.id)
    can_be_confirmed =  MarketplaceService::Transaction::Query.can_transition_to?(@listing_transaction.id, :confirmed)
    other_person =      query_person_entity(@listing_transaction.other_party(@current_user).id)

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

  # Handles confirm and cancel forms
  def confirmation
    status = params[:transaction][:status].to_sym

    if !MarketplaceService::Transaction::Query.can_transition_to?(@listing_transaction.id, status)
      flash[:error] = t("layouts.notifications.something_went_wrong")
      return redirect_to person_transaction_path(person_id: @current_user.id, message_id: @listing_transaction.id)
    end


    msg, sender_id = parse_message_param()
    transaction = complete_or_cancel_tx(@current_community.id, @listing_transaction.id, status, msg, sender_id)

    give_feedback = Maybe(params)[:give_feedback].select { |v| v == "true" }.or_else { false }

    confirmation = ConfirmConversation.new(@listing_transaction, @current_user, @current_community)
    confirmation.update_participation(give_feedback)

    flash[:notice] = t("layouts.notifications.offer_#{status}")

    redirect_path =
      if give_feedback
        new_person_message_feedback_path(:person_id => @current_user.id, :message_id => @listing_transaction.id)
      else
        person_transaction_path(:person_id => @current_user.id, :id => @listing_transaction.id)
      end

    redirect_to redirect_path
  end

  private


  def complete_or_cancel_tx(community_id, tx_id, status, msg, sender_id)
    if status == :confirmed
      TransactionService::Transaction.complete(community_id: community_id, transaction_id: tx_id, message: msg, sender_id: sender_id)
    else
      TransactionService::Transaction.cancel(community_id: community_id, transaction_id: tx_id, message: msg, sender_id: sender_id)
    end
  end

  def parse_message_param
    if(params[:message])
      message = MessageForm.new(params[:message].merge({ sender_id: @current_user.id, conversation_id: @listing_transaction.conversation.id }))
      if(message.valid?)
        [message.content, message.sender_id]
      end
    end
  end

  def ensure_is_starter
    unless @listing_transaction.starter == @current_user
      flash[:error] = "Only listing starter can perform the requested action"
      redirect_to (session[:return_to_content] || root)
    end
  end

  def fetch_listing
    @listing = @listing_transaction.listing
  end

  def fetch_conversation
    @listing_transaction = @current_community.transactions.find(params[:id])
  end

  def in_valid_pre_state(transaction)
    transaction.can_be_confirmed? || transaction.can_be_canceled?
  end

  def query_person_entity(id)
    person_entity = MarketplaceService::Person::Query.person(id, @current_community.id)
    person_display_entity = person_entity.merge(
      display_name: PersonViewUtils.person_entity_display_name(person_entity, @current_community.name_display_type)
    )
  end
end
