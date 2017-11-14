class MergeRequest < ActiveRecord::Base
  include InternalId
  include Issuable
  include Referable
  include Sortable
  include Taskable

  belongs_to :target_project, foreign_key: :target_project_id, class_name: "Project"
  belongs_to :source_project, foreign_key: :source_project_id, class_name: "Project"
  belongs_to :merge_user, class_name: "User"

  has_one :merge_request_diff, dependent: :destroy

  serialize :merge_params, Hash

  after_create :create_merge_request_diff
  after_update :update_merge_request_diff

  delegate :commits, :diffs, :real_size, to: :merge_request_diff, prefix: nil

  # When this attribute is true some MR validation is ignored
  # It allows us to close or modify broken merge requests
  attr_accessor :allow_broken

  # Temporary fields to store compare vars
  # when creating new merge request
  attr_accessor :can_be_created, :compare_commits, :compare

  # Temporary fields to store target_sha, and base_sha to
  # compare when importing pull requests from GitHub
  attr_accessor :base_target_sha, :head_source_sha

  state_machine :state, initial: :opened do
    event :close do
      transition [:reopened, :opened] => :closed
    end

    event :mark_as_merged do
      transition [:reopened, :opened, :locked] => :merged
    end

    event :reopen do
      transition closed: :reopened
    end

    event :lock_mr do
      transition [:reopened, :opened] => :locked
    end

    event :unlock_mr do
      transition locked: :reopened
    end

    after_transition any => :locked do |merge_request, transition|
      merge_request.locked_at = Time.now
      merge_request.save
    end

    after_transition locked: (any - :locked) do |merge_request, transition|
      merge_request.locked_at = nil
      merge_request.save
    end

    state :opened
    state :reopened
    state :closed
    state :merged
    state :locked
  end

  state_machine :merge_status, initial: :unchecked do
    event :mark_as_unchecked do
      transition [:can_be_merged, :cannot_be_merged] => :unchecked
    end

    event :mark_as_mergeable do
      transition [:unchecked, :cannot_be_merged] => :can_be_merged
    end

    event :mark_as_unmergeable do
      transition [:unchecked, :can_be_merged] => :cannot_be_merged
    end

    state :unchecked
    state :can_be_merged
    state :cannot_be_merged

    around_transition do |merge_request, transition, block|
      merge_request.record_timestamps = false
      begin
        block.call
      ensure
        merge_request.record_timestamps = true
      end
    end
  end

  validates :source_project, presence: true, unless: :allow_broken
  validates :source_branch, presence: true
  validates :target_project, presence: true
  validates :target_branch, presence: true
  validates :merge_user, presence: true, if: :merge_when_build_succeeds?
  validate :validate_branches, unless: :allow_broken
  validate :validate_fork

  scope :by_branch, ->(branch_name) { where("(source_branch LIKE :branch) OR (target_branch LIKE :branch)", branch: branch_name) }
  scope :cared, ->(user) { where('assignee_id = :user OR author_id = :user', user: user.id) }
  scope :by_milestone, ->(milestone) { where(milestone_id: milestone) }
  scope :of_projects, ->(ids) { where(target_project_id: ids) }
  scope :from_project, ->(project) { where(source_project_id: project.id) }
  scope :merged, -> { with_state(:merged) }
  scope :closed_and_merged, -> { with_states(:closed, :merged) }

  scope :join_project, -> { joins(:target_project) }
  scope :references_project, -> { references(:target_project) }

  def self.by_branch
where("(source_branch LIKE :branch) OR (target_branch LIKE :branch)", branch: branch_name)
end

def self.cared
where('assignee_id = :user OR author_id = :user', user: user.id)
end

def self.by_milestone
where(milestone_id: milestone)
end

def self.of_projects
where(target_project_id: ids)
end

def self.from_project
where(source_project_id: project.id)
end

def self.merged
with_state(:merged)
end

def self.closed_and_merged
with_states(:closed, :merged)
end

def self.join_project
joins(:target_project)
end

