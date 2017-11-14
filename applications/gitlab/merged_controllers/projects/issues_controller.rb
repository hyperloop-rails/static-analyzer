class Projects::IssuesController < Projects::ApplicationController
  include ToggleSubscriptionAction
  include IssuableActions

  before_action :module_enabled
  before_action :issue, only: [:edit, :update, :show, :referenced_merge_requests,
                               :related_branches, :can_create_branch]

  # Allow read any issue
  before_action :authorize_read_issue!, only: [:show]

  # Allow write(create) issue
  before_action :authorize_create_issue!, only: [:new, :create]

  # Allow modify issue
  before_action :authorize_update_issue!, only: [:edit, :update]

  # Allow issues bulk update
  before_action :authorize_admin_issues!, only: [:bulk_update]

  respond_to :html

  def index
    terms = params['issue_search']
    @issues = get_issues_collection

    if terms.present?
      if terms =~ /\A#(\d+)\z/
        @issues = @issues.where(iid: $1)
      else
        @issues = @issues.full_search(terms)
      end
    end

    @issues = @issues.page(params[:page])
    @labels = @project.labels.where(title: params[:label_name])

    respond_to do |format|
      format.html
      format.atom { render layout: false }
      format.json do
        render json: {
          html: view_to_html_string("projects/issues/_issues"),
          labels: @labels.as_json(methods: :text_color)
        }
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
 auto_discovery_link_tag(:atom, namespace_project_issues_url(@project.namespace, @project, :atom, private_token: current_user.private_token), title: " issues") 
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
 page_title "Issues" 
  header_title project_title(@project, "Issues", namespace_project_issues_path(@project.namespace, @project)) 
 
  
  if defined?(type) && type == :merge_requests 
 page_context_word = 'merge requests' 
 else 
 page_context_word = 'issues' 
 end 
 ("active" if params[:state] == 'opened') 
 link_to page_filter_path(state: 'opened', label: true), title: "Filter by  that are currently opened."  
 if defined?(type) && type == :merge_requests 
 ("active" if params[:state] == 'merged') 
 link_to page_filter_path(state: 'merged', label: true), title: 'Filter by merge requests that are currently merged.' 
 ("active" if params[:state] == 'closed') 
 link_to page_filter_path(state: 'closed', label: true), title: 'Filter by merge requests that are currently closed and unmerged.' 
 else 
 ("active" if params[:state] == 'closed') 
 link_to page_filter_path(state: 'closed', label: true), title: 'Filter by issues that are currently closed.' 
 end 
 ("active" if params[:state] == 'all') 
 link_to page_filter_path(state: 'all', label: true), title: "Show all ." 
 
 if current_user 
 link_to namespace_project_issues_path(@project.namespace, @project, :atom, { private_token: current_user.private_token }), class: 'btn append-right-10' do 
 icon('rss') 
 end 
  form_tag(path, method: :get, id: "issue_search_form", class: 'issue-search-form') do 
 search_field_tag :issue_search, params[:issue_search], { placeholder: 'Filter by name ...', class: 'form-control issue_search search-text-input input-short', spellcheck: false } 
 hidden_field_tag :state, params['state'] 
 hidden_field_tag :scope, params['scope'] 
 hidden_field_tag :assignee_id, params['assignee_id'] 
 hidden_field_tag :author_id, params['author_id'] 
 hidden_field_tag :milestone_id, params['milestone_id'] 
 hidden_field_tag :label_id, params['label_id'] 
 end 
 
 end 
 if can? current_user, :create_issue, @project 
 link_to new_namespace_project_issue_path(@project.namespace, @project, issue: { assignee_id: @issuable_finder.assignee.try(:id), milestone_id: @issuable_finder.milestones.try(:first).try(:id) }), class: "btn btn-new", title: "New Issue", id: "new_issue_link" do 
 icon('plus') 
 end 
 end 
  form_tag page_filter_path(without: [:assignee_id, :author_id, :milestone_title, :label_name]), method: :get, class: 'filter-form' do 
 if controller.controller_name == 'issues' && can?(current_user, :admin_issue, @project) 
 check_box_tag "check_all_issues", nil, false,            class: "check_all_issues left" 
 end 
 if params[:author_id].present? 
 hidden_field_tag(:author_id, params[:author_id]) 
 end 
 dropdown_tag(user_dropdown_label(params[:author_id], "Author"), options: { toggle_class: "js-user-search js-filter-submit js-author-search", title: "Filter by author", filter: true, dropdown_class: "dropdown-menu-user dropdown-menu-selectable dropdown-menu-author js-filter-submit",            placeholder: "Search authors", data: { any_user: "Any Author", first_user: (current_user.username if current_user), current_user: true, project_id: (@project.id if @project), selected: params[:author_id], field_name: "author_id", default_label: "Author" } }) 
 if params[:assignee_id].present? 
 hidden_field_tag(:assignee_id, params[:assignee_id]) 
 end 
 dropdown_tag(user_dropdown_label(params[:assignee_id], "Assignee"), options: { toggle_class: "js-user-search js-filter-submit js-assignee-search", title: "Filter by assignee", filter: true, dropdown_class: "dropdown-menu-user dropdown-menu-selectable dropdown-menu-assignee js-filter-submit",            placeholder: "Search assignee", data: { any_user: "Any Assignee", first_user: (current_user.username if current_user), null_user: true, current_user: true, project_id: (@project.id if @project), selected: params[:assignee_id], field_name: "assignee_id", default_label: "Assignee" } }) 
  if params[:milestone_title].present? 
 hidden_field_tag(:milestone_title, params[:milestone_title]) 
 end 
 dropdown_tag(milestone_dropdown_label(params[:milestone_title]), options: { title: "Filter by milestone", toggle_class: 'js-milestone-select js-filter-submit', filter: true, dropdown_class: "dropdown-menu-selectable",  placeholder: "Search milestones", footer_content: @project.present?, data: { show_no: true, show_any: true, show_upcoming: true, field_name: "milestone_title", selected: params[:milestone_title], project_id: @project.try(:id), milestones: milestones_filter_dropdown_path, default_label: "Milestone" } }) do 
 if @project 
 if can? current_user, :admin_milestone, @project 
 link_to new_namespace_project_milestone_path(@project.namespace, @project), title: "New Milestone" do 
 end 
 end 
 link_to namespace_project_milestones_path(@project.namespace, @project) do 
 if can? current_user, :admin_milestone, @project 
 else 
 end 
 end 
 end 
 end 
 
  if params[:label_name].present? 
 if params[:label_name].respond_to?('any?') 
 params[:label_name].each do |label| 
 hidden_field_tag "label_name[]", label, id: nil 
 end 
 end 
 end 
 h(multi_label_name(params[:label_name], "Label")) 
 icon('chevron-down') 
  title = local_assigns.fetch(:title, 'Assign labels') 
 filter_placeholder = local_assigns.fetch(:filter_placeholder, 'Search labels') 
 dropdown_title(title) 
 dropdown_filter(filter_placeholder) 
 dropdown_content 
 if @project 
 dropdown_footer do 
 if can? current_user, :admin_label, @project 
 end 
 link_to namespace_project_labels_path(@project.namespace, @project), :"data-is-link" => true do 
 if can? current_user, :admin_label, @project 
 else 
 end 
 end 
 end 
 end 
 dropdown_loading 
 
 if can? current_user, :admin_label, @project and @project 
  dropdown_title("Create new label", back: true) 
 dropdown_content do 
 suggested_colors.each do |color| 
 link_to '#', style: "background-color: ", data: { color: color } do 
 end 
 end 
 end 
 
 end 
 dropdown_loading 
 
  if @sort.present? 
 sort_options_hash[@sort] 
 else 
 sort_title_recently_created 
 end 
 link_to page_filter_path(sort: sort_value_recently_created) do 
 sort_title_recently_created 
 end 
 link_to page_filter_path(sort: sort_value_oldest_created) do 
 sort_title_oldest_created 
 end 
 link_to page_filter_path(sort: sort_value_recently_updated) do 
 sort_title_recently_updated 
 end 
 link_to page_filter_path(sort: sort_value_oldest_updated) do 
 sort_title_oldest_updated 
 end 
 link_to page_filter_path(sort: sort_value_milestone_soon) do 
 sort_title_milestone_soon 
 end 
 link_to page_filter_path(sort: sort_value_milestone_later) do 
 sort_title_milestone_later 
 end 
 if controller.controller_name == 'issues' || controller.action_name == 'issues' 
 link_to page_filter_path(sort: sort_value_due_date_soon) do 
 sort_title_due_date_soon 
 end 
 link_to page_filter_path(sort: sort_value_due_date_later) do 
 sort_title_due_date_later 
 end 
 end 
 link_to page_filter_path(sort: sort_value_upvotes) do 
 sort_title_upvotes 
 end 
 link_to page_filter_path(sort: sort_value_downvotes) do 
 sort_title_downvotes 
 end 
 
 end 
 if controller.controller_name == 'issues' 
 form_tag bulk_update_namespace_project_issues_path(@project.namespace, @project), method: :post  do 
 dropdown_tag("Status", options: {} ) do 
 end 
 dropdown_tag("Assignee", options: { toggle_class: "js-user-search js-update-assignee js-filter-submit js-filter-bulk-update", title: "Assign to", filter: true, dropdown_class: "dropdown-menu-user dropdown-menu-selectable",              placeholder: "Search authors", data: { first_user: (current_user.username if current_user), null_user: true, current_user: true, project_id: @project.id, field_name: "update[assignee_id]" } }) 
 dropdown_tag("Milestone", options: {}) 
 hidden_field_tag 'update[issues_ids]', [] 
 hidden_field_tag :state_event, params[:state_event] 
 button_tag "Update issues", class: "btn update_selected_issues btn-save" 
 end 
 end 
 if !@labels.nil? 
 ("hidden" if !@labels.any?) 
 if @labels.any? 
  labels.each do |label| 
 link_to_label(label, tooltip: false) 
 end 
 
 end 
 end 
 
   issue_css_classes(issue) 
 dom_id(issue) 
 issue_path(issue) 
 if controller.controller_name == 'issues' && can?(current_user, :admin_issue, @project) 
 check_box_tag dom_id(issue,"selected"), nil, false, 'data-id' => issue.id, class: "selected_issue" 
 end 
 confidential_icon(issue) 
 link_to_gfm issue.title, issue_path(issue) 
 if issue.closed? 
 end 
 if issue.assignee 
 link_to_member(@project, issue.assignee, name: false, title: "Assigned to :name") 
 end 
 upvotes, downvotes = issue.upvotes, issue.downvotes 
 if upvotes > 0 
 icon('thumbs-up') 
 upvotes 
 end 
 if downvotes > 0 
 icon('thumbs-down') 
 downvotes 
 end 
 note_count = issue.notes.user.nonawards.count 
 link_to issue_path(issue, anchor: 'notes'), class: ('issue-no-comments' if note_count.zero?) do 
 icon('comments') 
 note_count 
 end 
 
 if @issues.blank? 
 end 
 if @issues.present? 
 paginate @issues, theme: "gitlab" 
 end 
 
 
 yield :scripts_body 
 

