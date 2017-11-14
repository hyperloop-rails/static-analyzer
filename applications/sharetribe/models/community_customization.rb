# == Schema Information
#
# Table name: community_customizations
#
#  id                                         :integer          not null, primary key
#  community_id                               :integer
#  locale                                     :string(255)
#  name                                       :string(255)
#  slogan                                     :string(255)
#  description                                :text
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  blank_slate                                :text
#  welcome_email_content                      :text
#  how_to_use_page_content                    :text(16777215)
#  about_page_content                         :text(16777215)
#  terms_page_content                         :text(16777215)
#  privacy_page_content                       :text(16777215)
#  storefront_label                           :string(255)
#  signup_info_content                        :text
#  private_community_homepage_content         :text(16777215)
#  verification_to_post_listings_info_content :text(16777215)
#  search_placeholder                         :string(255)
#  transaction_agreement_label                :string(255)
#  transaction_agreement_content              :text(16777215)
#
# Indexes
#
#  index_community_customizations_on_community_id  (community_id)
#

class CommunityCustomization < ActiveRecord::Base

  attr_accessible :community_id,
    :description,
    :locale,
    :name,
    :slogan,
    :blank_slate,
    :welcome_email_content,
    :about_page_content,
    :how_to_use_page_content,
    :terms_page_content,
    :privacy_page_content,
    :storefront_label,
    :signup_info_content,
    :private_community_homepage_content,
    :verification_to_post_listings_info_content,
    :search_placeholder,
    :transaction_agreement_label,
    :transaction_agreement_content

  # Set sane limits for content length. These are either driven by
  # column length in MySQL or, in case of :mediumtext type, set low
  # enough to prevent excess storage usage.
  validates_length_of :blank_slate, maximum: 65535
  validates_length_of :welcome_email_content, maximum: 65535
  validates_length_of :how_to_use_page_content, maximum: 262140
  validates_length_of :about_page_content, maximum: 262140
  validates_length_of :terms_page_content, maximum: 393210
  validates_length_of :privacy_page_content, maximum: 262140
  validates_length_of :signup_info_content, maximum: 65535
  validates_length_of :private_community_homepage_content, maximum: 262140
  validates_length_of :verification_to_post_listings_info_content, maximum: 262140
  validates_length_of :transaction_agreement_content, maximum: 262140

  belongs_to :community
end
