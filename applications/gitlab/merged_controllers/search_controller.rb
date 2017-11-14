class SearchController < ApplicationController
  skip_before_action :authenticate_user!, :reject_blocked

  include SearchHelper

  layout 'search'

  def show
    return if params[:search].nil? || params[:search].blank?

    if params[:project_id].present?
      @project = Project.find_by(id: params[:project_id])
      @project = nil unless can?(current_user, :download_code, @project)
    end

    if params[:group_id].present?
      @group = Group.find_by(id: params[:group_id])
      @group = nil unless can?(current_user, :read_group, @group)
    end

    @search_term = params[:search]

    @scope = params[:scope]
    @show_snippets = params[:snippets].eql? 'true'

    @search_results =
      if @project
        unless %w(blobs notes issues merge_requests milestones wiki_blobs
                  commits).include?(@scope)
          @scope = 'blobs'
        end

        Search::ProjectService.new(@project, current_user, params).execute
      elsif @show_snippets
        unless %w(snippet_blobs snippet_titles).include?(@scope)
          @scope = 'snippet_blobs'
        end

        Search::SnippetService.new(current_user, params).execute
      else
        unless %w(projects issues merge_requests milestones).include?(@scope)
          @scope = 'projects'
        end
        Search::GlobalService.new(current_user, params).execute
      end

    @search_objects = @search_results.objects(@scope, params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title    "Search" 
 header_title  "Search", search_path 
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
 page_title @search_term 
  form_tag search_path, method: :get, class: 'js-search-form' do |f| 
 hidden_field_tag :snippets, params[:snippets] 
 hidden_field_tag :scope, params[:scope] 
 search_field_tag :search, params[:search], placeholder: "Search for projects, issues etc", class: "form-control search-text-input js-search-input", id: "dashboard_search", autofocus: true, spellcheck: false 
 icon("search", class: "search-icon") 
 ("hidden" if !params[:search].present?) 
 icon("times-circle") 
 unless params[:snippets].eql? 'true' 
  if params[:group_id].present? 
 hidden_field_tag :group_id, params[:group_id] 
 end 
 if params[:project_id].present? 
 hidden_field_tag :project_id, params[:project_id] 
 end 
 if @group.present? 
 @group.name 
 else 
 end 
 icon("chevron-down") 
 dropdown_title("Filter results by group") 
 dropdown_filter("Search groups") 
 dropdown_content 
 dropdown_loading 
 if @project.present? 
 @project.name_with_namespace 
 else 
 end 
 icon("chevron-down") 
 dropdown_title("Filter results by project") 
 dropdown_filter("Search projects") 
 dropdown_content 
 dropdown_loading 
 
 end 
 button_tag "Search", class: "btn btn-success btn-search" 
 end 
 
 if @search_term 
  if @project 
 ("active" if @scope == 'blobs') 
 link_to search_filter_path(scope: 'blobs') do 
 @search_results.blobs_count 
 end 
 ("active" if @scope == 'issues') 
 link_to search_filter_path(scope: 'issues') do 
 @search_results.issues_count 
 end 
 ("active" if @scope == 'merge_requests') 
 link_to search_filter_path(scope: 'merge_requests') do 
 @search_results.merge_requests_count 
 end 
 ("active" if @scope == 'milestones') 
 link_to search_filter_path(scope: 'milestones') do 
 @search_results.milestones_count 
 end 
 ("active" if @scope == 'notes') 
 link_to search_filter_path(scope: 'notes') do 
 @search_results.notes_count 
 end 
 ("active" if @scope == 'wiki_blobs') 
 link_to search_filter_path(scope: 'wiki_blobs') do 
 @search_results.wiki_blobs_count 
 end 
 ("active" if @scope == 'commits') 
 link_to search_filter_path(scope: 'commits') do 
 @search_results.commits_count 
 end 
 elsif @show_snippets 
 ("active" if @scope == 'snippet_blobs') 
 link_to search_filter_path(scope: 'snippet_blobs', snippets: true, group_id: nil, project_id: nil) do 
 @search_results.snippet_blobs_count 
 end 
 ("active" if @scope == 'snippet_titles') 
 link_to search_filter_path(scope: 'snippet_titles', snippets: true, group_id: nil, project_id: nil) do 
 @search_results.snippet_titles_count 
 end 
 else 
 ("active" if @scope == 'projects') 
 link_to search_filter_path(scope: 'projects') do 
 @search_results.projects_count 
 end 
 ("active" if @scope == 'issues') 
 link_to search_filter_path(scope: 'issues') do 
 @search_results.issues_count 
 end 
 ("active" if @scope == 'merge_requests') 
 link_to search_filter_path(scope: 'merge_requests') do 
 @search_results.merge_requests_count 
 end 
 ("active" if @scope == 'milestones') 
 link_to search_filter_path(scope: 'milestones') do 
 @search_results.milestones_count 
 end 
 end 
 
 end 
 
 yield :scripts_body 
 

end

  end

  def autocomplete
    term = params[:term]

    if params[:project_id].present?
      @project = Project.find_by(id: params[:project_id])
      @project = nil unless can?(current_user, :read_project, @project)
    end

    @ref = params[:project_ref] if params[:project_ref].present?

    render json: search_autocomplete_opts(term).to_json
  end
end
