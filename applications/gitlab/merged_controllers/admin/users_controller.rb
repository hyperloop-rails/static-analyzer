class Admin::UsersController < Admin::ApplicationController
  before_action :user, except: [:index, :new, :create]

  def index
    @users = User.order_name_asc.filter(params[:filter])
    @users = @users.search(params[:name]) if params[:name].present?
    @users = @users.sort(@sort = params[:sort])
    @users = @users.page(params[:page])
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
 page_title "Users" 
  link_to '#aside', class: 'show-aside' do 
 end 
 
 link_to admin_users_path do 
 number_with_delimiter(User.active.count) 
 end 
 link_to admin_users_path(filter: "admins") do 
 number_with_delimiter(User.admins.count) 
 end 
 link_to admin_users_path(filter: 'two_factor_enabled') do 
 number_with_delimiter(User.with_two_factor.count) 
 end 
 link_to admin_users_path(filter: 'two_factor_disabled') do 
 number_with_delimiter(User.without_two_factor.count) 
 end 
 link_to admin_users_path(filter: 'external') do 
 number_with_delimiter(User.external.count) 
 end 
 link_to admin_users_path(filter: "blocked") do 
 number_with_delimiter(User.blocked.count) 
 end 
 link_to admin_users_path(filter: "wop") do 
 number_with_delimiter(User.without_projects.count) 
 end 
 if @sort.present? 
 sort_options_hash[@sort] 
 else 
 sort_title_name 
 end 
 link_to admin_users_path(sort: sort_value_name, filter: params[:filter]) do 
 sort_title_name 
 end 
 link_to admin_users_path(sort: sort_value_recently_signin, filter: params[:filter]) do 
 sort_title_recently_signin 
 end 
 link_to admin_users_path(sort: sort_value_oldest_signin, filter: params[:filter]) do 
 sort_title_oldest_signin 
 end 
 link_to admin_users_path(sort: sort_value_recently_created, filter: params[:filter]) do 
 sort_title_recently_created 
 end 
 link_to admin_users_path(sort: sort_value_oldest_created, filter: params[:filter]) do 
 sort_title_oldest_created 
 end 
 link_to admin_users_path(sort: sort_value_recently_updated, filter: params[:filter]) do 
 sort_title_recently_updated 
 end 
 link_to admin_users_path(sort: sort_value_oldest_updated, filter: params[:filter]) do 
 sort_title_oldest_updated 
 end 
 link_to 'New User', new_admin_user_path, class: "btn btn-new" 
 form_tag admin_users_path, method: :get, class: 'form-inline' do 
 search_field_tag :name, params[:name], placeholder: 'Name, email or username', class: 'form-control', spellcheck: false 
 hidden_field_tag "filter", params[:filter] 
 button_tag class: 'btn btn-primary' do 
 end 
 end 
 @users.each do |user| 
 if user.blocked? 
 icon("lock", class: "cred") 
 else 
 icon("user", class: "cgreen") 
 end 
 link_to user.name, [:admin, user] 
 if user.admin? 
 end 
 if user.external? 
 end 
 if user == current_user 
 end 
 mail_to user.email, user.email, class: 'light' 
 link_to 'Edit', edit_admin_user_path(user), id: "edit_", class: 'btn-grouped btn btn-xs' 
 unless user == current_user 
 if user.ldap_blocked? 
 link_to '#', title: 'Cannot unblock LDAP blocked users', data: {toggle: 'tooltip'}, class: 'btn-grouped btn btn-xs btn-success disabled' do 
 end 
 elsif user.blocked? 
 link_to 'Unblock', unblock_admin_user_path(user), method: :put, class: 'btn-grouped btn btn-xs btn-success' 
 else 
 link_to 'Block', block_admin_user_path(user), data: {confirm: 'USER WILL BE BLOCKED! Are you sure?'}, method: :put, class: 'btn-grouped btn btn-xs btn-warning' 
 end 
 if user.access_locked? 
 link_to 'Unlock', unlock_admin_user_path(user), method: :put, class: 'btn-grouped btn btn-xs btn-success', data: { confirm: 'Are you sure?' } 
 end 
 if user.can_be_removed? 
 link_to 'Destroy', [:admin, user], data: {}, method: :delete, class: 'btn-grouped btn btn-xs btn-remove' 
 end 
 end 
 end 
 paginate @users, theme: "gitlab" 
 
 yield :scripts_body 
 

