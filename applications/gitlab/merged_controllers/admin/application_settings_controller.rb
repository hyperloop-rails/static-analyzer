class Admin::ApplicationSettingsController < Admin::ApplicationController
  before_action :set_application_setting

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
 page_title "Settings" 
  form_for @application_setting, url: admin_application_settings_path, html: { class: 'form-horizontal fieldset-form' } do |f| 
 form_errors(@application_setting) 
 f.label :default_branch_protection, class: 'control-label col-sm-2' 
 f.select :default_branch_protection, options_for_select(Gitlab::Access.protection_options, @application_setting.default_branch_protection), {}, class: 'form-control' 
 f.label :default_project_visibility, class: 'control-label col-sm-2' 
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
 
 f.label :default_snippet_visibility, class: 'control-label col-sm-2' 
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
 
 f.label :default_group_visibility, class: 'control-label col-sm-2' 
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
 
 f.label :restricted_visibility_levels, class: 'control-label col-sm-2' 
 data_attrs = { toggle: 'buttons' } 
 data_attrs 
 restricted_level_checkboxes('restricted-visibility-help').each do |level| 
 level 
 end 
 f.label :import_sources, class: 'control-label col-sm-2' 
 data_attrs = { toggle: 'buttons' } 
 data_attrs 
 import_sources_checkboxes('import-sources-help').each do |source| 
 source 
 end 
 link_to "(?)", help_page_path("integration", "github") 
 link_to "(?)", help_page_path("integration", "bitbucket") 
 link_to "(?)", help_page_path("integration", "gitlab") 
 f.label :version_check_enabled do 
 f.check_box :version_check_enabled 
 end 
 f.label :email_author_in_body do 
 f.check_box :email_author_in_body 
 end 
 f.label :admin_notification_email, class: 'control-label col-sm-2' 
 f.text_field :admin_notification_email, class: 'form-control' 
 f.label :gravatar_enabled do 
 f.check_box :gravatar_enabled 
 end 
 f.label :default_projects_limit, class: 'control-label col-sm-2' 
 f.number_field :default_projects_limit, class: 'form-control' 
 f.label :max_attachment_size, 'Maximum attachment size (MB)', class: 'control-label col-sm-2' 
 f.number_field :max_attachment_size, class: 'form-control' 
 f.label :session_expire_delay, 'Session duration (minutes)', class: 'control-label col-sm-2' 
 f.number_field :session_expire_delay, class: 'form-control' 
 f.label :user_oauth_applications, 'User OAuth applications', class: 'control-label col-sm-2' 
 f.label :user_oauth_applications do 
 f.check_box :user_oauth_applications 
 end 
 f.label :signup_enabled do 
 f.check_box :signup_enabled 
 end 
 f.label :signin_enabled do 
 f.check_box :signin_enabled 
 end 
 f.label :two_factor_authentication, 'Two-factor authentication', class: 'control-label col-sm-2' 
 f.label :require_two_factor_authentication do 
 f.check_box :require_two_factor_authentication 
 end 
 f.label :two_factor_authentication, 'Two-factor grace period (hours)', class: 'control-label col-sm-2' 
 f.number_field :two_factor_grace_period, min: 0, class: 'form-control', placeholder: '0' 
 f.label :restricted_signup_domains, 'Restricted domains for sign-ups', class: 'control-label col-sm-2' 
 f.text_area :restricted_signup_domains_raw, placeholder: 'domain.com', class: 'form-control' 
 f.label :home_page_url, 'Home page URL', class: 'control-label col-sm-2' 
 f.text_field :home_page_url, class: 'form-control', placeholder: 'http://company.example.com', :'aria-describedby' => 'home_help_block' 
 f.label :after_sign_out_path, class: 'control-label col-sm-2' 
 f.text_field :after_sign_out_path, class: 'form-control', placeholder: 'http://company.example.com', :'aria-describedby' => 'after_sign_out_path_help_block' 
 f.label :sign_in_text, class: 'control-label col-sm-2' 
 f.text_area :sign_in_text, class: 'form-control', rows: 4 
 f.label :help_page_text, class: 'control-label col-sm-2' 
 f.text_area :help_page_text, class: 'form-control', rows: 4 
 f.label :shared_runners_enabled do 
 f.check_box :shared_runners_enabled 
 end 
 f.label :shared_runners_text, class: 'control-label col-sm-2' 
 f.text_area :shared_runners_text, class: 'form-control', rows: 4 
 f.label :max_artifacts_size, 'Maximum artifacts size (MB)', class: 'control-label col-sm-2' 
 f.number_field :max_artifacts_size, class: 'form-control' 
 f.label :metrics_enabled do 
 f.check_box :metrics_enabled 
 end 
 f.label :metrics_host, 'InfluxDB host', class: 'control-label col-sm-2' 
 f.text_field :metrics_host, class: 'form-control', placeholder: 'influxdb.example.com' 
 f.label :metrics_port, 'InfluxDB port', class: 'control-label col-sm-2' 
 f.text_field :metrics_port, class: 'form-control', placeholder: '8089' 
 f.label :metrics_pool_size, 'Connection pool size', class: 'control-label col-sm-2' 
 f.number_field :metrics_pool_size, class: 'form-control' 
 f.label :metrics_timeout, 'Connection timeout', class: 'control-label col-sm-2' 
 f.number_field :metrics_timeout, class: 'form-control' 
 f.label :metrics_method_call_threshold, 'Method Call Threshold (ms)', class: 'control-label col-sm-2' 
 f.number_field :metrics_method_call_threshold, class: 'form-control' 
 f.label :metrics_sample_interval, 'Sampler Interval (sec)', class: 'control-label col-sm-2' 
 f.number_field :metrics_sample_interval, class: 'form-control' 
 f.label :metrics_packet_size, 'Metrics per packet', class: 'control-label col-sm-2' 
 f.number_field :metrics_packet_size, class: 'form-control' 
 f.label :recaptcha_enabled do 
 f.check_box :recaptcha_enabled 
 end 
 f.label :recaptcha_site_key, 'reCAPTCHA Site Key', class: 'control-label col-sm-2' 
 f.text_field :recaptcha_site_key, class: 'form-control' 
 f.label :recaptcha_private_key, 'reCAPTCHA Private Key', class: 'control-label col-sm-2' 
 f.text_field :recaptcha_private_key, class: 'form-control' 
 f.label :akismet_enabled do 
 f.check_box :akismet_enabled 
 end 
 f.label :akismet_api_key, 'Akismet API Key', class: 'control-label col-sm-2' 
 f.text_field :akismet_api_key, class: 'form-control' 
 f.label :sentry_enabled do 
 f.check_box :sentry_enabled 
 end 
 f.label :sentry_dsn, 'Sentry DSN', class: 'control-label col-sm-2' 
 f.text_field :sentry_dsn, class: 'form-control' 
 f.label :repository_checks_enabled do 
 f.check_box :repository_checks_enabled 
 end 
 link_to 'Clear all repository checks', clear_repository_check_states_admin_application_settings_path, data: { confirm: 'This will clear repository check states for ALL projects in the database. This cannot be undone. Are you sure?' }, method: :put, class: "btn btn-sm btn-remove" 
 f.submit 'Save', class: 'btn btn-save' 
 end 
 
 
 yield :scripts_body 
 

