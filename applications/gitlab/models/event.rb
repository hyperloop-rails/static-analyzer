class Event < ActiveRecord::Base
  include Sortable
  default_scope { where.not(author_id: nil) }

  CREATED   = 1
  UPDATED   = 2
  CLOSED    = 3
  REOPENED  = 4
  PUSHED    = 5
  COMMENTED = 6
  MERGED    = 7
  JOINED    = 8 # User joined project
  LEFT      = 9 # User left project
  DESTROYED = 10

  delegate :name, :email, to: :author, prefix: true, allow_nil: true
  delegate :title, to: :issue, prefix: true, allow_nil: true
  delegate :title, to: :merge_request, prefix: true, allow_nil: true
  delegate :title, to: :note, prefix: true, allow_nil: true

  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :target, polymorphic: true

  # For Hash only
  serialize :data

  # Callbacks
  after_create :reset_project_activity

  # Scopes
  scope :recent, -> { reorder(id: :desc) }
  scope :code_push, -> { where(action: PUSHED) }

  scope :in_projects, ->(projects) do
    where(project_id: projects.map(&:id)).recent
  end

  scope :with_associations, -> { includes(project: :namespace) }
  scope :for_milestone_id, ->(milestone_id) { where(target_type: "Milestone", target_id: milestone_id) }

  class << self
    def self.recent
reorder(id: :desc)
end

def self.code_push
where(action: PUSHED)
end

def self.in_projects
where(project_id: projects.map(&:id)).recent
end

def self.with_associations
includes(project: :namespace)
end

def self.for_milestone_id
where(target_type: "Milestone", target_id: milestone_id)
end

def self.recent
reorder(id: :desc)
end

def self.code_push
where(action: PUSHED)
end

def self.in_projects
where(project_id: projects.map(&:id)).recent
end

def self.with_associations
includes(project: :namespace)
end

def self.for_milestone_id
where(target_type: "Milestone", target_id: milestone_id)
end

def reset_event_cache_for(target)
      Event.where(target_id: target.id, target_type: target.class.to_s).
        order('id DESC').limit(100).
        update_all(updated_at: Time.now)
    end

    def contributions
      where("action = ? OR (target_type in (?) AND action in (?))",
            Event::PUSHED, ["MergeRequest", "Issue"],
            [Event::CREATED, Event::CLOSED, Event::MERGED])
    end

    def limit_recent(limit = 20, offset = nil)
      recent.limit(limit).offset(offset)
    end
  end

  def visible_to_user?(user = nil)
    if push?
      true
    elsif membership_changed?
      true
    elsif created_project?
      true
    elsif issue? || issue_note?
      Ability.abilities.allowed?(user, :read_issue, note? ? note_target : target)
    else
      ((merge_request? || note?) && target) || milestone?
    end
  end

  def project_name
    if project
      project.name_with_namespace
    else
      "(deleted project)"
    end
  end

  def target_title
    target.try(:title)
  end

  def created?
    action == CREATED
  end

  def push?
    action == PUSHED && valid_push?
  end

  def merged?
    action == MERGED
  end

  def closed?
    action == CLOSED
  end

  def reopened?
    action == REOPENED
  end

  def joined?
    action == JOINED
  end

  def left?
    action == LEFT
  end

  def destroyed?
    action == DESTROYED
  end

  def commented?
    action == COMMENTED
  end

  def membership_changed?
    joined? || left?
  end

  def created_project?
    created? && !target && target_type.nil?
  end

  def created_target?
    created? && target
  end

  def milestone?
    target_type == "Milestone"
  end

  def note?
    target_type == "Note"
  end

  def issue?
    target_type == "Issue"
  end

  def merge_request?
    target_type == "MergeRequest"
  end

  def milestone
    target if milestone?
  end

  def issue
    target if issue?
  end

  def merge_request
    target if merge_request?
  end

  def note
    target if note?
  end

  def action_name
    if push?
      if new_ref?
        "pushed new"
      elsif rm_ref?
        "deleted"
      else
        "pushed to"
      end
    elsif closed?
      "closed"
    elsif merged?
      "accepted"
    elsif joined?
      'joined'
    elsif left?
      'left'
    elsif destroyed?
      'destroyed'
    elsif commented?
      "commented on"
    elsif created_project?
      if project.external_import?
        "imported"
      else
        "created"
      end
    else
      "opened"
    end
  end

  def valid_push?
    data[:ref] && ref_name.present?
  rescue
    false
  end

  def tag?
    Gitlab::Git.tag_ref?(data[:ref])
  end

  def branch?
    Gitlab::Git.branch_ref?(data[:ref])
  end

  def new_ref?
    Gitlab::Git.blank_ref?(commit_from)
  end

  def rm_ref?
    Gitlab::Git.blank_ref?(commit_to)
  end

  def md_ref?
    !(rm_ref? || new_ref?)
  end

  def commit_from
    data[:before]
  end

  def commit_to
    data[:after]
  end

  def ref_name
    if tag?
      tag_name
    else
      branch_name
    end
  end

  def branch_name
    @branch_name ||= Gitlab::Git.ref_name(data[:ref])
  end

  def tag_name
    @tag_name ||= Gitlab::Git.ref_name(data[:ref])
  end

  # Max 20 commits from push DESC
  def commits
    @commits ||= (data[:commits] || []).reverse
  end

  def commits_count
    data[:total_commits_count] || commits.count || 0
  end

  def ref_type
    tag? ? "tag" : "branch"
  end

  def push_with_commits?
    !commits.empty? && commit_from && commit_to
  end

  def last_push_to_non_root?
    branch? && project.default_branch != branch_name
  end

  def target_iid
    target.respond_to?(:iid) ? target.iid : target_id
  end

  def commit_note?
    target.for_commit?
  end

  def issue_note?
    note? && target && target.for_issue?
  end

  def project_snippet_note?
    target.for_snippet?
  end

  def note_target
    target.noteable
  end

  def note_target_id
    if commit_note?
      target.commit_id
    else
      target.noteable_id.to_s
    end
  end

  def note_target_reference
    return unless note_target

    # Commit#to_reference returns the full SHA, but we want the short one here
    if commit_note?
      note_target.short_id
    else
      note_target.to_reference
    end
  end

  def note_target_type
    if target.noteable_type.present?
      target.noteable_type.titleize
    else
      "Wall"
    end.downcase
  end

  def body?
    if push?
      push_with_commits?
    elsif note?
      true
    else
      target.respond_to? :title
    end
  end

  def reset_project_activity
    if project && Gitlab::ExclusiveLease.new("project:update_last_activity_at:#{project.id}", timeout: 60).try_obtain
      project.update_column(:last_activity_at, self.created_at)
    end
  end
end