end

  end

  def show
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
 page_title @user.name, "Users" 
  @user.name 
 if @user.blocked? 
 end 
 if @user.admin 
 end 
 unless @user == current_user || @user.blocked? 
 link_to 'Impersonate', impersonate_admin_user_path(@user), method: :post, class: "btn btn-nr btn-grouped btn-info" 
 end 
 link_to edit_admin_user_path(@user), class: "btn btn-nr btn-grouped" do 
 end 
 nav_link(path: 'users#show') do 
 link_to "Account", admin_user_path(@user) 
 end 
 nav_link(path: 'users#groups') do 
 link_to "Groups", groups_admin_user_path(@user) 
 end 
 nav_link(path: 'users#projects') do 
 link_to "Projects", projects_admin_user_path(@user) 
 end 
 nav_link(path: 'users#keys') do 
 link_to "SSH keys", keys_admin_user_path(@user) 
 end 
 nav_link(controller: :identities) do 
 link_to "Identities", admin_user_identities_path(@user) 
 end 
 
 @user.name 
 image_tag avatar_icon(@user, 60), class: "avatar s60" 
 link_to user_path(@user) do 
 @user.username 
 end 
  user.created_at.to_s(:medium) 
 unless user.public_email.blank? 
 link_to user.public_email, "mailto:" 
 end 
 unless user.skype.blank? 
 link_to user.skype, "skype:" 
 end 
 unless user.linkedin.blank? 
 link_to user.linkedin, "https://www.linkedin.com/in/" 
 end 
 unless user.twitter.blank? 
 link_to user.twitter, "https://twitter.com/" 
 end 
 unless user.website_url.blank? 
 link_to user.short_website_url, user.full_website_url 
 end 
 unless user.location.blank? 
 user.location 
 end 
 
 @user.name 
 @user.username 
 mail_to @user.email 
 @user.emails.each do |email| 
 email.email 
 link_to remove_email_admin_user_path(@user, email), data: {}, method: :delete, class: "btn-xs btn btn-remove pull-right", title: 'Remove secondary email', id: "remove_email_" do 
 end 
 end 
 if @user.two_factor_enabled? 
 link_to 'Disable', disable_two_factor_admin_user_path(@user), data: {confirm: 'Are you sure?'}, method: :patch, class: 'btn btn-xs btn-remove pull-right', title: 'Disable Two-factor Authentication' 
 else 
 end 
 @user.external? ? "Yes" : "No" 
 @user.can_create_group ? "Yes" : "No" 
 @user.projects_limit 
 @user.created_at.to_s(:medium) 
 if @user.confirmed_at 
 @user.confirmed_at.to_s(:medium) 
 else 
 end 
 if @user.current_sign_in_ip 
 @user.current_sign_in_ip 
 else 
 end 
 if @user.current_sign_in_at 
 @user.current_sign_in_at.to_s(:medium) 
 else 
 end 
 if @user.last_sign_in_ip 
 @user.last_sign_in_ip 
 else 
 end 
 if @user.last_sign_in_at 
 @user.last_sign_in_at.to_s(:medium) 
 else 
 end 
 @user.sign_in_count 
 if @user.ldap_user? 
 @user.ldap_identity.extern_uid 
 end 
 if @user.created_by 
 link_to @user.created_by.name, [:admin, @user.created_by] 
 end 
 unless @user == current_user 
 unless @user.confirmed? 
 if @user.unconfirmed_email.present? 
 email = " ()" 
 end 
 link_to 'Confirm user', confirm_admin_user_path(@user), method: :put, class: "btn btn-info", data: { confirm: 'Are you sure?' } 
 end 
 if @user.blocked? 
 link_to 'Unblock user', unblock_admin_user_path(@user), method: :put, class: "btn btn-info", data: { confirm: 'Are you sure?' } 
 else 
 link_to 'Block user', block_admin_user_path(@user), data: { confirm: 'USER WILL BE BLOCKED! Are you sure?' }, method: :put, class: "btn btn-warning" 
 end 
 if @user.access_locked? 
 link_to 'Unlock user', unlock_admin_user_path(@user), method: :put, class: "btn btn-info", data: { confirm: 'Are you sure?' } 
 end 
 if @user.can_be_removed? 
 rp = @user.personal_projects.count 
 unless rp.zero? 
 end 
 link_to 'Remove user', [:admin, @user], data: {}, method: :delete, class: "btn btn-remove" 
 else 
 if @user.solo_owned_groups.present? 
 end 
 end 
 end 
 
 yield :scripts_body 
 

