# Redmine - project management software
# Copyright (C) 2006-2016  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class ProjectsController < ApplicationController
  menu_item :overview
  menu_item :settings, :only => :settings

  before_action :find_project, :except => [ :index, :list, :new, :create, :copy ]
  before_action :authorize, :except => [ :index, :list, :new, :create, :copy, :archive, :unarchive, :destroy]
  before_action :authorize_global, :only => [:new, :create]
  before_action :require_admin, :only => [ :copy, :archive, :unarchive, :destroy ]
  accept_rss_auth :index
  accept_api_auth :index, :show, :create, :update, :destroy
  require_sudo_mode :destroy

  helper :custom_fields
  helper :issues
  helper :queries
  helper :repositories
  helper :members

  # Lists visible projects
  def index
    scope = Project.visible.sorted

    respond_to do |format|
      format.html {
        unless params[:closed]
          scope = scope.active
        end
        @projects = scope.to_a
      }
      format.api  {
        @offset, @limit = api_offset_and_limit
        @project_count = scope.count
        @projects = scope.offset(@offset).limit(@limit).to_a
      }
      format.atom {
        projects = scope.reorder(:created_on => :desc).limit(Setting.feeds_limit.to_i).to_a
        render_feed(projects, :title => "#{Setting.app_title}: #{l(:label_project_latest)}")
      }
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 content_for :header_tags do 
 auto_discovery_link_tag(:atom, {:action => 'index', :format => 'atom', :key => User.current.rss_key}) 
 end 
 render_project_action_links 
 l(:label_project_plural) 
 render_project_hierarchy(@projects) 
 if User.current.logged? 
 l(:label_my_projects) 
 end 
 other_formats_links do |f| 
 f.link_to 'Atom', :url => {:key => User.current.rss_key} 
 end 
 content_for :sidebar do 
 form_tag({}, :method => :get) do 
 l(:label_project_plural) 
 check_box_tag 'closed', 1, params[:closed] 
 l(:label_show_closed_projects) 
 submit_tag l(:button_apply), :class => 'button-small', :name => nil 
 end 
 end 
 html_title(l(:label_project_plural)) 

end

  def new
    @issue_custom_fields = IssueCustomField.sorted.to_a
    @trackers = Tracker.sorted.to_a
    @project = Project.new
    @project.safe_attributes = params[:project]
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 title l(:label_project_new) 
 labelled_form_for @project do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_create) 
 submit_tag l(:button_create_and_continue), :name => 'continue' 
 end 

 error_messages_for 'project' 
 f.text_field :name, :required => true, :size => 60 
 f.text_area :description, :rows => 8, :class => 'wiki-edit' 
 f.text_field :identifier, :required => true, :size => 60, :disabled => @project.identifier_frozen?, :maxlength => Project::IDENTIFIER_MAX_LENGTH 
 unless @project.identifier_frozen? 
 l(:text_length_between, :min => 1, :max => Project::IDENTIFIER_MAX_LENGTH) 
 l(:text_project_identifier_info).html_safe 
 end 
 f.text_field :homepage, :size => 60 
 f.check_box :is_public 
 unless @project.allowed_parents.compact.empty? 
 label(:project, :parent_id, l(:field_parent)) 
 parent_project_select_tag(@project) 
 end 
 if @project.safe_attribute? 'inherit_members' 
 f.check_box :inherit_members 
 end 
 if @project.safe_attribute?('default_version_id') && (default_version_options = project_default_version_options(@project)).present? 
 f.select :default_version_id, project_default_version_options(@project), :include_blank => true 
 end 
 wikitoolbar_for 'project_description' 
 @project.custom_field_values.each do |value| 
 custom_field_tag_with_label :project, value 
 end 
 call_hook(:view_projects_form, :project => @project, :form => f) 
 if @project.new_record? 
 l(:label_module_plural) 
 Redmine::AccessControl.available_project_modules.each do |m| 
 check_box_tag 'project[enabled_module_names][]', m, @project.module_enabled?(m), :id => "project_enabled_module_names_#{m}" 
 l_or_humanize(m, :prefix => "project_module_") 
 end 
 hidden_field_tag 'project[enabled_module_names][]', '' 
 end 
 if @project.new_record? || @project.module_enabled?('issue_tracking') 
 unless @trackers.empty? 
l(:label_tracker_plural)
 @trackers.each do |tracker| 
 check_box_tag 'project[tracker_ids][]', tracker.id, @project.trackers.to_a.include?(tracker), :id => nil 
 tracker 
 end 
 hidden_field_tag 'project[tracker_ids][]', '' 
 end 
 unless @issue_custom_fields.empty? 
