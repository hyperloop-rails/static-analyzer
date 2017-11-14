class Projects::ProjectMembersController < Projects::ApplicationController
  # Authorize
  before_action :authorize_admin_project_member!, except: [:leave, :index]

  def index
    @project_members = @project.project_members
    @project_members = @project_members.non_invite unless can?(current_user, :admin_project, @project)

    if params[:search].present?
      users = @project.users.search(params[:search]).to_a
      @project_members = @project_members.where(user_id: users)
    end

    @project_members = @project_members.order('access_level DESC')

    @group = @project.group
    if @group
      @group_members = @group.group_members
      @group_members = @group_members.non_invite unless can?(current_user, :admin_group, @group)

      if params[:search].present?
        users = @group.users.search(params[:search]).to_a
        @group_members = @group_members.where(user_id: users)
      end

      @group_members = @group_members.order('access_level DESC')
    end

    @project_member = @project.project_members.new
    @project_group_links = @project.project_group_links
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
 page_title "Members" 
  header_title project_title(@project, "Members", namespace_project_project_members_path(@project.namespace, @project)) 
 
 if can?(current_user, :admin_project_member, @project) 
 link_to import_namespace_project_project_members_path(@project.namespace, @project), class: "btn btn-grouped", title: "Import members from another project" do 
 end 
  form_for @project_member, as: :project_member, url: namespace_project_project_members_path(@project.namespace, @project), html: { class: 'form-horizontal users-project-form' } do |f| 
 f.label :user_ids, "People", class: 'control-label' 
 users_select_tag(:user_ids, multiple: true, class: 'input-large', scope: :all, email_user: true) 
 f.label :access_level, "Project Access", class: 'control-label' 
 select_tag :access_level, options_for_select(ProjectMember.access_roles, @project_member.access_level), class: "project-access-select select2" 
 link_to "here", help_page_path("permissions", "permissions"), class: "vlink" 
 f.submit 'Add users to project', class: "btn btn-create" 
 end 
 
 end 
  form_tag namespace_project_project_members_path(@project.namespace, @project), method: :get, class: 'form-inline member-search-form'  do 
 search_field_tag :search, params[:search], { placeholder: 'Find existing member by name', class: 'form-control', spellcheck: false } 
 button_tag class: 'btn', title: 'Search' do 
 icon("search") 
 end 
 end 
 members.each do |project_member| 
  user = member.user 
 return unless user || member.invite? 
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
 if can?(current_user, :admin_project_member, @project) 
 link_to resend_invite_namespace_project_project_member_path(@project.namespace, @project, member), method: :post, class: "btn-xs btn", title: 'Resend invite' do 
 end 
 end 
 end 
 if can?(current_user, :admin_project_member, @project) 
 member.human_access 
 if can?(current_user, :update_project_member, member) 
 button_tag class: "btn-xs btn js-toggle-button",                     title: 'Edit access level', type: 'button' do 
 end 
 end 
 if can?(current_user, :destroy_project_member, member) 
 if current_user == user 
 link_to leave_namespace_project_project_members_path(@project.namespace, @project), data: { confirm: leave_project_message(@project) }, method: :delete, class: "btn-xs btn btn-remove", title: 'Leave project' do 
 icon("sign-out") 
 end 
 else 
 link_to namespace_project_project_member_path(@project.namespace, @project, member), data: { confirm: remove_from_project_team_message(@project, member) }, method: :delete, remote: true, class: "btn-xs btn btn-remove", title: 'Remove user from team' do 
 end 
 end 
 end 
 form_for member, as: :project_member, url: namespace_project_project_member_path(@project.namespace, @project, member), remote: true do |f| 
 f.select :access_level, options_for_select(ProjectMember.access_roles, member.access_level), {}, class: 'form-control' 
 f.submit 'Save', class: 'btn btn-save' 
 end 
 end 
 
 end 
 
 if @group 
  if can?(current_user, :admin_group_member, @group) 
 link_to group_group_members_path(@group), class: 'btn' do 
 icon('pencil-square-o') 
 end 
 end 
 members.limit(20).each do |member| 
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
 if members.count > 20 
 end 
 
 end 
 if @project_group_links.any? && @project.allowed_to_share_with_group? 
  @project_group_links.each do |group_links| 
 shared_group = group_links.group 
 shared_group_users_count = group_links.group.group_members.count 
 if can?(current_user, :admin_group, shared_group) 
 link_to group_group_members_path(shared_group), class: 'btn btn-sm' do 
 end 
 end 
 shared_group.group_members.order('access_level DESC').limit(20).each do |member| 
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
 if shared_group_users_count > 20 
 end 
 end 
 
 end 
 
 yield :scripts_body 
 

end

  end

  def create
    @project.team.add_users(params[:user_ids].split(','), params[:access_level], current_user)

    redirect_to namespace_project_project_members_path(@project.namespace, @project)
  end

  def update
    @project_member = @project.project_members.find(params[:id])

    return render_403 unless can?(current_user, :update_project_member, @project_member)

    @project_member.update_attributes(member_params)
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
 
 yield :scripts_body 
 

end

  end

  def destroy
    @project_member = @project.project_members.find(params[:id])

    return render_403 unless can?(current_user, :destroy_project_member, @project_member)

    @project_member.destroy

    respond_to do |format|
      format.html do
        redirect_to namespace_project_project_members_path(@project.namespace, @project)
      end
      format.js { render nothing: true }
    end
  end

  def resend_invite
    redirect_path = namespace_project_project_members_path(@project.namespace, @project)

    @project_member = @project.project_members.find(params[:id])

    if @project_member.invite?
      @project_member.resend_invite

      redirect_to redirect_path, notice: 'The invitation was successfully resent.'
    else
      redirect_to redirect_path, alert: 'The invitation has already been accepted.'
    end
  end

  def leave
    @project_member = @project.project_members.find_by(user_id: current_user)

    if can?(current_user, :destroy_project_member, @project_member)
      @project_member.destroy

      respond_to do |format|
        format.html { redirect_to dashboard_projects_path, notice: "You left the project." }
        format.js { render nothing: true }
      end
    else
      if current_user == @project.owner
        message = 'You can not leave your own project. Transfer or delete the project.'
        redirect_back_or_default(default: { action: 'index' }, options: { alert: message })
      else
        render_403
      end
    end
  end

  def apply_import
    source_project = Project.find(params[:source_project_id])

    if can?(current_user, :read_project_member, source_project)
      status = @project.team.import(source_project, current_user)
      notice = status ? "Successfully imported" : "Import failed"
    else
      return render_404
    end

    redirect_to(namespace_project_project_members_path(project.namespace, project),
                notice: notice)
  end

  protected

  def member_params
    params.require(:project_member).permit(:user_id, :access_level)
  end
end