end

  end

  def projects
    @personal_projects = user.personal_projects
    @joined_projects = user.projects.joined(@user)
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
 page_title "Projects", @user.name, "Users" 
 render 'admin/users/head' 
 if @user.groups.any? 
 @user.groups.each do |group| 
 group.name 
 end 
 end 
 if @personal_projects.present? 
  page_title "Projects", @user.name, "Users" 
  @user.name 
 if @user.blocked? 
 end 
 if @user.admin 
 end 
 unless @user == current_user || @user.blocked? 
 link_to 'Impersonate', impersonate_admin_user_path(@user), method: :post, class: "btn btn-nr btn-grouped btn-info" 
 end 
 link_to edit_admin_user_path(@user), class: "btn btn-nr btn-grouped" do 
 end 
 nav_link(path: 'users#show') do 
 link_to "Account", admin_user_path(@user) 
 end 
 nav_link(path: 'users#groups') do 
 link_to "Groups", groups_admin_user_path(@user) 
 end 
 nav_link(path: 'users#projects') do 
 link_to "Projects", projects_admin_user_path(@user) 
 end 
 nav_link(path: 'users#keys') do 
 link_to "SSH keys", keys_admin_user_path(@user) 
 end 
 nav_link(controller: :identities) do 
 link_to "Identities", admin_user_identities_path(@user) 
 end 
 
 if @user.groups.any? 
 @user.groups.each do |group| 
 group.name 
 end 
 end 
 if @personal_projects.present? 
 render 'admin/users/projects', projects: @personal_projects 
 else 
 end 
 @joined_projects.sort_by(&:name_with_namespace).each do |project| 
 member = project.team.find_member(@user.id) 
 link_to admin_namespace_project_path(project.namespace, project), class: dom_class(project) do 
 project.name_with_namespace 
 end 
 if member 
 if member.owner? 
 else 
 member.human_access 
 if member.respond_to? :project 
 link_to namespace_project_project_member_path(project.namespace, project, member), data: { confirm: remove_from_project_team_message(project, member) }, remote: true, method: :delete, class: "btn-xs btn btn-remove", title: 'Remove user from project' do 
 end 
 end 
 end 
 end 
 end 
 
 else 
 end 
 @joined_projects.sort_by(&:name_with_namespace).each do |project| 
 member = project.team.find_member(@user.id) 
 link_to admin_namespace_project_path(project.namespace, project), class: dom_class(project) do 
 project.name_with_namespace 
 end 
 if member 
 if member.owner? 
 else 
 member.human_access 
 if member.respond_to? :project 
 link_to namespace_project_project_member_path(project.namespace, project, member), data: { confirm: remove_from_project_team_message(project, member) }, remote: true, method: :delete, class: "btn-xs btn btn-remove", title: 'Remove user from project' do 
 end 
 end 
 end 
 end 
 end 
 
 yield :scripts_body 
 

