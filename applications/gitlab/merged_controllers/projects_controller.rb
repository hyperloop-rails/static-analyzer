class ProjectsController < Projects::ApplicationController
  include ExtractsPath

  before_action :authenticate_user!, except: [:show, :activity]
  before_action :project, except: [:new, :create]
  before_action :repository, except: [:new, :create]
  before_action :assign_ref_vars, :tree, only: [:show], if: :repo_exists?

  # Authorize
  before_action :authorize_admin_project!, only: [:edit, :update, :housekeeping]
  before_action :event_filter, only: [:show, :activity]

  layout :determine_layout

  def index
    redirect_to(current_user ? root_path : explore_root_path)
  end

  def new
    @project = Project.new
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
 page_title    'New Project' 
 header_title  "Projects", root_path 
  form_errors(@project) 
 
 form_for @project, html: { class: 'new_project form-horizontal js-requires-input' } do |f| 
 f.label :path, class: 'control-label' do 
 end 
 if current_user.can_select_namespace? 
 root_url 
 f.select :namespace_id, namespaces_options(params[:namespace_id] ), {}, {class: 'select2 js-select-namespace', tabindex: 1} 
 else 
 end 
 f.text_field :path, placeholder: "my-awesome-project", class: "form-control", tabindex: 2, autofocus: true, required: true 
 if current_user.can_create_group? 
 link_to "Create a group", new_group_path 
 end 
 if import_sources_enabled? 
 if github_import_enabled? 
 if github_import_configured? 
 link_to status_import_github_path, class: 'btn import_github' do 
 end 
 else 
 link_to '#', class: 'how_to_import_link btn import_github' do 
 end 
  
 end 
 end 
 if bitbucket_import_enabled? 
 if bitbucket_import_configured? 
 link_to status_import_bitbucket_path, class: 'btn import_bitbucket', "data-no-turbolink" => "true" do 
 end 
 else 
 link_to status_import_bitbucket_path, class: 'how_to_import_link btn import_bitbucket', "data-no-turbolink" => "true" do 
 end 
  
 end 
 end 
 if gitlab_import_enabled? 
 if gitlab_import_configured? 
 link_to status_import_gitlab_path, class: 'btn import_gitlab' do 
 end 
 else 
 link_to status_import_gitlab_path, class: 'how_to_import_link btn import_gitlab' do 
 end 
  
 end 
 end 
 if gitorious_import_enabled? 
 link_to new_import_gitorious_path, class: 'btn import_gitorious' do 
 end 
 end 
 if google_code_import_enabled? 
 link_to new_import_google_code_path, class: 'btn import_google_code' do 
 end 
 end 
 if fogbugz_import_enabled? 
 link_to new_import_fogbugz_path, class: 'btn import_fogbugz' do 
 end 
 end 
 if git_import_enabled? 
 link_to "#", class: 'btn js-toggle-button import_git' do 
 end 
 end 
  f.label :import_url, class: 'control-label' do 
 end 
 f.text_field :import_url, class: 'form-control', placeholder: 'https://username:password@gitlab.company.com/group/project.git' 
 
 end 
 f.label :description, class: 'control-label' do 
 end 
 f.text_area :description, class: "form-control", rows: 3, maxlength: 250, tabindex: 3 
  f.label :visibility_level, class: 'control-label' do 
 link_to "(?)", help_page_path("public_access", "public_access") 
 end 
 if can_change_visibility_level 
  Gitlab::VisibilityLevel.values.each do |level| 
 next if skip_level?(form_model, level) 
 restricted = restricted_visibility_levels.include?(level) 
 form.label "_" do 
 form.radio_button model_method, level, checked: (selected_level == level), disabled: restricted 
 visibility_level_icon(level) 
 visibility_level_label(level) 
 visibility_level_description(level, form_model) 
 end 
 end 
 unless restricted_visibility_levels.empty? 
 end 
 
 else 
 visibility_level_icon(visibility_level) 
 visibility_level_label(visibility_level) 
 visibility_level_description(visibility_level, form_model) 
 end 
 
 f.submit 'Create project', class: "btn btn-create project-submit", tabindex: 4 
 link_to 'Cancel', dashboard_projects_path, class: 'btn btn-cancel' 
 end 
 
 yield :scripts_body 
 

