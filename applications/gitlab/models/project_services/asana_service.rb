require 'asana'

class AsanaService < Service
  prop_accessor :api_key, :restrict_to_branch
  validates :api_key, presence: true, if: :activated?

  def title
    'Asana'
  end

  def description
    'Asana - Teamwork without email'
  end

  def help
    'This service adds commit messages as comments to Asana tasks.
Once enabled, commit messages are checked for Asana task URLs
(for example, `https://app.asana.com/0/123456/987654`) or task IDs
starting with # (for example, `#987654`). Every task ID found will
get the commit comment added to it.

You can also close a task with a message containing: `fix #123456`.

You can create a Personal Access Token here:
http://app.asana.com/-/account_api'
  end

  def to_param
    'asana'
  end

  def fields
    [
      {
        type: 'text',
        name: 'api_key',
        placeholder: 'User Personal Access Token. User must have access to task, all comments will be attributed to this user.'
      },
      {
        type: 'text',
        name: 'restrict_to_branch',
        placeholder: 'Comma-separated list of branches which will be automatically inspected. Leave blank to include all branches.'
      }
    ]
  end

  def supported_events
    %w(push)
  end

  def client
    @_client ||= begin
      Asana::Client.new do |c|
        c.authentication :access_token, api_key
      end
    end
  end

  def execute(data)
    return unless supported_events.include?(data[:object_kind])

    # check the branch restriction is poplulated and branch is not included
    branch = Gitlab::Git.ref_name(data[:ref])
    branch_restriction = restrict_to_branch.to_s
    if branch_restriction.length > 0 && branch_restriction.index(branch).nil?
      return
    end

    user = data[:user_name]
    project_name = project.name_with_namespace

    data[:commits].each do |commit|
      push_msg = "#{user} pushed to branch #{branch} of #{project_name} ( #{commit[:url]} ):"
      check_commit(commit[:message], push_msg)
    end
  end

  def check_commit(message, push_msg)
    # matches either:
    # - #1234
    # - https://app.asana.com/0/0/1234
    # optionally preceded with:
    # - fix/ed/es/ing
    # - close/s/d
    # - closing
    issue_finder = /(fix\w*|clos[ei]\w*+)?\W*(?:https:\/\/app\.asana\.com\/\d+\/\d+\/(\d+)|#(\d+))/i

    message.scan(issue_finder).each do |tuple|
      # tuple will be
      # [ 'fix', 'id_from_url', 'id_from_pound' ]
      taskid = tuple[2] || tuple[1]

      begin
        task = Asana::Task.find_by_id(client, taskid)
        task.add_comment(text: "#{push_msg} #{message}")

        if tuple[0]
          task.update(completed: true)
        end
      rescue => e
        Rails.logger.error(e.message)
        next
      end
    end
  end
end
