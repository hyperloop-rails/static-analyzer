# == Schema Information
#
# Table name: billing_agreements
#
#  id                   :integer          not null, primary key
#  paypal_account_id    :integer          not null
#  billing_agreement_id :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  paypal_username_to   :string(255)      not null
#  request_token        :string(255)      not null
#

class BillingAgreement < ActiveRecord::Base
  attr_accessible :paypal_account, :request_token, :billing_agreement_id, :paypal_username_to

  belongs_to :paypal_account, class_name: "PaypalAccount"

  validates_presence_of :paypal_account, :request_token, :paypal_username_to
end
