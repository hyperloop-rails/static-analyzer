# == Schema Information
#
# Table name: order_permissions
#
#  id                  :integer          not null, primary key
#  paypal_account_id   :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  request_token       :string(255)
#  paypal_username_to  :string(255)      not null
#  scope               :string(255)
#  verification_code   :string(255)
#  onboarding_id       :string(36)
#  permissions_granted :boolean
#

class OrderPermission < ActiveRecord::Base
  attr_accessible(
    :paypal_account,
    :paypal_account_id,
    :request_token,
    :paypal_username_to,
    :scope,
    :verification_code,
    :onboarding_id,
    :permissions_granted)

  belongs_to :paypal_account, class_name: "PaypalAccount"

  validates_presence_of :paypal_account, :paypal_username_to
end
