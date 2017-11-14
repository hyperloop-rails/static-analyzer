class Projects::BuildsController < Projects::ApplicationController
  before_action :build, except: [:index, :cancel_all]
  before_action :authorize_read_build!, except: [:cancel, :cancel_all, :retry]
  before_action :authorize_update_build!, except: [:index, :show, :status, :raw]
  layout 'project'

  def index
    @scope = params[:scope]
    @all_builds = project.builds
    @builds = @all_builds.order('created_at DESC')
    @builds =
      case @scope
      when 'running'
        @builds.running_or_pending.reverse_order
      when 'finished'
        @builds.finished
      else
        @builds
      end
    @builds = @builds.page(params[:page]).per(30)
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
 yield :meta_tags 
  
  
  
  
 
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
 page_title "Builds" 
  header_title project_title(@project, "Builds", project_builds_path(@project)) 
 
 ('active' if @scope.nil?) 
 link_to project_builds_path(@project) do 
 number_with_delimiter(@all_builds.count(:id)) 
 end 
 ('active' if @scope == 'running') 
 link_to project_builds_path(@project, scope: :running) do 
 number_with_delimiter(@all_builds.running_or_pending.count(:id)) 
 end 
 ('active' if @scope == 'finished') 
 link_to project_builds_path(@project, scope: :finished) do 
 number_with_delimiter(@all_builds.finished.count(:id)) 
 end 
 if can?(current_user, :update_build, @project) 
 if @all_builds.running_or_pending.any? 
 link_to 'Cancel running', cancel_all_namespace_project_builds_path(@project.namespace, @project),          data: { confirm: 'Are you sure?' }, class: 'btn btn-danger', method: :post 
 end 
 unless @repository.gitlab_ci_yml 
 link_to 'Get started with Builds', help_page_path('ci/quick_start', 'README'), class: 'btn btn-info' 
 end 
 link_to ci_lint_path, class: 'btn btn-default' do 
 icon('wrench') 
 end 
 end 
 if @builds.blank? 
 else 
 if @project.build_coverage_enabled? 
 end 
  project = build.project 
 ci_status_with_icon(build.status) 
 if can?(current_user, :read_build, build.project) 
 link_to namespace_project_build_url(build.project.namespace, build.project, build) do 
 end 
 else 
 end 
 if build.stuck? 
 end 
 if project 
 link_to project.name_with_namespace, admin_namespace_project_path(project.namespace, project) 
 end 
 link_to build.short_sha, namespace_project_commit_path(build.project.namespace, build.project, build.sha), class: "monospace" 
 if build.ref 
 link_to build.ref, namespace_project_commits_path(build.project.namespace, build.project, build.ref) 
 else 
 end 
 if build.try(:runner) 
 runner_link(build.runner) 
 else 
 end 
 if build.tags.any? 
 build.tags.each do |tag| 
 tag 
 end 
 end 
 if build.try(:trigger_request) 
 end 
 if build.try(:allow_failure) 
 end 
 if build.duration 
 if build.finished_at 
 end 
 if defined?(coverage) && coverage 
 if build.try(:coverage) 
 end 
 end 
 if can?(current_user, :read_build, project) && build.artifacts? 
 link_to download_namespace_project_build_artifacts_path(build.project.namespace, build.project, build), title: 'Download artifacts', class: 'btn btn-build' do 
 end 
 end 
 if can?(current_user, :update_build, build.project) 
 if build.active? 
 link_to cancel_namespace_project_build_path(build.project.namespace, build.project, build, return_to: request.original_url), method: :post, title: 'Cancel', class: 'btn btn-build' do 
 end 
 elsif defined?(allow_retry) && allow_retry && build.retryable? 
 link_to retry_namespace_project_build_path(build.project.namespace, build.project, build, return_to: request.original_url), method: :post, title: 'Retry', class: 'btn btn-build' do 
 end 
 end 
 end 
end
 
 paginate @builds, theme: 'gitlab' 
 end 
 
 yield :scripts_body 
 

