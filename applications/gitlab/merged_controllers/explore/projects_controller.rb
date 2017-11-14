class Explore::ProjectsController < Explore::ApplicationController
  include FilterProjects

  def index
    @projects = ProjectsFinder.new.execute(current_user)
    @tags = @projects.tags_on(:tags)
    @projects = @projects.tagged_with(params[:tag]) if params[:tag].present?
    @projects = @projects.where(visibility_level: params[:visibility_level]) if params[:visibility_level].present?
    @projects = filter_projects(@projects)
    @projects = @projects.sort(@sort = params[:sort])
    @projects = @projects.includes(:namespace).page(params[:page])

    respond_to do |format|
      format.html
      format.json do
        render json: {
          html: view_to_html_string("dashboard/projects/_projects", locals: { projects: @projects })
        }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title    "Explore" 
 unless current_user 
 header_title  "Explore GitLab", explore_root_path 
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
 
 if cookies[:hide_project_limit_message].blank? && !current_user.hide_project_limit && !current_user.can_create_project? && current_user.projects_limit > 0 
 link_to "Don't show again", profile_path(user: {hide_project_limit: true}), method: :put, class: 'alert-link' 
 link_to 'Remind later', '#', class: 'hide-project-limit-message alert-link' 
 end 
 (container_class unless @no_container) 
 page_title    "Projects" 
 header_title  "Projects", dashboard_projects_path 
 if current_user 
   
 nav_link(page: [dashboard_projects_path, root_path]) do 
 link_to dashboard_projects_path, title: 'Home', class: 'shortcuts-activity', data: {placement: 'right'} do 
 end 
 end 
 nav_link(page: starred_dashboard_projects_path) do 
 link_to starred_dashboard_projects_path, title: 'Starred Projects', data: {placement: 'right'} do 
 end 
 end 
 nav_link(page: [explore_root_path, trending_explore_projects_path, starred_explore_projects_path, explore_projects_path]) do 
 link_to explore_root_path, title: 'Explore', data: {placement: 'right'} do 
 end 
 end 
 form_tag request.original_url, method: :get, class: 'project-filter-form', id: 'project-filter-form' do |f| 
 search_field_tag :filter_projects, params[:filter_projects], placeholder: 'Filter by name...', class: 'project-filter-form-field form-control input-short projects-list-filter', spellcheck: false, id: 'project-filter-form-field', tabindex: "2" 
 end 
  @sort ||= sort_value_recently_updated 
 personal = params[:personal] 
 archived = params[:archived] 
 projects_sort_options_hash[@sort] 
 projects_sort_options_hash.each do |value, title| 
 link_to filter_projects_path(sort: value, archived: archived, personal: personal), class: ("is-active" if @sort == value) do 
 title 
 end 
 end 
 link_to filter_projects_path(sort: @sort, archived: nil), class: ("is-active" unless params[:archived].present?) do 
 end 
 link_to filter_projects_path(sort: @sort, archived: true), class: ("is-active" if params[:archived].present?) do 
 end 
 if current_user 
 link_to filter_projects_path(sort: @sort, personal: nil), class: ("is-active" unless personal) do 
 end 
 link_to filter_projects_path(sort: @sort, personal: true), class: ("is-active" if personal) do 
 end 
 end 
 
 if current_user.can_create_project? 
 link_to new_project_path, class: 'btn btn-new' do 
 icon('plus') 
 end 
 end 
 
 else 
  
 end 
  nav_link(page: [trending_explore_projects_path, explore_root_path]) do 
 link_to trending_explore_projects_path do 
 end 
 end 
 nav_link(page: starred_explore_projects_path) do 
 link_to starred_explore_projects_path do 
 end 
 end 
 nav_link(page: explore_projects_path) do 
 link_to explore_projects_path do 
 end 
 end 
 
  if current_user 
 icon('globe') 
 if params[:visibility_level].present? 
 visibility_level_label(params[:visibility_level].to_i) 
 else 
 end 
 link_to filter_projects_path(visibility_level: nil) do 
 end 
 Gitlab::VisibilityLevel.values.each do |level| 
 link_to filter_projects_path(visibility_level: level) do 
 visibility_level_icon(level) 
 visibility_level_label(level) 
 end 
 end 
 end 
 if @tags.present? 
 icon('tags') 
 if params[:tag].present? 
 params[:tag] 
 else 
 end 
 link_to filter_projects_path(tag: nil) do 
 end 
 @tags.each do |tag| 
 link_to filter_projects_path(tag: tag.name) do 
 icon('tag') 
 tag.name 
 end 
 end 
 end 
 
   projects_limit = 20 unless local_assigns[:projects_limit] 
 avatar = true unless local_assigns[:avatar] == false 
 use_creator_avatar = false unless local_assigns[:use_creator_avatar] == true 
 stars = true unless local_assigns[:stars] == false 
 forks = false unless local_assigns[:forks] == true 
 ci = false unless local_assigns[:ci] == true 
 skip_namespace = false unless local_assigns[:skip_namespace] == true 
 show_last_commit_as_description = false unless local_assigns[:show_last_commit_as_description] == true 
 remote = false unless local_assigns[:remote] == true 
 if projects.any? 
 projects.each_with_index do |project, i| 
 css_class = (i >= projects_limit) ? 'hide' : nil 
  avatar = true unless local_assigns[:avatar] == false 
 stars = true unless local_assigns[:stars] == false 
 forks = false unless local_assigns[:forks] == true 
 ci = false unless local_assigns[:ci] == true 
 skip_namespace = false unless local_assigns[:skip_namespace] == true 
 css_class = '' unless local_assigns[:css_class] 
 show_last_commit_as_description = false unless local_assigns[:show_last_commit_as_description] == true && project.commit 
 css_class += " no-description" if project.description.blank? && !show_last_commit_as_description 
 cache_key = [project.namespace, project, controller.controller_name, controller.action_name, current_application_settings, 'v2.3'] 
 cache_key.push(project.commit.status) if project.commit.try(:status) 
 css_class 
 cache(cache_key) do 
 if project.main_language 
 project.main_language 
 end 
 if project.commit.try(:status) 
 render_ci_status(project.commit) 
 end 
 if forks 
 icon('code-fork') 
 project.forks_count 
 end 
 if stars 
 icon('star') 
 project.star_count 
 end 
 visibility_level_icon(project.visibility_level, fw: false) 
 link_to project_path(project), class: dom_class(project) do 
 if avatar 
 if use_creator_avatar 
 image_tag avatar_icon(project.creator.email, 40), class: "avatar s40", alt:'' 
 else 
 project_icon(project, alt: '', class: 'avatar project-avatar s40') 
 end 
 end 
 if project.namespace && !skip_namespace 
 project.namespace.human_name 
 end 
 project.name 
 end 
 if show_last_commit_as_description 
 link_to_gfm project.commit.title, namespace_project_commit_path(project.namespace, project, project.commit),          class: "commit-row-message" 
 elsif project.description.present? 
 markdown(project.description, pipeline: :description) 
 end 
 end 
 
 end 
 paginate(projects, remote: remote, theme: "gitlab") if projects.respond_to? :total_pages 
 else 
 end 
 
 
 
 yield :scripts_body 
 

