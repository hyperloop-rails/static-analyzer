class Namespace < ActiveRecord::Base
  include Sortable
  include Gitlab::ShellAdapter

  has_many :projects, dependent: :destroy
  belongs_to :owner, class_name: "User"

  validates :owner, presence: true, unless: ->(n) { n.type == "Group" }
  validates :name,
    length: { within: 0..255 },
    namespace_name: true,
    presence: true,
    uniqueness: true

  validates :description, length: { within: 0..255 }
  validates :path,
    length: { within: 1..255 },
    namespace: true,
    presence: true,
    uniqueness: { case_sensitive: false }

  delegate :name, to: :owner, allow_nil: true, prefix: true

  after_create :ensure_dir_exist
  after_update :move_dir, if: :path_changed?
  after_destroy :rm_dir

  scope :root, -> { where('type IS NULL') }

  class << self
    def self.root
where('type IS NULL')
end

def self.root
where('type IS NULL')
end

def by_path(path)
      find_by('lower(path) = :value', value: path.downcase)
    end

    # Case insensetive search for namespace by path or name
    def find_by_path_or_name(path)
      find_by("lower(path) = :path OR lower(name) = :path", path: path.downcase)
    end

    # Searches for namespaces matching the given query.
    #
    # This method uses ILIKE on PostgreSQL and LIKE on MySQL.
    #
    # query - The search query as a String
    #
    # Returns an ActiveRecord::Relation
    def search(query)
      t = arel_table
      pattern = "%#{query}%"

      where(t[:name].matches(pattern).or(t[:path].matches(pattern)))
    end

    def clean_path(path)
      path = path.dup
      # Get the email username by removing everything after an `@` sign.
      path.gsub!(/@.*\z/,             "")
      # Usernames can't end in .git, so remove it.
      path.gsub!(/\.git\z/,           "")
      # Remove dashes at the start of the username.
      path.gsub!(/\A-+/,              "")
      # Remove periods at the end of the username.
      path.gsub!(/\.+\z/,             "")
      # Remove everything that's not in the list of allowed characters.
      path.gsub!(/[^a-zA-Z0-9_\-\.]/, "")

      # Users with the great usernames of "." or ".." would end up with a blank username.
      # Work around that by setting their username to "blank", followed by a counter.
      path = "blank" if path.blank?

      counter = 0
      base = path
      while Namespace.find_by_path_or_name(path)
        counter += 1
        path = "#{base}#{counter}"
      end

      path
    end
  end

  def to_param
    path
  end

  def human_name
    owner_name
  end

  def ensure_dir_exist
    gitlab_shell.add_namespace(path)
  end

  def rm_dir
    # Move namespace directory into trash.
    # We will remove it later async
    new_path = "#{path}+#{id}+deleted"

    if gitlab_shell.mv_namespace(path, new_path)
      message = "Namespace directory \"#{path}\" moved to \"#{new_path}\""
      Gitlab::AppLogger.info message

      # Remove namespace directroy async with delay so
      # GitLab has time to remove all projects first
      GitlabShellWorker.perform_in(5.minutes, :rm_namespace, new_path)
    end
  end

  def move_dir
    # Ensure old directory exists before moving it
    gitlab_shell.add_namespace(path_was)

    if gitlab_shell.mv_namespace(path_was, path)
      Gitlab::UploadsTransfer.new.rename_namespace(path_was, path)

      # If repositories moved successfully we need to
      # send update instructions to users.
      # However we cannot allow rollback since we moved namespace dir
      # So we basically we mute exceptions in next actions
      begin
        send_update_instructions
      rescue
        # Returning false does not rollback after_* transaction but gives
        # us information about failing some of tasks
        false
      end
    else
      # if we cannot move namespace directory we should rollback
      # db changes in order to prevent out of sync between db and fs
      raise Exception.new('namespace directory cannot be moved')
    end
  end

  def send_update_instructions
    projects.each do |project|
      project.send_move_instructions("#{path_was}/#{project.path}")
    end
  end

  def kind
    type == 'Group' ? 'group' : 'user'
  end

  def find_fork_of(project)
    projects.joins(:forked_project_link).find_by('forked_project_links.forked_from_project_id = ?', project.id)
  end
end
