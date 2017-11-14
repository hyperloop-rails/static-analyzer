class TransactionsController < ApplicationController

  before_filter only: [:show] do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_inbox")
  end

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_do_a_transaction")
  end

  MessageForm = Form::Message

  TransactionForm = EntityUtils.define_builder(
    [:listing_id, :fixnum, :to_integer, :mandatory],
    [:message, :string],
    [:quantity, :fixnum, :to_integer, default: 1],
    [:start_on, transform_with: ->(v) { Maybe(v).map { |d| TransactionViewUtils.parse_booking_date(d) }.or_else(nil) } ],
    [:end_on, transform_with: ->(v) { Maybe(v).map { |d| TransactionViewUtils.parse_booking_date(d) }.or_else(nil) } ]
  )

  def new
    Result.all(
      ->() {
        fetch_data(params[:listing_id])
      },
      ->((listing_id, listing_model)) {
        ensure_can_start_transactions(listing_model: listing_model, current_user: @current_user, current_community: @current_community)
      }
    ).on_success { |((listing_id, listing_model, author_model, process, gateway))|
      booking = listing_model.unit_type == :day

      transaction_params = HashUtils.symbolize_keys({listing_id: listing_model.id}.merge(params.slice(:start_on, :end_on, :quantity, :delivery)))

      case [process[:process], gateway, booking]
      when matches([:none])
        render_free(listing_model: listing_model, author_model: author_model, community: @current_community, params: transaction_params)
      when matches([:preauthorize, __, true])
        redirect_to book_path(transaction_params)
      when matches([:preauthorize, :paypal])
        redirect_to initiate_order_path(transaction_params)
      when matches([:preauthorize, :braintree])
        redirect_to preauthorize_payment_path(transaction_params)
      when matches([:postpay])
        redirect_to post_pay_listing_path(transaction_params)
      else
        opts = "listing_id: #{listing_id}, payment_gateway: #{gateway}, payment_process: #{process}, booking: #{booking}"
        raise ArgumentError.new("Cannot find new transaction path to #{opts}")
      end
    }.on_error { |error_msg, data|
      flash[:error] = Maybe(data)[:error_tr_key].map { |tr_key| t(tr_key) }.or_else("Could not start a transaction, error message: #{error_msg}")
      redirect_to (session[:return_to_content] || root)
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
 action_button_label 
 link_to(listing[:title], listing_path(listing[:id])) 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 action_button_label 
 link_to(listing[:title], listing_path(listing[:id])) 
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
  
 author_link = link_to(author[:display_name], person_path(id: author[:username])) 
 t("listing_conversations.preauthorize.details") 
 t("listing_conversations.preauthorize.by", listing: link_to("#{listing[:title]}", listing_path(listing[:id])), author: author_link).html_safe 
 m_price_break_down.each do |price_break_down| 
  if booking 
 t("transactions.initiate.price_per_day") 
 humanized_money_with_symbol(listing_price) 
 t("transactions.initiate.booked_days") 
 l start_on, format: :long_with_abbr_day_name 
 "-" 
 l end_on, format: :long_with_abbr_day_name 
 "(#{pluralize(duration, t("listing_conversations.preauthorize.day"), t("listing_conversations.preauthorize.days"))})" 
 elsif quantity.present? && localized_unit_type.present? 
 t("transactions.price_per_quantity", unit_type: localized_unit_type) 
 humanized_money_with_symbol(listing_price) 
 if quantity > 1 
 localized_selector_label || t("transactions.initiate.quantity") 
 quantity 
 end 
 end 
 if subtotal.present? 
 t("transactions.initiate.subtotal") 
 humanized_money_with_symbol(subtotal) 
 end 
 if shipping_price.present? 
 t("transactions.initiate.shipping-price") 
 humanized_money_with_symbol(shipping_price) 
 end 
 if total.present? 
 if total_label.present? 
 total_label 
 else 
 t("transactions.total") 
 end 
 humanized_money_with_symbol(total) 
 end 
 
 end 
 form_tag(form_action, method: :post, id: "transaction-form") do 
 hidden_field_tag(:start_on, booking_start) 
 hidden_field_tag(:end_on, booking_end) 
 t("conversations.new.send_message_to_user", person: author_link).html_safe 
 text_area_tag(:message, nil, :class => "text_area") 
 if quantity 
 hidden_field_tag(:quantity, quantity) 
 end 
 button_tag t("conversations.new.send_message"), :class => "send_button" 
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
    Result.all(
      ->() {
        TransactionForm.validate(params)
      },
      ->(form) {
        fetch_data(form[:listing_id])
      },
      ->(form, (_, _, _, process)) {
        validate_form(form, process)
      },
      ->(_, (listing_id, listing_model), _) {
        ensure_can_start_transactions(listing_model: listing_model, current_user: @current_user, current_community: @current_community)
      },
      ->(form, (listing_id, listing_model, author_model, process, gateway), _, _) {
        booking_fields = Maybe(form).slice(:start_on, :end_on).select { |booking| booking.values.all? }.or_else({})

        quantity = Maybe(booking_fields).map { |b| DateUtils.duration_days(b[:start_on], b[:end_on]) }.or_else(form[:quantity])

        TransactionService::Transaction.create(
          {
            transaction: {
              community_id: @current_community.id,
              listing_id: listing_id,
              listing_title: listing_model.title,
              starter_id: @current_user.id,
              listing_author_id: author_model.id,
              unit_type: listing_model.unit_type,
              unit_price: listing_model.price,
              unit_tr_key: listing_model.unit_tr_key,
              listing_quantity: quantity,
              content: form[:message],
              booking_fields: booking_fields,
              payment_gateway: process[:process] == :none ? :none : gateway, # TODO This is a bit awkward
              payment_process: process[:process]}
          })
      }
    ).on_success { |(_, (_, _, _, process), _, _, tx)|
      after_create_actions!(process: process, transaction: tx[:transaction], community_id: @current_community.id)
      flash[:notice] = after_create_flash(process: process) # add more params here when needed
      redirect_to after_create_redirect(process: process, starter_id: @current_user.id, transaction: tx[:transaction]) # add more params here when needed
    }.on_error { |error_msg, data|
      flash[:error] = Maybe(data)[:error_tr_key].map { |tr_key| t(tr_key) }.or_else("Could not start a transaction, error message: #{error_msg}")
      redirect_to (session[:return_to_content] || root)
    }
  end

  def show
    m_participant =
      Maybe(
        MarketplaceService::Transaction::Query.transaction_with_conversation(
        transaction_id: params[:id],
        person_id: @current_user.id,
        community_id: @current_community.id))
      .map { |tx_with_conv| [tx_with_conv, :participant] }

    m_admin =
      Maybe(@current_user.has_admin_rights_in?(@current_community))
      .select { |can_show| can_show }
      .map {
        MarketplaceService::Transaction::Query.transaction_with_conversation(
          transaction_id: params[:id],
          community_id: @current_community.id)
      }
      .map { |tx_with_conv| [tx_with_conv, :admin] }

    transaction_conversation, role = m_participant.or_else { m_admin.or_else([]) }

    tx = TransactionService::Transaction.get(community_id: @current_community.id, transaction_id: params[:id])
         .maybe()
         .or_else(nil)

    unless tx.present? && transaction_conversation.present?
      flash[:error] = t("layouts.notifications.you_are_not_authorized_to_view_this_content")
      return redirect_to root
    end

    tx_model = Transaction.where(id: tx[:id]).first
    conversation = transaction_conversation[:conversation]
    listing = Listing.where(id: tx[:listing_id]).first

    messages_and_actions = TransactionViewUtils::merge_messages_and_transitions(
      TransactionViewUtils.conversation_messages(conversation[:messages], @current_community.name_display_type),
      TransactionViewUtils.transition_messages(transaction_conversation, conversation, @current_community.name_display_type))

    MarketplaceService::Transaction::Command.mark_as_seen_by_current(params[:id], @current_user.id)

    is_author =
      if role == :admin
        true
      else
        listing.author_id == @current_user.id
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
 
    
 
  link_to_unless listing[:deleted], listing[:title], listing_path(id: listing[:id]) 
 if price_break_down_locals.present? 
  if booking 
 t("transactions.initiate.price_per_day") 
 humanized_money_with_symbol(listing_price) 
 t("transactions.initiate.booked_days") 
 l start_on, format: :long_with_abbr_day_name 
 "-" 
 l end_on, format: :long_with_abbr_day_name 
 "(#{pluralize(duration, t("listing_conversations.preauthorize.day"), t("listing_conversations.preauthorize.days"))})" 
 elsif quantity.present? && localized_unit_type.present? 
 t("transactions.price_per_quantity", unit_type: localized_unit_type) 
 humanized_money_with_symbol(listing_price) 
 if quantity > 1 
 localized_selector_label || t("transactions.initiate.quantity") 
 quantity 
 end 
 end 
 if subtotal.present? 
 t("transactions.initiate.subtotal") 
 humanized_money_with_symbol(subtotal) 
 end 
 if shipping_price.present? 
 t("transactions.initiate.shipping-price") 
 humanized_money_with_symbol(shipping_price) 
 end 
 if total.present? 
 if total_label.present? 
 total_label 
 else 
 t("transactions.total") 
 end 
 humanized_money_with_symbol(total) 
 end 
 
 end 
 if @current_community.vat.present? 
 t("conversations.show.price_excludes_vat") 
 end 
  fields = [:name, :phone, :street1, :street2, :postal_code, :city, :state_or_province, :country] 
 if shipping_address && shipping_address.slice(*fields).values.any? 
 t("shipping_address.shipping_address") 
 fields.map do |field| 
 if shipping_address[field].present? 
 if shipping_address[field] == :name 
 shipping_address[field] 
 else 
 shipping_address[field] 
 end 
 end 
 end 
 end 
 
  get_conversation_statuses(__transaction_model, is_author).each do |status| 
 if status[:type] == :status_info 
  if status_info[:info_icon_tag].present? 
 status_info[:info_icon_tag] 
 else 
 status_info[:info_icon_part_classes] 
 end 
 status_info[:info_text_part] 
 
 else 
 if role == :participant 
 status[:content].each do |status_link| 
  status_link[:link_classes] 
 status_link[:link_data] 
 status_link[:link_href] 
 if status_link[:link_icon_tag].present? 
 status_link[:link_icon_tag] 
 else 
 status_link[:link_icon_with_text_classes] 
 end 
 status_link[:link_text_with_icon] 
 
 end 
 end 
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
 
    
 
  link_to_unless listing[:deleted], listing[:title], listing_path(id: listing[:id]) 
 if price_break_down_locals.present? 
  if booking 
 t("transactions.initiate.price_per_day") 
 humanized_money_with_symbol(listing_price) 
 t("transactions.initiate.booked_days") 
 l start_on, format: :long_with_abbr_day_name 
 "-" 
 l end_on, format: :long_with_abbr_day_name 
 "(#{pluralize(duration, t("listing_conversations.preauthorize.day"), t("listing_conversations.preauthorize.days"))})" 
 elsif quantity.present? && localized_unit_type.present? 
 t("transactions.price_per_quantity", unit_type: localized_unit_type) 
 humanized_money_with_symbol(listing_price) 
 if quantity > 1 
 localized_selector_label || t("transactions.initiate.quantity") 
 quantity 
 end 
 end 
 if subtotal.present? 
 t("transactions.initiate.subtotal") 
 humanized_money_with_symbol(subtotal) 
 end 
 if shipping_price.present? 
 t("transactions.initiate.shipping-price") 
 humanized_money_with_symbol(shipping_price) 
 end 
 if total.present? 
 if total_label.present? 
 total_label 
 else 
 t("transactions.total") 
 end 
 humanized_money_with_symbol(total) 
 end 
 
 end 
 if @current_community.vat.present? 
 t("conversations.show.price_excludes_vat") 
 end 
  fields = [:name, :phone, :street1, :street2, :postal_code, :city, :state_or_province, :country] 
 if shipping_address && shipping_address.slice(*fields).values.any? 
 t("shipping_address.shipping_address") 
 fields.map do |field| 
 if shipping_address[field].present? 
 if shipping_address[field] == :name 
 shipping_address[field] 
 else 
 shipping_address[field] 
 end 
 end 
 end 
 end 
 
  get_conversation_statuses(__transaction_model, is_author).each do |status| 
 if status[:type] == :status_info 
  if status_info[:info_icon_tag].present? 
 status_info[:info_icon_tag] 
 else 
 status_info[:info_icon_part_classes] 
 end 
 status_info[:info_text_part] 
 
 else 
 if role == :participant 
 status[:content].each do |status_link| 
  status_link[:link_classes] 
 status_link[:link_data] 
 status_link[:link_href] 
 if status_link[:link_icon_tag].present? 
 status_link[:link_icon_tag] 
 else 
 status_link[:link_icon_with_text_classes] 
 end 
 status_link[:link_text_with_icon] 
 
 end 
 end 
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

  def op_status
    process_token = params[:process_token]

    resp = Maybe(process_token)
      .map { |ptok| paypal_process.get_status(ptok) }
      .select(&:success)
      .data
      .or_else(nil)

    if resp
      render :json => resp
    else
      redirect_to error_not_found_path
    end
  end

  def person_entity_with_url(person_entity)
    person_entity.merge({
      url: person_path(id: person_entity[:username]),
      display_name: PersonViewUtils.person_entity_display_name(person_entity, @current_community.name_display_type)})
  end

  def paypal_process
    PaypalService::API::Api.process
  end

  private

  def ensure_can_start_transactions(listing_model:, current_user:, current_community:)
    error =
      if listing_model.closed?
        "layouts.notifications.you_cannot_reply_to_a_closed_offer"
      elsif listing_model.author == current_user
       "layouts.notifications.you_cannot_send_message_to_yourself"
      elsif !listing_model.visible_to?(current_user, current_community)
        "layouts.notifications.you_are_not_authorized_to_view_this_content"
      else
        nil
      end

    if error
      Result::Error.new(error, {error_tr_key: error})
    else
      Result::Success.new
    end
  end

  def after_create_flash(process:)
    case process[:process]
    when :none
      t("layouts.notifications.message_sent")
    else
      raise NotImplementedError.new("Not implemented for process #{process}")
    end
  end

  def after_create_redirect(process:, starter_id:, transaction:)
    case process[:process]
    when :none
      person_transaction_path(person_id: starter_id, id: transaction[:id])
    else
      raise NotImplementedError.new("Not implemented for process #{process}")
    end
  end

  def after_create_actions!(process:, transaction:, community_id:)
    case process[:process]
    when :none
      # TODO Do I really have to do the state transition here?
      # Shouldn't it be handled by the TransactionService
      MarketplaceService::Transaction::Command.transition_to(transaction[:id], "free")

      # TODO: remove references to transaction model
      transaction = Transaction.find(transaction[:id])

      Delayed::Job.enqueue(MessageSentJob.new(transaction.conversation.messages.last.id, community_id))
    else
      raise NotImplementedError.new("Not implemented for process #{process}")
    end
  end
  # Fetch all related data based on the listing_id
  #
  # Returns: Result::Success([listing_id, listing_model, author, process, gateway])
  #
  def fetch_data(listing_id)
    Result.all(
      ->() {
        if listing_id.nil?
          Result::Error.new("No listing ID provided")
        else
          Result::Success.new(listing_id)
        end
      },
      ->(listing_id) {
        # TODO Do not use Models directly. The data should come from the APIs
        Maybe(@current_community.listings.where(id: listing_id).first)
          .map     { |listing_model| Result::Success.new(listing_model) }
          .or_else { Result::Error.new("Cannot find listing with id #{listing_id}") }
      },
      ->(_, listing_model) {
        # TODO Do not use Models directly. The data should come from the APIs
        Result::Success.new(listing_model.author)
      },
      ->(_, listing_model, *rest) {
        TransactionService::API::Api.processes.get(community_id: @current_community.id, process_id: listing_model.transaction_process_id)
      },
      ->(*) {
        Result::Success.new(MarketplaceService::Community::Query.payment_type(@current_community.id))
      },
    )
  end

  def validate_form(form_params, process)
    if process[:process] == :none && form_params[:message].blank?
      Result::Error.new("Message cannot be empty")
    else
      Result::Success.new
    end
  end

  def price_break_down_locals(tx)
    if tx[:payment_process] == :none && tx[:listing_price].cents == 0
      nil
    else
      unit_type = tx[:unit_type].present? ? ListingViewUtils.translate_unit(tx[:unit_type], tx[:unit_tr_key]) : nil
      localized_selector_label = tx[:unit_type].present? ? ListingViewUtils.translate_quantity(tx[:unit_type], tx[:unit_selector_tr_key]) : nil
      booking = !!tx[:booking]
      quantity = tx[:listing_quantity]
      show_subtotal = !!tx[:booking] || quantity.present? && quantity > 1 || tx[:shipping_price].present?
      total_label = (tx[:payment_process] != :preauthorize) ? t("transactions.price") : t("transactions.total")

      TransactionViewUtils.price_break_down_locals({
        listing_price: tx[:listing_price],
        localized_unit_type: unit_type,
        localized_selector_label: localized_selector_label,
        booking: booking,
        start_on: booking ? tx[:booking][:start_on] : nil,
        end_on: booking ? tx[:booking][:end_on] : nil,
        duration: booking ? tx[:booking][:duration] : nil,
        quantity: quantity,
        subtotal: show_subtotal ? tx[:listing_price] * quantity : nil,
        total: Maybe(tx[:payment_total]).or_else(tx[:checkout_total]),
        shipping_price: tx[:shipping_price],
        total_label: total_label
      })
    end
  end

  def render_free(listing_model:, author_model:, community:, params:)
    # TODO This data should come from API
    listing = {
      id: listing_model.id,
      title: listing_model.title,
      action_button_label: t(listing_model.action_button_tr_key),
    }
    author = {
      display_name: PersonViewUtils.person_display_name(author_model, community),
      username: author_model.username
    }

    unit_type = listing_model.unit_type.present? ? ListingViewUtils.translate_unit(listing_model.unit_type, listing_model.unit_tr_key) : nil
    localized_selector_label = listing_model.unit_type.present? ? ListingViewUtils.translate_quantity(listing_model.unit_type, listing_model.unit_selector_tr_key) : nil
    booking_start = Maybe(params)[:start_on].map { |d| TransactionViewUtils.parse_booking_date(d) }.or_else(nil)
    booking_end = Maybe(params)[:end_on].map { |d| TransactionViewUtils.parse_booking_date(d) }.or_else(nil)
    booking = !!(booking_start && booking_end)
    duration = booking ? DateUtils.duration_days(booking_start, booking_end) : nil
    quantity = Maybe(booking ? DateUtils.duration_days(booking_start, booking_end) : TransactionViewUtils.parse_quantity(params[:quantity])).or_else(1)
    total_label = t("transactions.price")

    m_price_break_down = Maybe(listing_model).select { |listing_model| listing_model.price.present? }.map { |listing_model|
      TransactionViewUtils.price_break_down_locals(
        {
          listing_price: listing_model.price,
          localized_unit_type: unit_type,
          localized_selector_label: localized_selector_label,
          booking: booking,
          start_on: booking_start,
          end_on: booking_end,
          duration: duration,
          quantity: quantity,
          subtotal: quantity != 1 ? listing_model.price * quantity : nil,
          total: listing_model.price * quantity,
          shipping_price: nil,
          total_label: total_label
        })
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
 action_button_label 
 link_to(listing[:title], listing_path(listing[:id])) 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 action_button_label 
 link_to(listing[:title], listing_path(listing[:id])) 
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
  
 author_link = link_to(author[:display_name], person_path(id: author[:username])) 
 t("listing_conversations.preauthorize.details") 
 t("listing_conversations.preauthorize.by", listing: link_to("#{listing[:title]}", listing_path(listing[:id])), author: author_link).html_safe 
 m_price_break_down.each do |price_break_down| 
  if booking 
 t("transactions.initiate.price_per_day") 
 humanized_money_with_symbol(listing_price) 
 t("transactions.initiate.booked_days") 
 l start_on, format: :long_with_abbr_day_name 
 "-" 
 l end_on, format: :long_with_abbr_day_name 
 "(#{pluralize(duration, t("listing_conversations.preauthorize.day"), t("listing_conversations.preauthorize.days"))})" 
 elsif quantity.present? && localized_unit_type.present? 
 t("transactions.price_per_quantity", unit_type: localized_unit_type) 
 humanized_money_with_symbol(listing_price) 
 if quantity > 1 
 localized_selector_label || t("transactions.initiate.quantity") 
 quantity 
 end 
 end 
 if subtotal.present? 
 t("transactions.initiate.subtotal") 
 humanized_money_with_symbol(subtotal) 
 end 
 if shipping_price.present? 
 t("transactions.initiate.shipping-price") 
 humanized_money_with_symbol(shipping_price) 
 end 
 if total.present? 
 if total_label.present? 
 total_label 
 else 
 t("transactions.total") 
 end 
 humanized_money_with_symbol(total) 
 end 
 
 end 
 form_tag(form_action, method: :post, id: "transaction-form") do 
 hidden_field_tag(:start_on, booking_start) 
 hidden_field_tag(:end_on, booking_end) 
 t("conversations.new.send_message_to_user", person: author_link).html_safe 
 text_area_tag(:message, nil, :class => "text_area") 
 if quantity 
 hidden_field_tag(:quantity, quantity) 
 end 
 button_tag t("conversations.new.send_message"), :class => "send_button" 
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
