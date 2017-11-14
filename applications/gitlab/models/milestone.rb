class Milestone < ActiveRecord::Base
  # Represents a "No Milestone" state used for filtering Issues and Merge
  # Requests that have no milestone assigned.
  MilestoneStruct = Struct.new(:title, :name, :id)
  None = MilestoneStruct.new('No Milestone', 'No Milestone', 0)
  Any = MilestoneStruct.new('Any Milestone', '', -1)
  Upcoming = MilestoneStruct.new('Upcoming', '#upcoming', -2)

  include InternalId
  include Sortable
  include Referable
  include StripAttribute
  include Milestoneish

  belongs_to :project
  has_many :issues
  has_many :labels, -> { distinct.reorder('labels.title') },  through: :issues
  has_many :merge_requests
  has_many :participants, -> { distinct.reorder('users.name') }, through: :issues, source: :assignee

  scope :active, -> { with_state(:active) }
  scope :closed, -> { with_state(:closed) }
  scope :of_projects, ->(ids) { where(project_id: ids) }

  validates :title, presence: true, uniqueness: { scope: :project_id }
  validates :project, presence: true

  strip_attributes :title

  state_machine :state, initial: :active do
    event :close do
      transition active: :closed
    end

    event :activate do
      transition closed: :active
    end

    state :closed

    state :active
  end

  alias_attribute :name, :title

  class << self
    # Searches for milestones matching the given query.
    #
    # This method uses ILIKE on PostgreSQL and LIKE on MySQL.
    #
    # query - The search query as a String
    #
    # Returns an ActiveRecord::Relation.
    def self.active
with_state(:active)
end

def self.closed
with_state(:closed)
end

def self.of_projects
where(project_id: ids)
end

def self.active
with_state(:active)
end

def self.closed
with_state(:closed)
end

def self.of_projects
where(project_id: ids)
end

def search(query)
      t = arel_table
      pattern = "%#{query}%"

      where(t[:title].matches(pattern).or(t[:description].matches(pattern)))
    end
  end

  def self.reference_pattern
    nil
  end

  def self.link_reference_pattern
    @link_reference_pattern ||= super("milestones", /(?<milestone>\d+)/)
  end

  def self.upcoming_ids_by_projects(projects)
    rel = unscoped.of_projects(projects).active.where('due_date > ?', Time.now)

    if Gitlab::Database.postgresql?
      rel.order(:project_id, :due_date).select('DISTINCT ON (project_id) id')
    else
      rel.
        group(:project_id).
        having('due_date = MIN(due_date)').
        pluck(:id, :project_id, :due_date).
        map(&:first)
    end
  end

  def to_reference(from_project = nil)
    escaped_title = self.title.gsub("]", "\\]")

    h = Gitlab::Routing.url_helpers
    url = h.namespace_project_milestone_url(self.project.namespace, self.project, self)

    "[#{escaped_title}](#{url})"
  end

  def reference_link_text(from_project = nil)
    self.title
  end

  def expired?
    if due_date
      due_date.past?
    else
      false
    end
  end

  def expires_at
    if due_date
      if due_date.past?
        "expired on #{due_date.to_s(:medium)}"
      else
        "expires on #{due_date.to_s(:medium)}"
      end
    end
  end

  def can_be_closed?
    active? && issues.opened.count.zero?
  end

  def is_empty?(user = nil)
    total_items_count(user).zero?
  end

  def author_id
    nil
  end

  def title=(value)
    write_attribute(:title, Sanitize.clean(value.to_s)) if value.present?
  end

  # Sorts the issues for the given IDs.
  #
  # This method runs a single SQL query using a CASE statement to update the
  # position of all issues in the current milestone (scoped to the list of IDs).
  #
  # Given the ids [10, 20, 30] this method produces a SQL query something like
  # the following:
  #
  #     UPDATE issues
  #     SET position = CASE
  #       WHEN id = 10 THEN 1
  #       WHEN id = 20 THEN 2
  #       WHEN id = 30 THEN 3
  #       ELSE position
  #     END
  #     WHERE id IN (10, 20, 30);
  #
  # This method expects that the IDs given in `ids` are already Fixnums.
  def sort_issues(ids)
    pairs = []

    ids.each_with_index do |id, index|
      pairs << id
      pairs << index + 1
    end

    conditions = 'WHEN id = ? THEN ? ' * ids.length

    issues.where(id: ids).
      update_all(["position = CASE #{conditions} ELSE position END", *pairs])
  end
end
