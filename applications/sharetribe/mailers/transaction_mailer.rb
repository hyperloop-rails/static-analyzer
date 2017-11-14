# Transaction mailer
#
# Responsible for:
# - transactions created
# - transaction status changes
# - reminders
#

include ApplicationHelper
include ListingsHelper

class TransactionMailer < ActionMailer::Base
  include MailUtils

  default :from => APP_CONFIG.sharetribe_mail_from_address
  layout 'email'

  include MoneyRails::ActionViewExtension # this is for humanized_money_with_symbol

  add_template_helper(EmailTemplateHelper)

  def transaction_created(transaction)
    community = transaction.community

    recipient = transaction.author
    sender = transaction.starter
    sender_name = sender.name(community)

    url_params = build_url_params(community, recipient)
    reply_url = person_transaction_url(recipient, url_params.merge(:id => transaction.id))

    prepare_template(community, recipient)

    # TODO Now that we have splitted "new message", we could be more specific here, and say that this message
    # is about a new transaction!
    with_locale(recipient.locale, community.locales.map(&:to_sym), community.id) do
      premailer_mail(
        mail_params(recipient, community, t("emails.new_message.you_have_a_new_message", :sender_name => sender_name))) do |format|
        format.html {
          render locals: {
                   recipient: recipient,
                   reply_url: reply_url,
                   sender_name: sender_name,
                 }
        }
      end
    end
  end

  def transaction_preauthorized(transaction)
    @transaction = transaction
    @community = transaction.community

    recipient = transaction.author
    set_up_urls(recipient, transaction.community)
    with_locale(recipient.locale, transaction.community.locales.map(&:to_sym), transaction.community.id) do

      payment_type = MarketplaceService::Community::Query.payment_type(@community.id)
      gateway_expires = MarketplaceService::Transaction::Entity.authorization_expiration_period(payment_type)

      expires = Maybe(transaction).booking.end_on.map { |booking_end|
        MarketplaceService::Transaction::Entity.preauth_expires_at(gateway_expires.days.from_now, booking_end)
      }.or_else(gateway_expires.days.from_now)

      buffer = 1.minute # Add a small buffer (it might take a couple seconds until the email is sent)
      expires_in = TimeUtils.time_to(expires + buffer)

      premailer_mail(
        mail_params(
          @recipient,
          @community,
          t("emails.transaction_preauthorized.subject", requester: transaction.starter.name(@community), listing_title: transaction.listing.title))) do |format|
        format.html {
          render locals: {
                   payment_expires_in_unit: expires_in[:unit],
                   payment_expires_in_count: expires_in[:count]
                 }
        }
      end
    end
  end

  def transaction_preauthorized_reminder(transaction)
    @transaction = transaction
    @community = transaction.community

    recipient = transaction.author
    set_up_urls(recipient, transaction.community)
    with_locale(recipient.locale, transaction.community.locales.map(&:to_sym), transaction.community.id) do

      premailer_mail(
        mail_params(
          @recipient,
          @community,
          t("emails.transaction_preauthorized_reminder.subject", requester: transaction.starter.name(@community), listing_title: transaction.listing.title)))
    end
  end

  def braintree_new_payment(payment, community)
    recipient = payment.recipient
    prepare_template(community, payment.recipient, "email_about_new_payments")
    with_locale(recipient.locale, community.locales.map(&:to_sym), community.id) do

      service_fee = payment.total_commission
      you_get = payment.seller_gets

      transaction = payment.transaction
      unit_type = Maybe(transaction).select { |t| t.unit_type.present? }.map { |t| ListingViewUtils.translate_unit(t.unit_type, t.unit_tr_key) }.or_else(nil)
      duration = payment.transaction.booking.present? ? payment.transaction.booking.duration : nil

      premailer_mail(:to => payment.recipient.confirmed_notification_emails_to,
                     :from => community_specific_sender(community),
                     :subject => t("emails.new_payment.new_payment")) { |format|
        format.html {
          render "braintree_payment_receipt_to_seller", locals: {
                   conversation_url: person_transaction_url(payment.recipient, @url_params.merge({:id => payment.transaction.id.to_s})),
                   listing_title: payment.transaction.listing_title,
                   price_per_unit_title: t("emails.new_payment.price_per_unit_type", unit_type: unit_type),
                   listing_price: humanized_money_with_symbol(payment.transaction.unit_price),
                   listing_quantity: payment.transaction.listing_quantity,
                   duration: duration,
                   payment_total: humanized_money_with_symbol(payment.total_sum),
                   payment_service_fee: humanized_money_with_symbol(-service_fee),
                   payment_seller_gets: humanized_money_with_symbol(you_get),
                   payer_full_name: payment.payer.name(community),
                   payer_given_name: payment.payer.given_name_or_username,
                   automatic_confirmation_days: payment.transaction.automatic_confirmation_after_days,
                   show_money_will_be_transferred_note: true
                 }
        }
      }
    end
  end

  def braintree_receipt_to_payer(payment, community)
    recipient = payment.payer
    prepare_template(community, recipient, "email_about_new_payments")
    with_locale(recipient.locale, community.locales.map(&:to_sym), community.id) do

      unit_type = Maybe(payment.transaction).select { |t| t.unit_type.present? }.map { |t| ListingViewUtils.translate_unit(t.unit_type, t.unit_tr_key) }.or_else(nil)
      duration = payment.transaction.booking.present? ? payment.transaction.booking.duration : nil

      premailer_mail(:to => payment.payer.confirmed_notification_emails_to,
                     :from => community_specific_sender(community),
                     :subject => t("emails.receipt_to_payer.receipt_of_payment")) { |format|
        format.html {
          render "payment_receipt_to_buyer", locals: {
                   conversation_url: person_transaction_url(payment.payer, @url_params.merge({:id => payment.transaction.id.to_s})),
                   listing_title: payment.transaction.listing_title,
                   price_per_unit_title: t("emails.new_payment.price_per_unit_type", unit_type: unit_type),
                   listing_price: humanized_money_with_symbol(payment.transaction.unit_price),
                   listing_quantity: payment.transaction.listing_quantity,
                   duration: duration,
                   payment_total: humanized_money_with_symbol(payment.total_sum),
                   subtotal: humanized_money_with_symbol(payment.total_sum),
                   shipping_total: nil,
                   recipient_full_name: payment.recipient.name(community),
                   recipient_given_name: payment.recipient.given_name_or_username,
                   automatic_confirmation_days: payment.transaction.automatic_confirmation_after_days,
                   show_money_will_be_transferred_note: true
                 }
        }
      }
    end
  end

  # seller_model, buyer_model and community can be passed as params for testing purposes
  def paypal_new_payment(transaction, seller_model = nil, buyer_model = nil, community = nil)
    seller_model ||= Person.find(transaction[:listing_author_id])
    buyer_model ||= Person.find(transaction[:starter_id])
    community ||= Community.find(transaction[:community_id])

    payment_total = transaction[:payment_total]
    service_fee = Maybe(transaction[:charged_commission]).or_else(Money.new(0, payment_total.currency))
    gateway_fee = transaction[:payment_gateway_fee]

    prepare_template(community, seller_model, "email_about_new_payments")
    with_locale(seller_model.locale, community.locales.map(&:to_sym), community.id) do

      you_get = payment_total - service_fee - gateway_fee

      unit_type = Maybe(transaction).select { |t| t[:unit_type].present? }.map { |t| ListingViewUtils.translate_unit(t[:unit_type], t[:unit_tr_key]) }.or_else(nil)
      quantity_selector_label = Maybe(transaction).select { |t| t[:unit_type].present? }.map { |t| ListingViewUtils.translate_quantity(t[:unit_type], t[:unit_selector_tr_key]) }.or_else(nil)

      premailer_mail(:to => seller_model.confirmed_notification_emails_to,
                     :from => community_specific_sender(community),
                     :subject => t("emails.new_payment.new_payment")) do |format|
        format.html {
          render "paypal_payment_receipt_to_seller", locals: {
                   conversation_url: person_transaction_url(seller_model, @url_params.merge(id: transaction[:id])),
                   listing_title: transaction[:listing_title],
                   price_per_unit_title: t("emails.new_payment.price_per_unit_type", unit_type: unit_type),
                   quantity_selector_label: quantity_selector_label,
                   listing_price: humanized_money_with_symbol(transaction[:listing_price]),
                   listing_quantity: transaction[:listing_quantity],
                   duration: transaction[:booking].present? ? transaction[:booking][:duration] : nil,
                   subtotal: humanized_money_with_symbol(transaction[:item_total]),
                   payment_total: humanized_money_with_symbol(payment_total),
                   shipping_total: humanized_money_with_symbol(transaction[:shipping_price]),
                   payment_service_fee: humanized_money_with_symbol(-service_fee),
                   paypal_gateway_fee: humanized_money_with_symbol(-gateway_fee),
                   payment_seller_gets: humanized_money_with_symbol(you_get),
                   payer_full_name: buyer_model.name(community),
                   payer_given_name: buyer_model.given_name_or_username,
                 }
        }
      end
    end
  end

  # seller_model, buyer_model and community can be passed as params for testing purposes
  def paypal_receipt_to_payer(transaction, seller_model = nil, buyer_model = nil, community = nil)
    seller_model ||= Person.find(transaction[:listing_author_id])
    buyer_model ||= Person.find(transaction[:starter_id])
    community ||= Community.find(transaction[:community_id])

    prepare_template(community, buyer_model, "email_about_new_payments")
    with_locale(buyer_model.locale, community.locales.map(&:to_sym), community.id) do

      unit_type = Maybe(transaction).select { |t| t[:unit_type].present? }.map { |t| ListingViewUtils.translate_unit(t[:unit_type], t[:unit_tr_key]) }.or_else(nil)
      quantity_selector_label = Maybe(transaction).select { |t| t[:unit_type].present? }.map { |t| ListingViewUtils.translate_quantity(t[:unit_type], t[:unit_selector_tr_key]) }.or_else(nil)

      premailer_mail(:to => buyer_model.confirmed_notification_emails_to,
                     :from => community_specific_sender(community),
                     :subject => t("emails.receipt_to_payer.receipt_of_payment")) { |format|
        format.html {
          render "payment_receipt_to_buyer", locals: {
                   conversation_url: person_transaction_url(buyer_model, @url_params.merge({:id => transaction[:id]})),
                   listing_title: transaction[:listing_title],
                   price_per_unit_title: t("emails.receipt_to_payer.price_per_unit_type", unit_type: unit_type),
                   quantity_selector_label: quantity_selector_label,
                   listing_price: humanized_money_with_symbol(transaction[:listing_price]),
                   listing_quantity: transaction[:listing_quantity],
                   duration: transaction[:booking].present? ? transaction[:booking][:duration] : nil,
                   subtotal: humanized_money_with_symbol(transaction[:item_total]),
                   shipping_total: humanized_money_with_symbol(transaction[:shipping_price]),
                   payment_total: humanized_money_with_symbol(transaction[:payment_total]),
                   recipient_full_name: seller_model.name(community),
                   recipient_given_name: seller_model.given_name_or_username,
                   automatic_confirmation_days: nil,
                   show_money_will_be_transferred_note: false
                 }
        }
      }
    end
  end

  private

  def premailer_mail(opts, &block)
    premailer(mail(opts, &block))
  end

  # TODO Get rid of this method. Pass all data in local variables, not instance variables.
  def prepare_template(community, recipient, email_type = nil)
    @email_type = email_type
    @community = community
    @current_community = community
    @recipient = recipient
    @url_params = build_url_params(community, recipient)
  end

  def mail_params(recipient, community, subject)
    {
      to: recipient.confirmed_notification_emails_to,
      from: community_specific_sender(community),
      subject: subject
    }
  end

  def build_url_params(community, recipient, ref="email")
    {
      host: community.full_domain,
      ref: ref,
      locale: recipient.locale
    }
  end

end
