# Controller for viewing a repository's file structure
class Projects::TreeController < Projects::ApplicationController
  include ExtractsPath
  include CreatesCommit
  include ActionView::Helpers::SanitizeHelper

  before_action :require_non_empty_project, except: [:new, :create]
  before_action :assign_ref_vars
  before_action :assign_dir_vars, only: [:create_dir]
  before_action :authorize_download_code!
  before_action :authorize_edit_tree!, only: [:create_dir]

  def show
    return render_404 unless @repository.commit(@ref)

    if tree.entries.empty?
      if @repository.blob_at(@commit.id, @path)
        redirect_to(
          namespace_project_blob_path(@project.namespace, @project,
                                      File.join(@ref, @path))
        ) and return
      elsif @path.present?
        return render_404
      end
    end

    respond_to do |format|
      format.html
      # Disable cache so browser history works
      format.js { no_cache_headers }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title       @project.name_with_namespace 
 page_description @project.description    unless page_description 
 header_title     project_title(@project) unless header_title 
 sidebar          "project"               unless sidebar 
 content_for :scripts_body_top do 
 project = @target_project || @project 
 if @project_wiki 
 markdown_preview_path = namespace_project_wikis_markdown_preview_path(project.namespace, project) 
 else 
 markdown_preview_path = markdown_preview_namespace_project_path(project.namespace, project) 
 end 
 if current_user 
 end 
 end 
 content_for :scripts_body do 
  project = @target_project || @project 
 if @noteable 
 end 
 
 end 
 content_for :header_content do 
 dropdown_title("Go to a project") 
 dropdown_filter("Search your projects") 
 dropdown_content 
 dropdown_loading 
 end 
   page_description brand_title unless page_description 
 site_name = "GitLab" 
 # Open Graph - http://ogp.me/ 
 site_name 
 page_title 
 page_description 
 page_image 
 request.base_url 
 # Twitter Card - https://dev.twitter.com/cards/types/summary 
 page_title 
 page_description 
 page_image 
 page_card_meta_tags 
 page_title(site_name) 
 page_description 
 favicon_link_tag 'favicon.ico' 
 stylesheet_link_tag "application", media: "all" 
 stylesheet_link_tag "print",       media: "print" 
 javascript_include_tag "application" 
 csrf_meta_tags 
 include_gon 
 unless browser.safari? 
 end 
 # Apple Safari/iOS home screen icons 
 favicon_link_tag 'touch-icon-iphone.png',        rel: 'apple-touch-icon' 
 favicon_link_tag 'touch-icon-ipad.png',          rel: 'apple-touch-icon', sizes: '76x76' 
 favicon_link_tag 'touch-icon-iphone-retina.png', rel: 'apple-touch-icon', sizes: '120x120' 
 favicon_link_tag 'touch-icon-ipad-retina.png',   rel: 'apple-touch-icon', sizes: '152x152' 
 image_path('logo.svg') 
 # Windows 8 pinned site tile 
 image_path('msapplication-tile.png') 
 if current_user 
 auto_discovery_link_tag(:atom, namespace_project_commits_url(@project.namespace, @project, @ref, format: :atom, private_token: current_user.private_token), title: ": commits") 
 end 
  
  
  
  
 
 # Ideally this would be inside the head, but turbolinks only evaluates page-specific JS in the body. 
 yield :scripts_body_top 
  nav_header_class 
 icon('bars') 
 icon('angle-left') 
  page_title    "Search" 
 header_title  "Search", search_path 
 render template: "layouts/application" 
 
 link_to search_path, title: 'Search', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('search') 
 end 
 if current_user 
 if session[:impersonator_id] 
 link_to admin_impersonation_path, method: :delete, title: 'Stop Impersonation', data: { toggle: 'tooltip', placement: 'bottom', container: 'body' } do 
 icon('user-secret fw') 
 end 
 end 
 if current_user.is_admin? 
 link_to admin_root_path, title: 'Admin Area', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('wrench fw') 
 end 
 end 
 link_to dashboard_todos_path, title: 'Todos', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('bell fw') 
 unless todos_pending_count == 0 
 todos_pending_count 
 end 
 end 
 if current_user.can_create_project? 
 link_to new_project_path, title: 'New project', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('plus fw') 
 end 
 end 
 if Gitlab::Sherlock.enabled? 
 link_to sherlock_transactions_path, title: 'Sherlock Transactions',                  data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('tachometer fw') 
 end 
 end 
 link_to destroy_user_session_path, class: 'logout', method: :delete, title: 'Sign out', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('sign-out') 
 end 
 else 
 link_to "Sign in", new_session_path(:user, redirect_to_referer: 'yes'), class: 'btn btn-sign-in btn-success' 
 end 
 title 
 yield :header_content 
  if outdated_browser? 
 link = "https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/requirements.md#supported-web-browsers" 
 link_to 'supported web browser', link 
 end 
 
 if @project && !@project.empty_repo? 
 if ref = @ref || @project.repository.root_ref 
 end 
 end 
 
   broadcast_message 
 
 nav_sidebar_class 
 brand_header_logo 
 link_to root_path, class: 'gitlab-text-container-link', title: 'Dashboard', id: 'js-shortcuts-home' do 
 end 
 if defined?(sidebar) && sidebar 
 render "layouts/nav/" 
 elsif current_user 
  nav_link(path: ['root#index', 'projects#trending', 'projects#starred', 'dashboard/projects#index'], html_options: {class: 'home'}) do 
 link_to dashboard_projects_path, title: 'Projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: :todos) do 
 link_to dashboard_todos_path, title: 'Todos' do 
 icon('bell fw') 
 number_with_delimiter(todos_pending_count) 
 end 
 end 
 nav_link(path: 'dashboard#activity') do 
 link_to activity_dashboard_path, class: 'shortcuts-activity', title: 'Activity' do 
 icon('dashboard fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to dashboard_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: 'dashboard/milestones') do 
 link_to dashboard_milestones_path, title: 'Milestones' do 
 icon('clock-o fw') 
 end 
 end 
 nav_link(path: 'dashboard#issues') do 
 link_to assigned_issues_dashboard_path, title: 'Issues', class: 'shortcuts-issues' do 
 icon('exclamation-circle fw') 
 number_with_delimiter(current_user.assigned_issues.opened.count) 
 end 
 end 
 nav_link(path: 'dashboard#merge_requests') do 
 link_to assigned_mrs_dashboard_path, title: 'Merge Requests', class: 'shortcuts-merge_requests' do 
 icon('tasks fw') 
 number_with_delimiter(current_user.assigned_merge_requests.opened.count) 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to dashboard_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 nav_link(html_options: {class: profile_tab_class}) do 
 link_to profile_path, title: 'Profile Settings', data: {placement: 'bottom'} do 
 icon('user fw') 
 end 
 end 
 
 else 
  nav_link(path: ['dashboard#show', 'root#show', 'projects#trending', 'projects#starred', 'projects#index'], html_options: {class: 'home'}) do 
 link_to explore_root_path, title: 'Projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to explore_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to explore_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 
 end 
  if nav_menu_collapsed? 
 link_to icon('angle-right'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 else 
 link_to icon('angle-left'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 end 
 
 if current_user 
 link_to current_user, class: 'sidebar-user', title: "Profile" do 
 image_tag avatar_icon(current_user, 60), alt: 'Profile', class: 'avatar avatar s36' 
 current_user.username 
 end 
 end 
 if defined?(nav) && nav 
 render "layouts/nav/" 
 end 
  if alert 
 alert 
 elsif notice 
 notice 
 end 
 
 yield :flash_message 
 (container_class unless @no_container) 
 page_title @path.presence , @ref 
 header_title project_title(@project, "Files", project_files_path(@project)) 
  
  if event = last_push_event 
 if show_last_push_widget?(event) 
 link_to namespace_project_commits_path(event.project.namespace, event.project, event.ref_name) do 
 event.ref_name 
 end 
 link_to new_mr_path_from_push_event(event), title: "New Merge Request", class: "btn btn-info btn-sm" do 
 end 
 end 
 end 
 
  link_to namespace_project_find_file_path(@project.namespace, @project, @ref), class: 'btn btn-grouped shortcuts-find-file', rel: 'nofollow' do 
 icon('search') 
 end 
 
 if can? current_user, :download_code, @project 
  ref = ref || nil 
 btn_class = btn_class || '' 
 split_button = split_button || false 
 if split_button == true 
 btn_class 
 link_to archive_namespace_project_repository_path(@project.namespace, @project, ref: ref, format: 'zip'), class: 'btn col-xs-10', rel: 'nofollow' do 
 end 
 link_to archive_namespace_project_repository_path(@project.namespace, @project, ref: ref, format: 'zip'), rel: 'nofollow' do 
 end 
 link_to archive_namespace_project_repository_path(@project.namespace, @project, ref: ref, format: 'tar.gz'), rel: 'nofollow' do 
 end 
 link_to archive_namespace_project_repository_path(@project.namespace, @project, ref: ref, format: 'tar.bz2'), rel: 'nofollow' do 
 end 
 link_to archive_namespace_project_repository_path(@project.namespace, @project, ref: ref, format: 'tar'), rel: 'nofollow' do 
 end 
 else 
 btn_class 
 link_to archive_namespace_project_repository_path(@project.namespace, @project, ref: ref, format: 'zip'), class: 'btn', rel: 'nofollow' do 
 end 
 link_to archive_namespace_project_repository_path(@project.namespace, @project, ref: ref, format: 'tar.gz'), class: 'btn', rel: 'nofollow' do 
 end 
 end 
 
 end 
   form_tag switch_namespace_project_refs_path(@project.namespace, @project), method: :get, class: "project-refs-form" do 
 select_tag "ref", grouped_options_refs, class: "project-refs-select select2 select2-sm" 
 hidden_field_tag :destination, destination 
 if defined?(path) 
 hidden_field_tag :path, path 
 end 
 @options && @options.each do |key, value| 
 hidden_field_tag key, value, id: nil 
 end 
 end 
 
 link_to namespace_project_tree_path(@project.namespace, @project, @ref) do 
 @project.path 
 end 
 tree_breadcrumbs(tree, 6) do |title, path| 
 if path 
 link_to truncate(title, length: 40), namespace_project_tree_path(@project.namespace, @project, path) 
 else 
 link_to title, '#' 
 end 
 end 
 if current_user 
 if !on_top_of_branch? 
 icon('plus') 
 else 
 icon('plus') 
 if can_edit_tree? 
 link_to namespace_project_new_blob_path(@project.namespace, @project, @id) do 
 icon('pencil fw') 
 end 
 link_to '#modal-upload-blob', { 'data-target' => '#modal-upload-blob', 'data-toggle' => 'modal'} do 
 icon('file fw') 
 end 
 link_to '#modal-create-new-dir', { 'data-target' => '#modal-create-new-dir', 'data-toggle' => 'modal'} do 
 icon('folder fw') 
 end 
 elsif can?(current_user, :fork_project, @project) 
 continue_params = { to:         namespace_project_new_blob_path(@project.namespace, @project, @id),                                      notice:     edit_in_new_fork_notice,                                      notice_now: edit_in_new_fork_notice_now } 
 fork_path = namespace_project_forks_path(@project.namespace, @project, namespace_key:  current_user.namespace.id,                                                                                        continue:       continue_params) 
 link_to fork_path, method: :post do 
 icon('pencil fw') 
 end 
 continue_params = { to:         request.fullpath,                                      notice:     edit_in_new_fork_notice + " Try to upload a file again.",                                      notice_now: edit_in_new_fork_notice_now } 
 fork_path = namespace_project_forks_path(@project.namespace, @project, namespace_key:  current_user.namespace.id,                                                                                        continue:       continue_params) 
 link_to fork_path, method: :post do 
 icon('file fw') 
 end 
 continue_params = { to:         request.fullpath,                                      notice:     edit_in_new_fork_notice + " Try to create a new directory again.",                                      notice_now: edit_in_new_fork_notice_now } 
 fork_path = namespace_project_forks_path(@project.namespace, @project, namespace_key:  current_user.namespace.id,                                                                                        continue:       continue_params) 
 link_to fork_path, method: :post do 
 icon('folder fw') 
 end 
 end 
 link_to new_namespace_project_branch_path(@project.namespace, @project) do 
 icon('code-fork fw') 
 end 
 link_to new_namespace_project_tag_path(@project.namespace, @project) do 
 icon('tags fw') 
 end 
 end 
 end 
 
  link_to @commit.short_id, namespace_project_commit_path(@project.namespace, @project, @commit), class: "monospace" 
 truncate(@commit.title, length: 50) 
 link_to 'History', namespace_project_commits_path(@project.namespace, @project, @id), class: 'pull-right' 
 if @path.present? 
 link_to "..", namespace_project_tree_path(@project.namespace, @project, up_dir_path), class: 'prepend-left-10' 
 end 
 render_tree(tree) 
 if tree.readme 
  blob_icon readme.mode, readme.name 
 link_to namespace_project_blob_path(@project.namespace, @project, tree_join(@repository.root_ref, @path, readme.name)) do 
 readme.name 
 end 
 render_readme(readme) 
 
 end 
 if can_edit_tree? 
  form_tag form_path, method: method, class: 'js-quick-submit js-upload-blob-form form-horizontal' do 
 link_to 'click to upload', '#', class: "markdown-selector" 
   nonce = SecureRandom.hex 
 label_tag "commit_message-", class: 'control-label' do 
 end 
 text_area_tag 'commit_message',          (params[:commit_message] ),          class: 'form-control js-commit-message', placeholder: local_assigns[:placeholder],          required: true, rows: (local_assigns[:rows] ),          id: "commit_message-" 
 if local_assigns[:hint] 
 end 
 
 if @project.empty_repo? 
 hidden_field_tag 'target_branch', @ref 
 else 
 if can?(current_user, :push_code, @project) 
 label_tag 'target_branch', 'Target branch', class: 'control-label' 
 text_field_tag 'target_branch', @target_branch , required: true, class: "form-control js-target-branch" 
 nonce = SecureRandom.hex 
 label_tag "create_merge_request-" do 
 check_box_tag 'create_merge_request', 1, true, class: 'js-create-merge-request', id: "create_merge_request-" 
 end 
 else 
 hidden_field_tag 'target_branch', @target_branch || tree_edit_branch 
 hidden_field_tag 'create_merge_request', 1 
 end 
 hidden_field_tag 'original_branch', @ref, class: 'js-original-branch' 
 end 
 
 button_tag button_title, class: 'btn btn-small btn-create btn-upload-file', id: 'submit-all' 
 link_to "Cancel", '#', class: "btn btn-cancel", "data-dismiss" => "modal" 
 unless can?(current_user, :push_code, @project) 
 commit_in_fork_help 
 end 
 end 
 
 end 
 
 
 yield :scripts_body 
 

end

  end

  def create_dir
    return render_404 unless @commit_params.values.all?

    create_commit(Files::CreateDirService,  success_notice: "The directory has been successfully created.",
                                            success_path: namespace_project_tree_path(@project.namespace, @project, File.join(@target_branch, @dir_name)),
                                            failure_path: namespace_project_tree_path(@project.namespace, @project, @ref))
  end

  private

  def assign_dir_vars
    @target_branch = params[:target_branch]

    @dir_name = File.join(@path, params[:dir_name])
    @commit_params = {
      file_path: @dir_name,
      commit_message: params[:commit_message],
    }
  end
end
