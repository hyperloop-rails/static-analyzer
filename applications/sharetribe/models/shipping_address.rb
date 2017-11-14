# == Schema Information
#
# Table name: shipping_addresses
#
#  id                :integer          not null, primary key
#  transaction_id    :integer          not null
#  status            :string(255)
#  name              :string(255)
#  phone             :string(255)
#  postal_code       :string(255)
#  city              :string(255)
#  country           :string(255)
#  state_or_province :string(255)
#  street1           :string(255)
#  street2           :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  country_code      :string(8)
#

class ShippingAddress < ActiveRecord::Base
  attr_accessible(
    :transaction_id,
    :status,
    :name,
    :phone,
    :postal_code,
    :city,
    :country,
    :country_code,
    :state_or_province,
    :street1,
    :street2
  )

  belongs_to :transaction
end
