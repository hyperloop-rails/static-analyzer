module Projects
  class DestroyService < BaseService
    include Gitlab::ShellAdapter

    class DestroyError < StandardError; end

    DELETED_FLAG = '+deleted'

    def pending_delete!
      project.schedule_delete!(current_user.id, params)
    end

    def execute
      return false unless can?(current_user, :remove_project, project)

      project.team.truncate

      repo_path = project.path_with_namespace
      wiki_path = repo_path + '.wiki'

      # Flush the cache for both repositories. This has to be done _before_
      # removing the physical repositories as some expiration code depends on
      # Git data (e.g. a list of branch names).
      flush_caches(project, wiki_path)

      Project.transaction do
        project.destroy!

        unless remove_repository(repo_path)
          raise_error('Failed to remove project repository. Please try again or contact administrator')
        end

        unless remove_repository(wiki_path)
          raise_error('Failed to remove wiki repository. Please try again or contact administrator')
        end
      end

      log_info("Project \"#{project.path_with_namespace}\" was removed")
      system_hook_service.execute_hooks_for(project, :destroy)
      true
    end

    private

    def remove_repository(path)
      # Skip repository removal. We use this flag when remove user or group
      return true if params[:skip_repo] == true

      # There is a possibility project does not have repository or wiki
      return true unless gitlab_shell.exists?(path + '.git')

      new_path = removal_path(path)

      if gitlab_shell.mv_repository(path, new_path)
        log_info("Repository \"#{path}\" moved to \"#{new_path}\"")
        GitlabShellWorker.perform_in(5.minutes, :remove_repository, new_path)
      else
        false
      end
    end

    def raise_error(message)
      raise DestroyError.new(message)
    end

    # Build a path for removing repositories
    # We use `+` because its not allowed by GitLab so user can not create
    # project with name cookies+119+deleted and capture someone stalled repository
    #
    # gitlab/cookies.git -> gitlab/cookies+119+deleted.git
    #
    def removal_path(path)
      "#{path}+#{project.id}#{DELETED_FLAG}"
    end

    def flush_caches(project, wiki_path)
      project.repository.before_delete

      Repository.new(wiki_path, project).before_delete
    end
  end
end
