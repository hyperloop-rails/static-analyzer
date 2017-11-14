class Admin::ProjectsController < Admin::ApplicationController
  before_action :project, only: [:show, :transfer, :repository_check]
  before_action :group, only: [:show, :transfer]

  def index
    @projects = Project.all
    @projects = @projects.in_namespace(params[:namespace_id]) if params[:namespace_id].present?
    @projects = @projects.where("projects.visibility_level IN (?)", params[:visibility_levels]) if params[:visibility_levels].present?
    @projects = @projects.with_push if params[:with_push].present?
    @projects = @projects.abandoned if params[:abandoned].present?
    @projects = @projects.where(last_repository_check_failed: true) if params[:last_repository_check_failed].present?
    @projects = @projects.non_archived unless params[:with_archived].present?
    @projects = @projects.search(params[:name]) if params[:name].present?
    @projects = @projects.sort(@sort = params[:sort])
    @projects = @projects.includes(:namespace).order("namespaces.path, projects.name ASC").page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title    "Admin Area" 
 header_title  "Admin Area", admin_root_path 
 sidebar       "admin" 
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
 page_title "Projects" 
  link_to '#aside', class: 'show-aside' do 
 end 
 
 form_tag admin_namespaces_projects_path, method: :get, class: '' do 
 label_tag :name, 'Name:' 
 text_field_tag :name, params[:name], class: "form-control" 
 label_tag :namespace_id, "Namespace" 
 namespace_select_tag :namespace_id, selected: params[:namespace_id], class: 'input-large' 
 label_tag :with_push do 
 check_box_tag :with_push, 1, params[:with_push] 
 end 
 label_tag :abandoned do 
 check_box_tag :abandoned, 1, params[:abandoned] 
 end 
 label_tag :with_archived do 
 check_box_tag :with_archived, 1, params[:with_archived] 
 end 
 Project.visibility_levels.each do |label, level| 
 check_box_tag 'visibility_levels[]', level, params[:visibility_levels].present? && params[:visibility_levels].include?(level.to_s) 
 visibility_level_icon(level) 
 label 
 end 
 label_tag :last_repository_check_failed do 
 check_box_tag :last_repository_check_failed, 1, params[:last_repository_check_failed] 
 end 
 hidden_field_tag :sort, params[:sort] 
 button_tag "Search", class: "btn submit btn-primary" 
 link_to "Reset", admin_namespaces_projects_path, class: "btn btn-cancel" 
 end 
 if @sort.present? 
 sort_options_hash[@sort] 
 else 
 sort_title_recently_created 
 end 
 link_to admin_namespaces_projects_path(sort: sort_value_recently_created) do 
 sort_title_recently_created 
 end 
 link_to admin_namespaces_projects_path(sort: sort_value_oldest_created) do 
 sort_title_oldest_created 
 end 
 link_to admin_namespaces_projects_path(sort: sort_value_recently_updated) do 
 sort_title_recently_updated 
 end 
 link_to admin_namespaces_projects_path(sort: sort_value_oldest_updated) do 
 sort_title_oldest_updated 
 end 
 link_to admin_namespaces_projects_path(sort: sort_value_largest_repo) do 
 sort_title_largest_repo 
 end 
 link_to 'New Project', new_project_path, class: "btn btn-sm btn-success" 
 @projects.each do |project| 
 visibility_level_color(project.visibility_level) 
 visibility_level_icon(project.visibility_level) 
 link_to project.name_with_namespace, [:admin, project.namespace.becomes(Namespace), project] 
 if project.archived 
 end 
 repository_size(project) 
 link_to 'Edit', edit_namespace_project_path(project.namespace, project), id: "edit_", class: "btn btn-sm" 
 link_to 'Destroy', [project.namespace.becomes(Namespace), project], data: { confirm: remove_project_message(project) }, method: :delete, class: "btn btn-sm btn-remove" 
 end 
 if @projects.blank? 
 end 
 paginate @projects, theme: "gitlab" 
 
 yield :scripts_body 
 

