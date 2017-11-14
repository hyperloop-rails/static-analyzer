require 'carrierwave/orm/activerecord'

class Project < ActiveRecord::Base
  include Gitlab::ConfigHelper
  include Gitlab::ShellAdapter
  include Gitlab::VisibilityLevel
  include Gitlab::CurrentSettings
  include Referable
  include Sortable
  include AfterCommitQueue
  include CaseSensitivity
  include TokenAuthenticatable

  extend Gitlab::ConfigHelper

  UNKNOWN_IMPORT_URL = 'http://unknown.git'

  default_value_for :archived, false
  default_value_for :visibility_level, gitlab_config_features.visibility_level
  default_value_for :issues_enabled, gitlab_config_features.issues
  default_value_for :merge_requests_enabled, gitlab_config_features.merge_requests
  default_value_for :builds_enabled, gitlab_config_features.builds
  default_value_for :wiki_enabled, gitlab_config_features.wiki
  default_value_for :snippets_enabled, gitlab_config_features.snippets
  default_value_for :container_registry_enabled, gitlab_config_features.container_registry
  default_value_for(:shared_runners_enabled) { current_application_settings.shared_runners_enabled }

  # set last_activity_at to the same as created_at
  after_create :set_last_activity_at
  def self.sorted_by_activity
reorder(last_activity_at: :desc)
end

def self.sorted_by_stars
reorder('projects.star_count DESC')
end

def self.sorted_by_names
joins(:namespace).reorder('namespaces.name ASC, projects.name ASC')
end

def self.without_user
where('projects.id NOT IN (:ids)', ids: user.authorized_projects.map(&:id) )
end

def self.without_team
team.projects.present?
end

def self.not_in_group
where('projects.id NOT IN (:ids)', ids: group.project_ids )
end

def self.in_namespace
where(namespace_id: namespace_ids)
end

def self.in_group_namespace
joins(:group)
end

def self.personal
where(namespace_id: user.namespace_id)
end

def self.joined
where('namespace_id != ?', user.namespace_id)
end

def self.non_archived
where(archived: false)
end

def self.for_milestones
joins(:milestones).where('milestones.id' => ids).distinct
end

def self.sorted_by_activity
reorder(last_activity_at: :desc)
end

def self.sorted_by_stars
reorder('projects.star_count DESC')
end

def self.sorted_by_names
joins(:namespace).reorder('namespaces.name ASC, projects.name ASC')
end

def self.without_user
where('projects.id NOT IN (:ids)', ids: user.authorized_projects.map(&:id) )
end

def self.without_team
team.projects.present?
end

def self.not_in_group
where('projects.id NOT IN (:ids)', ids: group.project_ids )
end

def self.in_namespace
where(namespace_id: namespace_ids)
end

def self.in_group_namespace
joins(:group)
end

def self.personal
where(namespace_id: user.namespace_id)
end

def self.joined
where('namespace_id != ?', user.namespace_id)
end

def self.non_archived
where(archived: false)
end

def self.for_milestones
joins(:milestones).where('milestones.id' => ids).distinct
end

