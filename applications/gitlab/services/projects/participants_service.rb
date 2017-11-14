module Projects
  class ParticipantsService < BaseService
    def execute(noteable_type, noteable_id)
      @noteable_type = noteable_type
      @noteable_id = noteable_id
      project_members = sorted(project.team.members)
      participants = target_owner + participants_in_target + all_members + groups + project_members
      participants.uniq
    end

    def target
      @target ||=
        case @noteable_type
        when "Issue"
          project.issues.find_by_iid(@noteable_id)
        when "MergeRequest"
          project.merge_requests.find_by_iid(@noteable_id)
        when "Commit"
          project.commit(@noteable_id)
        else
          nil
        end
    end

    def target_owner
      return [] unless target && target.author.present?

      [{
        name: target.author.name,
        username: target.author.username
      }]
    end

    def participants_in_target
      return [] unless target

      users = target.participants(current_user)
      sorted(users)
    end

    def sorted(users)
      users.uniq.to_a.compact.sort_by(&:username).map do |user|
        { username: user.username, name: user.name }
      end
    end

    def groups
      current_user.authorized_groups.sort_by(&:path).map do |group|
        count = group.users.count
        { username: group.path, name: group.name, count: count }
      end
    end

    def all_members
      count = project.team.members.flatten.count
      [{ username: "all", name: "All Project and Group Members", count: count }]
    end
  end
end