end

  end

  def new
    params[:issue] ||= ActionController::Parameters.new(
      assignee_id: ""
    )

    @issue = @noteable = @project.issues.new(issue_params)
    respond_with(@issue)
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
 page_title "New Issue" 
  header_title project_title(@project, "Issues", namespace_project_issues_path(@project.namespace, @project)) 
 
  form_for [@project.namespace.becomes(Namespace), @project, @issue], html: { class: 'form-horizontal issue-form common-note-form js-quick-submit js-requires-input' } do |f| 
  
 end 
 
 
 yield :scripts_body 
 

end

  end

  def edit
    respond_with(@issue)
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
 page_title "Edit", " (#)", "Issues" 
  header_title project_title(@project, "Issues", namespace_project_issues_path(@project.namespace, @project)) 
 
  form_for [@project.namespace.becomes(Namespace), @project, @issue], html: { class: 'form-horizontal issue-form common-note-form js-quick-submit js-requires-input' } do |f| 
  
 end 
 
 
 yield :scripts_body 
 

end

  end

  def show
    @note     = @project.notes.new(noteable: @issue)
    @notes    = @issue.notes.nonawards.with_associations.fresh
    @noteable = @issue

    respond_to do |format|
      format.html
      format.json do
        render json: @issue.to_json(include: [:milestone, :labels])
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
 page_title           " (#)", "Issues" 
 page_description     @issue.description 
 page_card_attributes @issue.card_attributes 
 header_title         project_title(@project, "Issues", namespace_project_issues_path(@project.namespace, @project)) 
 issue_button_visibility(@issue, false) 
 icon('check', class: "hidden-sm hidden-md hidden-lg") 
 issue_button_visibility(@issue, true) 
 icon('circle-o', class: "hidden-sm hidden-md hidden-lg") 
 icon('angle-double-left') 
 confidential_icon(@issue) 
 issuable_meta(@issue, @project, "Issue") 
 if can?(current_user, :create_issue, @project) 
 if can?(current_user, :create_issue, @project) 
 link_to 'New issue', new_namespace_project_issue_path(@project.namespace, @project), title: 'New issue', id: 'new_issue_link' 
 end 
 if can?(current_user, :update_issue, @issue) 
 link_to 'Reopen issue', issue_path(@issue, issue: { state_event: :reopen }, status_only: true, format: 'json'), data: {no_turbolink: true}, class: "btn-reopen ", title: 'Reopen issue' 
 link_to 'Close issue', issue_path(@issue, issue: { state_event: :close }, status_only: true, format: 'json'), data: {no_turbolink: true}, class: "btn-close ", title: 'Close issue' 
 link_to 'Edit', edit_namespace_project_issue_path(@project.namespace, @project, @issue) 
 end 
 if can?(current_user, :create_issue, @project) 
 link_to new_namespace_project_issue_path(@project.namespace, @project), class: 'hidden-xs hidden-sm btn btn-nr btn-grouped new-issue-link btn-success', title: 'New issue', id: 'new_issue_link' do 
 icon('plus') 
 end 
 end 
 if can?(current_user, :update_issue, @issue) 
 link_to 'Reopen issue', issue_path(@issue, issue: { state_event: :reopen }, status_only: true, format: 'json'), data: {no_turbolink: true}, class: "hidden-xs hidden-sm btn btn-nr btn-grouped btn-reopen ", title: 'Reopen issue' 
 link_to 'Close issue', issue_path(@issue, issue: { state_event: :close }, status_only: true, format: 'json'), data: {no_turbolink: true}, class: "hidden-xs hidden-sm btn btn-nr btn-grouped btn-close ", title: 'Close issue' 
 link_to edit_namespace_project_issue_path(@project.namespace, @project, @issue), class: 'hidden-xs hidden-sm btn btn-nr btn-grouped issuable-edit' do 
 icon('pencil-square-o') 
 end 
 end 
 end 
 markdown escape_once(@issue.title), pipeline: :single_line 
 if @issue.description.present? 
 preserve do 
 markdown(@issue.description, cache_key: [@issue, "description"]) 
 end 
 @issue.description 
 end 
 edited_time_ago_with_tooltip(@issue, placement: 'bottom', html_class: 'issue_edited_ago') 
  if can?(current_user, :push_code, @project) 
 can_create_branch_namespace_project_issue_path(@project.namespace, @project, @issue) 
 link_to namespace_project_branches_path(@project.namespace, @project, branch_name: @issue.to_branch_name, issue_iid: @issue.iid), method: :post, class: 'btn has-tooltip', title: @issue.to_branch_name, disabled: 'disabled' do 
 end 
 end 
 
  awards_sort(votable.notes.awards.grouped_awards).each do |emoji, notes| 
 emoji_icon(emoji, sprite: false) 
 notes.count 
 end 
 if current_user 
 icon('smile-o', {class: "award-control-icon"}) 
 icon('spinner spin', {class: "award-control-icon award-control-icon-loading"}) 
 end 
 if current_user 
 end 
 
  content_for :note_actions do 
 if can?(current_user, :update_issue, @issue) 
 link_to 'Reopen issue', issue_path(@issue, issue: {state_event: :reopen}, status_only: true, format: 'json'), data: {no_turbolink: true, original_text: "Reopen issue", alternative_text: "Comment & reopen issue"}, class: "btn btn-nr btn-grouped btn-reopen btn-comment js-note-target-reopen ", title: 'Reopen issue' 
 link_to 'Close issue', issue_path(@issue, issue: {state_event: :close}, status_only: true, format: 'json'), data: {no_turbolink: true, original_text: "Close issue", alternative_text: "Comment & close issue"}, class: "btn btn-nr btn-grouped btn-close btn-comment js-note-target-close ", title: 'Close issue' 
 end 
 end 
   if @discussions.present? 
 @discussions.each do |discussion_notes| 
 note = discussion_notes.first 
 if note_for_main_target?(note) 
 next if note.cross_reference_not_visible_for?(current_user) 
 render discussion_notes 
 else 
  note = discussion_notes.first 
 link_to user_path(note.author) do 
 image_tag avatar_icon(note.author_email), class: "avatar s40" 
 end 
 if note.for_merge_request? 
 (active_notes, outdated_notes) = discussion_notes.partition(&:active?) 
  note = discussion_notes.first 
 note.discussion_id 
 link_to_member(@project, note.author, avatar: false) 
 " started a discussion" 
 link_to diffs_namespace_project_merge_request_path(note.project.namespace, note.project, note.noteable, anchor: note.line_code) do 
 end 
 time_ago_with_tooltip(note.created_at, placement: "bottom", html_class: "discussion_updated_ago") 
 link_to "#", class: "discussion-action-button discussion-toggle-button js-toggle-button" do 
 end 
 render "projects/notes/discussions/diff", discussion_notes: discussion_notes, note: note 
 
  note = discussion_notes.first 
 note.discussion_id 
 link_to_member(@project, note.author, avatar: false) 
 " started a discussion" 
 time_ago_with_tooltip(note.created_at, placement: "bottom", html_class: "discussion_updated_ago") 
 link_to "#", class: "note-action-button discussion-toggle-button js-toggle-button" do 
 end 
 render "projects/notes/discussions/diff", discussion_notes: discussion_notes, note: note 
 
 else 
  note = discussion_notes.first 
 commit = note.noteable 
 commit_description = commit ? 'commit' : 'a deleted commit' 
 note.discussion_id 
 link_to_member(@project, note.author, avatar: false) 
 " started a discussion on " 
 if commit 
 link_to(commit.short_id, namespace_project_commit_path(note.project.namespace, note.project, note.noteable), class: 'monospace') 
 end 
 time_ago_with_tooltip(note.created_at, placement: "bottom", html_class: "discussion_updated_ago") 
 link_to "#", class: "note-action-button discussion-toggle-button js-toggle-button" do 
 end 
 if note.for_diff_line? 
  diff = note.diff 
 if diff 
 if diff.deleted_file 
 diff.old_path 
 else 
 diff.new_path 
 if diff.a_mode && diff.b_mode && diff.a_mode != diff.b_mode 
 "  " 
 end 
 end 
 note.truncated_diff_lines.each do |line| 
 type = line.type 
 line_code = generate_line_code(note.file_path, line) 
 if type == "match" 
 "..." 
 "..." 
 line.text 
 else 
 ['noteable_line', type, line_code] 
 line_code 
 diff_line_content(line.text, type) 
 if line_code == note.line_code 
  note = notes.first # example note 
 # Check if line want not changed since comment was left 
 if !defined?(line) || line == note.diff_line 
  note_editable = note_editable?(note) 
 user_path(note.author) 
 image_tag avatar_icon(note.author), alt: '', class: 'avatar s40' 
 link_to_member(note.project, note.author, avatar: false) 
 "" 
 if !note.system 
 end 
 time_ago_with_tooltip(note.created_at, placement: 'bottom', html_class: 'note-created-ago') 
 access = note.project.team.human_max_access(note.author.id) 
 if access 
 access 
 end 
 if note_editable 
 link_to '#', title: 'Edit comment', class: 'note-action-button js-note-edit' do 
 icon('pencil') 
 end 
 link_to namespace_project_note_path(note.project.namespace, note.project, note), title: 'Remove comment', method: :delete, data: { confirm: 'Are you sure you want to remove this comment?' }, remote: true, class: 'note-action-button js-note-delete danger' do 
 icon('trash-o') 
 end 
 end 
 preserve do 
 markdown(note.note, pipeline: :note, cache_key: [note, "note"]) 
 end 
 if note_editable 
 render 'projects/notes/edit_form', note: note 
 end 
 edited_time_ago_with_tooltip(note, placement: 'bottom', html_class: 'note_edited_ago', include_author: true) 
 if note.attachment.url 
 if note.attachment.image? 
 link_to note.attachment.url, target: '_blank' do 
 image_tag note.attachment.url, class: 'note-image-attach' 
 end 
 end 
 link_to note.attachment.url, target: '_blank' do 
 icon('paperclip') 
 note.attachment_identifier 
 link_to delete_attachment_namespace_project_note_path(note.project.namespace, note.project, note),                title: 'Delete this attachment', method: :delete, remote: true, data: { confirm: 'Are you sure you want to remove the attachment?' }, class: 'danger js-note-attachment-delete' do 
 icon('trash-o', class: 'cred') 
 end 
 end 
 end 
 
 end 
 
 end 
 end 
 end 
 end 
 
 else 
 render discussion_notes 
 link_to_reply_diff(discussion_notes.first) 
 end 
 
 end 
 
 end 
 end 
 else 
 @notes.each do |note| 
 next unless note.author 
 next if note.cross_reference_not_visible_for?(current_user) 
  note_editable = note_editable?(note) 
 user_path(note.author) 
 image_tag avatar_icon(note.author), alt: '', class: 'avatar s40' 
 link_to_member(note.project, note.author, avatar: false) 
 "" 
 if !note.system 
 end 
 time_ago_with_tooltip(note.created_at, placement: 'bottom', html_class: 'note-created-ago') 
 access = note.project.team.human_max_access(note.author.id) 
 if access 
 access 
 end 
 if note_editable 
 link_to '#', title: 'Edit comment', class: 'note-action-button js-note-edit' do 
 icon('pencil') 
 end 
 link_to namespace_project_note_path(note.project.namespace, note.project, note), title: 'Remove comment', method: :delete, data: { confirm: 'Are you sure you want to remove this comment?' }, remote: true, class: 'note-action-button js-note-delete danger' do 
 icon('trash-o') 
 end 
 end 
 preserve do 
 markdown(note.note, pipeline: :note, cache_key: [note, "note"]) 
 end 
 if note_editable 
  form_for note, url: namespace_project_note_path(@project.namespace, @project, note), method: :put, remote: true, authenticity_token: true, html: { class: 'edit-note common-note-form js-quick-submit' } do |f| 
 note_target_fields(note) 
 render layout: 'projects/md_preview', locals: { preview_class: 'md-preview' } do 
 render 'projects/zen', f: f, attr: :note, classes: 'note-textarea js-note-text js-task-list-field', placeholder: "Write a comment or drag your files here..." 
 render 'projects/notes/hints' 
 end 
 f.submit 'Save Comment', class: 'btn btn-nr btn-save btn-grouped js-comment-button' 
 end 
 
 end 
 edited_time_ago_with_tooltip(note, placement: 'bottom', html_class: 'note_edited_ago', include_author: true) 
 if note.attachment.url 
 if note.attachment.image? 
 link_to note.attachment.url, target: '_blank' do 
 image_tag note.attachment.url, class: 'note-image-attach' 
 end 
 end 
 link_to note.attachment.url, target: '_blank' do 
 icon('paperclip') 
 note.attachment_identifier 
 link_to delete_attachment_namespace_project_note_path(note.project.namespace, note.project, note),                title: 'Delete this attachment', method: :delete, remote: true, data: { confirm: 'Are you sure you want to remove the attachment?' }, class: 'danger js-note-attachment-delete' do 
 icon('trash-o', class: 'cred') 
 end 
 end 
 end 
 
 end 
 end 
 
 if can? current_user, :create_note, @project 
 user_path(current_user) 
 image_tag avatar_icon(current_user), alt: current_user.to_reference, class: 'avatar s40' 
  form_for [@project.namespace.becomes(Namespace), @project, @note], remote: true, html: { :'data-type' => 'json', multipart: true, id: nil, class: "new-note js-new-note-form js-quick-submit common-note-form" }, authenticity_token: true do |f| 
 hidden_field_tag :view, diff_view 
 hidden_field_tag :line_type 
 note_target_fields(@note) 
 f.hidden_field :commit_id 
 f.hidden_field :line_code 
 f.hidden_field :noteable_id 
 f.hidden_field :noteable_type 
 render layout: 'projects/md_preview', locals: { preview_class: "md-preview", referenced_users: true } do 
 render 'projects/zen', f: f, attr: :note, classes: 'note-textarea js-note-text', placeholder: "Write a comment or drag your files here..." 
 render 'projects/notes/hints' 
 end 
 f.submit 'Comment', class: "btn btn-nr btn-create comment-btn btn-grouped js-comment-button" 
 yield(:note_actions) 
 end 
 
 else 
 link_to "register",new_user_session_path 
 link_to "login",new_user_session_path 
 end 
 
 
  sidebar_gutter_collapsed_class 
 can_edit_issuable = can?(current_user, :"admin_", @project) 
 issuable.iid 
 issuables_count(issuable) 
 sidebar_gutter_toggle_icon 
 if prev_issuable = prev_issuable_for(issuable) 
 link_to 'Prev', [@project.namespace.becomes(Namespace), @project, prev_issuable], class: 'btn btn-default prev-btn issuable-pager' 
 else 
 end 
 if next_issuable = next_issuable_for(issuable) 
 link_to 'Next', [@project.namespace.becomes(Namespace), @project, next_issuable], class: 'btn btn-default next-btn issuable-pager' 
 else 
 end 
 form_for [@project.namespace.becomes(Namespace), @project, issuable], remote: true, format: :json, html: {class: 'issuable-context-form inline-update js-issuable-update'} do |f| 
 if issuable.assignee 
 link_to_member(@project, issuable.assignee, size: 24) 
 else 
 icon('user') 
 end 
 icon('spinner spin', class: 'block-loading') 
 if can_edit_issuable 
 link_to 'Edit', '#', class: 'edit-link pull-right' 
 end 
 if issuable.assignee 
 link_to_member(@project, issuable.assignee, size: 32) do 
 if issuable.instance_of?(MergeRequest) && !issuable.can_be_merged_by?(issuable.assignee) 
 icon('exclamation-triangle') 
 end 
 issuable.assignee.to_reference 
 end 
 else 
 if can_edit_issuable 
 end 
 end 
 f.hidden_field 'assignee_id', value: issuable.assignee_id, id: 'issue_assignee_id' 
 dropdown_tag('Select assignee', options: {}) 
 icon('clock-o') 
 if issuable.milestone 
 issuable.milestone.title 
 else 
 end 
 icon('spinner spin', class: 'block-loading') 
 if can_edit_issuable 
 link_to 'Edit', '#', class: 'edit-link pull-right' 
 end 
 if issuable.milestone 
 link_to namespace_project_milestone_path(@project.namespace, @project, issuable.milestone) do 
 issuable.milestone.title 
 end 
 else 
 end 
 f.hidden_field 'milestone_id', value: issuable.milestone_id, id: nil 
 dropdown_tag('Milestone', options: {}) 
 if issuable.has_attribute?(:due_date) 
 icon('calendar') 
 issuable.due_date.try(:to_s, :medium) || 'None' 
 icon('spinner spin', class: 'block-loading') 
 if can?(current_user, :"admin_", @project) 
 link_to 'Edit', '#', class: 'edit-link pull-right' 
 end 
 if issuable.due_date 
 issuable.due_date.to_s(:medium) 
 else 
 end 
 if can?(current_user, :"admin_", @project) 
 f.hidden_field :due_date, value: issuable.due_date 
 icon('chevron-down') 
 dropdown_title('Due date') 
 dropdown_content do 
 end 
 end 
 end 
 if issuable.project.labels.any? 
 icon('tags') 
 issuable.labels.count 
 icon('spinner spin', class: 'block-loading') 
 if can_edit_issuable 
 link_to 'Edit', '#', class: 'edit-link pull-right' 
 end 
 ("has-labels" if issuable.labels.any?) 
 if issuable.labels.any? 
 issuable.labels.each do |label| 
 link_to_label(label, type: issuable.to_ability_name) 
 end 
 else 
 end 
 issuable.labels.each do |label| 
 hidden_field_tag "[label_names][]", label.id, id: nil 
 end 
 icon('chevron-down') 
  title = local_assigns.fetch(:title, 'Assign labels') 
 filter_placeholder = local_assigns.fetch(:filter_placeholder, 'Search labels') 
 dropdown_title(title) 
 dropdown_filter(filter_placeholder) 
 dropdown_content 
 if @project 
 dropdown_footer do 
 if can? current_user, :admin_label, @project 
 end 
 link_to namespace_project_labels_path(@project.namespace, @project), :"data-is-link" => true do 
 if can? current_user, :admin_label, @project 
 else 
 end 
 end 
 end 
 end 
 dropdown_loading 
 
 if can? current_user, :admin_label, @project and @project 
  dropdown_title("Create new label", back: true) 
 dropdown_content do 
 suggested_colors.each do |color| 
 link_to '#', style: "background-color: ", data: { color: color } do 
 end 
 end 
 end 
 
 end 
 end 
  participants_row = 7 
 participants_size = participants.size 
 participants_extra = participants_size - participants_row 
 icon('users') 
 participants.count 
 pluralize participants.count, "participant" 
 participants.each do |participant| 
 link_to_member(@project, participant, name: false, size: 24) 
 end 
 if participants_extra > 0 
 end 
 
 if current_user 
 subscribed = issuable.subscribed?(current_user) 
 icon('rss') 
 subscribtion_status = subscribed ? 'subscribed' : 'unsubscribed' 
 subscribed ? 'Unsubscribe' : 'Subscribe' 
 ( 'hidden' if subscribed ) 
 ( 'hidden' unless subscribed ) 
 end 
 project_ref = cross_project_reference(@project, issuable) 
 clipboard_button(clipboard_text: project_ref) 
 project_ref 
 project_ref 
 clipboard_button(clipboard_text: project_ref) 
 end 
 
 
 yield :scripts_body 
 