end

  end

  def trending
    @projects = TrendingProjectsFinder.new.execute(current_user)
    @projects = filter_projects(@projects)
    @projects = @projects.page(params[:page])

    respond_to do |format|
      format.html
      format.json do
        render json: {
          html: view_to_html_string("dashboard/projects/_projects", locals: { projects: @projects })
        }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title    "Explore" 
 unless current_user 
 header_title  "Explore GitLab", explore_root_path 
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
 
 if cookies[:hide_project_limit_message].blank? && !current_user.hide_project_limit && !current_user.can_create_project? && current_user.projects_limit > 0 
 link_to "Don't show again", profile_path(user: {hide_project_limit: true}), method: :put, class: 'alert-link' 
 link_to 'Remind later', '#', class: 'hide-project-limit-message alert-link' 
 end 
 (container_class unless @no_container) 
 page_title    "Projects" 
 header_title  "Projects", dashboard_projects_path 
 if current_user 
   
 nav_link(page: [dashboard_projects_path, root_path]) do 
 link_to dashboard_projects_path, title: 'Home', class: 'shortcuts-activity', data: {placement: 'right'} do 
 end 
 end 
 nav_link(page: starred_dashboard_projects_path) do 
 link_to starred_dashboard_projects_path, title: 'Starred Projects', data: {placement: 'right'} do 
 end 
 end 
 nav_link(page: [explore_root_path, trending_explore_projects_path, starred_explore_projects_path, explore_projects_path]) do 
 link_to explore_root_path, title: 'Explore', data: {placement: 'right'} do 
 end 
 end 
 form_tag request.original_url, method: :get, class: 'project-filter-form', id: 'project-filter-form' do |f| 
 search_field_tag :filter_projects, params[:filter_projects], placeholder: 'Filter by name...', class: 'project-filter-form-field form-control input-short projects-list-filter', spellcheck: false, id: 'project-filter-form-field', tabindex: "2" 
 end 
  @sort ||= sort_value_recently_updated 
 personal = params[:personal] 
 archived = params[:archived] 
 projects_sort_options_hash[@sort] 
 projects_sort_options_hash.each do |value, title| 
 link_to filter_projects_path(sort: value, archived: archived, personal: personal), class: ("is-active" if @sort == value) do 
 title 
 end 
 end 
 link_to filter_projects_path(sort: @sort, archived: nil), class: ("is-active" unless params[:archived].present?) do 
 end 
 link_to filter_projects_path(sort: @sort, archived: true), class: ("is-active" if params[:archived].present?) do 
 end 
 if current_user 
 link_to filter_projects_path(sort: @sort, personal: nil), class: ("is-active" unless personal) do 
 end 
 link_to filter_projects_path(sort: @sort, personal: true), class: ("is-active" if personal) do 
 end 
 end 
 
 if current_user.can_create_project? 
 link_to new_project_path, class: 'btn btn-new' do 
 icon('plus') 
 end 
 end 
 
 else 
  
 end 
  nav_link(page: [trending_explore_projects_path, explore_root_path]) do 
 link_to trending_explore_projects_path do 
 end 
 end 
 nav_link(page: starred_explore_projects_path) do 
 link_to starred_explore_projects_path do 
 end 
 end 
 nav_link(page: explore_projects_path) do 
 link_to explore_projects_path do 
 end 
 end 
 
   projects_limit = 20 unless local_assigns[:projects_limit] 
 avatar = true unless local_assigns[:avatar] == false 
 use_creator_avatar = false unless local_assigns[:use_creator_avatar] == true 
 stars = true unless local_assigns[:stars] == false 
 forks = false unless local_assigns[:forks] == true 
 ci = false unless local_assigns[:ci] == true 
 skip_namespace = false unless local_assigns[:skip_namespace] == true 
 show_last_commit_as_description = false unless local_assigns[:show_last_commit_as_description] == true 
 remote = false unless local_assigns[:remote] == true 
 if projects.any? 
 projects.each_with_index do |project, i| 
 css_class = (i >= projects_limit) ? 'hide' : nil 
  avatar = true unless local_assigns[:avatar] == false 
 stars = true unless local_assigns[:stars] == false 
 forks = false unless local_assigns[:forks] == true 
 ci = false unless local_assigns[:ci] == true 
 skip_namespace = false unless local_assigns[:skip_namespace] == true 
 css_class = '' unless local_assigns[:css_class] 
 show_last_commit_as_description = false unless local_assigns[:show_last_commit_as_description] == true && project.commit 
 css_class += " no-description" if project.description.blank? && !show_last_commit_as_description 
 cache_key = [project.namespace, project, controller.controller_name, controller.action_name, current_application_settings, 'v2.3'] 
 cache_key.push(project.commit.status) if project.commit.try(:status) 
 css_class 
 cache(cache_key) do 
 if project.main_language 
 project.main_language 
 end 
 if project.commit.try(:status) 
 render_ci_status(project.commit) 
 end 
 if forks 
 icon('code-fork') 
 project.forks_count 
 end 
 if stars 
 icon('star') 
 project.star_count 
 end 
 visibility_level_icon(project.visibility_level, fw: false) 
 link_to project_path(project), class: dom_class(project) do 
 if avatar 
 if use_creator_avatar 
 image_tag avatar_icon(project.creator.email, 40), class: "avatar s40", alt:'' 
 else 
 project_icon(project, alt: '', class: 'avatar project-avatar s40') 
 end 
 end 
 if project.namespace && !skip_namespace 
 project.namespace.human_name 
 end 
 project.name 
 end 
 if show_last_commit_as_description 
 link_to_gfm project.commit.title, namespace_project_commit_path(project.namespace, project, project.commit),          class: "commit-row-message" 
 elsif project.description.present? 
 markdown(project.description, pipeline: :description) 
 end 
 end 
 
 end 
 paginate(projects, remote: remote, theme: "gitlab") if projects.respond_to? :total_pages 
 else 
 end 
 
 
 
 yield :scripts_body 
 