end

  end

  def groups
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
 page_title "Groups", @user.name, "Users" 
  @user.name 
 if @user.blocked? 
 end 
 if @user.admin 
 end 
 unless @user == current_user || @user.blocked? 
 link_to 'Impersonate', impersonate_admin_user_path(@user), method: :post, class: "btn btn-nr btn-grouped btn-info" 
 end 
 link_to edit_admin_user_path(@user), class: "btn btn-nr btn-grouped" do 
 end 
 nav_link(path: 'users#show') do 
 link_to "Account", admin_user_path(@user) 
 end 
 nav_link(path: 'users#groups') do 
 link_to "Groups", groups_admin_user_path(@user) 
 end 
 nav_link(path: 'users#projects') do 
 link_to "Projects", projects_admin_user_path(@user) 
 end 
 nav_link(path: 'users#keys') do 
 link_to "SSH keys", keys_admin_user_path(@user) 
 end 
 nav_link(controller: :identities) do 
 link_to "Identities", admin_user_identities_path(@user) 
 end 
 
 if @user.group_members.present? 
 @user.group_members.each do |group_member| 
 group = group_member.group 
 ("list-item-name" unless group_member.owner?) 
 link_to group.name, admin_group_path(group) 
 group_member.human_access 
 unless group_member.owner? 
 link_to group_group_member_path(group, group_member), data: { confirm: remove_user_from_group_message(group, group_member) }, method: :delete, remote: true, class: "btn-xs btn btn-remove", title: 'Remove user from group' do 
 end 
 end 
 end 
 else 
 end 
 
 yield :scripts_body 
 

end

  end

  def keys
    @keys = user.keys
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
 page_title "SSH Keys", @user.name, "Users" 
  @user.name 
 if @user.blocked? 
 end 
 if @user.admin 
 end 
 unless @user == current_user || @user.blocked? 
 link_to 'Impersonate', impersonate_admin_user_path(@user), method: :post, class: "btn btn-nr btn-grouped btn-info" 
 end 
 link_to edit_admin_user_path(@user), class: "btn btn-nr btn-grouped" do 
 end 
 nav_link(path: 'users#show') do 
 link_to "Account", admin_user_path(@user) 
 end 
 nav_link(path: 'users#groups') do 
 link_to "Groups", groups_admin_user_path(@user) 
 end 
 nav_link(path: 'users#projects') do 
 link_to "Projects", projects_admin_user_path(@user) 
 end 
 nav_link(path: 'users#keys') do 
 link_to "SSH keys", keys_admin_user_path(@user) 
 end 
 nav_link(controller: :identities) do 
 link_to "Identities", admin_user_identities_path(@user) 
 end 
 
  is_admin = local_assigns.fetch(:admin, false) 
 if @keys.any? 
  icon 'key', class: "settings-list-icon hidden-xs" 
 link_to path_to_key(key, is_admin), class: "title" do 
 key.title 
 end 
 key.fingerprint 
 link_to path_to_key(key, is_admin), data: { confirm: 'Are you sure?'}, method: :delete, class: "btn btn-transparent prepend-left-10" do 
 icon('trash') 
 end 
 
 else 
 if is_admin 
 else 
 end 
 end 
 
 
 yield :scripts_body 
 