l(:label_custom_field_plural)
 @issue_custom_fields.each do |custom_field| 
 check_box_tag 'project[issue_custom_field_ids][]', custom_field.id, (@project.all_issue_custom_fields.include? custom_field),
        :disabled => (custom_field.is_for_all? ? "disabled" : nil),
        :id => nil 
 custom_field_name_tag(custom_field) 
 end 
 hidden_field_tag 'project[issue_custom_field_ids][]', '' 
 end 
 end 
 unless @project.identifier_frozen? 
 content_for :header_tags do 
 javascript_include_tag 'project_identifier' 
 end 
 end 
 if !User.current.admin? && @project.inherit_members? && @project.parent && User.current.member_of?(@project.parent) 
 javascript_tag do 
 escape_javascript(l(:text_own_membership_delete_confirmation)) 
 end 
 end 
 javascript_tag do 
 end 

end

  def create
    @issue_custom_fields = IssueCustomField.sorted.to_a
    @trackers = Tracker.sorted.to_a
    @project = Project.new
    @project.safe_attributes = params[:project]

    if @project.save
      unless User.current.admin?
        @project.add_default_member(User.current)
      end
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_create)
          if params[:continue]
            attrs = {:parent_id => @project.parent_id}.reject {|k,v| v.nil?}
            redirect_to new_project_path(attrs)
          else
            redirect_to settings_project_path(@project)
          end
        }
        format.api  { render :action => 'show', :status => :created, :location => url_for(:controller => 'projects', :action => 'show', :id => @project.id) }
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.api  { render_validation_errors(@project) }
      end
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 if User.current.allowed_to?(:add_subprojects, @project) 
 link_to l(:label_subproject_new), new_project_path(:parent_id => @project), :class => 'icon icon-add' 
 end 
 if User.current.allowed_to?(:close_project, @project) 
 if @project.active? 
 link_to l(:button_close), close_project_path(@project), :data => {:confirm => l(:text_are_you_sure)}, :method => :post, :class => 'icon icon-lock' 
 else 
 link_to l(:button_reopen), reopen_project_path(@project), :data => {:confirm => l(:text_are_you_sure)}, :method => :post, :class => 'icon icon-unlock' 
 end 
 end 
l(:label_overview)
 unless @project.active? 
 l(:text_project_closed) 
 end 
 if @project.description.present? 
 textilizable @project.description 
 end 
 if @project.homepage.present? || @project.visible_custom_field_values.any?(&:present?) 
 unless @project.homepage.blank? 
l(:field_homepage)
 link_to_if uri_with_safe_scheme?(@project.homepage), @project.homepage, @project.homepage 
 end 
 render_custom_field_values(@project) do |custom_field, formatted| 
 custom_field.name 
 formatted 
 end 
 end 
 if User.current.allowed_to?(:view_issues, @project) 
l(:label_issue_tracking)
 if @trackers.present? 
l(:label_open_issues_plural)
l(:label_closed_issues_plural)
l(:label_total)
 @trackers.each do |tracker| 
 cycle("odd", "even") 
 link_to tracker.name, project_issues_path(@project, :set_filter => 1, :tracker_id => tracker.id) 
 link_to @open_issues_by_tracker[tracker].to_i, project_issues_path(@project, :set_filter => 1, :tracker_id => tracker.id) 
 link_to (@total_issues_by_tracker[tracker].to_i - @open_issues_by_tracker[tracker].to_i), project_issues_path(@project, :set_filter => 1, :tracker_id => tracker.id, :status_id => 'c') 
 link_to @total_issues_by_tracker[tracker].to_i, project_issues_path(@project, :set_filter => 1, :tracker_id => tracker.id, :status_id => '*') 
 end 
 end 
 link_to l(:label_issue_view_all), project_issues_path(@project, :set_filter => 1) 
 if User.current.allowed_to?(:view_calendar, @project, :global => true) 
 link_to l(:label_calendar), project_calendar_path(@project) 
 end 
 if User.current.allowed_to?(:view_gantt, @project, :global => true) 
 link_to l(:label_gantt), project_gantt_path(@project) 
 end 
 end 
 if User.current.allowed_to?(:view_time_entries, @project) 
 l(:label_spent_time) 
 if @total_hours.present? 
 l_hours(@total_hours) 
 end 
 if User.current.allowed_to?(:log_time, @project) 
 link_to l(:button_log_time), new_project_time_entry_path(@project) 
 end 
 link_to(l(:label_details), project_time_entries_path(@project)) 
 link_to(l(:label_report), report_project_time_entries_path(@project)) 
 end 
 call_hook(:view_projects_show_left, :project => @project) 
 render :partial => 'members_box' 
 if @news.any? && authorize_for('news', 'index') 