end

  end

  def starred
    @projects = ProjectsFinder.new.execute(current_user)
    @projects = filter_projects(@projects)
    @projects = @projects.reorder('star_count DESC')
    @projects = @projects.page(params[:page])

    respond_to do |format|
      format.html
      format.json do
        render json: {
          html: view_to_html_string("dashboard/projects/_projects", locals: { projects: @projects })
        }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title    "Explore" 
 unless current_user 
 header_title  "Explore GitLab", explore_root_path 
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
 
 if cookies[:hide_project_limit_message].blank? && !current_user.hide_project_limit && !current_user.can_create_project? && current_user.projects_limit > 0 
 link_to "Don't show again", profile_path(user: {hide_project_limit: true}), method: :put, class: 'alert-link' 
 link_to 'Remind later', '#', class: 'hide-project-limit-message alert-link' 
 end 
 (container_class unless @no_container) 
 page_title    "Projects" 
 header_title  "Projects", dashboard_projects_path 
 if current_user 
   
 nav_link(page: [dashboard_projects_path, root_path]) do 
 link_to dashboard_projects_path, title: 'Home', class: 'shortcuts-activity', data: {placement: 'right'} do 
 end 
 end 
 nav_link(page: starred_dashboard_projects_path) do 
 link_to starred_dashboard_projects_path, title: 'Starred Projects', data: {placement: 'right'} do 
 end 
 end 
 nav_link(page: [explore_root_path, trending_explore_projects_path, starred_explore_projects_path, explore_projects_path]) do 
 link_to explore_root_path, title: 'Explore', data: {placement: 'right'} do 
 end 
 end 
 form_tag request.original_url, method: :get, class: 'project-filter-form', id: 'project-filter-form' do |f| 
 search_field_tag :filter_projects, params[:filter_projects], placeholder: 'Filter by name...', class: 'project-filter-form-field form-control input-short projects-list-filter', spellcheck: false, id: 'project-filter-form-field', tabindex: "2" 
 end 
  @sort ||= sort_value_recently_updated 
 personal = params[:personal] 
 archived = params[:archived] 
 projects_sort_options_hash[@sort] 
 projects_sort_options_hash.each do |value, title| 
 link_to filter_projects_path(sort: value, archived: archived, personal: personal), class: ("is-active" if @sort == value) do 
 title 
 end 
 end 
 link_to filter_projects_path(sort: @sort, archived: nil), class: ("is-active" unless params[:archived].present?) do 
 end 
 link_to filter_projects_path(sort: @sort, archived: true), class: ("is-active" if params[:archived].present?) do 
 end 
 if current_user 
 link_to filter_projects_path(sort: @sort, personal: nil), class: ("is-active" unless personal) do 
 end 
 link_to filter_projects_path(sort: @sort, personal: true), class: ("is-active" if personal) do 
 end 
 end 
 
 if current_user.can_create_project? 
 link_to new_project_path, class: 'btn btn-new' do 
 icon('plus') 
 end 
 end 
 
 else 
  
 end 
  nav_link(page: [trending_explore_projects_path, explore_root_path]) do 
 link_to trending_explore_projects_path do 
 end 
 end 
 nav_link(page: starred_explore_projects_path) do 
 link_to starred_explore_projects_path do 
 end 
 end 
 nav_link(page: explore_projects_path) do 
 link_to explore_projects_path do 
 end 
 end 
 
   projects_limit = 20 unless local_assigns[:projects_limit] 
 avatar = true unless local_assigns[:avatar] == false 
 use_creator_avatar = false unless local_assigns[:use_creator_avatar] == true 
 stars = true unless local_assigns[:stars] == false 
 forks = false unless local_assigns[:forks] == true 
 ci = false unless local_assigns[:ci] == true 
 skip_namespace = false unless local_assigns[:skip_namespace] == true 
 show_last_commit_as_description = false unless local_assigns[:show_last_commit_as_description] == true 
 remote = false unless local_assigns[:remote] == true 
 if projects.any? 
 projects.each_with_index do |project, i| 
 css_class = (i >= projects_limit) ? 'hide' : nil 
  avatar = true unless local_assigns[:avatar] == false 
 stars = true unless local_assigns[:stars] == false 
 forks = false unless local_assigns[:forks] == true 
 ci = false unless local_assigns[:ci] == true 
 skip_namespace = false unless local_assigns[:skip_namespace] == true 
 css_class = '' unless local_assigns[:css_class] 
 show_last_commit_as_description = false unless local_assigns[:show_last_commit_as_description] == true && project.commit 
 css_class += " no-description" if project.description.blank? && !show_last_commit_as_description 
 cache_key = [project.namespace, project, controller.controller_name, controller.action_name, current_application_settings, 'v2.3'] 
 cache_key.push(project.commit.status) if project.commit.try(:status) 
 css_class 
 cache(cache_key) do 
 if project.main_language 
 project.main_language 
 end 
 if project.commit.try(:status) 
 render_ci_status(project.commit) 
 end 
 if forks 
 icon('code-fork') 
 project.forks_count 
 end 
 if stars 
 icon('star') 
 project.star_count 
 end 
 visibility_level_icon(project.visibility_level, fw: false) 
 link_to project_path(project), class: dom_class(project) do 
 if avatar 
 if use_creator_avatar 
 image_tag avatar_icon(project.creator.email, 40), class: "avatar s40", alt:'' 
 else 
 project_icon(project, alt: '', class: 'avatar project-avatar s40') 
 end 
 end 
 if project.namespace && !skip_namespace 
 project.namespace.human_name 
 end 
 project.name 
 end 
 if show_last_commit_as_description 
 link_to_gfm project.commit.title, namespace_project_commit_path(project.namespace, project, project.commit),          class: "commit-row-message" 
 elsif project.description.present? 
 markdown(project.description, pipeline: :description) 
 end 
 end 
 
 end 
 paginate(projects, remote: remote, theme: "gitlab") if projects.respond_to? :total_pages 
 else 
 end 
 
 
 
 yield :scripts_body 
 

end

  end
end
