# == Schema Information
#
# Table name: marketplace_settings
#
#  id               :integer          not null, primary key
#  shipping_enabled :boolean          default(FALSE)
#  community_id     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class MarketplaceSettings < ActiveRecord::Base
  attr_accessible :community, :shipping_enabled
  belongs_to :community
end
