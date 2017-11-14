module TransactionService::DataTypes::Transaction

  # Common response format:

  Transaction = EntityUtils.define_builder(
    [:id, :fixnum, :mandatory],
    [:payment_process, one_of: [:none, :postpay, :preauthorize]],
    [:payment_gateway, one_of: [:paypal, :checkout, :braintree, :none]],
    [:community_id, :fixnum, :mandatory],
    [:starter_id, :string, :mandatory],
    [:listing_id, :fixnum, :mandatory],
    [:listing_title, :string, :mandatory],
    [:listing_price, :money, :optional],
    [:item_total, :money, :mandatory],
    [:shipping_price, :money],
    [:listing_author_id, :string, :mandatory],
    [:listing_quantity, :fixnum, default: 1],
    [:unit_type, :to_symbol, one_of: [:hour, :day, :night, :week, :month, :custom, nil]],
    [:unit_tr_key, :string, :optional],
    [:unit_selector_tr_key, :string, :optional],
    [:automatic_confirmation_after_days, :fixnum],
    [:last_transition_at, :time],
    [:current_state, :symbol],
    [:payment_total, :money],
    [:minimum_commission, :money],
    [:commission_from_seller, :fixnum],
    [:commission_total, :money],
    [:checkout_total, :money],
    [:charged_commission, :money],
    [:payment_gateway_fee, :money],
    [:shipping_address, :hash],
    [:booking, :hash])

  TransactionResponse = EntityUtils.define_builder(
    [:transaction, :hash, :mandatory],
    [:gateway_fields, :hash, :optional])

  module_function

  def create_transaction(opts); Transaction.call(opts) end

  def create_transaction_response(transaction, gateway_fields = {})
    TransactionResponse.call({
        transaction: transaction,
        gateway_fields: gateway_fields
      })
  end
end