end

  end

  def edit
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
 form_for [@project.namespace.becomes(Namespace), @project], remote: true, html: { multipart: true, class: "edit_project form-horizontal fieldset-form" }, authenticity_token: true do |f| 
 f.label :name, class: 'control-label' do 
 end 
 f.text_field :name, class: "form-control", id: "project_name_edit" 
 f.label :description, class: 'control-label' do 
 end 
 f.text_area :description, class: "form-control", rows: 3, maxlength: 250 
 unless @project.empty_repo? 
 f.label :default_branch, "Default Branch", class: 'control-label' 
 f.select(:default_branch, @project.repository.branch_names, {}, {class: 'select2 select-wide'}) 
 end 
  f.label :visibility_level, class: 'control-label' do 
 link_to "(?)", help_page_path("public_access", "public_access") 
 end 
 if can_change_visibility_level 
  Gitlab::VisibilityLevel.values.each do |level| 
 next if skip_level?(form_model, level) 
 restricted = restricted_visibility_levels.include?(level) 
 form.label "_" do 
 form.radio_button model_method, level, checked: (selected_level == level), disabled: restricted 
 visibility_level_icon(level) 
 visibility_level_label(level) 
 visibility_level_description(level, form_model) 
 end 
 end 
 unless restricted_visibility_levels.empty? 
 end 
 
 else 
 visibility_level_icon(visibility_level) 
 visibility_level_label(visibility_level) 
 visibility_level_description(visibility_level, form_model) 
 end 
 
 f.label :tag_list, "Tags", class: 'control-label' 
 f.text_field :tag_list, value: @project.tag_list.to_s, maxlength: 2000, class: "form-control" 
 f.label :issues_enabled do 
 f.check_box :issues_enabled 
 end 
 f.label :merge_requests_enabled do 
 f.check_box :merge_requests_enabled 
 end 
 f.label :builds_enabled do 
 f.check_box :builds_enabled 
 end 
 f.label :wiki_enabled do 
 f.check_box :wiki_enabled 
 end 
 f.label :snippets_enabled do 
 f.check_box :snippets_enabled 
 end 
  unless @repository.gitlab_ci_yml 
 link_to 'Get started with Builds', help_page_path('ci/quick_start', 'README'), class: 'btn btn-info' 
 end 
 f.label :build_allow_git_fetch_false do 
 f.radio_button :build_allow_git_fetch, 'false' 
 end 
 f.label :build_allow_git_fetch_true do 
 f.radio_button :build_allow_git_fetch, 'true' 
 end 
 f.label :build_timeout_in_minutes, 'Timeout', class: 'control-label' 
 f.number_field :build_timeout_in_minutes, class: 'form-control', min: '0' 
 f.label :build_coverage_regex, "Test coverage parsing", class: 'control-label' 
 f.text_field :build_coverage_regex, class: 'form-control', placeholder: '\(\d+.\d+\%\) covered' 
 f.label :public_builds do 
 f.check_box :public_builds 
 end 
 f.label :runners_token, "Runners token", class: 'control-label' 
 f.text_field :runners_token, class: "form-control", placeholder: 'xEeFCaDAB89' 
 
 if @project.avatar? 
 project_icon("/", alt: '', class: 'avatar project-avatar s160') 
 end 
 if @project.avatar_in_git 
 end 
 if @project.avatar? 
 else 
 end 
 f.file_field :avatar, class: "js-project-avatar-input hidden" 
 if @project.avatar? 
 link_to 'Remove avatar', namespace_project_avatar_path(@project.namespace, @project), data: { confirm: "Project avatar will be removed. Are you sure?"}, method: :delete, class: "btn btn-remove btn-sm remove-avatar" 
 end 
 f.submit 'Save changes', class: "btn btn-save" 
 end 
 link_to 'Housekeeping', housekeeping_namespace_project_path(@project.namespace, @project),                method: :post, class: "btn btn-default" 
 if can? current_user, :archive_project, @project 
 if @project.archived? 
 link_to 'Unarchive project', unarchive_namespace_project_path(@project.namespace, @project),                    data: { confirm: "Are you sure that you want to unarchive this project?\nWhen this project is unarchived it is active and can be committed to again." },                    method: :post, class: "btn btn-success" 
 else 
 link_to 'Archive project', archive_namespace_project_path(@project.namespace, @project),                    data: { confirm: "Are you sure that you want to archive this project?\nAn archived project cannot be committed to." },                    method: :post, class: "btn btn-warning" 
 end 
 else 
 end 
 form_for([@project.namespace.becomes(Namespace), @project], html: { class: 'form-horizontal' }) do |f| 
 f.label :name, class: 'control-label' do 
 end 
 f.text_field :name, class: "form-control" 
 f.label :path, class: 'control-label' do 
 end 
 f.text_field :path, class: 'form-control' 
 f.submit 'Rename project', class: "btn btn-warning" 
 end 
 if can?(current_user, :change_namespace, @project) 
 form_for([@project.namespace.becomes(Namespace), @project], url: transfer_namespace_project_path(@project.namespace, @project), method: :put, remote: true, html: { class: 'transfer-project form-horizontal' }) do |f| 
 label_tag :new_namespace_id, nil, class: 'control-label' do 
 end 
 select_tag :new_namespace_id, namespaces_options(@project.namespace_id), { prompt: 'Choose a project namespace', class: 'select2' } 
 f.submit 'Transfer project', class: "btn btn-remove js-confirm-danger", data: { "confirm-danger-message" => transfer_project_message(@project) } 
 end 
 else 
 end 
 if @project.forked? 
 if can?(current_user, :remove_fork_project, @project) 
 form_for([@project.namespace.becomes(Namespace), @project], url: remove_fork_namespace_project_path(@project.namespace, @project), method: :delete, remote: true, html: { class: 'transfer-project form-horizontal' }) do |f| 
 button_to 'Remove fork relationship', '#', class: "btn btn-remove js-confirm-danger", data: { "confirm-danger-message" => remove_fork_project_message(@project) } 
 end 
 else 
 end 
 end 
 if can?(current_user, :remove_project, @project) 
 form_tag(namespace_project_path(@project.namespace, @project), method: :delete, class: 'form-horizontal') do 
 button_to 'Remove project', '#', class: "btn btn-remove js-confirm-danger", data: { "confirm-danger-message" => remove_project_message(@project) } 
 end 
 else 
 end 
  -1 
 text_field_tag 'confirm_name_input', '', class: 'form-control js-confirm-danger-input' 
 submit_tag 'Confirm', class: "btn btn-danger js-confirm-danger-submit" 
 
 
 yield :scripts_body 
 

end
end

  def create
    @project = ::Projects::CreateService.new(current_user, project_params).execute

    if @project.saved?
      redirect_to(
        project_path(@project),
        notice: "Project '#{@project.name}' was successfully created."
      )
    else
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
 page_title    'New Project' 
 header_title  "Projects", root_path 
  form_errors(@project) 
 
 form_for @project, html: { class: 'new_project form-horizontal js-requires-input' } do |f| 
 f.label :path, class: 'control-label' do 
 end 
 if current_user.can_select_namespace? 
 root_url 
 f.select :namespace_id, namespaces_options(params[:namespace_id] ), {}, {class: 'select2 js-select-namespace', tabindex: 1} 
 else 
 end 
 f.text_field :path, placeholder: "my-awesome-project", class: "form-control", tabindex: 2, autofocus: true, required: true 
 if current_user.can_create_group? 
 link_to "Create a group", new_group_path 
 end 
 if import_sources_enabled? 
 if github_import_enabled? 
 if github_import_configured? 
 link_to status_import_github_path, class: 'btn import_github' do 
 end 
 else 
 link_to '#', class: 'how_to_import_link btn import_github' do 
 end 
  
 end 
 end 
 if bitbucket_import_enabled? 
 if bitbucket_import_configured? 
 link_to status_import_bitbucket_path, class: 'btn import_bitbucket', "data-no-turbolink" => "true" do 
 end 
 else 
 link_to status_import_bitbucket_path, class: 'how_to_import_link btn import_bitbucket', "data-no-turbolink" => "true" do 
 end 
  
 end 
 end 
 if gitlab_import_enabled? 
 if gitlab_import_configured? 
 link_to status_import_gitlab_path, class: 'btn import_gitlab' do 
 end 
 else 
 link_to status_import_gitlab_path, class: 'how_to_import_link btn import_gitlab' do 
 end 
  
 end 
 end 
 if gitorious_import_enabled? 
 link_to new_import_gitorious_path, class: 'btn import_gitorious' do 
 end 
 end 
 if google_code_import_enabled? 
 link_to new_import_google_code_path, class: 'btn import_google_code' do 
 end 
 end 
 if fogbugz_import_enabled? 
 link_to new_import_fogbugz_path, class: 'btn import_fogbugz' do 
 end 
 end 
 if git_import_enabled? 
 link_to "#", class: 'btn js-toggle-button import_git' do 
 end 
 end 
  f.label :import_url, class: 'control-label' do 
 end 
 f.text_field :import_url, class: 'form-control', placeholder: 'https://username:password@gitlab.company.com/group/project.git' 
 
 end 
 f.label :description, class: 'control-label' do 
 end 
 f.text_area :description, class: "form-control", rows: 3, maxlength: 250, tabindex: 3 
  f.label :visibility_level, class: 'control-label' do 
 link_to "(?)", help_page_path("public_access", "public_access") 
 end 
 if can_change_visibility_level 
  Gitlab::VisibilityLevel.values.each do |level| 
 next if skip_level?(form_model, level) 
 restricted = restricted_visibility_levels.include?(level) 
 form.label "_" do 
 form.radio_button model_method, level, checked: (selected_level == level), disabled: restricted 
 visibility_level_icon(level) 
 visibility_level_label(level) 
 visibility_level_description(level, form_model) 
 end 
 end 
 unless restricted_visibility_levels.empty? 
 end 
 
 else 
 visibility_level_icon(visibility_level) 
 visibility_level_label(visibility_level) 
 visibility_level_description(visibility_level, form_model) 
 end 
 
 f.submit 'Create project', class: "btn btn-create project-submit", tabindex: 4 
 link_to 'Cancel', dashboard_projects_path, class: 'btn btn-cancel' 
 end 
 
 yield :scripts_body 
 

