class PreauthorizeTransactionsController < ApplicationController

  before_filter do |controller|
   controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_do_a_transaction")
  end

  before_filter :fetch_listing_from_params
  before_filter :ensure_listing_is_open
  before_filter :ensure_listing_author_is_not_current_user
  before_filter :ensure_authorized_to_reply
  before_filter :ensure_can_receive_payment

  BookingForm = FormUtils.define_form("BookingForm", :start_on, :end_on)
    .with_validations do
      validates :start_on, :end_on, presence: true
      validates_date :end_on, on_or_after: :start_on
    end

  ContactForm = FormUtils.define_form("ListingConversation", :content, :sender_id, :listing_id, :community_id)
    .with_validations { validates_presence_of :content, :listing_id }

  BraintreeForm = Form::Braintree

  PreauthorizeMessageForm = FormUtils.define_form("ListingConversation",
    :content,
    :sender_id,
    :contract_agreed,
    :delivery_method,
    :quantity,
    :listing_id
   ).with_validations {
    validates_presence_of :listing_id
    validates :delivery_method, inclusion: { in: %w(shipping pickup), message: "%{value} is not shipping or pickup." }, allow_nil: true
  }

  PreauthorizeBookingForm = FormUtils.merge("ListingConversation", PreauthorizeMessageForm, BookingForm)

  ListingQuery = MarketplaceService::Listing::Query
  BraintreePaymentQuery = BraintreeService::Payments::Query

  def initiate
    delivery_method = valid_delivery_method(delivery_method_str: params[:delivery],
                                             shipping: @listing.require_shipping_address,
                                             pickup: @listing.pickup_enabled)
    if(delivery_method == :errored)
      return redirect_to error_not_found_path
    end

    quantity = TransactionViewUtils.parse_quantity(params[:quantity])

    vprms = view_params(listing_id: params[:listing_id],
                        quantity: quantity,
                        shipping_enabled: delivery_method == :shipping)

    price_break_down_locals = TransactionViewUtils.price_break_down_locals({
      booking:  false,
      quantity: quantity,
      listing_price: vprms[:listing][:price],
      localized_unit_type: translate_unit_from_listing(vprms[:listing]),
      localized_selector_label: translate_selector_label_from_listing(vprms[:listing]),
      subtotal: (quantity > 1 || vprms[:listing][:shipping_price].present?) ? vprms[:subtotal] : nil,
      shipping_price: delivery_method == :shipping ? vprms[:shipping_price] : nil,
      total: vprms[:total_price]
    })

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
 
  content_for :javascript do 
 end 
 content_for :extra_javascript do 
 end 
  
 author_link = link_to(author[:display_name], person_path(id: author[:username])) 
 t("listing_conversations.preauthorize.details") 
 t("listing_conversations.preauthorize.by", listing: link_to("#{listing[:title]}", listing_path(listing[:id])), author: author_link).html_safe 
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
 
 form_for preauthorize_form,    :url => form_action,      :method => "post",      :html => { :id => "transaction-form" } do |form| 
 if preauthorize_form.respond_to?(:start_on) && preauthorize_form.respond_to?(:end_on) 
 form.date_select :start_on, discard_day: true, discard_month: true, discard_year: true, default: preauthorize_form.start_on 
 form.date_select :end_on, discard_day: true, discard_month: true, discard_year: true, default: preauthorize_form.end_on 
 end 
 t("conversations.new.optional_message_to", author_name: author_link).html_safe 
 form.text_area :content, :class => "text_area" 
 form.hidden_field :sender_id, :value => @current_user.id 
 if @current_community.transaction_agreement_in_use 
  form.check_box :contract_agreed, class: "required" 
 @community_customization.transaction_agreement_label 
 link_to(t(".read_more"), "#", id: "transaction-agreement-read-more").html_safe 
 render layout: "layouts/lightbox", locals: { id: "transaction-agreement-content"} do 
 text_with_line_breaks do 
 @community_customization.transaction_agreement_content.html_safe 
 end 
 end 
 
 end 
 if local_assigns.has_key?(:quantity) 
 form.hidden_field :quantity, value: quantity 
 end 
 if delivery_method 
 form.hidden_field :delivery_method, value: delivery_method 
 end 
 form.button t("paypal.pay_with_paypal"), class: "checkout-with-paypal-button" 
  how_paypal_works_link = PaypalCountryHelper.popup_link(country_code) 
 image_tag "https://www.paypalobjects.com/webstatic/en_US/i/buttons/cc-badges-ppmcvdam.png", style: "max-width: 100%" 
 how_paypal_works_link 
 t("listings.listing_actions.how_paypal_works") 
 t("listings.listing_actions.payment_help") 
 content_for :extra_javascript do 
 end 
 
 t("listing_conversations.preauthorize.you_will_be_charged", author: author_link, expiration_period: expiration_period).html_safe 
 end 
 "For security reasons JavaScript has to be enabled" 
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

  def initiated
    conversation_params = params[:listing_conversation]

    if @current_community.transaction_agreement_in_use? && conversation_params[:contract_agreed] != "1"
      return render_error_response(request.xhr?, t("error_messages.transaction_agreement.required_error"), action: :initiate)
    end

    preauthorize_form = PreauthorizeMessageForm.new(conversation_params.merge({
      listing_id: @listing.id
    }))
    unless preauthorize_form.valid?
      return render_error_response(request.xhr?, preauthorize_form.errors.full_messages.join(", "), action: :initiate)
    end
    delivery_method = valid_delivery_method(delivery_method_str: preauthorize_form.delivery_method,
                                             shipping: @listing.require_shipping_address,
                                             pickup: @listing.pickup_enabled)
    if(delivery_method == :errored)
      return render_error_response(request.xhr?, "Delivery method is invalid.", action: :initiate)
    end

    quantity = TransactionViewUtils.parse_quantity(preauthorize_form.quantity)
    shipping_price = shipping_price_total(@listing.shipping_price, @listing.shipping_price_additional, quantity)

    transaction_response = create_preauth_transaction(
      payment_type: :paypal,
      community: @current_community,
      listing: @listing,
      listing_quantity: quantity,
      user: @current_user,
      content: preauthorize_form.content,
      use_async: request.xhr?,
      delivery_method: delivery_method,
      shipping_price: shipping_price
    )

    unless transaction_response[:success]
      return render_error_response(request.xhr?, t("error_messages.paypal.generic_error"), action: :initiate) unless transaction_response[:success]
    end

    transaction_id = transaction_response[:data][:transaction][:id]

    if (transaction_response[:data][:gateway_fields][:redirect_url])
      redirect_to transaction_response[:data][:gateway_fields][:redirect_url]
    else
      render json: {
        op_status_url: transaction_op_status_path(transaction_response[:data][:gateway_fields][:process_token]),
        op_error_msg: t("error_messages.paypal.generic_error")
      }
    end
  end

  def book
    delivery_method = valid_delivery_method(delivery_method_str: params[:delivery],
                                             shipping: @listing.require_shipping_address,
                                             pickup: @listing.pickup_enabled)
    if(delivery_method == :errored)
      return redirect_to error_not_found_path
    end

    booking_data = verified_booking_data(params[:start_on], params[:end_on])
    vprms = view_params(listing_id: params[:listing_id],
                        quantity: booking_data[:duration],
                        shipping_enabled: delivery_method == :shipping)

    if booking_data[:error].present?
      flash[:error] = booking_data[:error]
      return redirect_to listing_path(vprms[:listing][:id])
    end

    gateway_locals =
      if (vprms[:payment_type] == :braintree)
        braintree_gateway_locals(@current_community.id)
      else
        {}
      end

    view =
      case vprms[:payment_type]
      when :braintree
        "listing_conversations/preauthorize"
      when :paypal
        "listing_conversations/initiate"
      else
        raise ArgumentError.new("Unknown payment type #{vprms[:payment_type]} for booking")
      end

    community_country_code = LocalizationUtils.valid_country_code(@current_community.country)

    price_break_down_locals = TransactionViewUtils.price_break_down_locals({
      booking:  true,
      start_on: booking_data[:start_on],
      end_on:   booking_data[:end_on],
      duration: booking_data[:duration],
      listing_price: vprms[:listing][:price],
      localized_unit_type: translate_unit_from_listing(vprms[:listing]),
      localized_selector_label: translate_selector_label_from_listing(vprms[:listing]),
      subtotal: vprms[:subtotal],
      shipping_price: delivery_method == :shipping ? vprms[:shipping_price] : nil,
      total: vprms[:total_price]
    })

    render view, locals: {
      preauthorize_form: PreauthorizeBookingForm.new({
          start_on: booking_data[:start_on],
          end_on: booking_data[:end_on]
      }),
      country_code: community_country_code,
      listing: vprms[:listing],
      delivery_method: delivery_method,
      subtotal: vprms[:subtotal],
      author: query_person_entity(vprms[:listing][:author_id]),
      action_button_label: vprms[:action_button_label],
      expiration_period: MarketplaceService::Transaction::Entity.authorization_expiration_period(vprms[:payment_type]),
      form_action: booked_path(person_id: @current_user.id, listing_id: vprms[:listing][:id]),
      price_break_down_locals: price_break_down_locals
    }.merge(gateway_locals)
  end

  def booked
    payment_type = MarketplaceService::Community::Query.payment_type(@current_community.id)
    conversation_params = params[:listing_conversation]

    start_on = DateUtils.from_date_select(conversation_params, :start_on)
    end_on = DateUtils.from_date_select(conversation_params, :end_on)
    preauthorize_form = PreauthorizeBookingForm.new(conversation_params.merge({
      start_on: start_on,
      end_on: end_on,
      listing_id: @listing.id
    }))

    if @current_community.transaction_agreement_in_use? && conversation_params[:contract_agreed] != "1"
      return render_error_response(request.xhr?,
        t("error_messages.transaction_agreement.required_error"),
        { action: :book, start_on: TransactionViewUtils.stringify_booking_date(start_on), end_on: TransactionViewUtils.stringify_booking_date(end_on) })
    end

    delivery_method = valid_delivery_method(delivery_method_str: preauthorize_form.delivery_method,
                                             shipping: @listing.require_shipping_address,
                                             pickup: @listing.pickup_enabled)
    if(delivery_method == :errored)
      return render_error_response(request.xhr?, "Delivery method is invalid.", action: :booked)
    end

    unless preauthorize_form.valid?
      return render_error_response(request.xhr?,
        preauthorize_form.errors.full_messages.join(", "),
       { action: :book, start_on: TransactionViewUtils.stringify_booking_date(start_on), end_on: TransactionViewUtils.stringify_booking_date(end_on) })
    end

    transaction_response = create_preauth_transaction(
      payment_type: payment_type,
      community: @current_community,
      listing: @listing,
      user: @current_user,
      listing_quantity: DateUtils.duration_days(preauthorize_form.start_on, preauthorize_form.end_on),
      content: preauthorize_form.content,
      use_async: request.xhr?,
      delivery_method: delivery_method,
      shipping_price: @listing.shipping_price,
      bt_payment_params: params[:braintree_payment],
      booking_fields: {
        start_on: preauthorize_form.start_on,
        end_on: preauthorize_form.end_on
      })

    unless transaction_response[:success]
      error =
        if (payment_type == :paypal)
          t("error_messages.paypal.generic_error")
        else
          "An error occured while trying to create a new transaction: #{transaction_response[:error_msg]}"
        end

      return render_error_response(request.xhr?, error, { action: :book, start_on: TransactionViewUtils.stringify_booking_date(start_on), end_on: TransactionViewUtils.stringify_booking_date(end_on) })
    end

    transaction_id = transaction_response[:data][:transaction][:id]

    case payment_type
    when :paypal
      if (transaction_response[:data][:gateway_fields][:redirect_url])
        return redirect_to transaction_response[:data][:gateway_fields][:redirect_url]
      else
        return render json: {
          op_status_url: transaction_op_status_path(transaction_response[:data][:gateway_fields][:process_token]),
          op_error_msg: t("error_messages.paypal.generic_error")
        }
      end
    when :braintree
      return redirect_to person_transaction_path(:person_id => @current_user.id, :id => transaction_id)
    end

  end

  def preauthorize
    quantity = TransactionViewUtils.parse_quantity(params[:quantity])
    vprms = view_params(listing_id: params[:listing_id], quantity: quantity)
    braintree_settings = BraintreePaymentQuery.braintree_settings(@current_community.id)

    price_break_down_locals = TransactionViewUtils.price_break_down_locals({
      booking:  false,
      quantity: quantity,
      listing_price: vprms[:listing][:price],
      localized_unit_type: translate_unit_from_listing(vprms[:listing]),
      localized_selector_label: translate_selector_label_from_listing(vprms[:listing]),
      subtotal: (quantity > 1) ? vprms[:subtotal] : nil,
      total: vprms[:total_price]
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
 javascript_include_tag "https://js.braintreegateway.com/v1/braintree.js" 
 end 
 content_for :extra_javascript do 
 end 
 content_for :javascript do 
 end 
  
 author_link = link_to(author[:display_name], person_path(id: author[:username])) 
 t(".details") 
 t(".by", listing: link_to("#{listing[:title]}", listing_path(listing[:id])), author: author_link).html_safe 
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
 
 form_for preauthorize_form,    :url => form_action,      :method => "post",      :html => { :id => "braintree-payment-form", :class => "hidden" } do |form| 
 if preauthorize_form.respond_to?(:start_on) && preauthorize_form.respond_to?(:end_on) 
 form.date_select :start_on, discard_day: true, discard_month: true, discard_year: true, default: preauthorize_form.start_on 
 form.date_select :end_on, discard_day: true, discard_month: true, discard_year: true, default: preauthorize_form.end_on 
 end 
 t(".payment") 
  fields_for :braintree_payment, braintree_form do |form| 
 form.text_field :cardholder_name, :class => :text_field, :placeholder => t("braintree_payments.edit.cardholder_name"), :data => { :'encrypted-name' => "braintree_payment[cardholder_name]" } 
 form.text_field :credit_card_number, :class => :text_field, :placeholder => t("braintree_payments.edit.credit_card_number"), :data => { :'encrypted-name' => "braintree_payment[credit_card_number]"} 
 form.text_field :cvv, :class => :text_field, :maxlength => 4, :placeholder => t("braintree_payments.edit.cvv"), :data => { :'encrypted-name' => "braintree_payment[cvv]"} 
 form.label :credit_card_expiration_month, t("braintree_payments.edit.exp"), :class => "preauthorize-exp" 
 form.select :credit_card_expiration_month, options_for_select(credit_card_expiration_month_options), {}, data: { "encrypted-name" => "braintree_payment[credit_card_expiration_month]" } 
 " / " 
 form.select :credit_card_expiration_year, options_for_select(credit_card_expiration_year_options), {}, data: { "encrypted-name" => "braintree_payment[credit_card_expiration_year]" } 
 end 
 
 t("conversations.new.optional_message_to", author_name: link_to(author[:display_name], person_path(id: author[:username]))).html_safe 
 form.text_area :content, :class => "text_area" 
 form.hidden_field :sender_id, :value => @current_user.id 
 if @current_community.transaction_agreement_in_use 
  form.check_box :contract_agreed, class: "required" 
 @community_customization.transaction_agreement_label 
 link_to(t(".read_more"), "#", id: "transaction-agreement-read-more").html_safe 
 render layout: "layouts/lightbox", locals: { id: "transaction-agreement-content"} do 
 text_with_line_breaks do 
 @community_customization.transaction_agreement_content.html_safe 
 end 
 end 
 
 end 
 if local_assigns.has_key?(:quantity) 
 form.hidden_field :quantity, value: quantity 
 end 
 form.button t("preauthorize_payments.edit.confirm_payment"), :class => "send_button" 
 t(".you_will_be_charged", author: author_link, expiration_period: expiration_period ).html_safe 
 end 
 "For security reasons JavaScript has to be enabled" 
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

  def preauthorized
    conversation_params = params[:listing_conversation]

    if @current_community.transaction_agreement_in_use? && conversation_params[:contract_agreed] != "1"
      flash[:error] = t("error_messages.transaction_agreement.required_error")
      return redirect_to action: :preauthorize
    end

    preauthorize_form = PreauthorizeMessageForm.new(conversation_params.merge({
      listing_id: @listing.id
    }))

    if preauthorize_form.valid?
      braintree_form = BraintreeForm.new(params[:braintree_payment])
      quantity = TransactionViewUtils.parse_quantity(preauthorize_form.quantity)

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
            listing_quantity: quantity,
            content: preauthorize_form.content,
            payment_gateway: :braintree,
            payment_process: :preauthorize,
          },
          gateway_fields: braintree_form.to_hash
        })

      unless transaction_response[:success]
        flash[:error] = "An error occured while trying to create a new transaction: #{transaction_response[:error_msg]}"
        return redirect_to action: :preauthorize
      end

      transaction_id = transaction_response[:data][:transaction][:id]

      redirect_to person_transaction_path(:person_id => @current_user.id, :id => transaction_id)
    else
      flash[:error] = preauthorize_form.errors.full_messages.join(", ")
      return redirect_to action: :preauthorize
    end
  end

  private

  def translate_unit_from_listing(listing)
    Maybe(listing).select { |l|
      l[:unit_type].present?
    }.map { |l|
      ListingViewUtils.translate_unit(l[:unit_type], l[:unit_tr_key])
    }.or_else(nil)
  end

  def translate_selector_label_from_listing(listing)
    Maybe(listing).select { |l|
      l[:unit_type].present?
    }.map { |l|
      ListingViewUtils.translate_quantity(l[:unit_type], l[:unit_selector_tr_key])
    }.or_else(nil)
  end

  def view_params(listing_id: listing_id, quantity: 1, shipping_enabled: false)
    listing = ListingQuery.listing(listing_id)
    payment_type = MarketplaceService::Community::Query.payment_type(@current_community.id)

    action_button_label = translate(listing[:action_button_tr_key])

    subtotal = listing[:price] * quantity
    shipping_price = shipping_price_total(listing[:shipping_price], listing[:shipping_price_additional], quantity)
    total_price = shipping_enabled ? subtotal + shipping_price : subtotal

    { listing: listing,
      payment_type: payment_type,
      action_button_label: action_button_label,
      subtotal: subtotal,
      shipping_price: shipping_price,
      total_price: total_price }
  end

  def render_error_response(isXhr, error_msg, redirect_params)
    if isXhr
      render json: { error_msg: error_msg }
    else
      flash[:error] = error_msg
      redirect_to(redirect_params)
    end
  end

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
    payment_type = MarketplaceService::Community::Query.payment_type(@current_community.id) || :none

    ready = TransactionService::Transaction.can_start_transaction(transaction: {
        payment_gateway: payment_type,
        community_id: @current_community.id,
        listing_author_id: @listing.author.id
      })

    unless ready[:data][:result]
      flash[:error] = t("layouts.notifications.listing_author_payment_details_missing")
      return redirect_to listing_path(@listing)
    end
  end

  def verified_booking_data(start_on, end_on)
    booking_form = BookingForm.new({
      start_on: TransactionViewUtils.parse_booking_date(start_on),
      end_on: TransactionViewUtils.parse_booking_date(end_on)
    })

    if !booking_form.valid?
      { error: booking_form.errors.full_messages }
    else
      booking_form.to_hash.merge({
        duration: DateUtils.duration_days(booking_form.start_on, booking_form.end_on)
      })
    end
  end

  def valid_delivery_method(delivery_method_str:, shipping:, pickup:)
    case [delivery_method_str, shipping, pickup]
    when matches([nil, true, false]), matches(["shipping", true, __])
      :shipping
    when matches([nil, false, true]), matches(["pickup", __, true])
      :pickup
    when matches([nil, false, false])
      nil
    else
      :errored
    end
  end

  def braintree_gateway_locals(community_id)
    braintree_settings = BraintreePaymentQuery.braintree_settings(community_id)

    {
      braintree_client_side_encryption_key: braintree_settings[:braintree_client_side_encryption_key],
      braintree_form: BraintreeForm.new
    }
  end

  def create_preauth_transaction(opts)
    gateway_fields =
      if (opts[:payment_type] == :paypal)
        # PayPal doesn't like images with cache buster in the URL
        logo_url = Maybe(opts[:community])
          .wide_logo
          .select { |wl| wl.present? }
          .url(:paypal, timestamp: false)
          .or_else(nil)

        {
          merchant_brand_logo_url: logo_url,
          success_url: success_paypal_service_checkout_orders_url,
          cancel_url: cancel_paypal_service_checkout_orders_url(listing_id: opts[:listing].id)
        }
      else
        BraintreeForm.new(opts[:bt_payment_params]).to_hash
      end

    transaction = {
          community_id: opts[:community].id,
          listing_id: opts[:listing].id,
          listing_title: opts[:listing].title,
          starter_id: opts[:user].id,
          listing_author_id: opts[:listing].author.id,
          listing_quantity: opts[:listing_quantity],
          unit_type: opts[:listing].unit_type,
          unit_price: opts[:listing].price,
          unit_tr_key: opts[:listing].unit_tr_key,
          unit_selector_tr_key: opts[:listing].unit_selector_tr_key,
          content: opts[:content],
          payment_gateway: opts[:payment_type],
          payment_process: :preauthorize,
          booking_fields: opts[:booking_fields],
          delivery_method: opts[:delivery_method]
    }

    if(opts[:delivery_method] == :shipping)
      transaction[:shipping_price] = opts[:shipping_price]
    end

    TransactionService::Transaction.create({
        transaction: transaction,
        gateway_fields: gateway_fields
      },
      paypal_async: opts[:use_async])
  end

  def query_person_entity(id)
    person_entity = MarketplaceService::Person::Query.person(id, @current_community.id)
    person_display_entity = person_entity.merge(
      display_name: PersonViewUtils.person_entity_display_name(person_entity, @current_community.name_display_type)
    )
  end

  def shipping_price_total(shipping_price, shipping_price_additional, quantity)
    Maybe(shipping_price)
      .map { |price|
        if shipping_price_additional.present? && quantity.present? && quantity > 1
          price + (shipping_price_additional * (quantity - 1))
        else
          price
        end
      }
      .or_else(nil)
  end

end