end

  end

  def create
    @issue = Issues::CreateService.new(project, current_user, issue_params).execute

    respond_to do |format|
      format.html do
        if @issue.valid?
          redirect_to issue_path(@issue)
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
 page_title "New Issue" 
  header_title project_title(@project, "Issues", namespace_project_issues_path(@project.namespace, @project)) 
 
  form_for [@project.namespace.becomes(Namespace), @project, @issue], html: { class: 'form-horizontal issue-form common-note-form js-quick-submit js-requires-input' } do |f| 
  
 end 
 
 
 yield :scripts_body 
 

end

        end
      end
      format.js do |format|
        @link = @issue.attachment.url.to_js
      end
    end
  end

  def update
    @issue = Issues::UpdateService.new(project, current_user, issue_params).execute(issue)

    if params[:move_to_project_id].to_i > 0
      new_project = Project.find(params[:move_to_project_id])
      return render_404 unless issue.can_move?(current_user, new_project)

      move_service = Issues::MoveService.new(project, current_user)
      @issue = move_service.execute(@issue, new_project)
    end

    respond_to do |format|
      format.html do
        if @issue.valid?
          redirect_to issue_path(@issue)
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
 page_title "Edit", " (#)", "Issues" 
  header_title project_title(@project, "Issues", namespace_project_issues_path(@project.namespace, @project)) 
 
  form_for [@project.namespace.becomes(Namespace), @project, @issue], html: { class: 'form-horizontal issue-form common-note-form js-quick-submit js-requires-input' } do |f| 
  
 end 
 
 
 yield :scripts_body 
 

