class ConversationsController < ApplicationController
  include MoneyRails::ActionViewExtension

  MessageForm = Form::Message

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_inbox")
  end

  def show
    conversation_id = params[:id]

    conversation = MarketplaceService::Conversation::Query.conversation_for_person(
      conversation_id,
      @current_user.id,
      @current_community.id)

    if conversation.blank?
      flash[:error] = t("layouts.notifications.you_are_not_authorized_to_view_this_content")
      return redirect_to root
    end

    transaction = Transaction.find_by_conversation_id(conversation[:id])

    if transaction.present?
      # We do not want to use this controller to show conversations with transactions
      # as the transaction controller shows not only the messages, but also the actions
      # so redirect there.
      redirect_to person_transaction_url(@current_user, {:id => transaction.id}) and return
    end

    message_form = MessageForm.new({sender_id: @current_user.id, conversation_id: conversation_id})

    conversation[:other_person] = person_entity_with_url(conversation[:other_person])

    messages = TransactionViewUtils.conversation_messages(conversation[:messages], @current_community.name_display_type)

    MarketplaceService::Conversation::Command.mark_as_read(conversation[:id], @current_user.id)

    render locals: {
      messages: messages.reverse,
      conversation_data: conversation,
      message_form: message_form,
      message_form_action: person_message_messages_path(@current_user, :message_id => conversation[:id])
    }
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
 link_to person_inbox_path(@current_user) do 
 t("layouts.no_tribe.inbox") 
 end 
 t("conversations.show.conversation_with", person: link_to_unless(other_party[:is_deleted], other_party[:display_name], other_party[:url])).html_safe 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 link_to person_inbox_path(@current_user) do 
 t("layouts.no_tribe.inbox") 
 end 
 t("conversations.show.conversation_with", person: link_to_unless(other_party[:is_deleted], other_party[:display_name], other_party[:url])).html_safe 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
    
 
  if role == :participant 
 content_for :javascript do 
 end 
 form_for message_form, :url => message_form_action do |f| 
 f.label :content, t("conversations.show.write_a_reply") 
 f.text_area :content, :class => "reply_form_text_area" 
 f.hidden_field :conversation_id 
 f.hidden_field :sender_id 
 f.button t("conversations.show.send_reply") 
 end 
 end 
  avatar_side = message_or_action[:sender][:id] == @current_user.id ? "left" : "right" 
 avatar_side 
 image_tag(message_or_action[:sender][:avatar], :class => "message-avatar-image") 
 avatar_side 
 avatar_side 
 link_to_unless message_or_action[:sender][:is_deleted], message_or_action[:sender][:display_name], person_path(id: message_or_action[:sender][:username]) 
 time_ago(message_or_action[:created_at]) 
 avatar_side 
 message_or_action[:type] 
 message_or_action[:mood] 
 text_with_line_breaks do 
 message_or_action[:content] 
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

  def person_entity_with_url(person_entity)
    person_entity.merge({
                          url: person_path(id: person_entity[:username]),
                          display_name: PersonViewUtils.person_entity_display_name(person_entity, @current_community.name_display_type)
                        })
  end
end