def self.references_project
references(:target_project)
end

def self.by_branch
where("(source_branch LIKE :branch) OR (target_branch LIKE :branch)", branch: branch_name)
end

def self.cared
where('assignee_id = :user OR author_id = :user', user: user.id)
end

def self.by_milestone
where(milestone_id: milestone)
end

def self.of_projects
where(target_project_id: ids)
end

def self.from_project
where(source_project_id: project.id)
end

def self.merged
with_state(:merged)
end

def self.closed_and_merged
with_states(:closed, :merged)
end

def self.join_project
joins(:target_project)
end

def self.references_project
references(:target_project)
end

def self.reference_prefix
    '!'
  end

  # Pattern used to extract `!123` merge request references from text
  #
  # This pattern supports cross-project references.
  def self.reference_pattern
    @reference_pattern ||= %r{
      (#{Project.reference_pattern})?
      #{Regexp.escape(reference_prefix)}(?<merge_request>\d+)
    }x
  end

  def self.link_reference_pattern
    @link_reference_pattern ||= super("merge_requests", /(?<merge_request>\d+)/)
  end

  # Returns all the merge requests from an ActiveRecord:Relation.
  #
  # This method uses a UNION as it usually operates on the result of
  # ProjectsFinder#execute. PostgreSQL in particular doesn't always like queries
  # using multiple sub-queries especially when combined with an OR statement.
  # UNIONs on the other hand perform much better in these cases.
  #
  # relation - An ActiveRecord::Relation that returns a list of Projects.
  #
  # Returns an ActiveRecord::Relation.
  def self.in_projects(relation)
    source = where(source_project_id: relation).select(:id)
    target = where(target_project_id: relation).select(:id)
    union  = Gitlab::SQL::Union.new([source, target])

    where("merge_requests.id IN (#{union.to_sql})")
  end

  def to_reference(from_project = nil)
    reference = "#{self.class.reference_prefix}#{iid}"

    if cross_project_reference?(from_project)
      reference = project.to_reference + reference
    end

    reference
  end

  def last_commit
    merge_request_diff ? merge_request_diff.last_commit : compare_commits.last
  end

  def first_commit
    merge_request_diff ? merge_request_diff.first_commit : compare_commits.first
  end

  def diff_size
    merge_request_diff.size
  end

  def diff_base_commit
    if merge_request_diff
      merge_request_diff.base_commit
    elsif source_sha
      self.target_project.merge_base_commit(self.source_sha, self.target_branch)
    end
  end

  def last_commit_short_sha
    last_commit.short_id
  end

  def validate_branches
    if target_project == source_project && target_branch == source_branch
      errors.add :branch_conflict, "You can not use same project/branch for source and target"
    end

    if opened? || reopened?
      similar_mrs = self.target_project.merge_requests.where(source_branch: source_branch, target_branch: target_branch, source_project_id: source_project.try(:id)).opened
      similar_mrs = similar_mrs.where('id not in (?)', self.id) if self.id
      if similar_mrs.any?
        errors.add :validate_branches,
                   "Cannot Create: This merge request already exists: #{similar_mrs.pluck(:title)}"
      end
    end
  end

  def validate_fork
    return true unless target_project && source_project

    if target_project == source_project
      true
    else
      # If source and target projects are different
      # we should check if source project is actually a fork of target project
      if source_project.forked_from?(target_project)
        true
      else
        errors.add :validate_fork,
                   'Source project is not a fork of target project'
      end
    end
  end

  def update_merge_request_diff
    if source_branch_changed? || target_branch_changed?
      reload_code
    end
  end

  def reload_code
    if merge_request_diff && open?
      merge_request_diff.reload_content
    end
  end

  def check_if_can_be_merged
    return unless unchecked?

    can_be_merged =
      !broken? && project.repository.can_be_merged?(source_sha, target_branch)

    if can_be_merged
      mark_as_mergeable
    else
      mark_as_unmergeable
    end
  end

  def merge_event
    self.target_project.events.where(target_id: self.id, target_type: "MergeRequest", action: Event::MERGED).last
  end

  def closed_event
    self.target_project.events.where(target_id: self.id, target_type: "MergeRequest", action: Event::CLOSED).last
  end

  WIP_REGEX = /\A\s*(\[WIP\]\s*|WIP:\s*|WIP\s+)+\s*/i.freeze

  def work_in_progress?
    !!(title =~ WIP_REGEX)
  end

  def wipless_title
    self.title.sub(WIP_REGEX, "")
  end

  def mergeable?
    return false unless open? && !work_in_progress? && !broken?

    check_if_can_be_merged

    can_be_merged?
  end

  def gitlab_merge_status
    if work_in_progress?
      "work_in_progress"
    else
      merge_status_name
    end
  end

  def can_cancel_merge_when_build_succeeds?(current_user)
    can_be_merged_by?(current_user) || self.author == current_user
  end

  def can_remove_source_branch?(current_user)
    !source_project.protected_branch?(source_branch) &&
      !source_project.root_ref?(source_branch) &&
      Ability.abilities.allowed?(current_user, :push_code, source_project) &&
      last_commit == source_project.commit(source_branch)
  end

  def mr_and_commit_notes
    # Fetch comments only from last 100 commits
    commits_for_notes_limit = 100
    commit_ids = commits.last(commits_for_notes_limit).map(&:id)

    Note.where(
      "(project_id = :target_project_id AND noteable_type = 'MergeRequest' AND noteable_id = :mr_id) OR" +
      "((project_id = :source_project_id OR project_id = :target_project_id) AND noteable_type = 'Commit' AND commit_id IN (:commit_ids))",
      mr_id: id,
      commit_ids: commit_ids,
      target_project_id: target_project_id,
      source_project_id: source_project_id
    )
  end

  # Returns the raw diff for this merge request
  #
  # see "git diff"
  def to_diff
    target_project.repository.diff_text(diff_base_commit.sha, source_sha)
  end

  # Returns the commit as a series of email patches.
  #
  # see "git format-patch"
  def to_patch
    target_project.repository.format_patch(diff_base_commit.sha, source_sha)
  end

  def hook_attrs
    attrs = {
      source: source_project.try(:hook_attrs),
      target: target_project.hook_attrs,
      last_commit: nil,
      work_in_progress: work_in_progress?
    }

    if last_commit
      attrs.merge!(last_commit: last_commit.hook_attrs)
    end

    attributes.merge!(attrs)
  end

  def for_fork?
    target_project != source_project
  end

  def project
    target_project
  end

  def closes_issue?(issue)
    closes_issues.include?(issue)
  end

  # Return the set of issues that will be closed if this merge request is accepted.
  def closes_issues(current_user = self.author)
    if target_branch == project.default_branch
      messages = commits.map(&:safe_message) << description

      Gitlab::ClosingIssueExtractor.new(project, current_user).
        closed_by_message(messages.join("\n"))
    else
      []
    end
  end

  def target_project_path
    if target_project
      target_project.path_with_namespace
    else
      "(removed)"
    end
  end

  def source_project_path
    if source_project
      source_project.path_with_namespace
    else
      "(removed)"
    end
  end

  def source_project_namespace
    if source_project && source_project.namespace
      source_project.namespace.path
    else
      "(removed)"
    end
  end

  def target_project_namespace
    if target_project && target_project.namespace
      target_project.namespace.path
    else
      "(removed)"
    end
  end

  def source_branch_exists?
    return false unless self.source_project

    self.source_project.repository.branch_names.include?(self.source_branch)
  end

  def target_branch_exists?
    return false unless self.target_project

    self.target_project.repository.branch_names.include?(self.target_branch)
  end

  # Reset merge request events cache
  #
  # Since we do cache @event we need to reset cache in special cases:
  # * when a merge request is updated
  # Events cache stored like  events/23-20130109142513.
  # The cache key includes updated_at timestamp.
  # Thus it will automatically generate a new fragment
  # when the event is updated because the key changes.
  def reset_events_cache
    Event.reset_event_cache_for(self)
  end

  def merge_commit_message
    message = "Merge branch '#{source_branch}' into '#{target_branch}'"
    message << "\n\n"
    message << title.to_s
    message << "\n\n"
    message << description.to_s
    message << "\n\n"
    message << "See merge request !#{iid}"
    message
  end

  def reset_merge_when_build_succeeds
    return unless merge_when_build_succeeds?

    self.merge_when_build_succeeds = false
    self.merge_user = nil
    self.merge_params = nil

    self.save
  end

  # Return array of possible target branches
  # depends on target project of MR
  def target_branches
    if target_project.nil?
      []
    else
      target_project.repository.branch_names
    end
  end

  # Return array of possible source branches
  # depends on source project of MR
  def source_branches
    if source_project.nil?
      []
    else
      source_project.repository.branch_names
    end
  end

  def locked_long_ago?
    return false unless locked?

    locked_at.nil? || locked_at < (Time.now - 1.day)
  end

  def has_ci?
    source_project.ci_service && commits.any?
  end

  def branch_missing?
    !source_branch_exists? || !target_branch_exists?
  end

  def broken?
    self.commits.blank? || branch_missing? || cannot_be_merged?
  end

  def can_be_merged_by?(user)
    ::Gitlab::GitAccess.new(user, project).can_push_to_branch?(target_branch)
  end

  def state_human_name
    if merged?
      "Merged"
    elsif closed?
      "Closed"
    else
      "Open"
    end
  end

  def state_icon_name
    if merged?
      "check"
    elsif closed?
      "times"
    else
      "circle-o"
    end
  end

  def target_sha
    return @base_target_sha if defined?(@base_target_sha)

    target_project.repository.commit(target_branch).try(:sha)
  end

  def source_sha
    return @head_source_sha if defined?(@head_source_sha)

    last_commit.try(:sha) || source_tip.try(:sha)
  end

  def source_tip
    source_branch && source_project.repository.commit(source_branch)
  end

  def fetch_ref
    target_project.repository.fetch_ref(
      source_project.repository.path_to_repo,
      "refs/heads/#{source_branch}",
      ref_path
    )
  end

  def ref_path
    "refs/merge-requests/#{iid}/head"
  end

  def ref_is_fetched?
    File.exist?(File.join(project.repository.path_to_repo, ref_path))
  end

  def ensure_ref_fetched
    fetch_ref unless ref_is_fetched?
  end

  def in_locked_state
    begin
      lock_mr
      yield
    ensure
      unlock_mr if locked?
    end
  end

  def diverged_commits_count
    cache = Rails.cache.read(:"merge_request_#{id}_diverged_commits")

    if cache.blank? || cache[:source_sha] != source_sha || cache[:target_sha] != target_sha
      cache = {
        source_sha: source_sha,
        target_sha: target_sha,
        diverged_commits_count: compute_diverged_commits_count
      }
      Rails.cache.write(:"merge_request_#{id}_diverged_commits", cache)
    end

    cache[:diverged_commits_count]
  end

  def compute_diverged_commits_count
    return 0 unless source_sha && target_sha

    Gitlab::Git::Commit.between(target_project.repository.raw_repository, source_sha, target_sha).size
  end
  private :compute_diverged_commits_count

  def diverged_from_target_branch?
    diverged_commits_count > 0
  end

  def ci_commit
    @ci_commit ||= source_project.ci_commit(last_commit.id, source_branch) if last_commit && source_project
  end

  def diff_refs
    return nil unless diff_base_commit

    [diff_base_commit, last_commit]
  end

  def merge_commit
    @merge_commit ||= project.commit(merge_commit_sha) if merge_commit_sha
  end

  def can_be_reverted?(current_user = nil)
    merge_commit && !merge_commit.has_been_reverted?(current_user, self)
  end

  def can_be_cherry_picked?
    merge_commit
  end
end