l(:label_news_latest)
 render :partial => 'news/news', :collection => @news 
 link_to l(:label_news_view_all), project_news_index_path(@project) 
 end 
 if @subprojects.any? 
l(:label_subproject_plural)
 @subprojects.collect{|p| link_to p, project_path(p), :class => p.css_classes}.join(", ").html_safe 
 end 
 call_hook(:view_projects_show_right, :project => @project) 
 content_for :sidebar do 
 call_hook(:view_projects_show_sidebar_bottom, :project => @project) 
 end 
 content_for :header_tags do 
 auto_discovery_link_tag(:atom, {:controller => 'activities', :action => 'index', :id => @project, :format => 'atom', :key => User.current.rss_key}) 
 end 
 html_title(l(:label_overview)) 

 if @users_by_role.any? 
l(:label_member_plural)
 @users_by_role.keys.sort.each do |role| 
 role 
 @users_by_role[role].sort.collect{|u| link_to_user u}.join(", ").html_safe 
 end 
 end 

 link_to_project(news.project) + ': ' unless @project 
 link_to news.title, news_path(news) 
 if news.comments_count > 0 
 l(:label_x_comments, :count => news.comments_count) 
 end 
 unless news.summary.blank? 
 news.summary 
 end 
 authoring news.created_on, news.author 

 title l(:label_project_new) 
 labelled_form_for @project do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_create) 
 submit_tag l(:button_create_and_continue), :name => 'continue' 
 end 

 error_messages_for 'project' 
 f.text_field :name, :required => true, :size => 60 
 f.text_area :description, :rows => 8, :class => 'wiki-edit' 
 f.text_field :identifier, :required => true, :size => 60, :disabled => @project.identifier_frozen?, :maxlength => Project::IDENTIFIER_MAX_LENGTH 
 unless @project.identifier_frozen? 
 l(:text_length_between, :min => 1, :max => Project::IDENTIFIER_MAX_LENGTH) 
 l(:text_project_identifier_info).html_safe 
 end 
 f.text_field :homepage, :size => 60 
 f.check_box :is_public 
 unless @project.allowed_parents.compact.empty? 
 label(:project, :parent_id, l(:field_parent)) 
 parent_project_select_tag(@project) 
 end 
 if @project.safe_attribute? 'inherit_members' 
 f.check_box :inherit_members 
 end 
 if @project.safe_attribute?('default_version_id') && (default_version_options = project_default_version_options(@project)).present? 
 f.select :default_version_id, project_default_version_options(@project), :include_blank => true 
 end 
 wikitoolbar_for 'project_description' 
 @project.custom_field_values.each do |value| 
 custom_field_tag_with_label :project, value 
 end 
 call_hook(:view_projects_form, :project => @project, :form => f) 
 if @project.new_record? 
 l(:label_module_plural) 
 Redmine::AccessControl.available_project_modules.each do |m| 
 check_box_tag 'project[enabled_module_names][]', m, @project.module_enabled?(m), :id => "project_enabled_module_names_#{m}" 
 l_or_humanize(m, :prefix => "project_module_") 
 end 
 hidden_field_tag 'project[enabled_module_names][]', '' 
 end 
 if @project.new_record? || @project.module_enabled?('issue_tracking') 
 unless @trackers.empty? 
l(:label_tracker_plural)
 @trackers.each do |tracker| 
 check_box_tag 'project[tracker_ids][]', tracker.id, @project.trackers.to_a.include?(tracker), :id => nil 
 tracker 
 end 
 hidden_field_tag 'project[tracker_ids][]', '' 
 end 
 unless @issue_custom_fields.empty? 
l(:label_custom_field_plural)
 @issue_custom_fields.each do |custom_field| 
 check_box_tag 'project[issue_custom_field_ids][]', custom_field.id, (@project.all_issue_custom_fields.include? custom_field),
        :disabled => (custom_field.is_for_all? ? "disabled" : nil),
        :id => nil 
 custom_field_name_tag(custom_field) 
 end 
 hidden_field_tag 'project[issue_custom_field_ids][]', '' 
 end 
 end 
 unless @project.identifier_frozen? 
 content_for :header_tags do 
 javascript_include_tag 'project_identifier' 
 end 
 end 
 if !User.current.admin? && @project.inherit_members? && @project.parent && User.current.member_of?(@project.parent) 
 javascript_tag do 
 escape_javascript(l(:text_own_membership_delete_confirmation)) 
 end 
 end 
 javascript_tag do 
 end 