end

    end
  end

  def update
    status = ::Projects::UpdateService.new(@project, current_user, project_params).execute

    # Refresh the repo in case anything changed
    @repository = project.repository

    respond_to do |format|
      if status
        flash[:notice] = "Project '#{@project.name}' was successfully updated."
        format.html do
          redirect_to(
            edit_project_path(@project),
            notice: "Project '#{@project.name}' was successfully updated."
          )
        end
        format.js
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 form_for [@project.namespace.becomes(Namespace), @project], remote: true, html: { multipart: true, class: "edit_project form-horizontal fieldset-form" }, authenticity_token: true do |f| 
 f.label :name, class: 'control-label' do 
 end 
 f.text_field :name, class: "form-control", id: "project_name_edit" 
 f.label :description, class: 'control-label' do 
 end 
 f.text_area :description, class: "form-control", rows: 3, maxlength: 250 
 unless @project.empty_repo? 
 f.label :default_branch, "Default Branch", class: 'control-label' 
 f.select(:default_branch, @project.repository.branch_names, {}, {class: 'select2 select-wide'}) 
 end 
  f.label :visibility_level, class: 'control-label' do 
 link_to "(?)", help_page_path("public_access", "public_access") 
 end 
 if can_change_visibility_level 
  Gitlab::VisibilityLevel.values.each do |level| 
 next if skip_level?(form_model, level) 
 restricted = restricted_visibility_levels.include?(level) 
 form.label "_" do 
 form.radio_button model_method, level, checked: (selected_level == level), disabled: restricted 
 visibility_level_icon(level) 
 visibility_level_label(level) 
 visibility_level_description(level, form_model) 
 end 
 end 
 unless restricted_visibility_levels.empty? 
 end 
 
 else 
 visibility_level_icon(visibility_level) 
 visibility_level_label(visibility_level) 
 visibility_level_description(visibility_level, form_model) 
 end 
 
 f.label :tag_list, "Tags", class: 'control-label' 
 f.text_field :tag_list, value: @project.tag_list.to_s, maxlength: 2000, class: "form-control" 
 f.label :issues_enabled do 
 f.check_box :issues_enabled 
 end 
 f.label :merge_requests_enabled do 
 f.check_box :merge_requests_enabled 
 end 
 f.label :builds_enabled do 
 f.check_box :builds_enabled 
 end 
 f.label :wiki_enabled do 
 f.check_box :wiki_enabled 
 end 
 f.label :snippets_enabled do 
 f.check_box :snippets_enabled 
 end 
  unless @repository.gitlab_ci_yml 
 link_to 'Get started with Builds', help_page_path('ci/quick_start', 'README'), class: 'btn btn-info' 
 end 
 f.label :build_allow_git_fetch_false do 
 f.radio_button :build_allow_git_fetch, 'false' 
 end 
 f.label :build_allow_git_fetch_true do 
 f.radio_button :build_allow_git_fetch, 'true' 
 end 
 f.label :build_timeout_in_minutes, 'Timeout', class: 'control-label' 
 f.number_field :build_timeout_in_minutes, class: 'form-control', min: '0' 
 f.label :build_coverage_regex, "Test coverage parsing", class: 'control-label' 
 f.text_field :build_coverage_regex, class: 'form-control', placeholder: '\(\d+.\d+\%\) covered' 
 f.label :public_builds do 
 f.check_box :public_builds 
 end 
 f.label :runners_token, "Runners token", class: 'control-label' 
 f.text_field :runners_token, class: "form-control", placeholder: 'xEeFCaDAB89' 
 
 if @project.avatar? 
 project_icon("/", alt: '', class: 'avatar project-avatar s160') 
 end 
 if @project.avatar_in_git 
 end 
 if @project.avatar? 
 else 
 end 
 f.file_field :avatar, class: "js-project-avatar-input hidden" 
 if @project.avatar? 
 link_to 'Remove avatar', namespace_project_avatar_path(@project.namespace, @project), data: { confirm: "Project avatar will be removed. Are you sure?"}, method: :delete, class: "btn btn-remove btn-sm remove-avatar" 
 end 
 f.submit 'Save changes', class: "btn btn-save" 
 end 
 link_to 'Housekeeping', housekeeping_namespace_project_path(@project.namespace, @project),                method: :post, class: "btn btn-default" 
 if can? current_user, :archive_project, @project 
 if @project.archived? 
 link_to 'Unarchive project', unarchive_namespace_project_path(@project.namespace, @project),                    data: { confirm: "Are you sure that you want to unarchive this project?\nWhen this project is unarchived it is active and can be committed to again." },                    method: :post, class: "btn btn-success" 
 else 
 link_to 'Archive project', archive_namespace_project_path(@project.namespace, @project),                    data: { confirm: "Are you sure that you want to archive this project?\nAn archived project cannot be committed to." },                    method: :post, class: "btn btn-warning" 
 end 
 else 
 end 
 form_for([@project.namespace.becomes(Namespace), @project], html: { class: 'form-horizontal' }) do |f| 
 f.label :name, class: 'control-label' do 
 end 
 f.text_field :name, class: "form-control" 
 f.label :path, class: 'control-label' do 
 end 
 f.text_field :path, class: 'form-control' 
 f.submit 'Rename project', class: "btn btn-warning" 
 end 
 if can?(current_user, :change_namespace, @project) 
 form_for([@project.namespace.becomes(Namespace), @project], url: transfer_namespace_project_path(@project.namespace, @project), method: :put, remote: true, html: { class: 'transfer-project form-horizontal' }) do |f| 
 label_tag :new_namespace_id, nil, class: 'control-label' do 
 end 
 select_tag :new_namespace_id, namespaces_options(@project.namespace_id), { prompt: 'Choose a project namespace', class: 'select2' } 
 f.submit 'Transfer project', class: "btn btn-remove js-confirm-danger", data: { "confirm-danger-message" => transfer_project_message(@project) } 
 end 
 else 
 end 
 if @project.forked? 
 if can?(current_user, :remove_fork_project, @project) 
 form_for([@project.namespace.becomes(Namespace), @project], url: remove_fork_namespace_project_path(@project.namespace, @project), method: :delete, remote: true, html: { class: 'transfer-project form-horizontal' }) do |f| 
 button_to 'Remove fork relationship', '#', class: "btn btn-remove js-confirm-danger", data: { "confirm-danger-message" => remove_fork_project_message(@project) } 
 end 
 else 
 end 
 end 
 if can?(current_user, :remove_project, @project) 
 form_tag(namespace_project_path(@project.namespace, @project), method: :delete, class: 'form-horizontal') do 
 button_to 'Remove project', '#', class: "btn btn-remove js-confirm-danger", data: { "confirm-danger-message" => remove_project_message(@project) } 
 end 
 else 
 end 
  -1 
 text_field_tag 'confirm_name_input', '', class: 'form-control js-confirm-danger-input' 
 submit_tag 'Confirm', class: "btn btn-danger js-confirm-danger-submit" 
 
 
 yield :scripts_body 
 

