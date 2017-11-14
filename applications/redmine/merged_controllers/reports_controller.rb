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

class ReportsController < ApplicationController
  menu_item :issues
  before_action :find_project, :authorize, :find_issue_statuses

  def issue_report
    @trackers = @project.rolled_up_trackers(false).visible
    @versions = @project.shared_versions.sort
    @priorities = IssuePriority.all.reverse
    @categories = @project.issue_categories
    @assignees = (Setting.issue_group_assignment? ? @project.principals : @project.users).sort
    @authors = @project.users.sort
    @subprojects = @project.descendants.visible

    @issues_by_tracker = Issue.by_tracker(@project)
    @issues_by_version = Issue.by_version(@project)
    @issues_by_priority = Issue.by_priority(@project)
    @issues_by_category = Issue.by_category(@project)
    @issues_by_assigned_to = Issue.by_assigned_to(@project)
    @issues_by_author = Issue.by_author(@project)
    @issues_by_subproject = Issue.by_subproject(@project) || []

    render :template => "reports/issue_report"
  
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

l(:label_report_plural)
l(:field_tracker)
 link_to l(:label_details),
        project_issues_report_details_path(@project, :detail => 'tracker'),
        :class => 'icon-only icon-zoom-in',
        :title => l(:label_details) 
 render :partial => 'simple', :locals => { :data => @issues_by_tracker, :field_name => "tracker_id", :rows => @trackers } 
l(:field_priority)
 link_to l(:label_details),
        project_issues_report_details_path(@project, :detail => 'priority'),
        :class => 'icon-only icon-zoom-in',
        :title => l(:label_details) 
 render :partial => 'simple', :locals => { :data => @issues_by_priority, :field_name => "priority_id", :rows => @priorities } 
l(:field_assigned_to)
 link_to l(:label_details),
        project_issues_report_details_path(@project, :detail => 'assigned_to'),
        :class => 'icon-only icon-zoom-in',
        :title => l(:label_details) 
 render :partial => 'simple', :locals => { :data => @issues_by_assigned_to, :field_name => "assigned_to_id", :rows => @assignees } 
l(:field_author)
 link_to l(:label_details),
        project_issues_report_details_path(@project, :detail => 'author'),
        :class => 'icon-only icon-zoom-in',
        :title => l(:label_details) 
 render :partial => 'simple', :locals => { :data => @issues_by_author, :field_name => "author_id", :rows => @authors } 
 call_hook(:view_reports_issue_report_split_content_left, :project => @project) 
l(:field_version)
 link_to l(:label_details),
        project_issues_report_details_path(@project, :detail => 'version'),
        :class => 'icon-only icon-zoom-in',
        :title => l(:label_details) 
 render :partial => 'simple', :locals => { :data => @issues_by_version, :field_name => "fixed_version_id", :rows => @versions } 
 if @project.children.any? 
l(:field_subproject)
 link_to l(:label_details),
        project_issues_report_details_path(@project, :detail => 'subproject'),
        :class => 'icon-only icon-zoom-in',
        :title => l(:label_details) 
 render :partial => 'simple', :locals => { :data => @issues_by_subproject, :field_name => "project_id", :rows => @subprojects } 
 end 
l(:field_category)
 link_to l(:label_details),
        project_issues_report_details_path(@project, :detail => 'category'),
        :class => 'icon-only icon-zoom-in',
        :title => l(:label_details) 
 render :partial => 'simple', :locals => { :data => @issues_by_category, :field_name => "category_id", :rows => @categories } 
 call_hook(:view_reports_issue_report_split_content_right, :project => @project) 

 if @statuses.empty? or rows.empty? 
l(:label_no_data)
 else 
l(:label_open_issues_plural)
l(:label_closed_issues_plural)
l(:label_total)
 for row in rows 
 cycle("odd", "even") 
 link_to row.name, aggregate_path(@project, field_name, row) 
 aggregate_link data, { field_name => row.id, "closed" => 0 }, aggregate_path(@project, field_name, row, :status_id => "o") 
 aggregate_link data, { field_name => row.id, "closed" => 1 }, aggregate_path(@project, field_name, row, :status_id => "c") 
 aggregate_link data, { field_name => row.id }, aggregate_path(@project, field_name, row, :status_id => "*") 
 end 
 end
  reset_cycle 

end

  def issue_report_details
    case params[:detail]
    when "tracker"
      @field = "tracker_id"
      @rows = @project.rolled_up_trackers(false).visible
      @data = Issue.by_tracker(@project)
      @report_title = l(:field_tracker)
    when "version"
      @field = "fixed_version_id"
      @rows = @project.shared_versions.sort
      @data = Issue.by_version(@project)
      @report_title = l(:field_version)
    when "priority"
      @field = "priority_id"
      @rows = IssuePriority.all.reverse
      @data = Issue.by_priority(@project)
      @report_title = l(:field_priority)
    when "category"
      @field = "category_id"
      @rows = @project.issue_categories
      @data = Issue.by_category(@project)
      @report_title = l(:field_category)
    when "assigned_to"
      @field = "assigned_to_id"
      @rows = (Setting.issue_group_assignment? ? @project.principals : @project.users).sort
      @data = Issue.by_assigned_to(@project)
      @report_title = l(:field_assigned_to)
    when "author"
      @field = "author_id"
      @rows = @project.users.sort
      @data = Issue.by_author(@project)
      @report_title = l(:field_author)
    when "subproject"
      @field = "project_id"
      @rows = @project.descendants.visible
      @data = Issue.by_subproject(@project) || []
      @report_title = l(:field_subproject)
    else
      render_404
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

l(:label_report_plural)
@report_title
 render :partial => 'details', :locals => { :data => @data, :field_name => @field, :rows => @rows } 
 link_to l(:button_back), project_issues_report_path(@project) 

 if @statuses.empty? or rows.empty? 
l(:label_no_data)
 else 
 for status in @statuses 
 status.name 
 end 
l(:label_open_issues_plural)
l(:label_closed_issues_plural)
l(:label_total)
 for row in rows 
 cycle("odd", "even") 
 link_to row.name, aggregate_path(@project, field_name, row) 
 for status in @statuses 
 aggregate_link data, { field_name => row.id, "status_id" => status.id }, aggregate_path(@project, field_name, row, :status_id => status.id) 
 end 
 aggregate_link data, { field_name => row.id, "closed" => 0 }, aggregate_path(@project, field_name, row, :status_id => "o") 
 aggregate_link data, { field_name => row.id, "closed" => 1 }, aggregate_path(@project, field_name, row, :status_id => "c") 
 aggregate_link data, { field_name => row.id }, aggregate_path(@project, field_name, row, :status_id => "*") 
 end 
 end
  reset_cycle 

end

  private

  def find_issue_statuses
    @statuses = IssueStatus.sorted.to_a
  end
end