end

  end

  def new
    @user = User.new
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
 page_title "New User" 
  form_for [:admin, @user], html: { class: 'form-horizontal fieldset-form' } do |f| 
 form_errors(@user) 
 f.label :name, class: 'control-label' 
 f.text_field :name, required: true, autocomplete: 'off', class: 'form-control' 
 f.label :username, class: 'control-label' 
 f.text_field :username, required: true, autocomplete: 'off', autocorrect: 'off', autocapitalize: 'off', spellcheck: false, class: 'form-control' 
 f.label :email, class: 'control-label' 
 f.text_field :email, required: true, autocomplete: 'off', class: 'form-control' 
 if @user.new_record? 
 f.label :password, class: 'control-label' 
 else 
 f.label :password, class: 'control-label' 
 f.password_field :password, disabled: f.object.force_random_password, class: 'form-control' 
 f.label :password_confirmation, class: 'control-label' 
 f.password_field :password_confirmation, disabled: f.object.force_random_password, class: 'form-control' 
 end 
 f.label :projects_limit, class: 'control-label' 
 f.number_field :projects_limit, class: 'form-control' 
 f.label :can_create_group, class: 'control-label' 
 f.check_box :can_create_group 
 f.label :admin, class: 'control-label' 
 if current_user == @user 
 f.check_box :admin, disabled: true 
 else 
 f.check_box :admin 
 end 
 f.label :external, class: 'control-label' 
 f.check_box :external 
 f.label :avatar, class: 'control-label' 
 f.file_field :avatar 
 f.label :skype, class: 'control-label' 
 f.text_field :skype, class: 'form-control' 
 f.label :linkedin, class: 'control-label' 
 f.text_field :linkedin, class: 'form-control' 
 f.label :twitter, class: 'control-label' 
 f.text_field :twitter, class: 'form-control' 
 f.label :website_url, 'Website', class: 'control-label' 
 f.text_field :website_url, class: 'form-control' 
 if @user.new_record? 
 f.submit 'Create user', class: "btn btn-create" 
 link_to 'Cancel', admin_users_path, class: "btn btn-cancel" 
 else 
 f.submit 'Save changes', class: "btn btn-save" 
 link_to 'Cancel', admin_user_path(@user), class: "btn btn-cancel" 
 end 
 end 
 
 
 yield :scripts_body 
 

end

  end

  def edit
    user
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
 page_title "Edit", @user.name, "Users" 
  form_for [:admin, @user], html: { class: 'form-horizontal fieldset-form' } do |f| 
 form_errors(@user) 
 f.label :name, class: 'control-label' 
 f.text_field :name, required: true, autocomplete: 'off', class: 'form-control' 
 f.label :username, class: 'control-label' 
 f.text_field :username, required: true, autocomplete: 'off', autocorrect: 'off', autocapitalize: 'off', spellcheck: false, class: 'form-control' 
 f.label :email, class: 'control-label' 
 f.text_field :email, required: true, autocomplete: 'off', class: 'form-control' 
 if @user.new_record? 
 f.label :password, class: 'control-label' 
 else 
 f.label :password, class: 'control-label' 
 f.password_field :password, disabled: f.object.force_random_password, class: 'form-control' 
 f.label :password_confirmation, class: 'control-label' 
 f.password_field :password_confirmation, disabled: f.object.force_random_password, class: 'form-control' 
 end 
 f.label :projects_limit, class: 'control-label' 
 f.number_field :projects_limit, class: 'form-control' 
 f.label :can_create_group, class: 'control-label' 
 f.check_box :can_create_group 
 f.label :admin, class: 'control-label' 
 if current_user == @user 
 f.check_box :admin, disabled: true 
 else 
 f.check_box :admin 
 end 
 f.label :external, class: 'control-label' 
 f.check_box :external 
 f.label :avatar, class: 'control-label' 
 f.file_field :avatar 
 f.label :skype, class: 'control-label' 
 f.text_field :skype, class: 'form-control' 
 f.label :linkedin, class: 'control-label' 
 f.text_field :linkedin, class: 'form-control' 
 f.label :twitter, class: 'control-label' 
 f.text_field :twitter, class: 'form-control' 
 f.label :website_url, 'Website', class: 'control-label' 
 f.text_field :website_url, class: 'form-control' 
 if @user.new_record? 
 f.submit 'Create user', class: "btn btn-create" 
 link_to 'Cancel', admin_users_path, class: "btn btn-cancel" 
 else 
 f.submit 'Save changes', class: "btn btn-save" 
 link_to 'Cancel', admin_user_path(@user), class: "btn btn-cancel" 
 end 
 end 
 
 
 yield :scripts_body 
 