end
 }
        format.js
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
 if @project.valid? 
 else 
 end 
 
 yield :scripts_body 
 

end

  end

  def transfer
    return access_denied! unless can?(current_user, :change_namespace, @project)

    namespace = Namespace.find_by(id: params[:new_namespace_id])
    ::Projects::TransferService.new(project, current_user).execute(namespace)

    if @project.errors[:new_namespace].present?
      flash[:alert] = @project.errors[:new_namespace].first
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
 
 yield :scripts_body 
 

end

  end

  def remove_fork
    return access_denied! unless can?(current_user, :remove_fork_project, @project)

    if ::Projects::UnlinkForkService.new(@project, current_user).execute
      flash[:notice] = 'The fork relationship has been removed.'
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
 
 yield :scripts_body 
 

end

  end

  def activity
    respond_to do |format|
      format.html
      format.json do
        load_events
        pager_json('events/_events', @events.count)
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
 page_title "Activity" 
 header_title project_title(@project, "Activity", activity_project_path(@project)) 
 render 'projects/last_push' 
  page_title "Activity" 
 header_title project_title(@project, "Activity", activity_project_path(@project)) 
  if event = last_push_event 
 if show_last_push_widget?(event) 
 link_to namespace_project_commits_path(event.project.namespace, event.project, event.ref_name) do 
 event.ref_name 
 end 
 link_to new_mr_path_from_push_event(event), title: "New Merge Request", class: "btn btn-info btn-sm" do 
 end 
 end 
 end 
 
 render 'projects/activity' 
 
 
 yield :scripts_body 
 