end

  end

  def update
    if @application_setting.update_attributes(application_setting_params)
      redirect_to admin_application_settings_path,
        notice: 'Application settings saved successfully'
    else
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
 page_title "Settings" 
  form_for @application_setting, url: admin_application_settings_path, html: { class: 'form-horizontal fieldset-form' } do |f| 
 form_errors(@application_setting) 
 f.label :default_branch_protection, class: 'control-label col-sm-2' 
 f.select :default_branch_protection, options_for_select(Gitlab::Access.protection_options, @application_setting.default_branch_protection), {}, class: 'form-control' 
 f.label :default_project_visibility, class: 'control-label col-sm-2' 
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
 
 f.label :default_snippet_visibility, class: 'control-label col-sm-2' 
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
 
 f.label :default_group_visibility, class: 'control-label col-sm-2' 
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
 
 f.label :restricted_visibility_levels, class: 'control-label col-sm-2' 
 data_attrs = { toggle: 'buttons' } 
 data_attrs 
 restricted_level_checkboxes('restricted-visibility-help').each do |level| 
 level 
 end 
 f.label :import_sources, class: 'control-label col-sm-2' 
 data_attrs = { toggle: 'buttons' } 
 data_attrs 
 import_sources_checkboxes('import-sources-help').each do |source| 
 source 
 end 
 link_to "(?)", help_page_path("integration", "github") 
 link_to "(?)", help_page_path("integration", "bitbucket") 
 link_to "(?)", help_page_path("integration", "gitlab") 
 f.label :version_check_enabled do 
 f.check_box :version_check_enabled 
 end 
 f.label :email_author_in_body do 
 f.check_box :email_author_in_body 
 end 
 f.label :admin_notification_email, class: 'control-label col-sm-2' 
 f.text_field :admin_notification_email, class: 'form-control' 
 f.label :gravatar_enabled do 
 f.check_box :gravatar_enabled 
 end 
 f.label :default_projects_limit, class: 'control-label col-sm-2' 
 f.number_field :default_projects_limit, class: 'form-control' 
 f.label :max_attachment_size, 'Maximum attachment size (MB)', class: 'control-label col-sm-2' 
 f.number_field :max_attachment_size, class: 'form-control' 
 f.label :session_expire_delay, 'Session duration (minutes)', class: 'control-label col-sm-2' 
 f.number_field :session_expire_delay, class: 'form-control' 
 f.label :user_oauth_applications, 'User OAuth applications', class: 'control-label col-sm-2' 
 f.label :user_oauth_applications do 
 f.check_box :user_oauth_applications 
 end 
 f.label :signup_enabled do 
 f.check_box :signup_enabled 
 end 
 f.label :signin_enabled do 
 f.check_box :signin_enabled 
 end 
 f.label :two_factor_authentication, 'Two-factor authentication', class: 'control-label col-sm-2' 
 f.label :require_two_factor_authentication do 
 f.check_box :require_two_factor_authentication 
 end 
 f.label :two_factor_authentication, 'Two-factor grace period (hours)', class: 'control-label col-sm-2' 
 f.number_field :two_factor_grace_period, min: 0, class: 'form-control', placeholder: '0' 
 f.label :restricted_signup_domains, 'Restricted domains for sign-ups', class: 'control-label col-sm-2' 
 f.text_area :restricted_signup_domains_raw, placeholder: 'domain.com', class: 'form-control' 
 f.label :home_page_url, 'Home page URL', class: 'control-label col-sm-2' 
 f.text_field :home_page_url, class: 'form-control', placeholder: 'http://company.example.com', :'aria-describedby' => 'home_help_block' 
 f.label :after_sign_out_path, class: 'control-label col-sm-2' 
 f.text_field :after_sign_out_path, class: 'form-control', placeholder: 'http://company.example.com', :'aria-describedby' => 'after_sign_out_path_help_block' 
 f.label :sign_in_text, class: 'control-label col-sm-2' 
 f.text_area :sign_in_text, class: 'form-control', rows: 4 
 f.label :help_page_text, class: 'control-label col-sm-2' 
 f.text_area :help_page_text, class: 'form-control', rows: 4 
 f.label :shared_runners_enabled do 
 f.check_box :shared_runners_enabled 
 end 
 f.label :shared_runners_text, class: 'control-label col-sm-2' 
 f.text_area :shared_runners_text, class: 'form-control', rows: 4 
 f.label :max_artifacts_size, 'Maximum artifacts size (MB)', class: 'control-label col-sm-2' 
 f.number_field :max_artifacts_size, class: 'form-control' 
 f.label :metrics_enabled do 
 f.check_box :metrics_enabled 
 end 
 f.label :metrics_host, 'InfluxDB host', class: 'control-label col-sm-2' 
 f.text_field :metrics_host, class: 'form-control', placeholder: 'influxdb.example.com' 
 f.label :metrics_port, 'InfluxDB port', class: 'control-label col-sm-2' 
 f.text_field :metrics_port, class: 'form-control', placeholder: '8089' 
 f.label :metrics_pool_size, 'Connection pool size', class: 'control-label col-sm-2' 
 f.number_field :metrics_pool_size, class: 'form-control' 
 f.label :metrics_timeout, 'Connection timeout', class: 'control-label col-sm-2' 
 f.number_field :metrics_timeout, class: 'form-control' 
 f.label :metrics_method_call_threshold, 'Method Call Threshold (ms)', class: 'control-label col-sm-2' 
 f.number_field :metrics_method_call_threshold, class: 'form-control' 
 f.label :metrics_sample_interval, 'Sampler Interval (sec)', class: 'control-label col-sm-2' 
 f.number_field :metrics_sample_interval, class: 'form-control' 
 f.label :metrics_packet_size, 'Metrics per packet', class: 'control-label col-sm-2' 
 f.number_field :metrics_packet_size, class: 'form-control' 
 f.label :recaptcha_enabled do 
 f.check_box :recaptcha_enabled 
 end 
 f.label :recaptcha_site_key, 'reCAPTCHA Site Key', class: 'control-label col-sm-2' 
 f.text_field :recaptcha_site_key, class: 'form-control' 
 f.label :recaptcha_private_key, 'reCAPTCHA Private Key', class: 'control-label col-sm-2' 
 f.text_field :recaptcha_private_key, class: 'form-control' 
 f.label :akismet_enabled do 
 f.check_box :akismet_enabled 
 end 
 f.label :akismet_api_key, 'Akismet API Key', class: 'control-label col-sm-2' 
 f.text_field :akismet_api_key, class: 'form-control' 
 f.label :sentry_enabled do 
 f.check_box :sentry_enabled 
 end 
 f.label :sentry_dsn, 'Sentry DSN', class: 'control-label col-sm-2' 
 f.text_field :sentry_dsn, class: 'form-control' 
 f.label :repository_checks_enabled do 
 f.check_box :repository_checks_enabled 
 end 
 link_to 'Clear all repository checks', clear_repository_check_states_admin_application_settings_path, data: { confirm: 'This will clear repository check states for ALL projects in the database. This cannot be undone. Are you sure?' }, method: :put, class: "btn btn-sm btn-remove" 
 f.submit 'Save', class: 'btn btn-save' 
 end 
 
 
 yield :scripts_body 
 