end

  def copy
    @issue_custom_fields = IssueCustomField.sorted.to_a
    @trackers = Tracker.sorted.to_a
    @source_project = Project.find(params[:id])
    if request.get?
      @project = Project.copy_from(@source_project)
      @project.identifier = Project.next_identifier if Setting.sequential_project_identifiers?
    else
      Mailer.with_deliveries(params[:notifications] == '1') do
        @project = Project.new
        @project.safe_attributes = params[:project]
        if @project.copy(@source_project, :only => params[:only])
          flash[:notice] = l(:notice_successful_create)
          redirect_to settings_project_path(@project)
        elsif !@project.new_record?
          # Project was created
          # But some objects were not copied due to validation failures
          # (eg. issues from disabled trackers)
          # TODO: inform about that
          redirect_to settings_project_path(@project)
        end
      end
    end
  rescue ActiveRecord::RecordNotFound
    # source_project not found
    render_404
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

l(:label_project_new)
 labelled_form_for @project, :url => { :action => "copy" } do |f| 
 render :partial => 'form', :locals => { :f => f } 
 l(:button_copy) 
 check_box_tag 'only[]', 'members', true, :id => nil 
 l(:label_member_plural) 
 @source_project.members.count 
 check_box_tag 'only[]', 'versions', true, :id => nil 
 l(:label_version_plural) 
 @source_project.versions.count 
 check_box_tag 'only[]', 'issue_categories', true, :id => nil 
 l(:label_issue_category_plural) 
 @source_project.issue_categories.count 
 check_box_tag 'only[]', 'issues', true, :id => nil 
 l(:label_issue_plural) 
 @source_project.issues.count 
 check_box_tag 'only[]', 'queries', true, :id => nil 
 l(:label_query_plural) 
 @source_project.queries.count 
 check_box_tag 'only[]', 'boards', true, :id => nil 
 l(:label_board_plural) 
 @source_project.boards.count 
 check_box_tag 'only[]', 'wiki', true, :id => nil 
 l(:label_wiki_page_plural) 
 @source_project.wiki.nil? ? 0 : @source_project.wiki.pages.count 
 hidden_field_tag 'only[]', '' 
 check_box_tag 'notifications', 1, params[:notifications] 
 l(:label_project_copy_notifications) 
 submit_tag l(:button_copy) 
 end 

 error_messages_for 'project' 
 f.text_field :name, :required => true, :size => 60 
 f.text_area :description, :rows => 8, :class => 'wiki-edit' 
 f.text_field :identifier, :required => true, :size => 60, :disabled => @project.identifier_frozen?, :maxlength => Project::IDENTIFIER_MAX_LENGTH 
 unless @project.identifier_frozen? 
 l(:text_length_between, :min => 1, :max => Project::IDENTIFIER_MAX_LENGTH) 
 l(:text_project_identifier_info).html_safe 
 end 
 f.text_field :homepage, :size => 60 
 f.check_box :is_public 
 unless @project.allowed_parents.compact.empty? 
 label(:project, :parent_id, l(:field_parent)) 
 parent_project_select_tag(@project) 
 end 
 if @project.safe_attribute? 'inherit_members' 
 f.check_box :inherit_members 
 end 
 if @project.safe_attribute?('default_version_id') && (default_version_options = project_default_version_options(@project)).present? 
 f.select :default_version_id, project_default_version_options(@project), :include_blank => true 
 end 
 wikitoolbar_for 'project_description' 
 @project.custom_field_values.each do |value| 
 custom_field_tag_with_label :project, value 
 end 
 call_hook(:view_projects_form, :project => @project, :form => f) 
 if @project.new_record? 
 l(:label_module_plural) 
 Redmine::AccessControl.available_project_modules.each do |m| 
 check_box_tag 'project[enabled_module_names][]', m, @project.module_enabled?(m), :id => "project_enabled_module_names_#{m}" 
 l_or_humanize(m, :prefix => "project_module_") 
 end 
 hidden_field_tag 'project[enabled_module_names][]', '' 
 end 
 if @project.new_record? || @project.module_enabled?('issue_tracking') 
 unless @trackers.empty? 