end

  end

  def show
    if @project.import_in_progress?
      redirect_to namespace_project_import_path(@project.namespace, @project)
      return
    end

    if @project.pending_delete?
      flash[:alert] = "Project queued for delete."
    end

    respond_to do |format|
      format.html do
        if current_user
          @membership = @project.team.find_member(current_user.id)

          if @membership
            @notification_setting = current_user.notification_settings_for(@project)
          end
        end

        if @project.repository_exists?
          if @project.empty_repo?
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
 
 if current_user && can?(current_user, :download_code, @project) 
  if cookies[:hide_no_ssh_message].blank? && !current_user.hide_no_ssh_key && current_user.require_ssh_key? 
 link_to "Don't show again", profile_path(user: {hide_no_ssh_key: true}), method: :put, class: 'alert-link' 
 link_to 'Remind later', '#', class: 'hide-no-ssh-message alert-link' 
 end 
 
 end 
 (container_class unless @no_container) 
 @no_container = true 
  
  empty_repo = @project.empty_repo? 
 ("empty-project" if empty_repo) 
 project_icon(@project, alt: '', class: 'project-avatar avatar s90') 
 @project.name 
 visibility_level_icon(@project.visibility_level, fw: false) 
 if @project.description.present? 
 markdown(@project.description, pipeline: :description) 
 end 
 if forked_from_project = @project.forked_from_project 
 link_to project_path(forked_from_project) do 
 forked_from_project.namespace.try(:name) 
 end 
 end 
 if current_user 
 link_to namespace_project_path(@project.namespace, @project, format: :atom, private_token: current_user.private_token), class: 'btn btn-gray' do 
 icon('rss') 
 end 
 access = user_max_access_in_project(current_user.id, @project) 
 can_edit = can?(current_user, :admin_project, @project) 
 if access || can_edit 
 icon('cog') 
 icon('angle-down') 
 if can_edit 
 link_to edit_project_path(@project) do 
 end 
 end 
 if access 
 link_to leave_namespace_project_project_members_path(@project.namespace, @project),                  data: { confirm: leave_project_message(@project) }, method: :delete, title: 'Leave project' do 
 end 
 end 
 end 
 end 
  if current_user 
 link_to toggle_star_namespace_project_path(@project.namespace, @project), class: 'btn star-btn toggle-star has-tooltip', method: :post, remote: true, title: "Star project" do 
 if current_user.starred?(@project) 
 icon('star fw') 
 else 
 icon('star-o fw') 
 end 
 end 
 @project.star_count 
 else 
 link_to new_user_session_path, class: 'btn has-tooltip star-btn', title: 'You must sign in to star a project' do 
 icon('star fw') 
 end 
 @project.star_count 
 end 
 
  unless @project.empty_repo? 
 if current_user && can?(current_user, :fork_project, @project) 
 if current_user.already_forked?(@project) && current_user.manageable_namespaces.size < 2 
 link_to namespace_project_path(current_user, current_user.fork_of(@project)), title: 'Go to your fork', class: 'btn has-tooltip' do 
 icon('code-fork fw') 
 end 
 @project.forks_count 
 else 
 link_to new_namespace_project_fork_path(@project.namespace, @project), title: "Fork project", class: 'btn has-tooltip' do 
 icon('code-fork fw') 
 end 
 link_to namespace_project_forks_path(@project.namespace, @project), class: 'count-with-arrow' do 
 @project.forks_count 
 end 
 end 
 end 
 end 
 
  project = project || @project 
 default_clone_protocol.upcase 
 icon('angle-down') 
 ssh_clone_button(project) 
 http_clone_button(project) 
 text_field_tag :project_clone, default_url_to_repo(project), class: "js-select-on-focus form-control", readonly: true 
 clipboard_button(clipboard_target: '#project_clone') 
 
  unless @project.empty_repo? 
 if can? current_user, :download_code, @project 
 link_to archive_namespace_project_repository_path(@project.namespace, @project, ref: @ref, format: 'zip'), class: 'btn has-tooltip', data: {container: "body"}, rel: 'nofollow', title: "Download ZIP" do 
 icon('download') 
 end 
 end 
 end 
 
  if current_user 
 icon('plus') 
 can_create_issue = can?(current_user, :create_issue, @project) 
 merge_project = can?(current_user, :create_merge_request, @project) ? @project : (current_user && current_user.fork_of(@project)) 
 can_create_snippet = can?(current_user, :create_snippet, @project) 
 if can_create_issue 
 link_to url_for_new_issue(@project, only_path: true) do 
 icon('exclamation-circle fw') 
 end 
 end 
 if merge_project 
 link_to new_namespace_project_merge_request_path(merge_project.namespace, merge_project) do 
 icon('tasks fw') 
 end 
 end 
 if can_create_snippet 
 link_to new_namespace_project_snippet_path(@project.namespace, @project) do 
 icon('file-text-o fw') 
 end 
 end 
 if can_create_issue || merge_project || can_create_snippet 
 end 
 if can?(current_user, :push_code, @project) 
 link_to namespace_project_new_blob_path(@project.namespace, @project, @project.default_branch ) do 
 icon('file fw') 
 end 
 link_to new_namespace_project_branch_path(@project.namespace, @project) do 
 icon('code-fork fw') 
 end 
 link_to new_namespace_project_tag_path(@project.namespace, @project) do 
 icon('tags fw') 
 end 
 elsif current_user && current_user.already_forked?(@project) 
 link_to namespace_project_new_blob_path(@project.namespace, @project, @project.default_branch ) do 
 icon('file fw') 
 end 
 elsif can?(current_user, :fork_project, @project) 
 continue_params = { to:         namespace_project_new_blob_path(@project.namespace, @project, @project.default_branch ),                                notice:     edit_in_new_fork_notice,                                notice_now: edit_in_new_fork_notice_now } 
 fork_path = namespace_project_forks_path(@project.namespace, @project, namespace_key:  current_user.namespace.id,                                                                                  continue:       continue_params) 
 link_to fork_path, method: :post do 
 icon('file fw') 
 end 
 end 
 end 
 
  if @notification_setting 
 form_for @notification_setting, url: namespace_project_notification_setting_path(@project.namespace.becomes(Namespace), @project), method: :patch, remote: true, html: { class: 'inline', id: 'notification-form' } do |f| 
 f.hidden_field :level 
 icon('bell') 
 notification_title(@notification_setting.level) 
 icon('angle-down') 
 NotificationSetting.levels.each do |level| 
 notification_list_item(level.first, @notification_setting) 
 end 
 end 
 end 
 
 
 if can?(current_user, :push_code, @project) 
 link_to "README", new_readme_path, class: 'underlined-link' 
 link_to "LICENSE", add_special_file_path(@project, file_name: 'LICENSE'), class: 'underlined-link' 
 end 
 if can?(current_user, :push_code, @project) 
 container_class 
 if can? current_user, :remove_project, @project 
 link_to 'Remove project', [@project.namespace.becomes(Namespace), @project], data: { confirm: remove_project_message(@project)}, method: :delete, class: "btn btn-remove pull-right" 
 end 
 end 
 
 yield :scripts_body 
 