end

  end

  def impersonate
    if user.blocked?
      flash[:alert] = "You cannot impersonate a blocked user"

      redirect_to admin_user_path(user)
    else
      session[:impersonator_id] = current_user.id

      warden.set_user(user, scope: :user)

      Gitlab::AppLogger.info("User #{current_user.username} has started impersonating #{user.username}")

      flash[:alert] = "You are now impersonating #{user.username}"

      redirect_to root_path
    end
  end

  def block
    if user.block
      redirect_back_or_admin_user(notice: "Successfully blocked")
    else
      redirect_back_or_admin_user(alert: "Error occurred. User was not blocked")
    end
  end

  def unblock
    if user.ldap_blocked?
      redirect_back_or_admin_user(alert: "This user cannot be unlocked manually from GitLab")
    elsif user.activate
      redirect_back_or_admin_user(notice: "Successfully unblocked")
    else
      redirect_back_or_admin_user(alert: "Error occurred. User was not unblocked")
    end
  end

  def unlock
    if user.unlock_access!
      redirect_back_or_admin_user(alert: "Successfully unlocked")
    else
      redirect_back_or_admin_user(alert: "Error occurred. User was not unlocked")
    end
  end

  def confirm
    if user.confirm
      redirect_back_or_admin_user(notice: "Successfully confirmed")
    else
      redirect_back_or_admin_user(alert: "Error occurred. User was not confirmed")
    end
  end

  def disable_two_factor
    user.disable_two_factor!
    redirect_to admin_user_path(user),
      notice: 'Two-factor Authentication has been disabled for this user'
  end

  def create
    opts = {
      force_random_password: true,
      password_expires_at: nil
    }

    @user = User.new(user_params.merge(opts))
    @user.created_by_id = current_user.id
    @user.generate_password
    @user.generate_reset_token
    @user.skip_confirmation!

    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user], notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 page_title "New User" 
  form_for [:admin, @user], html: { class: 'form-horizontal fieldset-form' } do |f| 
 form_errors(@user) 
 f.label :name, class: 'control-label' 
 f.text_field :name, required: true, autocomplete: 'off', class: 'form-control' 
 f.label :username, class: 'control-label' 
 f.text_field :username, required: true, autocomplete: 'off', autocorrect: 'off', autocapitalize: 'off', spellcheck: false, class: 'form-control' 
 f.label :email, class: 'control-label' 
 f.text_field :email, required: true, autocomplete: 'off', class: 'form-control' 
 if @user.new_record? 
 f.label :password, class: 'control-label' 
 else 
 f.label :password, class: 'control-label' 
 f.password_field :password, disabled: f.object.force_random_password, class: 'form-control' 
 f.label :password_confirmation, class: 'control-label' 
 f.password_field :password_confirmation, disabled: f.object.force_random_password, class: 'form-control' 
 end 
 f.label :projects_limit, class: 'control-label' 
 f.number_field :projects_limit, class: 'form-control' 
 f.label :can_create_group, class: 'control-label' 
 f.check_box :can_create_group 
 f.label :admin, class: 'control-label' 
 if current_user == @user 
 f.check_box :admin, disabled: true 
 else 
 f.check_box :admin 
 end 
 f.label :external, class: 'control-label' 
 f.check_box :external 
 f.label :avatar, class: 'control-label' 
 f.file_field :avatar 
 f.label :skype, class: 'control-label' 
 f.text_field :skype, class: 'form-control' 
 f.label :linkedin, class: 'control-label' 
 f.text_field :linkedin, class: 'form-control' 
 f.label :twitter, class: 'control-label' 
 f.text_field :twitter, class: 'form-control' 
 f.label :website_url, 'Website', class: 'control-label' 
 f.text_field :website_url, class: 'form-control' 
 if @user.new_record? 
 f.submit 'Create user', class: "btn btn-create" 
 link_to 'Cancel', admin_users_path, class: "btn btn-cancel" 
 else 
 f.submit 'Save changes', class: "btn btn-save" 
 link_to 'Cancel', admin_user_path(@user), class: "btn btn-cancel" 
 end 
 end 
 
 
 yield :scripts_body 
 

