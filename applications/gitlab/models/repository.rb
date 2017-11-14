require 'securerandom'

class Repository
  class CommitError < StandardError; end

  # Files to use as a project avatar in case no avatar was uploaded via the web
  # UI.
  AVATAR_FILES = %w{logo.png logo.jpg logo.gif}

  include Gitlab::ShellAdapter

  attr_accessor :path_with_namespace, :project

  def self.clean_old_archives
    Gitlab::Metrics.measure(:clean_old_archives) do
      repository_downloads_path = Gitlab.config.gitlab.repository_downloads_path

      return unless File.directory?(repository_downloads_path)

      Gitlab::Popen.popen(%W(find #{repository_downloads_path} -not -path #{repository_downloads_path} -mmin +120 -delete))
    end
  end

  def initialize(path_with_namespace, project)
    @path_with_namespace = path_with_namespace
    @project = project
  end

  def raw_repository
    return nil unless path_with_namespace

    @raw_repository ||= Gitlab::Git::Repository.new(path_to_repo)
  end

  def update_autocrlf_option
    raw_repository.autocrlf = :input if raw_repository.autocrlf != :input
  end

  # Return absolute path to repository
  def path_to_repo
    @path_to_repo ||= File.expand_path(
      File.join(Gitlab.config.gitlab_shell.repos_path, path_with_namespace + ".git")
    )
  end

  def exists?
    return @exists unless @exists.nil?

    @exists = cache.fetch(:exists?) do
      begin
        raw_repository && raw_repository.rugged ? true : false
      rescue Gitlab::Git::Repository::NoRepository
        false
      end
    end
  end

  def empty?
    return @empty unless @empty.nil?

    @empty = cache.fetch(:empty?) { raw_repository.empty? }
  end

  #
  # Git repository can contains some hidden refs like:
  #   /refs/notes/*
  #   /refs/git-as-svn/*
  #   /refs/pulls/*
  # This refs by default not visible in project page and not cloned to client side.
  #
  # This method return true if repository contains some content visible in project page.
  #
  def has_visible_content?
    return @has_visible_content unless @has_visible_content.nil?

    @has_visible_content = cache.fetch(:has_visible_content?) do
      branch_count > 0
    end
  end

  def commit(id = 'HEAD')
    return nil unless exists?
    commit = Gitlab::Git::Commit.find(raw_repository, id)
    commit = ::Commit.new(commit, @project) if commit
    commit
  rescue Rugged::OdbError
    nil
  end

  def commits(ref, path: nil, limit: nil, offset: nil, skip_merges: false, after: nil, before: nil)
    options = {
      repo: raw_repository,
      ref: ref,
      path: path,
      limit: limit,
      offset: offset,
      after: after,
      before: before,
      # --follow doesn't play well with --skip. See:
      # https://gitlab.com/gitlab-org/gitlab-ce/issues/3574#note_3040520
      follow: false,
      skip_merges: skip_merges
    }

    commits = Gitlab::Git::Commit.where(options)
    commits = Commit.decorate(commits, @project) if commits.present?
    commits
  end

  def commits_between(from, to)
    commits = Gitlab::Git::Commit.between(raw_repository, from, to)
    commits = Commit.decorate(commits, @project) if commits.present?
    commits
  end

  def find_commits_by_message(query, ref = nil, path = nil, limit = 1000, offset = 0)
    ref ||= root_ref

    # Limited to 1000 commits for now, could be parameterized?
    args = %W(#{Gitlab.config.git.bin_path} log #{ref} --pretty=%H --skip #{offset} --max-count #{limit} --grep=#{query})
    args = args.concat(%W(-- #{path})) if path.present?

    git_log_results = Gitlab::Popen.popen(args, path_to_repo).first.lines.map(&:chomp)
    commits = git_log_results.map { |c| commit(c) }
    commits
  end

  def find_branch(name)
    raw_repository.branches.find { |branch| branch.name == name }
  end

  def find_tag(name)
    raw_repository.tags.find { |tag| tag.name == name }
  end

  def add_branch(user, branch_name, target)
    oldrev = Gitlab::Git::BLANK_SHA
    ref    = Gitlab::Git::BRANCH_REF_PREFIX + branch_name
    target = commit(target).try(:id)

    return false unless target

    GitHooksService.new.execute(user, path_to_repo, oldrev, target, ref) do
      rugged.branches.create(branch_name, target)
    end

    after_create_branch
    find_branch(branch_name)
  end

  def add_tag(user, tag_name, target, message = nil)
    oldrev = Gitlab::Git::BLANK_SHA
    ref    = Gitlab::Git::TAG_REF_PREFIX + tag_name
    target = commit(target).try(:id)

    return false unless target

    options = { message: message, tagger: user_to_committer(user) } if message

    GitHooksService.new.execute(user, path_to_repo, oldrev, target, ref) do
      rugged.tags.create(tag_name, target, options)
    end

    find_tag(tag_name)
  end

  def rm_branch(user, branch_name)
    before_remove_branch

    branch = find_branch(branch_name)
    oldrev = branch.try(:target)
    newrev = Gitlab::Git::BLANK_SHA
    ref    = Gitlab::Git::BRANCH_REF_PREFIX + branch_name

    GitHooksService.new.execute(user, path_to_repo, oldrev, newrev, ref) do
      rugged.branches.delete(branch_name)
    end

    after_remove_branch
    true
  end

  def rm_tag(tag_name)
    before_remove_tag

    begin
      rugged.tags.delete(tag_name)
      true
    rescue Rugged::ReferenceError
      false
    end
  end

  def branch_names
    cache.fetch(:branch_names) { branches.map(&:name) }
  end

  def branch_exists?(branch_name)
    branch_names.include?(branch_name)
  end

  def tag_names
    cache.fetch(:tag_names) { raw_repository.tag_names }
  end

  def commit_count
    cache.fetch(:commit_count) do
      begin
        raw_repository.commit_count(self.root_ref)
      rescue
        0
      end
    end
  end

  def branch_count
    @branch_count ||= cache.fetch(:branch_count) { branches.size }
  end

  def tag_count
    @tag_count ||= cache.fetch(:tag_count) { raw_repository.rugged.tags.count }
  end

  # Return repo size in megabytes
  # Cached in redis
  def size
    cache.fetch(:size) { raw_repository.size }
  end

  def diverging_commit_counts(branch)
    root_ref_hash = raw_repository.rev_parse_target(root_ref).oid
    cache.fetch(:"diverging_commit_counts_#{branch.name}") do
      # Rugged seems to throw a `ReferenceError` when given branch_names rather
      # than SHA-1 hashes
      number_commits_behind = raw_repository.
        count_commits_between(branch.target, root_ref_hash)

      number_commits_ahead = raw_repository.
        count_commits_between(root_ref_hash, branch.target)

      { behind: number_commits_behind, ahead: number_commits_ahead }
    end
  end

  def cache_keys
    %i(size branch_names tag_names commit_count
       readme version contribution_guide changelog
       license_blob license_key)
  end

  def build_cache
    cache_keys.each do |key|
      unless cache.exist?(key)
        send(key)
      end
    end
  end

  def expire_tags_cache
    cache.expire(:tag_names)
    @tags = nil
  end

  def expire_branches_cache
    cache.expire(:branch_names)
    @local_branches = nil
  end

  def expire_cache(branch_name = nil, revision = nil)
    cache_keys.each do |key|
      cache.expire(key)
    end

    expire_branch_cache(branch_name)
    expire_avatar_cache(branch_name, revision)

    # This ensures this particular cache is flushed after the first commit to a
    # new repository.
    expire_emptiness_caches if empty?
    expire_branch_count_cache
    expire_tag_count_cache
  end

  def expire_branch_cache(branch_name = nil)
    # When we push to the root branch we have to flush the cache for all other
    # branches as their statistics are based on the commits relative to the
    # root branch.
    if !branch_name || branch_name == root_ref
      branches.each do |branch|
        cache.expire(:"diverging_commit_counts_#{branch.name}")
      end
    # In case a commit is pushed to a non-root branch we only have to flush the
    # cache for said branch.
    else
      cache.expire(:"diverging_commit_counts_#{branch_name}")
    end
  end

  def expire_root_ref_cache
    cache.expire(:root_ref)
    @root_ref = nil
  end

  # Expires the cache(s) used to determine if a repository is empty or not.
  def expire_emptiness_caches
    cache.expire(:empty?)
    @empty = nil

    expire_has_visible_content_cache
  end

  def expire_has_visible_content_cache
    cache.expire(:has_visible_content?)
    @has_visible_content = nil
  end

  def expire_branch_count_cache
    cache.expire(:branch_count)
    @branch_count = nil
  end

  def expire_tag_count_cache
    cache.expire(:tag_count)
    @tag_count = nil
  end

  def lookup_cache
    @lookup_cache ||= {}
  end

  def expire_branch_names
    cache.expire(:branch_names)
  end

  def expire_avatar_cache(branch_name = nil, revision = nil)
    # Avatars are pulled from the default branch, thus if somebody pushes to a
    # different branch there's no need to expire anything.
    return if branch_name && branch_name != root_ref

    # We don't want to flush the cache if the commit didn't actually make any
    # changes to any of the possible avatar files.
    if revision && commit = self.commit(revision)
      return unless commit.diffs.
        any? { |diff| AVATAR_FILES.include?(diff.new_path) }
    end

    cache.expire(:avatar)

    @avatar = nil
  end

  def expire_exists_cache
    cache.expire(:exists?)
    @exists = nil
  end

  # Runs code after a repository has been created.
  def after_create
    expire_exists_cache
    expire_root_ref_cache
    expire_emptiness_caches
  end

  # Runs code just before a repository is deleted.
  def before_delete
    expire_exists_cache

    expire_cache if exists?

    expire_root_ref_cache
    expire_emptiness_caches
    expire_exists_cache
  end

  # Runs code just before the HEAD of a repository is changed.
  def before_change_head
    # Cached divergent commit counts are based on repository head
    expire_branch_cache
    expire_root_ref_cache
  end

  # Runs code before pushing (= creating or removing) a tag.
  def before_push_tag
    expire_cache
    expire_tags_cache
    expire_tag_count_cache
  end

  # Runs code before removing a tag.
  def before_remove_tag
    expire_tags_cache
    expire_tag_count_cache
  end

  def before_import
    expire_emptiness_caches
    expire_exists_cache
  end

  # Runs code after a repository has been forked/imported.
  def after_import
    expire_emptiness_caches
    expire_exists_cache
  end

  # Runs code after a new commit has been pushed.
  def after_push_commit(branch_name, revision)
    expire_cache(branch_name, revision)
  end

  # Runs code after a new branch has been created.
  def after_create_branch
    expire_branches_cache
    expire_has_visible_content_cache
    expire_branch_count_cache
  end

  # Runs code before removing an existing branch.
  def before_remove_branch
    expire_branches_cache
  end

  # Runs code after an existing branch has been removed.
  def after_remove_branch
    expire_has_visible_content_cache
    expire_branch_count_cache
    expire_branches_cache
  end

  def method_missing(m, *args, &block)
    if m == :lookup && !block_given?
      lookup_cache[m] ||= {}
      lookup_cache[m][args.join(":")] ||= raw_repository.send(m, *args, &block)
    else
      raw_repository.send(m, *args, &block)
    end
  end

  def respond_to_missing?(method, include_private = false)
    raw_repository.respond_to?(method, include_private) || super
  end

  def blob_at(sha, path)
    unless Gitlab::Git.blank_ref?(sha)
      Gitlab::Git::Blob.find(self, sha, path)
    end
  end

  def blob_by_oid(oid)
    Gitlab::Git::Blob.raw(self, oid)
  end

  def readme
    cache.fetch(:readme) { tree(:head).readme }
  end

  def version
    cache.fetch(:version) do
      tree(:head).blobs.find do |file|
        file.name.casecmp('version').zero?
      end
    end
  end

  def contribution_guide
    cache.fetch(:contribution_guide) do
      tree(:head).blobs.find do |file|
        file.contributing?
      end
    end
  end

  def changelog
    cache.fetch(:changelog) do
      tree(:head).blobs.find do |file|
        file.name =~ /\A(changelog|history|changes|news)/i
      end
    end
  end

  def license_blob
    return nil if !exists? || empty?

    cache.fetch(:license_blob) do
      tree(:head).blobs.find do |file|
        file.name =~ /\A(licen[sc]e|copying)(\..+|\z)/i
      end
    end
  end

  def license_key
    return nil if !exists? || empty?

    cache.fetch(:license_key) do
      Licensee.license(path).try(:key)
    end
  end

  def gitlab_ci_yml
    return nil if !exists? || empty?

    @gitlab_ci_yml ||= tree(:head).blobs.find do |file|
      file.name == '.gitlab-ci.yml'
    end
  rescue Rugged::ReferenceError
    # For unknow reason spinach scenario "Scenario: I change project path"
    # lead to "Reference 'HEAD' not found" exception from Repository#empty?
    nil
  end

  def head_commit
    @head_commit ||= commit(self.root_ref)
  end

  def head_tree
    @head_tree ||= Tree.new(self, head_commit.sha, nil)
  end

  def tree(sha = :head, path = nil)
    if sha == :head
      if path.nil?
        return head_tree
      else
        sha = head_commit.sha
      end
    end

    Tree.new(self, sha, path)
  end

  def blob_at_branch(branch_name, path)
    last_commit = commit(branch_name)

    if last_commit
      blob_at(last_commit.sha, path)
    else
      nil
    end
  end

  # Returns url for submodule
  #
  # Ex.
  #   @repository.submodule_url_for('master', 'rack')
  #   # => git@localhost:rack.git
  #
  def submodule_url_for(ref, path)
    if submodules(ref).any?
      submodule = submodules(ref)[path]

      if submodule
        submodule['url']
      end
    end
  end

  def last_commit_for_path(sha, path)
    args = %W(#{Gitlab.config.git.bin_path} rev-list --max-count=1 #{sha} -- #{path})
    sha = Gitlab::Popen.popen(args, path_to_repo).first.strip
    commit(sha)
  end

  def next_branch(name, opts={})
    branch_ids = self.branch_names.map do |n|
      next 1 if n == name
      result = n.match(/\A#{name}-([0-9]+)\z/)
      result[1].to_i if result
    end.compact

    highest_branch_id = branch_ids.max || 0

    return name if opts[:mild] && 0 == highest_branch_id

    "#{name}-#{highest_branch_id + 1}"
  end

  # Remove archives older than 2 hours
  def branches_sorted_by(value)
    case value
    when 'recently_updated'
      branches.sort do |a, b|
        commit(b.target).committed_date <=> commit(a.target).committed_date
      end
    when 'last_updated'
      branches.sort do |a, b|
        commit(a.target).committed_date <=> commit(b.target).committed_date
      end
    else
      branches
    end
  end

  def contributors
    commits = self.commits(nil, limit: 2000, offset: 0, skip_merges: true)

    commits.group_by(&:author_email).map do |email, commits|
      contributor = Gitlab::Contributor.new
      contributor.email = email

      commits.each do |commit|
        if contributor.name.blank?
          contributor.name = commit.author_name
        end

        contributor.commits += 1
      end

      contributor
    end
  end

  def blob_for_diff(commit, diff)
    blob_at(commit.id, diff.file_path)
  end

  def prev_blob_for_diff(commit, diff)
    if commit.parent_id
      blob_at(commit.parent_id, diff.old_path)
    end
  end

  def refs_contains_sha(ref_type, sha)
    args = %W(#{Gitlab.config.git.bin_path} #{ref_type} --contains #{sha})
    names = Gitlab::Popen.popen(args, path_to_repo).first

    if names.respond_to?(:split)
      names = names.split("\n").map(&:strip)

      names.each do |name|
        name.slice! '* '
      end

      names
    else
      []
    end
  end

  def branch_names_contains(sha)
    refs_contains_sha('branch', sha)
  end

  def tag_names_contains(sha)
    refs_contains_sha('tag', sha)
  end

  def local_branches
    @local_branches ||= rugged.branches.each(:local).map do |branch|
      Gitlab::Git::Branch.new(branch.name, branch.target)
    end
  end

  alias_method :branches, :local_branches

  def tags
    @tags ||= raw_repository.tags
  end

  def root_ref
    @root_ref ||= cache.fetch(:root_ref) { raw_repository.root_ref }
  end

  def commit_dir(user, path, message, branch)
    commit_with_hooks(user, branch) do |ref|
      committer = user_to_committer(user)
      options = {}
      options[:committer] = committer
      options[:author] = committer

      options[:commit] = {
        message: message,
        branch: ref,
      }

      raw_repository.mkdir(path, options)
    end
  end

  def commit_file(user, path, content, message, branch, update)
    commit_with_hooks(user, branch) do |ref|
      committer = user_to_committer(user)
      options = {}
      options[:committer] = committer
      options[:author] = committer
      options[:commit] = {
        message: message,
        branch: ref,
      }

      options[:file] = {
        content: content,
        path: path,
        update: update
      }

      Gitlab::Git::Blob.commit(raw_repository, options)
    end
  end

  def remove_file(user, path, message, branch)
    commit_with_hooks(user, branch) do |ref|
      committer = user_to_committer(user)
      options = {}
      options[:committer] = committer
      options[:author] = committer
      options[:commit] = {
        message: message,
        branch: ref
      }

      options[:file] = {
        path: path
      }

      Gitlab::Git::Blob.remove(raw_repository, options)
    end
  end

  def user_to_committer(user)
    {
      email: user.email,
      name: user.name,
      time: Time.now
    }
  end

  def can_be_merged?(source_sha, target_branch)
    our_commit = rugged.branches[target_branch].target
    their_commit = rugged.lookup(source_sha)

    if our_commit && their_commit
      !rugged.merge_commits(our_commit, their_commit).conflicts?
    else
      false
    end
  end

  def merge(user, source_sha, target_branch, options = {})
    our_commit = rugged.branches[target_branch].target
    their_commit = rugged.lookup(source_sha)

    raise "Invalid merge target" if our_commit.nil?
    raise "Invalid merge source" if their_commit.nil?

    merge_index = rugged.merge_commits(our_commit, their_commit)
    return false if merge_index.conflicts?

    commit_with_hooks(user, target_branch) do |ref|
      actual_options = options.merge(
        parents: [our_commit, their_commit],
        tree: merge_index.write_tree(rugged),
        update_ref: ref
      )

      Rugged::Commit.create(rugged, actual_options)
    end
  end

  def revert(user, commit, base_branch, revert_tree_id = nil)
    source_sha = find_branch(base_branch).target
    revert_tree_id ||= check_revert_content(commit, base_branch)

    return false unless revert_tree_id

    commit_with_hooks(user, base_branch) do |ref|
      committer = user_to_committer(user)
      source_sha = Rugged::Commit.create(rugged,
        message: commit.revert_message,
        author: committer,
        committer: committer,
        tree: revert_tree_id,
        parents: [rugged.lookup(source_sha)],
        update_ref: ref)
    end
  end

  def cherry_pick(user, commit, base_branch, cherry_pick_tree_id = nil)
    source_sha = find_branch(base_branch).target
    cherry_pick_tree_id ||= check_cherry_pick_content(commit, base_branch)

    return false unless cherry_pick_tree_id

    commit_with_hooks(user, base_branch) do |ref|
      committer = user_to_committer(user)
      source_sha = Rugged::Commit.create(rugged,
        message: commit.message,
        author: {
          email: commit.author_email,
          name: commit.author_name,
          time: commit.authored_date
        },
        committer: committer,
        tree: cherry_pick_tree_id,
        parents: [rugged.lookup(source_sha)],
        update_ref: ref)
    end
  end

  def check_revert_content(commit, base_branch)
    source_sha = find_branch(base_branch).target
    args       = [commit.id, source_sha]
    args << { mainline: 1 } if commit.merge_commit?

    revert_index = rugged.revert_commit(*args)
    return false if revert_index.conflicts?

    tree_id = revert_index.write_tree(rugged)
    return false unless diff_exists?(source_sha, tree_id)

    tree_id
  end

  def check_cherry_pick_content(commit, base_branch)
    source_sha = find_branch(base_branch).target
    args       = [commit.id, source_sha]
    args << 1 if commit.merge_commit?

    cherry_pick_index = rugged.cherrypick_commit(*args)
    return false if cherry_pick_index.conflicts?

    tree_id = cherry_pick_index.write_tree(rugged)
    return false unless diff_exists?(source_sha, tree_id)

    tree_id
  end

  def diff_exists?(sha1, sha2)
    rugged.diff(sha1, sha2).size > 0
  end

  def merged_to_root_ref?(branch_name)
    branch_commit = commit(branch_name)
    root_ref_commit = commit(root_ref)

    if branch_commit
      is_ancestor?(branch_commit.id, root_ref_commit.id)
    else
      nil
    end
  end

  def merge_base(first_commit_id, second_commit_id)
    first_commit_id = commit(first_commit_id).try(:id) || first_commit_id
    second_commit_id = commit(second_commit_id).try(:id) || second_commit_id
    rugged.merge_base(first_commit_id, second_commit_id)
  rescue Rugged::ReferenceError
    nil
  end

  def is_ancestor?(ancestor_id, descendant_id)
    merge_base(ancestor_id, descendant_id) == ancestor_id
  end


  def search_files(query, ref)
    offset = 2
    args = %W(#{Gitlab.config.git.bin_path} grep -i -I -n --before-context #{offset} --after-context #{offset} -e #{Regexp.escape(query)} #{ref || root_ref})
    Gitlab::Popen.popen(args, path_to_repo).first.scrub.split(/^--$/)
  end

  def parse_search_result(result)
    ref = nil
    filename = nil
    basename = nil
    startline = 0

    result.each_line.each_with_index do |line, index|
      if line =~ /^.*:.*:\d+:/
        ref, filename, startline = line.split(':')
        startline = startline.to_i - index
        extname = File.extname(filename)
        basename = filename.sub(/#{extname}$/, '')
        break
      end
    end

    data = ""

    result.each_line do |line|
      data << line.sub(ref, '').sub(filename, '').sub(/^:-\d+-/, '').sub(/^::\d+:/, '')
    end

    OpenStruct.new(
      filename: filename,
      basename: basename,
      ref: ref,
      startline: startline,
      data: data
    )
  end

  def fetch_ref(source_path, source_ref, target_ref)
    args = %W(#{Gitlab.config.git.bin_path} fetch --no-tags -f #{source_path} #{source_ref}:#{target_ref})
    Gitlab::Popen.popen(args, path_to_repo)
  end

  def with_tmp_ref(oldrev = nil)
    random_string = SecureRandom.hex
    tmp_ref = "refs/tmp/#{random_string}/head"

    if oldrev && !Gitlab::Git.blank_ref?(oldrev)
      rugged.references.create(tmp_ref, oldrev)
    end

    # Make commit in tmp ref
    yield(tmp_ref)
  ensure
    rugged.references.delete(tmp_ref) rescue nil
  end

  def commit_with_hooks(current_user, branch)
    update_autocrlf_option

    oldrev = Gitlab::Git::BLANK_SHA
    ref = Gitlab::Git::BRANCH_REF_PREFIX + branch
    target_branch = find_branch(branch)
    was_empty = empty?

    if !was_empty && target_branch
      oldrev = target_branch.target
    end

    with_tmp_ref(oldrev) do |tmp_ref|
      # Make commit in tmp ref
      newrev = yield(tmp_ref)

      unless newrev
        raise CommitError.new('Failed to create commit')
      end

      GitHooksService.new.execute(current_user, path_to_repo, oldrev, newrev, ref) do
        if was_empty || !target_branch
          # Create branch
          rugged.references.create(ref, newrev)
        else
          # Update head
          current_head = find_branch(branch).target

          # Make sure target branch was not changed during pre-receive hook
          if current_head == oldrev
            rugged.references.update(ref, newrev)
          else
            raise CommitError.new('Commit was rejected because branch received new push')
          end
        end
      end

      newrev
    end
  end

  def ls_files(ref)
    actual_ref = ref || root_ref
    raw_repository.ls_files(actual_ref)
  end

  def copy_gitattributes(ref)
    actual_ref = ref || root_ref
    begin
      raw_repository.copy_gitattributes(actual_ref)
      true
    rescue Gitlab::Git::Repository::InvalidRef
      false
    end
  end

  def main_language
    return if empty? || rugged.head_unborn?

    Linguist::Repository.new(rugged, rugged.head.target_id).language
  end

  def avatar
    return nil unless exists?

    @avatar ||= cache.fetch(:avatar) do
      AVATAR_FILES.find do |file|
        blob_at_branch('master', file)
      end
    end
  end

  private

  def cache
    @cache ||= RepositoryCache.new(path_with_namespace)
  end
end
