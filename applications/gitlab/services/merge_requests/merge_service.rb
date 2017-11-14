module MergeRequests
  # MergeService class
  #
  # Do git merge and in case of success
  # mark merge request as merged and execute all hooks and notifications
  # Executed when you do merge via GitLab UI
  #
  class MergeService < MergeRequests::BaseService
    attr_reader :merge_request

    def execute(merge_request)
      @merge_request = merge_request

      return error('Merge request is not mergeable') unless @merge_request.mergeable?

      merge_request.in_locked_state do
        if commit
          after_merge
          success
        else
          error('Can not merge changes')
        end
      end
    end

    private

    def commit
      committer = repository.user_to_committer(current_user)

      options = {
        message: params[:commit_message] || merge_request.merge_commit_message,
        author: committer,
        committer: committer
      }

      commit_id = repository.merge(current_user, merge_request.source_sha, merge_request.target_branch, options)
      merge_request.update(merge_commit_sha: commit_id)
    rescue StandardError => e
      merge_request.update(merge_error: "Something went wrong during merge")
      Rails.logger.error(e.message)
      return false
    end

    def after_merge
      MergeRequests::PostMergeService.new(project, current_user).execute(merge_request)

      if params[:should_remove_source_branch].present?
        DeleteBranchService.new(@merge_request.source_project, current_user).
          execute(merge_request.source_branch)
      end
    end
  end
end