end

  end

  def show
    if @group
      @group_members = @group.members.order("access_level DESC").page(params[:group_members_page])
    end

    @project_members = @project.project_members.page(params[:project_members_page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title    "Admin Area" 
 header_title  "Admin Area", admin_root_path 
 sidebar       "admin" 
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
 page_title @project.name_with_namespace, "Projects" 
 link_to edit_project_path(@project), class: "btn btn-nr pull-right" do 
 end 
 if @project.last_repository_check_failed? 
 "( ago)" 
 link_to 'repocheck.log', admin_logs_path 
 end 
 link_to @project.name, project_path(@project) 
 if @project.namespace 
 link_to @project.namespace.human_name, [:admin, @project.group || @project.owner] 
 else 
 end 
 if @project.owner 
 link_to @project.owner_name, [:admin, @project.owner] 
 else 
 end 
 @project.creator.try(:name) || '(deleted)' 
 @project.created_at.to_s(:medium) 
 link_to @project.http_url_to_repo, project_path(@project) 
 link_to @project.ssh_url_to_repo, project_path(@project) 
 if @project.repository.exists? 
 @project.repository.path_to_repo 
 repository_size(@project) 
 last_commit(@project) 
 else 
 end 
 if @project.archived? 
 end 
 visibility_level_color(@project.visibility_level) 
 visibility_level_icon(@project.visibility_level) 
 visibility_level_label(@project.visibility_level) 
 form_for @project, url: transfer_admin_namespace_project_path(@project.namespace, @project), method: :put, html: { class: 'form-horizontal' } do |f| 
 f.label :new_namespace_id, "Namespace", class: 'control-label' 
 namespace_select_tag :new_namespace_id, selected: params[:namespace_id], class: 'input-large' 
 f.submit 'Transfer', class: 'btn btn-primary' 
 end 
 form_for @project, url: repository_check_admin_namespace_project_path(@project.namespace, @project), method: :post do |f| 
 if @project.last_repository_check_at.nil? 
 else 
 @project.last_repository_check_at.to_s(:medium) + '.' 
 if @project.last_repository_check_failed? 
 succeed '.' do 
 end 
 link_to 'repocheck.log', admin_logs_path 
 else 
 end 
 end 
 link_to icon('question-circle'), help_page_path('administration', 'repository_checks') 
 f.submit 'Trigger repository check', class: 'btn btn-primary' 
 end 
 if @group 
 link_to admin_group_path(@group), class: 'btn btn-xs' do 
 end 
 @group_members.each do |member| 
  user = member.user 
 return unless user || member.invite? 
 show_roles = local_assigns.fetch(:show_roles, true) 
 ("list-item-name" if show_controls) 
 if member.user 
 image_tag avatar_icon(user, 24), class: "avatar s24", alt: '' 
 link_to user.name, user_path(user) 
 user.username 
 if user == current_user 
 end 
 if user.blocked? 
 end 
 else 
 image_tag avatar_icon(member.invite_email, 24), class: "avatar s24", alt: '' 
 member.invite_email 
 if member.created_by 
 link_to member.created_by.name, user_path(member.created_by) 
 end 
 time_ago_with_tooltip(member.created_at) 
 if show_controls && can?(current_user, :admin_group_member, @group) 
 link_to resend_invite_group_group_member_path(@group, member), method: :post, class: "btn-xs btn", title: 'Resend invite' do 
 end 
 end 
 end 
 if show_roles && should_user_see_group_roles?(current_user, @group) 
 member.human_access 
 if show_controls 
 if can?(current_user, :update_group_member, member) 
 button_tag class: "btn-xs btn js-toggle-button",                       title: 'Edit access level', type: 'button' do 
 end 
 end 
 if can?(current_user, :destroy_group_member, member) 
 if current_user == user 
 link_to leave_group_group_members_path(@group), data: { confirm: leave_group_message(@group.name)}, method: :delete, class: "btn-xs btn btn-remove", title: 'Remove user from group' do 
 icon("sign-out") 
 end 
 else 
 link_to group_group_member_path(@group, member), data: { confirm: remove_user_from_group_message(@group, member) }, method: :delete, remote: true, class: "btn-xs btn btn-remove", title: 'Remove user from group' do 
 end 
 end 
 end 
 end 
 form_for [@group, member], remote: true do |f| 
 f.select :access_level, options_for_select(GroupMember.access_level_roles, member.access_level), {}, class: 'form-control' 
 f.submit 'Save', class: 'btn btn-save btn-sm' 
 end 
 end 
 
 end 
 paginate @group_members, param_name: 'group_members_page', theme: 'gitlab' 
 end 
 link_to namespace_project_project_members_path(@project.namespace, @project), class: "btn btn-xs" do 
 end 
 @project_members.each do |project_member| 
 user = project_member.user 
 if user 
 link_to user.name, admin_user_path(user) 
 else 
 project_member.invite_email 
 end 
 if project_member.owner? 
 else 
 project_member.human_access 
 link_to namespace_project_project_member_path(@project.namespace, @project, project_member), data: { confirm: remove_from_project_team_message(@project, project_member)}, method: :delete, remote: true, class: "btn btn-sm btn-remove" do 
 end 
 end 
 end 
 paginate @project_members, param_name: 'project_members_page', theme: 'gitlab' 
 
 yield :scripts_body 
 

end

  end

  def transfer
    namespace = Namespace.find_by(id: params[:new_namespace_id])
    ::Projects::TransferService.new(@project, current_user, params.dup).execute(namespace)

    @project.reload
    redirect_to admin_namespace_project_path(@project.namespace, @project)
  end

  def repository_check
    RepositoryCheck::SingleRepositoryWorker.perform_async(@project.id)

    redirect_to(
      admin_namespace_project_path(@project.namespace, @project),
      notice: 'Repository check was triggered.'
    )
  end

  protected

  def project
    @project = Project.find_with_namespace(
      [params[:namespace_id], '/', params[:id]].join('')
    )
    @project || render_404
  end

  def group
    @group ||= @project.group
  end
end
