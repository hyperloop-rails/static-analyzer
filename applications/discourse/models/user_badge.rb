class UserBadge < ActiveRecord::Base
  belongs_to :badge
  belongs_to :user
  belongs_to :granted_by, class_name: 'User'
  belongs_to :notification, dependent: :destroy
  belongs_to :post

  validates :badge_id, presence: true, uniqueness: {scope: :user_id}, if: 'badge.single_grant?'
  validates :user_id, presence: true
  validates :granted_at, presence: true
  validates :granted_by, presence: true

  after_create do
    Badge.increment_counter 'grant_count', self.badge_id
    DiscourseEvent.trigger(:user_badge_granted, self.badge_id, self.user_id)
  end

  after_destroy do
    Badge.decrement_counter 'grant_count', self.badge_id
    DiscourseEvent.trigger(:user_badge_removed, self.badge_id, self.user_id)
  end
end

# == Schema Information
#
# Table name: user_badges
#
#  id              :integer          not null, primary key
#  badge_id        :integer          not null
#  user_id         :integer          not null
#  granted_at      :datetime         not null
#  granted_by_id   :integer          not null
#  post_id         :integer
#  notification_id :integer
#  seq             :integer          default(0), not null
#
# Indexes
#
#  index_user_badges_on_badge_id_and_user_id              (badge_id,user_id)
#  index_user_badges_on_badge_id_and_user_id_and_post_id  (badge_id,user_id,post_id) UNIQUE
#  index_user_badges_on_badge_id_and_user_id_and_seq      (badge_id,user_id,seq) UNIQUE
#  index_user_badges_on_user_id                           (user_id)
#