l(:label_tracker_plural)
 @trackers.each do |tracker| 
 check_box_tag 'project[tracker_ids][]', tracker.id, @project.trackers.to_a.include?(tracker), :id => nil 
 tracker 
 end 
 hidden_field_tag 'project[tracker_ids][]', '' 
 end 
 unless @issue_custom_fields.empty? 
l(:label_custom_field_plural)
 @issue_custom_fields.each do |custom_field| 
 check_box_tag 'project[issue_custom_field_ids][]', custom_field.id, (@project.all_issue_custom_fields.include? custom_field),
        :disabled => (custom_field.is_for_all? ? "disabled" : nil),
        :id => nil 
 custom_field_name_tag(custom_field) 
 end 
 hidden_field_tag 'project[issue_custom_field_ids][]', '' 
 end 
 end 
 unless @project.identifier_frozen? 
 content_for :header_tags do 
 javascript_include_tag 'project_identifier' 
 end 
 end 
 if !User.current.admin? && @project.inherit_members? && @project.parent && User.current.member_of?(@project.parent) 
 javascript_tag do 
 escape_javascript(l(:text_own_membership_delete_confirmation)) 
 end 
 end 
 javascript_tag do 
 end 

end

  # Show @project
  def show
    # try to redirect to the requested menu item
    if params[:jump] && redirect_to_project_menu_item(@project, params[:jump])
      return
    end

    @users_by_role = @project.users_by_role
    @subprojects = @project.children.visible.to_a
    @news = @project.news.limit(5).includes(:author, :project).reorder("#{News.table_name}.created_on DESC").to_a
    @trackers = @project.rolled_up_trackers.visible

    cond = @project.project_condition(Setting.display_subprojects_issues?)

    @open_issues_by_tracker = Issue.visible.open.where(cond).group(:tracker).count
    @total_issues_by_tracker = Issue.visible.where(cond).group(:tracker).count

    if User.current.allowed_to_view_all_time_entries?(@project)
      @total_hours = TimeEntry.visible.where(cond).sum(:hours).to_f
    end

    @key = User.current.rss_key

    respond_to do |format|
      format.html
      format.api
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 if User.current.allowed_to?(:add_subprojects, @project) 
 link_to l(:label_subproject_new), new_project_path(:parent_id => @project), :class => 'icon icon-add' 
 end 
 if User.current.allowed_to?(:close_project, @project) 
 if @project.active? 
 link_to l(:button_close), close_project_path(@project), :data => {:confirm => l(:text_are_you_sure)}, :method => :post, :class => 'icon icon-lock' 
 else 
 link_to l(:button_reopen), reopen_project_path(@project), :data => {:confirm => l(:text_are_you_sure)}, :method => :post, :class => 'icon icon-unlock' 
 end 
 end 
l(:label_overview)
 unless @project.active? 
 l(:text_project_closed) 
 end 
 if @project.description.present? 
 textilizable @project.description 
 end 
 if @project.homepage.present? || @project.visible_custom_field_values.any?(&:present?) 
 unless @project.homepage.blank? 
l(:field_homepage)
 link_to_if uri_with_safe_scheme?(@project.homepage), @project.homepage, @project.homepage 
 end 
 render_custom_field_values(@project) do |custom_field, formatted| 
 custom_field.name 
 formatted 
 end 
 end 
 if User.current.allowed_to?(:view_issues, @project) 
l(:label_issue_tracking)
 if @trackers.present? 
l(:label_open_issues_plural)
l(:label_closed_issues_plural)
l(:label_total)
 @trackers.each do |tracker| 
 cycle("odd", "even") 
 link_to tracker.name, project_issues_path(@project, :set_filter => 1, :tracker_id => tracker.id) 
 link_to @open_issues_by_tracker[tracker].to_i, project_issues_path(@project, :set_filter => 1, :tracker_id => tracker.id) 
 link_to (@total_issues_by_tracker[tracker].to_i - @open_issues_by_tracker[tracker].to_i), project_issues_path(@project, :set_filter => 1, :tracker_id => tracker.id, :status_id => 'c') 
 link_to @total_issues_by_tracker[tracker].to_i, project_issues_path(@project, :set_filter => 1, :tracker_id => tracker.id, :status_id => '*') 
 end 
 end 
 link_to l(:label_issue_view_all), project_issues_path(@project, :set_filter => 1) 
 if User.current.allowed_to?(:view_calendar, @project, :global => true) 
 link_to l(:label_calendar), project_calendar_path(@project) 
 end 
 if User.current.allowed_to?(:view_gantt, @project, :global => true) 
 link_to l(:label_gantt), project_gantt_path(@project) 
 end 
 end 
 if User.current.allowed_to?(:view_time_entries, @project) 
 l(:label_spent_time) 
 if @total_hours.present? 
 l_hours(@total_hours) 
 end 
 if User.current.allowed_to?(:log_time, @project) 
 link_to l(:button_log_time), new_project_time_entry_path(@project) 
 end 
 link_to(l(:label_details), project_time_entries_path(@project)) 
 link_to(l(:label_report), report_project_time_entries_path(@project)) 
 end 
 call_hook(:view_projects_show_left, :project => @project) 
 render :partial => 'members_box' 
 if @news.any? && authorize_for('news', 'index') 
