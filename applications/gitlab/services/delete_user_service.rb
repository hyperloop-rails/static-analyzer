class DeleteUserService
  attr_accessor :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def execute(user, options = {})
    if !options[:delete_solo_owned_groups] && user.solo_owned_groups.present?
      user.errors[:base] << 'You must transfer ownership or delete groups before you can remove user'
      return user
    end

    user.solo_owned_groups.each do |group|
      DestroyGroupService.new(group, current_user).execute
    end

    user.personal_projects.each do |project|
      # Skip repository removal because we remove directory with namespace
      # that contain all this repositories
      ::Projects::DestroyService.new(project, current_user, skip_repo: true).pending_delete!
    end

    user.destroy
  end
end
