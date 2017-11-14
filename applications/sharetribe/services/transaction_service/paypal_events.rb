module TransactionService::PaypalEvents

  TransactionStore = TransactionService::Store::Transaction
  module_function

  # Public event API

  # Paypal payment request was cancelled, remove the associated transaction
  def request_cancelled(flow, token)
    delete_transaction(cid: token[:community_id], tx_id: token[:transaction_id])
  end

  def payment_updated(flow, payment)
    tx = MarketplaceService::Transaction::Query.transaction(payment[:transaction_id])
    if (tx)
      case transition_type(tx, payment)
      when :initiated_to_preauthorized
        initiated_to_preauthorized(tx)
      when :initiated_to_voided
        delete_transaction(cid: tx[:community_id], tx_id: tx[:id])
      when :preauthorized_to_paid
        preauthorized_to_paid(tx)
      when :preauthorized_to_pending_ext
        preauthorized_to_pending_ext(tx, payment[:pending_reason])
      when :pending_ext_to_paid
        pending_ext_to_paid(tx)
      when :preauthorized_to_voided
        preauthorized_to_rejected(tx) if(flow == :success)
        preauthorized_to_errored(tx) if(flow == :error)
      when :preauthorized_to_expired
        preauthorized_to_rejected(tx, payment[:payment_status])
      when :pending_ext_to_denied
        pending_ext_to_denied(tx, payment[:payment_status])
      else
        # No handler yet, should log but how to get a logger?
      end
    end
  end

  def update_transaction_details(flow, details)
    community_id = details.delete(:community_id)
    transaction_id = details.delete(:transaction_id)

    if shipping_fields_present?(details)
      TransactionStore.upsert_shipping_address(
        community_id: community_id,
        transaction_id: transaction_id,
        addr: details)
    end
  end

  # Privates

  def shipping_fields_present?(details)
    details.except(:status).values.any?
  end

  ## Mapping from payment transition to transaction transition

  TRANSITIONS = [
    [:initiated_to_preauthorized,   [:initiated, :pending, :authorization]],
    [:initiated_to_voided,          [:initiated, :voided]],
    [:preauthorized_to_paid,        [:preauthorized, :completed]],
    [:preauthorized_to_pending_ext, [:preauthorized, :pending]],
    [:pending_ext_to_paid,          [:pending_ext, :completed]],
    [:preauthorized_to_voided,      [:preauthorized, :voided]],
    [:preauthorized_to_expired,     [:preauthorized, :expired]],
    [:pending_ext_to_denied,        [:pending_ext, :denied]]
  ]

  def transition_type(tx, payment)
    payment_status = payment[:payment_status]
    pending_reason = payment[:pending_reason]
    tx_state = tx[:status].to_sym

    transition_key, _ = first_matching_transition(TRANSITIONS, [tx_state, payment_status, pending_reason])
    Maybe(transition_key).or_else(:unknown_transition)
  end

  def first_matching_transition(transitions, val)
    transitions.find { |(_, match)| match.zip(val).all? { |(p1, p2)| p1 == p2 } }
  end

  ## Transaction transition handlers
  def preauthorized_to_errored(tx)
    MarketplaceService::Transaction::Command.transition_to(tx[:id], "errored")
  end

  def preauthorized_to_rejected(tx, payment_status = nil)
    metadata = payment_status ? { paypal_payment_status: payment_status } : nil
    MarketplaceService::Transaction::Command.transition_to(tx[:id], "rejected", metadata)
  end

  def pending_ext_to_denied(tx, payment_status)
    MarketplaceService::Transaction::Command.transition_to(tx[:id], "rejected", paypal_payment_status: payment_status)
  end

  def initiated_to_preauthorized(tx)
    MarketplaceService::Transaction::Command.transition_to(tx[:id], :preauthorized)
  end

  def preauthorized_to_paid(tx)
    # Commission charge is synchronous and must complete before we
    # transition to paid so that we have the full payment info
    # available at the time we send payment receipts.
    TransactionService::Transaction.charge_commission(tx[:id])
    MarketplaceService::Transaction::Command.transition_to(tx[:id], :paid)
  end

  def preauthorized_to_pending_ext(tx, pending_reason)
    MarketplaceService::Transaction::Command.transition_to(tx[:id], :pending_ext, paypal_pending_reason: pending_reason) if pending_ext?(pending_reason)
  end

  def pending_ext?(pending_reason)
    pending_reason != :order && pending_reason != :authorization
  end

  def pending_ext_to_paid(tx)
    MarketplaceService::Transaction::Command.transition_to(tx[:id], :paid)
    TransactionService::Transaction.charge_commission(tx[:id])
  end

  def delete_transaction(cid:, tx_id:)
    if TransactionStore.get_in_community(community_id: cid, transaction_id: tx_id)
      TransactionStore.delete(community_id: cid, transaction_id: tx_id)
    end
  end

end