end

          else
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
 auto_discovery_link_tag(:atom, namespace_project_path(@project.namespace, @project, format: :atom, private_token: current_user.private_token), title: " activity") 
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
 
 if current_user && can?(current_user, :download_code, @project) 
  if cookies[:hide_no_ssh_message].blank? && !current_user.hide_no_ssh_key && current_user.require_ssh_key? 
 link_to "Don't show again", profile_path(user: {hide_no_ssh_key: true}), method: :put, class: 'alert-link' 
 link_to 'Remind later', '#', class: 'hide-no-ssh-message alert-link' 
 end 
 
 end 
 (container_class unless @no_container) 
 @no_container = true 
  
  
  if event = last_push_event 
 if show_last_push_widget?(event) 
 link_to namespace_project_commits_path(event.project.namespace, event.project, event.ref_name) do 
 event.ref_name 
 end 
 link_to new_mr_path_from_push_event(event), title: "New Merge Request", class: "btn btn-info btn-sm" do 
 end 
 end 
 end 
 
  empty_repo = @project.empty_repo? 
 ("empty-project" if empty_repo) 
 project_icon(@project, alt: '', class: 'project-avatar avatar s90') 
 @project.name 
 visibility_level_icon(@project.visibility_level, fw: false) 
 if @project.description.present? 
 markdown(@project.description, pipeline: :description) 
 end 
 if forked_from_project = @project.forked_from_project 
 link_to project_path(forked_from_project) do 
 forked_from_project.namespace.try(:name) 
 end 
 end 
 if current_user 
 link_to namespace_project_path(@project.namespace, @project, format: :atom, private_token: current_user.private_token), class: 'btn btn-gray' do 
 icon('rss') 
 end 
 access = user_max_access_in_project(current_user.id, @project) 
 can_edit = can?(current_user, :admin_project, @project) 
 if access || can_edit 
 icon('cog') 
 icon('angle-down') 
 if can_edit 
 link_to edit_project_path(@project) do 
 end 
 end 
 if access 
 link_to leave_namespace_project_project_members_path(@project.namespace, @project),                  data: { confirm: leave_project_message(@project) }, method: :delete, title: 'Leave project' do 
 end 
 end 
 end 
 end 
  if current_user 
 link_to toggle_star_namespace_project_path(@project.namespace, @project), class: 'btn star-btn toggle-star has-tooltip', method: :post, remote: true, title: "Star project" do 
 if current_user.starred?(@project) 
 icon('star fw') 
 else 
 icon('star-o fw') 
 end 
 end 
 @project.star_count 
 else 
 link_to new_user_session_path, class: 'btn has-tooltip star-btn', title: 'You must sign in to star a project' do 
 icon('star fw') 
 end 
 @project.star_count 
 end 
 
  unless @project.empty_repo? 
 if current_user && can?(current_user, :fork_project, @project) 
 if current_user.already_forked?(@project) && current_user.manageable_namespaces.size < 2 
 link_to namespace_project_path(current_user, current_user.fork_of(@project)), title: 'Go to your fork', class: 'btn has-tooltip' do 
 icon('code-fork fw') 
 end 
 @project.forks_count 
 else 
 link_to new_namespace_project_fork_path(@project.namespace, @project), title: "Fork project", class: 'btn has-tooltip' do 
 icon('code-fork fw') 
 end 
 link_to namespace_project_forks_path(@project.namespace, @project), class: 'count-with-arrow' do 
 @project.forks_count 
 end 
 end 
 end 
 end 
 
  project = project || @project 
 default_clone_protocol.upcase 
 icon('angle-down') 
 ssh_clone_button(project) 
 http_clone_button(project) 
 text_field_tag :project_clone, default_url_to_repo(project), class: "js-select-on-focus form-control", readonly: true 
 clipboard_button(clipboard_target: '#project_clone') 
 
  unless @project.empty_repo? 
 if can? current_user, :download_code, @project 
 link_to archive_namespace_project_repository_path(@project.namespace, @project, ref: @ref, format: 'zip'), class: 'btn has-tooltip', data: {container: "body"}, rel: 'nofollow', title: "Download ZIP" do 
 icon('download') 
 end 
 end 
 end 
 
  if current_user 
 icon('plus') 
 can_create_issue = can?(current_user, :create_issue, @project) 
 merge_project = can?(current_user, :create_merge_request, @project) ? @project : (current_user && current_user.fork_of(@project)) 
 can_create_snippet = can?(current_user, :create_snippet, @project) 
 if can_create_issue 
 link_to url_for_new_issue(@project, only_path: true) do 
 icon('exclamation-circle fw') 
 end 
 end 
 if merge_project 
 link_to new_namespace_project_merge_request_path(merge_project.namespace, merge_project) do 
 icon('tasks fw') 
 end 
 end 
 if can_create_snippet 
 link_to new_namespace_project_snippet_path(@project.namespace, @project) do 
 icon('file-text-o fw') 
 end 
 end 
 if can_create_issue || merge_project || can_create_snippet 
 end 
 if can?(current_user, :push_code, @project) 
 link_to namespace_project_new_blob_path(@project.namespace, @project, @project.default_branch ) do 
 icon('file fw') 
 end 
 link_to new_namespace_project_branch_path(@project.namespace, @project) do 
 icon('code-fork fw') 
 end 
 link_to new_namespace_project_tag_path(@project.namespace, @project) do 
 icon('tags fw') 
 end 
 elsif current_user && current_user.already_forked?(@project) 
 link_to namespace_project_new_blob_path(@project.namespace, @project, @project.default_branch ) do 
 icon('file fw') 
 end 
 elsif can?(current_user, :fork_project, @project) 
 continue_params = { to:         namespace_project_new_blob_path(@project.namespace, @project, @project.default_branch ),                                notice:     edit_in_new_fork_notice,                                notice_now: edit_in_new_fork_notice_now } 
 fork_path = namespace_project_forks_path(@project.namespace, @project, namespace_key:  current_user.namespace.id,                                                                                  continue:       continue_params) 
 link_to fork_path, method: :post do 
 icon('file fw') 
 end 
 end 
 end 
 
  if @notification_setting 
 form_for @notification_setting, url: namespace_project_notification_setting_path(@project.namespace.becomes(Namespace), @project), method: :patch, remote: true, html: { class: 'inline', id: 'notification-form' } do |f| 
 f.hidden_field :level 
 icon('bell') 
 notification_title(@notification_setting.level) 
 icon('angle-down') 
 NotificationSetting.levels.each do |level| 
 notification_list_item(level.first, @notification_setting) 
 end 
 end 
 end 
 
 
 link_to namespace_project_commits_path(@project.namespace, @project, current_ref) do 
 pluralize(number_with_delimiter(@project.commit_count), 'commit') 
 end 
 link_to namespace_project_branches_path(@project.namespace, @project) do 
 pluralize(number_with_delimiter(@repository.branch_names.count), 'branch') 
 end 
 link_to namespace_project_tags_path(@project.namespace, @project) do 
 pluralize(number_with_delimiter(@repository.tag_names.count), 'tag') 
 end 
 link_to project_files_path(@project) do 
 repository_size 
 end 
 if default_project_view != 'readme' && @repository.readme 
 link_to 'Readme', readme_path(@project) 
 end 
 if @repository.changelog 
 link_to 'Changelog', changelog_path(@project) 
 end 
 if @repository.license_blob 
 link_to license_short_name(@project), license_path(@project) 
 end 
 if @repository.contribution_guide 
 link_to 'Contribution guide', contribution_guide_path(@project) 
 end 
 if current_user && can_push_branch?(@project, @project.default_branch) 
 unless @repository.changelog 
 link_to add_special_file_path(@project, file_name: 'CHANGELOG') do 
 end 
 end 
 unless @repository.license_blob 
 link_to add_special_file_path(@project, file_name: 'LICENSE') do 
 end 
 end 
 unless @repository.contribution_guide 
 link_to add_special_file_path(@project, file_name: 'CONTRIBUTING.md', commit_message: 'Add contribution guide') do 
 end 
 end 
 end 
 if @repository.commit 
 container_class 
  if commit.status 
 link_to builds_namespace_project_commit_path(commit.project.namespace, commit.project, commit), class: "ci-status ci-" do 
 ci_icon_for_status(commit.status) 
 ci_label_for_status(commit.status) 
 end 
 end 
 link_to commit.short_id, namespace_project_commit_path(project.namespace, project, commit), class: "commit_short_id" 
 link_to_gfm commit.title, namespace_project_commit_path(project.namespace, project, commit), class: "commit-row-message" 
 commit_author_link(commit, avatar: true, size: 24) 
 
 end 
 container_class 
 if @project.archived? 
 icon("exclamation-triangle fw") 
 end 
 render default_project_view 
 
 yield :scripts_body 
 

