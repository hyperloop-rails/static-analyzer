class AbuseReport < ActiveRecord::Base
  belongs_to :reporter, class_name: 'User'
  belongs_to :user

  validates :reporter, presence: true
  validates :user, presence: true
  validates :message, presence: true
  validates :user_id, uniqueness: { message: 'has already been reported' }

  def remove_user(deleted_by:)
    user.block
    DeleteUserWorker.perform_async(deleted_by.id, user.id, delete_solo_owned_groups: true)
  end

  def notify
    return unless self.persisted?

    AbuseReportMailer.notify(self.id).deliver_later
  end
end
