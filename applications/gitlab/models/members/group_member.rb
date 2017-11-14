class GroupMember < Member
  SOURCE_TYPE = 'Namespace'

  belongs_to :group, class_name: 'Group', foreign_key: 'source_id'

  # Make sure group member points only to group as it source
  default_value_for :source_type, SOURCE_TYPE
  validates_format_of :source_type, with: /\ANamespace\z/
  default_scope { where(source_type: SOURCE_TYPE) }

  scope :with_group, ->(group) { where(source_id: group.id) }
  scope :with_user, ->(user) { where(user_id: user.id) }

  def self.with_group
where(source_id: group.id)
end

def self.with_user
where(user_id: user.id)
end

def self.with_group
where(source_id: group.id)
end

def self.with_user
where(user_id: user.id)
end

def self.access_level_roles
    Gitlab::Access.options_with_owner
  end

  def group
    source
  end

  def access_field
    access_level
  end

  private

  def send_invite
    notification_service.invite_group_member(self, @raw_invite_token)

    super
  end

  def post_create_hook
    notification_service.new_group_member(self)

    super
  end

  def post_update_hook
    if access_level_changed?
      notification_service.update_group_member(self)
    end

    super
  end

  def after_accept_invite
    notification_service.accept_group_invite(self)

    super
  end

  def after_decline_invite
    notification_service.decline_group_invite(self)

    super
  end
end