end

  end

  def cancel_all
    @project.builds.running_or_pending.each(&:cancel)
    redirect_to namespace_project_builds_path(project.namespace, project)
  end

  def show
    @builds = @project.ci_commits.find_by_sha(@build.sha).builds.order('id DESC')
    @builds = @builds.where("id not in (?)", @build.id)
    @commit = @build.commit

    respond_to do |format|
      format.html
      format.json do
        render json: @build.to_json(methods: :trace_html)
      end
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
 yield :meta_tags 
  
  
  
  
 
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
 page_title " (#)", "Builds" 
  header_title project_title(@project, "Builds", project_builds_path(@project)) 
 
 link_to @build.commit.short_sha, ci_status_path(@build.commit) 
 link_to @build.ref, namespace_project_commits_path(@project.namespace, @project, @build.ref) 
 merge_request = @build.merge_request 
 if merge_request 
 link_to "merge request ", merge_request_path(merge_request) 
 end 
 builds = @build.commit.builds.latest.to_a 
 if builds.size > 1 
 builds.each do |build| 
 ('active' if build == @build) 
 link_to namespace_project_build_path(@project.namespace, @project, build) do 
 ci_icon_for_status(build.status) 
 if build.name 
 build.name 
 else 
 build.id 
 end 
 end 
 end 
 if @build.retried? 
 end 
 end 
 ci_status_with_icon(@build.status) 
 if @build.duration 
 end 
 if @build.stuck? 
 unless @build.any_runners_online? 
 if no_runners_for_project?(@build.project) 
 elsif @build.tags.any? 
 @build.tags.each do |tag| 
 tag 
 end 
 else 
 end 
 link_to namespace_project_runners_path(@build.project.namespace, @build.project) do 
 end 
 end 
 end 
 if @build.active? 
 end 
 link_to '#up-build-trace', class: 'btn' do 
 end 
 link_to '#down-build-trace', class: 'btn' do 
 end 
 if @build.erased? 
 erased_by = "by " if @build.erased_by 
 else 
 preserve do 
 raw @build.trace_html 
 end 
 end 
 if @build.coverage 
 end 
 if can?(current_user, :read_build, @project) && @build.artifacts? 
 :group 
 link_to download_namespace_project_build_artifacts_path(@project.namespace, @project, @build), class: 'btn btn-sm btn-primary' do 
 icon('download') 
 end 
 if @build.artifacts_metadata? 
 link_to browse_namespace_project_build_artifacts_path(@project.namespace, @project, @build), class: 'btn btn-sm btn-primary' do 
 icon('folder-open') 
 end 
 end 
 end 
 if can?(current_user, :update_build, @project) 
 :group 
 if @build.active? 
 link_to "Cancel", cancel_namespace_project_build_path(@project.namespace, @project, @build), class: 'btn btn-sm btn-danger', method: :post 
 elsif @build.retryable? 
 link_to "Retry", retry_namespace_project_build_path(@project.namespace, @project, @build), class: 'btn btn-sm btn-primary', method: :post 
 end 
 if @build.erasable? 
 link_to erase_namespace_project_build_path(@project.namespace, @project, @build),                            class: 'btn btn-sm btn-warning', method: :post,                            data: { confirm: 'Are you sure you want to erase this build?' } do 
 icon('eraser') 
 end 
 end 
 if @build.has_trace? 
 link_to 'Raw', raw_namespace_project_build_path(@project.namespace, @project, @build),                            class: 'btn btn-sm btn-success', target: '_blank' 
 end 
 end 
 if @build.duration 
 end 
 if @build.finished_at 
 end 
 if @build.erased_at 
 end 
 if @build.runner && current_user && current_user.admin 
 link_to "#", admin_runner_path(@build.runner.id) 
 elsif @build.runner 
 end 
 if @build.trigger_request 
 if @build.trigger_request.variables 
 @build.trigger_request.variables.each do |key, value| 
 end 
 end 
 link_to @build.commit.short_sha, ci_status_path(@build.commit), class: "monospace" 
 link_to @build.ref, namespace_project_commits_path(@project.namespace, @project, @build.ref) 
 end 
 if @build.tags.any? 
 @build.tag_list.each do |tag| 
 tag 
 end 
 end 
 if @builds.present? 
 succeed ":" do 
 link_to @build.commit.short_sha, ci_status_path(@build.commit), class: "monospace" 
 end 
 @builds.each_with_index do |build, i| 
 ci_icon_for_status(build.status) 
 link_to namespace_project_build_path(@project.namespace, @project, build) do 
 if build.name 
 build.name 
 else 
 end 
 end 
 build.status 
 end 
 end 
 
 yield :scripts_body 
 

end

  end

  def retry
    unless @build.retryable?
      return render_404
    end

    build = Ci::Build.retry(@build)
    redirect_to build_path(build)
  end

  def cancel
    @build.cancel
    redirect_to build_path(@build)
  end

  def status
    render json: @build.to_json(only: [:status, :id, :sha, :coverage], methods: :sha)
  end

  def erase
    @build.erase(erased_by: current_user)
    redirect_to namespace_project_build_path(project.namespace, project, @build),
                notice: "Build has been sucessfully erased!"
  end

  def raw
    if @build.has_trace?
      send_file @build.path_to_trace, type: 'text/plain; charset=utf-8', disposition: 'inline'
    else
      render_404
    end
  end

  private

  def build
    @build ||= project.builds.unscoped.find_by!(id: params[:id])
  end

  def build_path(build)
    namespace_project_build_path(build.project.namespace, build.project, build)
  end
end