end
 }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    user_params_with_pass = user_params.dup

    if params[:user][:password].present?
      user_params_with_pass.merge!(
        password: params[:user][:password],
        password_confirmation: params[:user][:password_confirmation],
      )
    end

    respond_to do |format|
      user.skip_reconfirmation!
      if user.update_attributes(user_params_with_pass)
        format.html { redirect_to [:admin, user], notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        # restore username to keep form action url.
        user.username = params[:id]
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 page_title "Edit", @user.name, "Users" 
  form_for [:admin, @user], html: { class: 'form-horizontal fieldset-form' } do |f| 
 form_errors(@user) 
 f.label :name, class: 'control-label' 
 f.text_field :name, required: true, autocomplete: 'off', class: 'form-control' 
 f.label :username, class: 'control-label' 
 f.text_field :username, required: true, autocomplete: 'off', autocorrect: 'off', autocapitalize: 'off', spellcheck: false, class: 'form-control' 
 f.label :email, class: 'control-label' 
 f.text_field :email, required: true, autocomplete: 'off', class: 'form-control' 
 if @user.new_record? 
 f.label :password, class: 'control-label' 
 else 
 f.label :password, class: 'control-label' 
 f.password_field :password, disabled: f.object.force_random_password, class: 'form-control' 
 f.label :password_confirmation, class: 'control-label' 
 f.password_field :password_confirmation, disabled: f.object.force_random_password, class: 'form-control' 
 end 
 f.label :projects_limit, class: 'control-label' 
 f.number_field :projects_limit, class: 'form-control' 
 f.label :can_create_group, class: 'control-label' 
 f.check_box :can_create_group 
 f.label :admin, class: 'control-label' 
 if current_user == @user 
 f.check_box :admin, disabled: true 
 else 
 f.check_box :admin 
 end 
 f.label :external, class: 'control-label' 
 f.check_box :external 
 f.label :avatar, class: 'control-label' 
 f.file_field :avatar 
 f.label :skype, class: 'control-label' 
 f.text_field :skype, class: 'form-control' 
 f.label :linkedin, class: 'control-label' 
 f.text_field :linkedin, class: 'form-control' 
 f.label :twitter, class: 'control-label' 
 f.text_field :twitter, class: 'form-control' 
 f.label :website_url, 'Website', class: 'control-label' 
 f.text_field :website_url, class: 'form-control' 
 if @user.new_record? 
 f.submit 'Create user', class: "btn btn-create" 
 link_to 'Cancel', admin_users_path, class: "btn btn-cancel" 
 else 
 f.submit 'Save changes', class: "btn btn-save" 
 link_to 'Cancel', admin_user_path(@user), class: "btn btn-cancel" 
 end 
 end 
 
 
 yield :scripts_body 
 

end
 }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    DeleteUserWorker.perform_async(current_user.id, user.id)

    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "The user is being deleted." }
      format.json { head :ok }
    end
  end

  def remove_email
    email = user.emails.find(params[:email_id])
    email.destroy

    user.update_secondary_emails!

    respond_to do |format|
      format.html { redirect_back_or_admin_user(notice: "Successfully removed email.") }
      format.js { render nothing: true }
    end
  end

  protected

  def user
    @user ||= User.find_by!(username: params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email, :remember_me, :bio, :name, :username,
      :skype, :linkedin, :twitter, :website_url, :color_scheme_id, :theme_id, :force_random_password,
      :extern_uid, :provider, :password_expires_at, :avatar, :hide_no_ssh_key, :hide_no_password,
      :projects_limit, :can_create_group, :admin, :key_id, :external
    )
  end

  def redirect_back_or_admin_user(options = {})
    redirect_back_or_default(default: default_route, options: options)
  end

  def default_route
    [:admin, @user]
  end
end