end

          end
        else
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
 link_to namespace_project_repository_path(@project.namespace, @project), method: :post, class: 'btn btn-primary' do 
 end 
 link_to new_namespace_project_import_path(@project.namespace, @project), class: 'btn' do 
 end 
 if can? current_user, :remove_project, @project 
 link_to 'Remove project', project_path(@project), data: { confirm: remove_project_message(@project)}, method: :delete, class: "btn btn-remove pull-right" 
 end 
 
 yield :scripts_body 
 

end

        end
      end

      format.atom do
        load_events
        render layout: false
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
 if current_user 
 auto_discovery_link_tag(:atom, namespace_project_path(@project.namespace, @project, format: :atom, private_token: current_user.private_token), title: " activity") 
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
 
 if current_user && can?(current_user, :download_code, @project) 
  if cookies[:hide_no_ssh_message].blank? && !current_user.hide_no_ssh_key && current_user.require_ssh_key? 
 link_to "Don't show again", profile_path(user: {hide_no_ssh_key: true}), method: :put, class: 'alert-link' 
 link_to 'Remind later', '#', class: 'hide-no-ssh-message alert-link' 
 end 
 
 end 
 (container_class unless @no_container) 
 @no_container = true 
  
  
  if event = last_push_event 
 if show_last_push_widget?(event) 
 link_to namespace_project_commits_path(event.project.namespace, event.project, event.ref_name) do 
 event.ref_name 
 end 
 link_to new_mr_path_from_push_event(event), title: "New Merge Request", class: "btn btn-info btn-sm" do 
 end 
 end 
 end 
 
  empty_repo = @project.empty_repo? 
 ("empty-project" if empty_repo) 
 project_icon(@project, alt: '', class: 'project-avatar avatar s90') 
 @project.name 
 visibility_level_icon(@project.visibility_level, fw: false) 
 if @project.description.present? 
 markdown(@project.description, pipeline: :description) 
 end 
 if forked_from_project = @project.forked_from_project 
 link_to project_path(forked_from_project) do 
 forked_from_project.namespace.try(:name) 
 end 
 end 
 if current_user 
 link_to namespace_project_path(@project.namespace, @project, format: :atom, private_token: current_user.private_token), class: 'btn btn-gray' do 
 icon('rss') 
 end 
 access = user_max_access_in_project(current_user.id, @project) 
 can_edit = can?(current_user, :admin_project, @project) 
 if access || can_edit 
 icon('cog') 
 icon('angle-down') 
 if can_edit 
 link_to edit_project_path(@project) do 
 end 
 end 
 if access 
 link_to leave_namespace_project_project_members_path(@project.namespace, @project),                  data: { confirm: leave_project_message(@project) }, method: :delete, title: 'Leave project' do 
 end 
 end 
 end 
 end 
  if current_user 
 link_to toggle_star_namespace_project_path(@project.namespace, @project), class: 'btn star-btn toggle-star has-tooltip', method: :post, remote: true, title: "Star project" do 
 if current_user.starred?(@project) 
 icon('star fw') 
 else 
 icon('star-o fw') 
 end 
 end 
 @project.star_count 
 else 
 link_to new_user_session_path, class: 'btn has-tooltip star-btn', title: 'You must sign in to star a project' do 
 icon('star fw') 
 end 
 @project.star_count 
 end 
 
  unless @project.empty_repo? 
 if current_user && can?(current_user, :fork_project, @project) 
 if current_user.already_forked?(@project) && current_user.manageable_namespaces.size < 2 
 link_to namespace_project_path(current_user, current_user.fork_of(@project)), title: 'Go to your fork', class: 'btn has-tooltip' do 
 icon('code-fork fw') 
 end 
 @project.forks_count 
 else 
 link_to new_namespace_project_fork_path(@project.namespace, @project), title: "Fork project", class: 'btn has-tooltip' do 
 icon('code-fork fw') 
 end 
 link_to namespace_project_forks_path(@project.namespace, @project), class: 'count-with-arrow' do 
 @project.forks_count 
 end 
 end 
 end 
 end 
 
  project = project || @project 
 default_clone_protocol.upcase 
 icon('angle-down') 
 ssh_clone_button(project) 
 http_clone_button(project) 
 text_field_tag :project_clone, default_url_to_repo(project), class: "js-select-on-focus form-control", readonly: true 
 clipboard_button(clipboard_target: '#project_clone') 
 
  unless @project.empty_repo? 
 if can? current_user, :download_code, @project 
 link_to archive_namespace_project_repository_path(@project.namespace, @project, ref: @ref, format: 'zip'), class: 'btn has-tooltip', data: {container: "body"}, rel: 'nofollow', title: "Download ZIP" do 
 icon('download') 
 end 
 end 
 end 
 
  if current_user 
 icon('plus') 
 can_create_issue = can?(current_user, :create_issue, @project) 
 merge_project = can?(current_user, :create_merge_request, @project) ? @project : (current_user && current_user.fork_of(@project)) 
 can_create_snippet = can?(current_user, :create_snippet, @project) 
 if can_create_issue 
 link_to url_for_new_issue(@project, only_path: true) do 
 icon('exclamation-circle fw') 
 end 
 end 
 if merge_project 
 link_to new_namespace_project_merge_request_path(merge_project.namespace, merge_project) do 
 icon('tasks fw') 
 end 
 end 
 if can_create_snippet 
 link_to new_namespace_project_snippet_path(@project.namespace, @project) do 
 icon('file-text-o fw') 
 end 
 end 
 if can_create_issue || merge_project || can_create_snippet 
 end 
 if can?(current_user, :push_code, @project) 
 link_to namespace_project_new_blob_path(@project.namespace, @project, @project.default_branch ) do 
 icon('file fw') 
 end 
 link_to new_namespace_project_branch_path(@project.namespace, @project) do 
 icon('code-fork fw') 
 end 
 link_to new_namespace_project_tag_path(@project.namespace, @project) do 
 icon('tags fw') 
 end 
 elsif current_user && current_user.already_forked?(@project) 
 link_to namespace_project_new_blob_path(@project.namespace, @project, @project.default_branch ) do 
 icon('file fw') 
 end 
 elsif can?(current_user, :fork_project, @project) 
 continue_params = { to:         namespace_project_new_blob_path(@project.namespace, @project, @project.default_branch ),                                notice:     edit_in_new_fork_notice,                                notice_now: edit_in_new_fork_notice_now } 
 fork_path = namespace_project_forks_path(@project.namespace, @project, namespace_key:  current_user.namespace.id,                                                                                  continue:       continue_params) 
 link_to fork_path, method: :post do 
 icon('file fw') 
 end 
 end 
 end 
 
  if @notification_setting 
 form_for @notification_setting, url: namespace_project_notification_setting_path(@project.namespace.becomes(Namespace), @project), method: :patch, remote: true, html: { class: 'inline', id: 'notification-form' } do |f| 
 f.hidden_field :level 
 icon('bell') 
 notification_title(@notification_setting.level) 
 icon('angle-down') 
 NotificationSetting.levels.each do |level| 
 notification_list_item(level.first, @notification_setting) 
 end 
 end 
 end 
 
 
 link_to namespace_project_commits_path(@project.namespace, @project, current_ref) do 
 pluralize(number_with_delimiter(@project.commit_count), 'commit') 
 end 
 link_to namespace_project_branches_path(@project.namespace, @project) do 
 pluralize(number_with_delimiter(@repository.branch_names.count), 'branch') 
 end 
 link_to namespace_project_tags_path(@project.namespace, @project) do 
 pluralize(number_with_delimiter(@repository.tag_names.count), 'tag') 
 end 
 link_to project_files_path(@project) do 
 repository_size 
 end 
 if default_project_view != 'readme' && @repository.readme 
 link_to 'Readme', readme_path(@project) 
 end 
 if @repository.changelog 
 link_to 'Changelog', changelog_path(@project) 
 end 
 if @repository.license_blob 
 link_to license_short_name(@project), license_path(@project) 
 end 
 if @repository.contribution_guide 
 link_to 'Contribution guide', contribution_guide_path(@project) 
 end 
 if current_user && can_push_branch?(@project, @project.default_branch) 
 unless @repository.changelog 
 link_to add_special_file_path(@project, file_name: 'CHANGELOG') do 
 end 
 end 
 unless @repository.license_blob 
 link_to add_special_file_path(@project, file_name: 'LICENSE') do 
 end 
 end 
 unless @repository.contribution_guide 
 link_to add_special_file_path(@project, file_name: 'CONTRIBUTING.md', commit_message: 'Add contribution guide') do 
 end 
 end 
 end 
 if @repository.commit 
 container_class 
  if commit.status 
 link_to builds_namespace_project_commit_path(commit.project.namespace, commit.project, commit), class: "ci-status ci-" do 
 ci_icon_for_status(commit.status) 
 ci_label_for_status(commit.status) 
 end 
 end 
 link_to commit.short_id, namespace_project_commit_path(project.namespace, project, commit), class: "commit_short_id" 
 link_to_gfm commit.title, namespace_project_commit_path(project.namespace, project, commit), class: "commit-row-message" 
 commit_author_link(commit, avatar: true, size: 24) 
 
 end 
 container_class 
 if @project.archived? 
 icon("exclamation-triangle fw") 
 end 
 render default_project_view 
 
 yield :scripts_body 
 