def set_last_activity_at
    update_column(:last_activity_at, self.created_at)
  end

  # update visibility_level of forks
  after_update :update_forks_visibility_level
  def update_forks_visibility_level
    return unless visibility_level < visibility_level_was

    forks.each do |forked_project|
      if forked_project.visibility_level > visibility_level
        forked_project.visibility_level = visibility_level
        forked_project.save!
      end
    end
  end

  ActsAsTaggableOn.strict_case_match = true
  acts_as_taggable_on :tags

  attr_accessor :new_default_branch
  attr_accessor :old_path_with_namespace

  alias_attribute :title, :name

  # Relations
  belongs_to :creator, foreign_key: 'creator_id', class_name: 'User'
  belongs_to :group, -> { where(type: Group) }, foreign_key: 'namespace_id'
  belongs_to :namespace

  has_one :last_event, -> {order 'events.created_at DESC'}, class_name: 'Event', foreign_key: 'project_id'

  # Project services
  has_many :services
  has_one :campfire_service, dependent: :destroy
  has_one :drone_ci_service, dependent: :destroy
  has_one :emails_on_push_service, dependent: :destroy
  has_one :builds_email_service, dependent: :destroy
  has_one :irker_service, dependent: :destroy
  has_one :pivotaltracker_service, dependent: :destroy
  has_one :hipchat_service, dependent: :destroy
  has_one :flowdock_service, dependent: :destroy
  has_one :assembla_service, dependent: :destroy
  has_one :asana_service, dependent: :destroy
  has_one :gemnasium_service, dependent: :destroy
  has_one :slack_service, dependent: :destroy
  has_one :buildkite_service, dependent: :destroy
  has_one :bamboo_service, dependent: :destroy
  has_one :teamcity_service, dependent: :destroy
  has_one :pushover_service, dependent: :destroy
  has_one :jira_service, dependent: :destroy
  has_one :redmine_service, dependent: :destroy
  has_one :custom_issue_tracker_service, dependent: :destroy
  has_one :gitlab_issue_tracker_service, dependent: :destroy
  has_one :external_wiki_service, dependent: :destroy

  has_one  :forked_project_link,  dependent: :destroy, foreign_key: "forked_to_project_id"
  has_one  :forked_from_project,  through:   :forked_project_link

  has_many :forked_project_links, foreign_key: "forked_from_project_id"
  has_many :forks,                through:     :forked_project_links, source: :forked_to_project

  # Merge Requests for target project should be removed with it
  has_many :merge_requests,     dependent: :destroy, foreign_key: 'target_project_id'
  # Merge requests from source project should be kept when source project was removed
  has_many :fork_merge_requests, foreign_key: 'source_project_id', class_name: MergeRequest
  has_many :issues,             dependent: :destroy
  has_many :labels,             dependent: :destroy
  has_many :services,           dependent: :destroy
  has_many :events,             dependent: :destroy
  has_many :milestones,         dependent: :destroy
  has_many :notes,              dependent: :destroy
  has_many :snippets,           dependent: :destroy, class_name: 'ProjectSnippet'
  has_many :hooks,              dependent: :destroy, class_name: 'ProjectHook'
  has_many :protected_branches, dependent: :destroy
  has_many :project_members, dependent: :destroy, as: :source, class_name: 'ProjectMember'
  has_many :users, through: :project_members
  has_many :deploy_keys_projects, dependent: :destroy
  has_many :deploy_keys, through: :deploy_keys_projects
  has_many :users_star_projects, dependent: :destroy
  has_many :starrers, through: :users_star_projects, source: :user
  has_many :releases, dependent: :destroy
  has_many :lfs_objects_projects, dependent: :destroy
  has_many :lfs_objects, through: :lfs_objects_projects
  has_many :project_group_links, dependent: :destroy
  has_many :invited_groups, through: :project_group_links, source: :group
  has_many :todos, dependent: :destroy
  has_many :notification_settings, dependent: :destroy, as: :source

  has_one :import_data, dependent: :destroy, class_name: "ProjectImportData"

  has_many :commit_statuses, dependent: :destroy, class_name: 'CommitStatus', foreign_key: :gl_project_id
  has_many :ci_commits, dependent: :destroy, class_name: 'Ci::Commit', foreign_key: :gl_project_id
  has_many :builds, class_name: 'Ci::Build', foreign_key: :gl_project_id # the builds are created from the commit_statuses
  has_many :runner_projects, dependent: :destroy, class_name: 'Ci::RunnerProject', foreign_key: :gl_project_id
  has_many :runners, through: :runner_projects, source: :runner, class_name: 'Ci::Runner'
  has_many :variables, dependent: :destroy, class_name: 'Ci::Variable', foreign_key: :gl_project_id
  has_many :triggers, dependent: :destroy, class_name: 'Ci::Trigger', foreign_key: :gl_project_id

  accepts_nested_attributes_for :variables, allow_destroy: true

  delegate :name, to: :owner, allow_nil: true, prefix: true
  delegate :members, to: :team, prefix: true

  # Validations
  validates :creator, presence: true, on: :create
  validates :description, length: { maximum: 2000 }, allow_blank: true
  validates :name,
    presence: true,
    length: { within: 0..255 },
    format: { with: Gitlab::Regex.project_name_regex,
              message: Gitlab::Regex.project_name_regex_message }
  validates :path,
    presence: true,
    length: { within: 0..255 },
    format: { with: Gitlab::Regex.project_path_regex,
              message: Gitlab::Regex.project_path_regex_message }
  validates :issues_enabled, :merge_requests_enabled,
            :wiki_enabled, inclusion: { in: [true, false] }
  validates :issues_tracker_id, length: { maximum: 255 }, allow_blank: true
  validates :namespace, presence: true
  validates_uniqueness_of :name, scope: :namespace_id
  validates_uniqueness_of :path, scope: :namespace_id
  validates :import_url,
    url: { protocols: %w(ssh git http https) },
    if: :external_import?
  validates :star_count, numericality: { greater_than_or_equal_to: 0 }
  validate :check_limit, on: :create
  validate :avatar_type,
    if: ->(project) { project.avatar.present? && project.avatar_changed? }
  validates :avatar, file_size: { maximum: 200.kilobytes.to_i }
  validate :visibility_level_allowed_by_group
  validate :visibility_level_allowed_as_fork

  add_authentication_token_field :runners_token
  before_save :ensure_runners_token

  mount_uploader :avatar, AvatarUploader

  # Scopes
  default_scope { where(pending_delete: false) }

  scope :sorted_by_activity, -> { reorder(last_activity_at: :desc) }
  scope :sorted_by_stars, -> { reorder('projects.star_count DESC') }
  scope :sorted_by_names, -> { joins(:namespace).reorder('namespaces.name ASC, projects.name ASC') }

  scope :without_user, ->(user)  { where('projects.id NOT IN (:ids)', ids: user.authorized_projects.map(&:id) ) }
  scope :without_team, ->(team) { team.projects.present? ? where('projects.id NOT IN (:ids)', ids: team.projects.map(&:id)) : scoped  }
  scope :not_in_group, ->(group) { where('projects.id NOT IN (:ids)', ids: group.project_ids ) }
  scope :in_namespace, ->(namespace_ids) { where(namespace_id: namespace_ids) }
  scope :in_group_namespace, -> { joins(:group) }
  scope :personal, ->(user) { where(namespace_id: user.namespace_id) }
  scope :joined, ->(user) { where('namespace_id != ?', user.namespace_id) }
  scope :non_archived, -> { where(archived: false) }
  scope :for_milestones, ->(ids) { joins(:milestones).where('milestones.id' => ids).distinct }

  state_machine :import_status, initial: :none do
    event :import_start do
      transition [:none, :finished] => :started
    end

    event :import_finish do
      transition started: :finished
    end

    event :import_fail do
      transition started: :failed
    end

    event :import_retry do
      transition failed: :started
    end

    state :started
    state :finished
    state :failed

    after_transition any => :started, do: :schedule_add_import_job
    after_transition any => :finished, do: :clear_import_data
  end

  class << self
    def abandoned
      where('projects.last_activity_at < ?', 6.months.ago)
    end

    def with_push
      joins(:events).where('events.action = ?', Event::PUSHED)
    end

    def active
      joins(:issues, :notes, :merge_requests).order('issues.created_at, notes.created_at, merge_requests.created_at DESC')
    end

    # Searches for a list of projects based on the query given in `query`.
    #
    # On PostgreSQL this method uses "ILIKE" to perform a case-insensitive
    # search. On MySQL a regular "LIKE" is used as it's already
    # case-insensitive.
    #
    # query - The search query as a String.
    def search(query)
      ptable  = arel_table
      ntable  = Namespace.arel_table
      pattern = "%#{query}%"

      projects = select(:id).where(
        ptable[:path].matches(pattern).
          or(ptable[:name].matches(pattern)).
          or(ptable[:description].matches(pattern))
      )

      # We explicitly remove any eager loading clauses as they're:
      #
      # 1. Not needed by this query
      # 2. Combined with .joins(:namespace) lead to all columns from the
      #    projects & namespaces tables being selected, leading to a SQL error
      #    due to the columns of all UNION'd queries no longer being the same.
      namespaces = select(:id).
        except(:includes).
        joins(:namespace).
        where(ntable[:name].matches(pattern))

      union = Gitlab::SQL::Union.new([projects, namespaces])

      where("projects.id IN (#{union.to_sql})")
    end

    def search_by_visibility(level)
      where(visibility_level: Gitlab::VisibilityLevel.const_get(level.upcase))
    end

    def search_by_title(query)
      pattern = "%#{query}%"
      table   = Project.arel_table

      non_archived.where(table[:name].matches(pattern))
    end

    def find_with_namespace(id)
      namespace_path, project_path = id.split('/', 2)

      return nil if !namespace_path || !project_path

      # Use of unscoped ensures we're not secretly adding any ORDER BYs, which
      # have a negative impact on performance (and aren't needed for this
      # query).
      projects = unscoped.
        joins(:namespace).
        iwhere('namespaces.path' => namespace_path)

      projects.find_by('projects.path' => project_path) ||
        projects.iwhere('projects.path' => project_path).take
    end

    def find_by_ci_id(id)
      find_by(ci_id: id.to_i)
    end

    def visibility_levels
      Gitlab::VisibilityLevel.options
    end

    def sort(method)
      if method == 'repository_size_desc'
        reorder(repository_size: :desc, id: :desc)
      else
        order_by(method)
      end
    end

    def reference_pattern
      name_pattern = Gitlab::Regex::NAMESPACE_REGEX_STR
      %r{(?<project>#{name_pattern}/#{name_pattern})}
    end

    def trending(since = 1.month.ago)
      # By counting in the JOIN we don't expose the GROUP BY to the outer query.
      # This means that calls such as "any?" and "count" just return a number of
      # the total count, instead of the counts grouped per project as a Hash.
      join_body = "INNER JOIN (
        SELECT project_id, COUNT(*) AS amount
        FROM notes
        WHERE created_at >= #{sanitize(since)}
        GROUP BY project_id
      ) join_note_counts ON projects.id = join_note_counts.project_id"

      joins(join_body).reorder('join_note_counts.amount DESC')
    end

    def visible_to_user(user)
      where(id: user.authorized_projects.select(:id).reorder(nil))
    end
  end

  def team
    @team ||= ProjectTeam.new(self)
  end

  def repository
    @repository ||= Repository.new(path_with_namespace, self)
  end

  def container_registry_url
    if container_registry_enabled? && Gitlab.config.registry.enabled
      "#{Gitlab.config.registry.host_with_port}/#{path_with_namespace}"
    end
  end

  def commit(id = 'HEAD')
    repository.commit(id)
  end

  def merge_base_commit(first_commit_id, second_commit_id)
    sha = repository.merge_base(first_commit_id, second_commit_id)
    repository.commit(sha) if sha
  end

  def saved?
    id && persisted?
  end

  def schedule_add_import_job
    run_after_commit(:add_import_job)
  end

  def add_import_job
    if forked?
      job_id = RepositoryForkWorker.perform_async(self.id, forked_from_project.path_with_namespace, self.namespace.path)
    else
      job_id = RepositoryImportWorker.perform_async(self.id)
    end

    if job_id
      Rails.logger.info "Import job started for #{path_with_namespace} with job ID #{job_id}"
    else
      Rails.logger.error "Import job failed to start for #{path_with_namespace}"
    end
  end

  def clear_import_data
    update(import_error: nil)

    ProjectCacheWorker.perform_async(self.id)

    self.import_data.destroy if self.import_data
  end

  def import_url=(value)
    import_url = Gitlab::ImportUrl.new(value)
    create_or_update_import_data(credentials: import_url.credentials)
    super(import_url.sanitized_url)
  end

  def import_url
    if import_data && super
      import_url = Gitlab::ImportUrl.new(super, credentials: import_data.credentials)
      import_url.full_url
    else
      super
    end
  end

  def create_or_update_import_data(data: nil, credentials: nil)
    project_import_data = import_data || build_import_data
    if data
      project_import_data.data ||= {}
      project_import_data.data = project_import_data.data.merge(data)
    end
    if credentials
      project_import_data.credentials ||= {}
      project_import_data.credentials = project_import_data.credentials.merge(credentials)
    end

    project_import_data.save
  end

  def import?
    external_import? || forked?
  end

  def no_import?
    import_status == 'none'
  end

  def external_import?
    import_url.present?
  end

  def imported?
    import_finished?
  end

  def import_in_progress?
    import? && import_status == 'started'
  end

  def import_failed?
    import_status == 'failed'
  end

  def import_finished?
    import_status == 'finished'
  end

  def safe_import_url
    result = URI.parse(self.import_url)
    result.password = '*****' unless result.password.nil?
    result.user = '*****' unless result.user.nil? || result.user == "git" #tokens or other data may be saved as user
    result.to_s
  rescue
    self.import_url
  end

  def check_limit
    unless creator.can_create_project? or namespace.kind == 'group'
      self.errors.add(:limit_reached, "Your project limit is #{creator.projects_limit} projects! Please contact your administrator to increase it")
    end
  rescue
    self.errors.add(:base, "Can't check your ability to create project")
  end

  def visibility_level_allowed_by_group
    return if visibility_level_allowed_by_group?

    level_name = Gitlab::VisibilityLevel.level_name(self.visibility_level).downcase
    group_level_name = Gitlab::VisibilityLevel.level_name(self.group.visibility_level).downcase
    self.errors.add(:visibility_level, "#{level_name} is not allowed in a #{group_level_name} group.")
  end

  def visibility_level_allowed_as_fork
    return if visibility_level_allowed_as_fork?

    level_name = Gitlab::VisibilityLevel.level_name(self.visibility_level).downcase
    self.errors.add(:visibility_level, "#{level_name} is not allowed since the fork source project has lower visibility.")
  end

  def to_param
    path
  end

  def to_reference(_from_project = nil)
    path_with_namespace
  end

  def web_url
    Gitlab::Routing.url_helpers.namespace_project_url(self.namespace, self)
  end

  def web_url_without_protocol
    web_url.split('://')[1]
  end

  def build_commit_note(commit)
    notes.new(commit_id: commit.id, noteable_type: 'Commit')
  end

  def last_activity
    last_event
  end

  def last_activity_date
    last_activity_at || updated_at
  end

  def project_id
    self.id
  end

  def get_issue(issue_id)
    if default_issues_tracker?
      issues.find_by(iid: issue_id)
    else
      ExternalIssue.new(issue_id, self)
    end
  end

  def issue_exists?(issue_id)
    get_issue(issue_id)
  end

  def default_issue_tracker
    gitlab_issue_tracker_service || create_gitlab_issue_tracker_service
  end

  def issues_tracker
    if external_issue_tracker
      external_issue_tracker
    else
      default_issue_tracker
    end
  end

  def default_issues_tracker?
    !external_issue_tracker
  end

  def external_issue_tracker
    return @external_issue_tracker if defined?(@external_issue_tracker)
    @external_issue_tracker ||=
      services.issue_trackers.active.without_defaults.first
  end

  def can_have_issues_tracker_id?
    self.issues_enabled && !self.default_issues_tracker?
  end

  def build_missing_services
    services_templates = Service.where(template: true)

    Service.available_services_names.each do |service_name|
      service = find_service(services, service_name)

      # If service is available but missing in db
      if service.nil?
        # We should check if template for the service exists
        template = find_service(services_templates, service_name)

        if template.nil?
          # If no template, we should create an instance. Ex `create_gitlab_ci_service`
          self.send :"create_#{service_name}_service"
        else
          Service.create_from_template(self.id, template)
        end
      end
    end
  end

  def create_labels
    Label.templates.each do |label|
      label = label.dup
      label.template = nil
      label.project_id = self.id
      label.save
    end
  end

  def find_service(list, name)
    list.find { |service| service.to_param == name }
  end

  def ci_services
    services.where(category: :ci)
  end

  def ci_service
    @ci_service ||= ci_services.reorder(nil).find_by(active: true)
  end

  def jira_tracker?
    issues_tracker.to_param == 'jira'
  end

  def avatar_type
    unless self.avatar.image?
      self.errors.add :avatar, 'only images allowed'
    end
  end

  def avatar_in_git
    repository.avatar
  end

  def avatar_url
    if avatar.present?
      [gitlab_config.url, avatar.url].join
    elsif avatar_in_git
      Gitlab::Routing.url_helpers.namespace_project_avatar_url(namespace, self)
    end
  end

  # For compatibility with old code
  def code
    path
  end

  def items_for(entity)
    case entity
    when 'issue' then
      issues
    when 'merge_request' then
      merge_requests
    end
  end

  def send_move_instructions(old_path_with_namespace)
    # New project path needs to be committed to the DB or notification will
    # retrieve stale information
    run_after_commit { NotificationService.new.project_was_moved(self, old_path_with_namespace) }
  end

  def owner
    if group
      group
    else
      namespace.try(:owner)
    end
  end

  def project_member_by_name_or_email(name = nil, email = nil)
    user = users.find_by('name like ? or email like ?', name, email)
    project_members.where(user: user) if user
  end

  # Get Team Member record by user id
  def project_member_by_id(user_id)
    project_members.find_by(user_id: user_id)
  end

  def name_with_namespace
    @name_with_namespace ||= begin
                               if namespace
                                 namespace.human_name + ' / ' + name
                               else
                                 name
                               end
                             end
  end

  def path_with_namespace
    if namespace
      namespace.path + '/' + path
    else
      path
    end
  end

  def execute_hooks(data, hooks_scope = :push_hooks)
    hooks.send(hooks_scope).each do |hook|
      hook.async_execute(data, hooks_scope.to_s)
    end
  end

  def execute_services(data, hooks_scope = :push_hooks)
    # Call only service hooks that are active for this scope
    services.send(hooks_scope).each do |service|
      service.async_execute(data)
    end
  end

  def update_merge_requests(oldrev, newrev, ref, user)
    MergeRequests::RefreshService.new(self, user).
      execute(oldrev, newrev, ref)
  end

  def valid_repo?
    repository.exists?
  rescue
    errors.add(:path, 'Invalid repository path')
    false
  end

  def empty_repo?
    !repository.exists? || !repository.has_visible_content?
  end

  def repo
    repository.raw
  end

  def url_to_repo
    gitlab_shell.url_to_repo(path_with_namespace)
  end

  def namespace_dir
    namespace.try(:path) || ''
  end

  def repo_exists?
    @repo_exists ||= repository.exists?
  rescue
    @repo_exists = false
  end

  def open_branches
    # We're using a Set here as checking values in a large Set is faster than
    # checking values in a large Array.
    protected_set = Set.new(protected_branch_names)

    repository.branches.reject do |branch|
      protected_set.include?(branch.name)
    end
  end

  def protected_branch_names
    @protected_branch_names ||= protected_branches.pluck(:name)
  end

  def root_ref?(branch)
    repository.root_ref == branch
  end

  def ssh_url_to_repo
    url_to_repo
  end

  def http_url_to_repo
    "#{web_url}.git"
  end

  # Check if current branch name is marked as protected in the system
  def protected_branch?(branch_name)
    protected_branch_names.include?(branch_name)
  end

  def developers_can_push_to_protected_branch?(branch_name)
    protected_branches.any? { |pb| pb.name == branch_name && pb.developers_can_push }
  end

  def forked?
    !(forked_project_link.nil? || forked_project_link.forked_from_project.nil?)
  end

  def personal?
    !group
  end

  def rename_repo
    path_was = previous_changes['path'].first
    old_path_with_namespace = File.join(namespace_dir, path_was)
    new_path_with_namespace = File.join(namespace_dir, path)

    expire_caches_before_rename(old_path_with_namespace)

    if gitlab_shell.mv_repository(old_path_with_namespace, new_path_with_namespace)
      # If repository moved successfully we need to send update instructions to users.
      # However we cannot allow rollback since we moved repository
      # So we basically we mute exceptions in next actions
      begin
        gitlab_shell.mv_repository("#{old_path_with_namespace}.wiki", "#{new_path_with_namespace}.wiki")
        send_move_instructions(old_path_with_namespace)
        reset_events_cache

        @old_path_with_namespace = old_path_with_namespace

        SystemHooksService.new.execute_hooks_for(self, :rename)

        @repository = nil
      rescue
        # Returning false does not rollback after_* transaction but gives
        # us information about failing some of tasks
        false
      end
    else
      # if we cannot move namespace directory we should rollback
      # db changes in order to prevent out of sync between db and fs
      raise Exception.new('repository cannot be renamed')
    end

    Gitlab::UploadsTransfer.new.rename_project(path_was, path, namespace.path)
  end

  # Expires various caches before a project is renamed.
  def expire_caches_before_rename(old_path)
    repo = Repository.new(old_path, self)
    wiki = Repository.new("#{old_path}.wiki", self)

    if repo.exists?
      repo.before_delete
    end

    if wiki.exists?
      wiki.before_delete
    end
  end

  def hook_attrs(backward: true)
    attrs = {
      name: name,
      description: description,
      web_url: web_url,
      avatar_url: avatar_url,
      git_ssh_url: ssh_url_to_repo,
      git_http_url: http_url_to_repo,
      namespace: namespace.name,
      visibility_level: visibility_level,
      path_with_namespace: path_with_namespace,
      default_branch: default_branch,
    }

    # Backward compatibility
    if backward
      attrs.merge!({
                    homepage: web_url,
                    url: url_to_repo,
                    ssh_url: ssh_url_to_repo,
                    http_url: http_url_to_repo
                  })
    end

    attrs
  end

  # Reset events cache related to this project
  #
  # Since we do cache @event we need to reset cache in special cases:
  # * when project was moved
  # * when project was renamed
  # * when the project avatar changes
  # Events cache stored like  events/23-20130109142513.
  # The cache key includes updated_at timestamp.
  # Thus it will automatically generate a new fragment
  # when the event is updated because the key changes.
  def reset_events_cache
    Event.where(project_id: self.id).
      order('id DESC').limit(100).
      update_all(updated_at: Time.now)
  end

  def project_member(user)
    project_members.find_by(user_id: user)
  end

  def default_branch
    @default_branch ||= repository.root_ref if repository.exists?
  end

  def reload_default_branch
    @default_branch = nil
    default_branch
  end

  def visibility_level_field
    visibility_level
  end

  def archive!
    update_attribute(:archived, true)
  end

  def unarchive!
    update_attribute(:archived, false)
  end

  def change_head(branch)
    repository.before_change_head
    repository.rugged.references.create('HEAD',
                                        "refs/heads/#{branch}",
                                        force: true)
    repository.copy_gitattributes(branch)
    reload_default_branch
  end

  def forked_from?(project)
    forked? && project == forked_from_project
  end

  def update_repository_size
    update_attribute(:repository_size, repository.size)
  end

  def update_commit_count
    update_attribute(:commit_count, repository.commit_count)
  end

  def forks_count
    forks.count
  end

  def find_label(name)
    labels.find_by(name: name)
  end

  def origin_merge_requests
    merge_requests.where(source_project_id: self.id)
  end

  def create_repository
    # Forked import is handled asynchronously
    unless forked?
      if gitlab_shell.add_repository(path_with_namespace)
        repository.after_create
        true
      else
        errors.add(:base, 'Failed to create repository via gitlab-shell')
        false
      end
    end
  end

  def repository_exists?
    !!repository.exists?
  end

  def create_wiki
    ProjectWiki.new(self, self.owner).wiki
    true
  rescue ProjectWiki::CouldNotCreateWikiError
    errors.add(:base, 'Failed create wiki')
    false
  end

  def jira_tracker_active?
    jira_tracker? && jira_service.active
  end

  def allowed_to_share_with_group?
    !namespace.share_with_group_lock
  end

  def ci_commit(sha, ref)
    ci_commits.order(id: :desc).find_by(sha: sha, ref: ref)
  end

  def ensure_ci_commit(sha, ref)
    ci_commit(sha, ref) || ci_commits.create(sha: sha, ref: ref)
  end

  def enable_ci
    self.builds_enabled = true
  end

  def any_runners?(&block)
    if runners.active.any?(&block)
      return true
    end

    shared_runners_enabled? && Ci::Runner.shared.active.any?(&block)
  end

  def valid_runners_token? token
    self.runners_token && ActiveSupport::SecurityUtils.variable_size_secure_compare(token, self.runners_token)
  end

  # TODO (ayufan): For now we use runners_token (backward compatibility)
  # In 8.4 every build will have its own individual token valid for time of build
  def valid_build_token? token
    self.builds_enabled? && self.runners_token && ActiveSupport::SecurityUtils.variable_size_secure_compare(token, self.runners_token)
  end

  def build_coverage_enabled?
    build_coverage_regex.present?
  end

  def build_timeout_in_minutes
    build_timeout / 60
  end

  def build_timeout_in_minutes=(value)
    self.build_timeout = value.to_i * 60
  end

  def open_issues_count
    issues.opened.count
  end

  def visibility_level_allowed_as_fork?(level = self.visibility_level)
    return true unless forked?

    # self.forked_from_project will be nil before the project is saved, so
    # we need to go through the relation
    original_project = forked_project_link.forked_from_project
    return true unless original_project

    level <= original_project.visibility_level
  end

  def visibility_level_allowed_by_group?(level = self.visibility_level)
    return true unless group

    level <= group.visibility_level
  end

  def visibility_level_allowed?(level = self.visibility_level)
    visibility_level_allowed_as_fork?(level) && visibility_level_allowed_by_group?(level)
  end

  def runners_token
    ensure_runners_token!
  end

  def wiki
    @wiki ||= ProjectWiki.new(self, self.owner)
  end

  def schedule_delete!(user_id, params)
    # Queue this task for after the commit, so once we mark pending_delete it will run
    run_after_commit { ProjectDestroyWorker.perform_async(id, user_id, params) }

    update_attribute(:pending_delete, true)
  end
end
