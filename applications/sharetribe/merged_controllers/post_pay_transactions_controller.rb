class PostPayTransactionsController < ApplicationController

  before_filter do |controller|
   controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_do_a_transaction")
  end

  before_filter :fetch_listing_from_params
  before_filter :ensure_listing_is_open
  before_filter :ensure_listing_author_is_not_current_user
  before_filter :ensure_authorized_to_reply
  before_filter :ensure_can_receive_payment, only: [:preauthorize, :preauthorized]

  ContactForm = FormUtils.define_form("ListingConversation", :content, :sender_id, :listing_id, :community_id)
    .with_validations { validates_presence_of :content, :listing_id }

  def new
    @listing_conversation = new_contact_form

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
 action_button_label(listing) 
 link_to(listing.title, listing) 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 action_button_label(listing) 
 link_to(listing.title, listing) 
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
  
  Maybe(listing).map do |listing| 
 price = Maybe(listing).price.or_else(nil) 
 sum = Maybe(transaction).payment.total_sum.or_else(nil) 
 Maybe(transaction).booking.each do |booking| 
 l booking.start_on, format: :long_with_abbr_day_name 
 "-" 
 l booking.end_on, format: :long_with_abbr_day_name 
 "(#{pluralize(booking.duration, t(".day"), t(".days"))})" 
 t(".price_per_day", price: humanized_money_with_symbol(listing.price)) 
 end 
 if sum 
 t("conversations.show.sum", sum: humanized_money_with_symbol(sum)) 
 elsif price 
 t("conversations.show.price", price: humanized_money_with_symbol(listing.price)) 
 if listing.quantity.present? 
 "/ #{listing.quantity}" 
 elsif listing.unit_type.present? 
 "/ #{ListingViewUtils.translate_unit(listing.unit_type, listing.unit_tr_key)}" 
 end 
 if @current_community.vat 
 t("conversations.show.price_excludes_vat") 
 end 
 end 
 end 
 
 form_for contact_form, :url => contact_to_listing do |form| 
 form.label :content, t("conversations.new.message_to", author_name: link_to(listing.author.name(@current_community), listing.author)).html_safe 
 form.text_area :content, :class => "text_area" 
 form.hidden_field :sender_id, :value => @current_user.id 
 form.hidden_field :listing_id, :value => @listing.id 
 form.hidden_field :community_id, :value => @current_community.id 
 form.button action_button_label(listing), :class => "send_button" 
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
    contact_form = new_contact_form(params[:listing_conversation])

    if contact_form.valid?
      transaction_response = TransactionService::Transaction.create({
          transaction: {
            community_id: @current_community.id,
            listing_id: @listing.id,
            listing_title: @listing.title,
            starter_id: @current_user.id,
            listing_author_id: @listing.author.id,
            unit_type: @listing.unit_type,
            unit_price: @listing.price,
            unit_tr_key: @listing.unit_tr_key,
            listing_quantity: 1,
            content: contact_form.content,
            payment_gateway: @current_community.payment_gateway.gateway_type,
            payment_process: :postpay,
          }
        })

      unless transaction_response[:success]
        flash[:error] = "Sending the message failed. Please try again."
        return redirect_to root
      end

      transaction_id = transaction_response[:data][:transaction][:id]

      flash[:notice] = t("layouts.notifications.message_sent")
      Delayed::Job.enqueue(TransactionCreatedJob.new(transaction_id, @current_community.id))

      [3, 10].each do |send_interval|
        Delayed::Job.enqueue(
          AcceptReminderJob.new(
            transaction_id,
            @listing.author.id, @current_community.id),
          :priority => 9, :run_at => send_interval.days.from_now)
      end

      redirect_to session[:return_to_content] || root
    else
      flash[:error] = "Sending the message failed. Please try again."
      redirect_to root
    end
  end

  private

  def ensure_listing_author_is_not_current_user
    if @listing.author == @current_user
      flash[:error] = t("layouts.notifications.you_cannot_send_message_to_yourself")
      redirect_to (session[:return_to_content] || root)
    end
  end

  # Ensure that only users with appropriate visibility settings can reply to the listing
  def ensure_authorized_to_reply
    unless @listing.visible_to?(@current_user, @current_community)
      flash[:error] = t("layouts.notifications.you_are_not_authorized_to_view_this_content")
      redirect_to root and return
    end
  end

  def ensure_listing_is_open
    if @listing.closed?
      flash[:error] = t("layouts.notifications.you_cannot_reply_to_a_closed_offer")
      redirect_to (session[:return_to_content] || root)
    end
  end

  def fetch_listing_from_params
    @listing = Listing.find(params[:listing_id] || params[:id])
  end

  def new_contact_form(conversation_params = {})
    ContactForm.new(conversation_params.merge({sender_id: @current_user.id, listing_id: @listing.id, community_id: @current_community.id}))
  end

  def ensure_can_receive_payment
    Maybe(@current_community).payment_gateway.each do |gateway|
      unless gateway.can_receive_payments?(@listing.author)
        flash[:error] = t("layouts.notifications.listing_author_payment_details_missing")
        redirect_to (session[:return_to_content] || root)
      end
    end
  end
end