l(:label_news_latest)
 render :partial => 'news/news', :collection => @news 
 link_to l(:label_news_view_all), project_news_index_path(@project) 
 end 
 if @subprojects.any? 
l(:label_subproject_plural)
 @subprojects.collect{|p| link_to p, project_path(p), :class => p.css_classes}.join(", ").html_safe 
 end 
 call_hook(:view_projects_show_right, :project => @project) 
 content_for :sidebar do 
 call_hook(:view_projects_show_sidebar_bottom, :project => @project) 
 end 
 content_for :header_tags do 
 auto_discovery_link_tag(:atom, {:controller => 'activities', :action => 'index', :id => @project, :format => 'atom', :key => User.current.rss_key}) 
 end 
 html_title(l(:label_overview)) 

 if @users_by_role.any? 
l(:label_member_plural)
 @users_by_role.keys.sort.each do |role| 
 role 
 @users_by_role[role].sort.collect{|u| link_to_user u}.join(", ").html_safe 
 end 
 end 

 link_to_project(news.project) + ': ' unless @project 
 link_to news.title, news_path(news) 
 if news.comments_count > 0 
 l(:label_x_comments, :count => news.comments_count) 
 end 
 unless news.summary.blank? 
 news.summary 
 end 
 authoring news.created_on, news.author 

end

  def settings
    @issue_custom_fields = IssueCustomField.sorted.to_a
    @issue_category ||= IssueCategory.new
    @member ||= @project.members.new
    @trackers = Tracker.sorted.to_a
    @wiki ||= @project.wiki || Wiki.new(:project => @project)
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

l(:label_settings)
 render_tabs project_settings_tabs 
 html_title(l(:label_settings)) 

end

  def edit
  end

  def update
    @project.safe_attributes = params[:project]
    if @project.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_to settings_project_path(@project)
        }
        format.api  { render_api_ok }
      end
    else
      respond_to do |format|
        format.html {
          settings
          render :action => 'settings'
        }
        format.api  { render_validation_errors(@project) }
      end
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

l(:label_settings)
 render_tabs project_settings_tabs 
 html_title(l(:label_settings)) 

end

  def modules
    @project.enabled_module_names = params[:enabled_module_names]
    flash[:notice] = l(:notice_successful_update)
    redirect_to settings_project_path(@project, :tab => 'modules')
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  def archive
    unless @project.archive
      flash[:error] = l(:error_can_not_archive_project)
    end
    redirect_to admin_projects_path(:status => params[:status])
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  def unarchive
    unless @project.active?
      @project.unarchive
    end
    redirect_to admin_projects_path(:status => params[:status])
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  def close
    @project.close
    redirect_to project_path(@project)
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  def reopen
    @project.reopen
    redirect_to project_path(@project)
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  # Delete @project
  def destroy
    @project_to_destroy = @project
    if api_request? || params[:confirm]
      @project_to_destroy.destroy
      respond_to do |format|
        format.html { redirect_to admin_projects_path }
        format.api  { render_api_ok }
      end
    end
    # hide project in layout
    @project = nil
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 title l(:label_confirmation) 
 form_tag(project_path(@project_to_destroy), :method => :delete) do 
h @project_to_destroy 
l(:text_project_destroy_confirmation)
 if @project_to_destroy.descendants.any? 
 l(:text_subprojects_destroy_warning,
          content_tag('strong', @project_to_destroy.descendants.collect{|p| p.to_s}.join(', '))).html_safe 
 end 
 check_box_tag 'confirm', 1 
 l(:general_text_Yes) 
 submit_tag l(:button_delete) 
 link_to l(:button_cancel), :controller => 'admin', :action => 'projects' 
 end 

end
end