end

        end
      end
      format.json do
        render json: @issue.to_json(include: { milestone: {}, assignee: { methods: :avatar_url }, labels: { methods: :text_color } })
      end
    end
  end

  def referenced_merge_requests
    @merge_requests = @issue.referenced_merge_requests(current_user)
    @closed_by_merge_requests = @issue.closed_by_merge_requests(current_user)

    respond_to do |format|
      format.json do
        render json: {
          html: view_to_html_string('projects/issues/_merge_requests')
        }
      end
    end
  end

  def related_branches
    @related_branches = @issue.related_branches(current_user)

    respond_to do |format|
      format.json do
        render json: {
          html: view_to_html_string('projects/issues/_related_branches')
        }
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
 if @related_branches.any? 
 pluralize(@related_branches.count, 'Related Branch') 
 @related_branches.each do |branch| 
 sha = @project.repository.find_branch(branch).target 
 ci_commit = @project.ci_commit(sha, branch) if sha 
 if ci_commit 
 render_ci_status(ci_commit) 
 end 
 link_to namespace_project_compare_path(@project.namespace, @project, from: @project.default_branch, to: branch), class: "label-branch" do 
 branch 
 end 
 end 
 end 
 
 yield :scripts_body 
 

end

  end

  def can_create_branch
    can_create = current_user &&
      can?(current_user, :push_code, @project) &&
      @issue.can_be_worked_on?(current_user)

    respond_to do |format|
      format.json do
        render json: { can_create_branch: can_create }
      end
    end
  end

  def bulk_update
    result = Issues::BulkUpdateService.new(project, current_user, bulk_update_params).execute
    redirect_back_or_default(default: { action: 'index' }, options: { notice: "#{result[:count]} issues updated" })
  end

  protected

  def issue
    @issue ||= begin
                 @project.issues.find_by!(iid: params[:id])
               rescue ActiveRecord::RecordNotFound
                 redirect_old
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
 issue_css_classes(issue) 
 dom_id(issue) 
 issue_path(issue) 
 if controller.controller_name == 'issues' && can?(current_user, :admin_issue, @project) 
 check_box_tag dom_id(issue,"selected"), nil, false, 'data-id' => issue.id, class: "selected_issue" 
 end 
 confidential_icon(issue) 
 link_to_gfm issue.title, issue_path(issue) 
 if issue.closed? 
 end 
 if issue.assignee 
 link_to_member(@project, issue.assignee, name: false, title: "Assigned to :name") 
 end 
 upvotes, downvotes = issue.upvotes, issue.downvotes 
 if upvotes > 0 
 icon('thumbs-up') 
 upvotes 
 end 
 if downvotes > 0 
 icon('thumbs-down') 
 downvotes 
 end 
 note_count = issue.notes.user.nonawards.count 
 link_to issue_path(issue, anchor: 'notes'), class: ('issue-no-comments' if note_count.zero?) do 
 icon('comments') 
 note_count 
 end 
 
 yield :scripts_body 
 

end

  end
  alias_method :subscribable_resource, :issue
  alias_method :issuable, :issue

  def authorize_read_issue!
    return render_404 unless can?(current_user, :read_issue, @issue)
  end

  def authorize_update_issue!
    return render_404 unless can?(current_user, :update_issue, @issue)
  end

  def authorize_admin_issues!
    return render_404 unless can?(current_user, :admin_issue, @project)
  end

  def module_enabled
    return render_404 unless @project.issues_enabled && @project.default_issues_tracker?
  end

  # Since iids are implemented only in 6.1
  # user may navigate to issue page using old global ids.
  #
  # To prevent 404 errors we provide a redirect to correct iids until 7.0 release
  #
  def redirect_old
    issue = @project.issues.find_by(id: params[:id])

    if issue
      redirect_to issue_path(issue)
      return
    else
      raise ActiveRecord::RecordNotFound.new
    end
  end

  def issue_params
    params.require(:issue).permit(
      :title, :assignee_id, :position, :description, :confidential,
      :milestone_id, :due_date, :state_event, :task_num, label_ids: []
    )
  end

  def bulk_update_params
    params.require(:update).permit(
      :issues_ids,
      :assignee_id,
      :milestone_id,
      :state_event
    )
  end
end