end

  end

  def destroy
    return access_denied! unless can?(current_user, :remove_project, @project)

    ::Projects::DestroyService.new(@project, current_user, {}).pending_delete!
    flash[:alert] = "Project '#{@project.name}' will be deleted."

    redirect_to dashboard_projects_path
  rescue Projects::DestroyService::DestroyError => ex
    redirect_to edit_project_path(@project), alert: ex.message
  end

  def autocomplete_sources
    note_type = params['type']
    note_id = params['type_id']
    autocomplete = ::Projects::AutocompleteService.new(@project, current_user)
    participants = ::Projects::ParticipantsService.new(@project, current_user).execute(note_type, note_id)

    @suggestions = {
      emojis: AwardEmoji.urls,
      issues: autocomplete.issues,
      mergerequests: autocomplete.merge_requests,
      members: participants
    }

    respond_to do |format|
      format.json { render json: @suggestions }
    end
  end

  def archive
    return access_denied! unless can?(current_user, :archive_project, @project)

    @project.archive!

    respond_to do |format|
      format.html { redirect_to project_path(@project) }
    end
  end

  def unarchive
    return access_denied! unless can?(current_user, :archive_project, @project)

    @project.unarchive!

    respond_to do |format|
      format.html { redirect_to project_path(@project) }
    end
  end

  def housekeeping
    ::Projects::HousekeepingService.new(@project).execute

    redirect_to(
      project_path(@project),
      notice: "Housekeeping successfully started"
    )
  rescue ::Projects::HousekeepingService::LeaseTaken => ex
    redirect_to(
      edit_project_path(@project),
      alert: ex.to_s
    )
  end

  def toggle_star
    current_user.toggle_star(@project)
    @project.reload

    render json: {
      star_count: @project.star_count
    }
  end

  def markdown_preview
    text = params[:text]

    ext = Gitlab::ReferenceExtractor.new(@project, current_user, current_user)
    ext.analyze(text)

    render json: {
      body:       view_context.markdown(text),
      references: {
        users: ext.users.map(&:username)
      }
    }
  end

  private

  def determine_layout
    if [:new, :create].include?(action_name.to_sym)
      'application'
    elsif [:edit, :update].include?(action_name.to_sym)
      'project_settings'
    else
      'project'
    end
  end

  def load_events
    @events = @project.events.recent
    @events = event_filter.apply_filter(@events).with_associations
    limit = (params[:limit] || 20).to_i
    @events = @events.limit(limit).offset(params[:offset] || 0)
  end

  def project_params
    params.require(:project).permit(
      :name, :path, :description, :issues_tracker, :tag_list, :runners_token,
      :issues_enabled, :merge_requests_enabled, :snippets_enabled, :issues_tracker_id, :default_branch,
      :wiki_enabled, :visibility_level, :import_url, :last_activity_at, :namespace_id, :avatar,
      :builds_enabled, :build_allow_git_fetch, :build_timeout_in_minutes, :build_coverage_regex,
      :public_builds,
    )
  end

  def repo_exists?
    project.repository_exists? && !project.empty_repo?
  end

  # Override get_id from ExtractsPath, which returns the branch and file path
  # for the blob/tree, which in this case is just the root of the default branch.
  def get_id
    project.repository.root_ref
  end
end