end

    end
  end

  def reset_runners_token
    @application_setting.reset_runners_registration_token!
    flash[:notice] = 'New runners registration token has been generated!'
    redirect_to admin_runners_path
  end

  def clear_repository_check_states
    RepositoryCheck::ClearWorker.perform_async

    redirect_to(
      admin_application_settings_path,
      notice: 'Started asynchronous removal of all repository check states.'
    )
  end

  private

  def set_application_setting
    @application_setting = ApplicationSetting.current
  end

  def application_setting_params
    restricted_levels = params[:application_setting][:restricted_visibility_levels]
    if restricted_levels.nil?
      params[:application_setting][:restricted_visibility_levels] = []
    else
      restricted_levels.map! do |level|
        level.to_i
      end
    end

    import_sources = params[:application_setting][:import_sources]
    if import_sources.nil?
      params[:application_setting][:import_sources] = []
    else
      import_sources.map! do |source|
        source.to_str
      end
    end

    params.require(:application_setting).permit(
      :default_projects_limit,
      :default_branch_protection,
      :signup_enabled,
      :signin_enabled,
      :require_two_factor_authentication,
      :two_factor_grace_period,
      :gravatar_enabled,
      :sign_in_text,
      :help_page_text,
      :home_page_url,
      :after_sign_out_path,
      :max_attachment_size,
      :session_expire_delay,
      :default_project_visibility,
      :default_snippet_visibility,
      :default_group_visibility,
      :restricted_signup_domains_raw,
      :version_check_enabled,
      :admin_notification_email,
      :user_oauth_applications,
      :shared_runners_enabled,
      :shared_runners_text,
      :max_artifacts_size,
      :metrics_enabled,
      :metrics_host,
      :metrics_port,
      :metrics_pool_size,
      :metrics_timeout,
      :metrics_method_call_threshold,
      :metrics_sample_interval,
      :recaptcha_enabled,
      :recaptcha_site_key,
      :recaptcha_private_key,
      :sentry_enabled,
      :sentry_dsn,
      :akismet_enabled,
      :akismet_api_key,
      :email_author_in_body,
      :repository_checks_enabled,
      :metrics_packet_size,
      restricted_visibility_levels: [],
      import_sources: []
    )
  end
end
