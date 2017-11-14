
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

l(:label_version)
 labelled_form_for @version do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_save) 
 end 

 back_url_hidden_field_tag 
 error_messages_for 'version' 
 f.text_field :name, :size => 60, :required => true 
 f.text_field :description, :size => 60 
 f.select :status, Version::VERSION_STATUSES.collect {|s| [l("version_status_#{s}"), s]} 
 f.text_field :wiki_page_title, :label => :label_wiki_page, :size => 60, :disabled => @project.wiki.nil? 
 f.date_field :effective_date, :size => 10 
 calendar_for('version_effective_date') 
 f.select :sharing, @version.allowed_sharings.collect {|v| [format_version_sharing(v), v]} 
 @version.custom_field_values.each do |value| 
 custom_field_tag_with_label :version, value 
 end 

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

class VersionsController < ApplicationController
  menu_item :roadmap
  model_object Version
  before_action :find_model_object, :except => [:index, :new, :create, :close_completed]
  before_action :find_project_from_association, :except => [:index, :new, :create, :close_completed]
  before_action :find_project_by_project_id, :only => [:index, :new, :create, :close_completed]
  before_action :authorize

  accept_api_auth :index, :show, :create, :update, :destroy

  helper :custom_fields
  helper :projects

  def index
    respond_to do |format|
      format.html {
        @trackers = @project.trackers.sorted.to_a
        retrieve_selected_tracker_ids(@trackers, @trackers.select {|t| t.is_in_roadmap?})
        @with_subprojects = params[:with_subprojects].nil? ? Setting.display_subprojects_issues? : (params[:with_subprojects] == '1')
        project_ids = @with_subprojects ? @project.self_and_descendants.collect(&:id) : [@project.id]

        @versions = @project.shared_versions.preload(:custom_values)
        @versions += @project.rolled_up_versions.visible.preload(:custom_values) if @with_subprojects
        @versions = @versions.to_a.uniq.sort
        unless params[:completed]
          @completed_versions = @versions.select(&:completed?)
          @versions -= @completed_versions
        end

        @issues_by_version = {}
        if @selected_tracker_ids.any? && @versions.any?
          issues = Issue.visible.
            includes(:project, :tracker).
            preload(:status, :priority, :fixed_version).
            where(:tracker_id => @selected_tracker_ids, :project_id => project_ids, :fixed_version_id => @versions.map(&:id)).
            order("#{Project.table_name}.lft, #{Tracker.table_name}.position, #{Issue.table_name}.id")
          @issues_by_version = issues.group_by(&:fixed_version)
        end
        @versions.reject! {|version| !project_ids.include?(version.project_id) && @issues_by_version[version].blank?}
      }
      format.api {
        @versions = @project.shared_versions.to_a
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

 link_to(l(:label_version_new), new_project_version_path(@project),
              :class => 'icon icon-add') if User.current.allowed_to?(:manage_versions, @project) 
l(:label_roadmap)
 if @versions.empty? 
 l(:label_no_data) 
 else 
 @versions.each do |version| 
 version.css_classes 
 if User.current.allowed_to?(:manage_versions, version.project) 
 link_to l(:button_edit), edit_version_path(version), :title => l(:button_edit), :class => 'icon-only icon-edit' 
 end 
 link_to_version version, :name => version_anchor(version) 
 render :partial => 'versions/overview', :locals => {:version => version} 
 render(:partial => "wiki/content",
               :locals => {:content => version.wiki_page.content}) if version.wiki_page 
 if (issues = @issues_by_version[version]) && issues.size > 0 
 form_tag({}) do 
 l(:label_related_issues) 
 issues.each do |issue| 
 check_box_tag 'ids[]', issue.id, false, :id => nil 
 link_to_issue(issue, :project => (@project != issue.project)) 
 end 
 end 
 end 
 call_hook :view_projects_roadmap_version_bottom, :version => version 
 end 
 end 
 content_for :sidebar do 
 form_tag({}, :method => :get) do 
 l(:label_roadmap) 
 @trackers.each do |tracker| 
 check_box_tag("tracker_ids[]", tracker.id,
                        (@selected_tracker_ids.include? tracker.id.to_s),
                        :id => nil) 
 tracker.name 
 end 
 check_box_tag "completed", 1, params[:completed] 
 l(:label_show_completed_versions) 
 if @project.descendants.active.any? 
 hidden_field_tag 'with_subprojects', 0, :id => nil 
 check_box_tag 'with_subprojects', 1, @with_subprojects 
l(:label_subproject_plural)
 end 
 submit_tag l(:button_apply), :class => 'button-small', :name => nil 
 end 
 l(:label_version_plural) 
 @versions.each do |version| 
 link_to(format_version_name(version), "##{version_anchor(version)}") 
 end 
 if @completed_versions.present? 
 link_to_function l(:label_completed_versions), 
                       '$("#toggle-completed-versions").toggleClass("collapsed"); $("#completed-versions").toggle()',
                       :id => 'toggle-completed-versions', :class => 'collapsible collapsed' 
 @completed_versions.each do |version| 
 link_to_version version 
 end 
 end 
 end 
 html_title(l(:label_roadmap)) 
 context_menu issues_context_menu_path 

 if version.completed? 
 format_date(version.effective_date) 
 elsif version.effective_date 
 due_date_distance_in_words(version.effective_date) 
 format_date(version.effective_date) 
 end 
h version.description 
 if version.custom_field_values.any? 
 render_custom_field_values(version) do |custom_field, formatted| 
 custom_field.name 
 formatted 
 end 
 end 
 if version.issues_count > 0 
 progress_bar([version.closed_percent, version.completed_percent],
                     :titles =>
                       ["%s: %0.0f%" % [l(:label_closed_issues_plural), version.closed_percent],
                        "%s: %0.0f%" % [l(:field_done_ratio), version.completed_percent]],
                     :legend => ('%0.0f%' % version.completed_percent)) 
 link_to(l(:label_x_issues, :count => version.issues_count),
                  version_filtered_issues_path(version, :status_id => '*')) 
 link_to_if(version.closed_issues_count > 0,
                      l(:label_x_closed_issues_abbr, :count => version.closed_issues_count),
                      version_filtered_issues_path(version, :status_id => 'c')) 
 link_to_if(version.open_issues_count > 0,
                     l(:label_x_open_issues_abbr, :count => version.open_issues_count),
                     version_filtered_issues_path(version, :status_id => 'o')) 
 else 
 l(:label_roadmap_no_issues) 
 end 

 textilizable content, :text, :attachments => content.page.attachments,
        :edit_section_links => (@sections_editable && {:controller => 'wiki', :action => 'edit', :project_id => @page.project, :id => @page.title}) 

end

  def show
    respond_to do |format|
      format.html {
        @issues = @version.fixed_issues.visible.
          includes(:status, :tracker, :priority).
          preload(:project).
          reorder("#{Tracker.table_name}.position, #{Issue.table_name}.id").
          to_a
      }
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

 link_to(l(:button_edit), edit_version_path(@version), :class => 'icon icon-edit') if User.current.allowed_to?(:manage_versions, @version.project) 
 link_to_if_authorized(l(:button_edit_associated_wikipage, :page_title => @version.wiki_page_title), {:controller => 'wiki', :action => 'edit', :project_id => @version.project, :id => Wiki.titleize(@version.wiki_page_title)}, :class => 'icon icon-edit') unless @version.wiki_page_title.blank? || @version.project.wiki.nil? 
 delete_link version_path(@version, :back_url => url_for(:controller => 'versions', :action => 'index', :project_id => @version.project)) if User.current.allowed_to?(:manage_versions, @version.project) 
 call_hook(:view_versions_show_contextual, { :version => @version, :project => @project }) 
 @version.name 
 @version.css_classes 
 render :partial => 'versions/overview', :locals => {:version => @version} 
 render(:partial => "wiki/content", :locals => {:content => @version.wiki_page.content}) if @version.wiki_page 
 if @version.estimated_hours > 0 || User.current.allowed_to?(:view_time_entries, @project) 
 l(:label_time_tracking) 
 l(:field_estimated_hours) 
 html_hours(l_hours(@version.estimated_hours)) 
 if User.current.allowed_to_view_all_time_entries?(@project) 
 l(:label_spent_time) 
 link_to html_hours(l_hours(@version.spent_hours)),
                                        project_time_entries_path(@version.project, :set_filter => 1, :"issue.fixed_version_id" => @version.id) 
 end 
 end 
 render_issue_status_by(@version, params[:status_by]) if @version.fixed_issues.count > 0 
 if @issues.present? 
 form_tag({}) do 
 l(:label_related_issues) 
 @issues.each do |issue| 
 check_box_tag 'ids[]', issue.id, false, :id => nil 
 link_to_issue(issue, :project => (@project != issue.project)) 
 end 
 end 
 context_menu issues_context_menu_path 
 end 
 call_hook :view_versions_show_bottom, :version => @version 
 html_title @version.name 

 if version.completed? 
 format_date(version.effective_date) 
 elsif version.effective_date 
 due_date_distance_in_words(version.effective_date) 
 format_date(version.effective_date) 
 end 
h version.description 
 if version.custom_field_values.any? 
 render_custom_field_values(version) do |custom_field, formatted| 
 custom_field.name 
 formatted 
 end 
 end 
 if version.issues_count > 0 
 progress_bar([version.closed_percent, version.completed_percent],
                     :titles =>
                       ["%s: %0.0f%" % [l(:label_closed_issues_plural), version.closed_percent],
                        "%s: %0.0f%" % [l(:field_done_ratio), version.completed_percent]],
                     :legend => ('%0.0f%' % version.completed_percent)) 
 link_to(l(:label_x_issues, :count => version.issues_count),
                  version_filtered_issues_path(version, :status_id => '*')) 
 link_to_if(version.closed_issues_count > 0,
                      l(:label_x_closed_issues_abbr, :count => version.closed_issues_count),
                      version_filtered_issues_path(version, :status_id => 'c')) 
 link_to_if(version.open_issues_count > 0,
                     l(:label_x_open_issues_abbr, :count => version.open_issues_count),
                     version_filtered_issues_path(version, :status_id => 'o')) 
 else 
 l(:label_roadmap_no_issues) 
 end 

 textilizable content, :text, :attachments => content.page.attachments,
        :edit_section_links => (@sections_editable && {:controller => 'wiki', :action => 'edit', :project_id => @page.project, :id => @page.title}) 

end

  def new
    @version = @project.versions.build
    @version.safe_attributes = params[:version]

    respond_to do |format|
      format.html
      format.js
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

l(:label_version_new)
 labelled_form_for @version, :url => project_versions_path(@project) do |f| 
 render :partial => 'versions/form', :locals => { :f => f } 
 submit_tag l(:button_create) 
 end 

 back_url_hidden_field_tag 
 error_messages_for 'version' 
 f.text_field :name, :size => 60, :required => true 
 f.text_field :description, :size => 60 
 f.select :status, Version::VERSION_STATUSES.collect {|s| [l("version_status_#{s}"), s]} 
 f.text_field :wiki_page_title, :label => :label_wiki_page, :size => 60, :disabled => @project.wiki.nil? 
 f.date_field :effective_date, :size => 10 
 calendar_for('version_effective_date') 
 f.select :sharing, @version.allowed_sharings.collect {|v| [format_version_sharing(v), v]} 
 @version.custom_field_values.each do |value| 
 custom_field_tag_with_label :version, value 
 end 

end

  def create
    @version = @project.versions.build
    if params[:version]
      attributes = params[:version].dup
      attributes.delete('sharing') unless attributes.nil? || @version.allowed_sharings.include?(attributes['sharing'])
      @version.safe_attributes = attributes
    end

    if request.post?
      if @version.save
        respond_to do |format|
          format.html do
            flash[:notice] = l(:notice_successful_create)
            redirect_back_or_default settings_project_path(@project, :tab => 'versions')
          end
          format.js
          format.api do
            render :action => 'show', :status => :created, :location => version_url(@version)
          end
        end
      else
        respond_to do |format|
          format.html { render :action => 'new' }
          format.js   { render :action => 'new' }
          format.api  { render_validation_errors(@version) }
        end
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

 link_to(l(:button_edit), edit_version_path(@version), :class => 'icon icon-edit') if User.current.allowed_to?(:manage_versions, @version.project) 
 link_to_if_authorized(l(:button_edit_associated_wikipage, :page_title => @version.wiki_page_title), {:controller => 'wiki', :action => 'edit', :project_id => @version.project, :id => Wiki.titleize(@version.wiki_page_title)}, :class => 'icon icon-edit') unless @version.wiki_page_title.blank? || @version.project.wiki.nil? 
 delete_link version_path(@version, :back_url => url_for(:controller => 'versions', :action => 'index', :project_id => @version.project)) if User.current.allowed_to?(:manage_versions, @version.project) 
 call_hook(:view_versions_show_contextual, { :version => @version, :project => @project }) 
 @version.name 
 @version.css_classes 
 render :partial => 'versions/overview', :locals => {:version => @version} 
 render(:partial => "wiki/content", :locals => {:content => @version.wiki_page.content}) if @version.wiki_page 
 if @version.estimated_hours > 0 || User.current.allowed_to?(:view_time_entries, @project) 
 l(:label_time_tracking) 
 l(:field_estimated_hours) 
 html_hours(l_hours(@version.estimated_hours)) 
 if User.current.allowed_to_view_all_time_entries?(@project) 
 l(:label_spent_time) 
 link_to html_hours(l_hours(@version.spent_hours)),
                                        project_time_entries_path(@version.project, :set_filter => 1, :"issue.fixed_version_id" => @version.id) 
 end 
 end 
 render_issue_status_by(@version, params[:status_by]) if @version.fixed_issues.count > 0 
 if @issues.present? 
 form_tag({}) do 
 l(:label_related_issues) 
 @issues.each do |issue| 
 check_box_tag 'ids[]', issue.id, false, :id => nil 
 link_to_issue(issue, :project => (@project != issue.project)) 
 end 
 end 
 context_menu issues_context_menu_path 
 end 
 call_hook :view_versions_show_bottom, :version => @version 
 html_title @version.name 

 if version.completed? 
 format_date(version.effective_date) 
 elsif version.effective_date 
 due_date_distance_in_words(version.effective_date) 
 format_date(version.effective_date) 
 end 
h version.description 
 if version.custom_field_values.any? 
 render_custom_field_values(version) do |custom_field, formatted| 
 custom_field.name 
 formatted 
 end 
 end 
 if version.issues_count > 0 
 progress_bar([version.closed_percent, version.completed_percent],
                     :titles =>
                       ["%s: %0.0f%" % [l(:label_closed_issues_plural), version.closed_percent],
                        "%s: %0.0f%" % [l(:field_done_ratio), version.completed_percent]],
                     :legend => ('%0.0f%' % version.completed_percent)) 
 link_to(l(:label_x_issues, :count => version.issues_count),
                  version_filtered_issues_path(version, :status_id => '*')) 
 link_to_if(version.closed_issues_count > 0,
                      l(:label_x_closed_issues_abbr, :count => version.closed_issues_count),
                      version_filtered_issues_path(version, :status_id => 'c')) 
 link_to_if(version.open_issues_count > 0,
                     l(:label_x_open_issues_abbr, :count => version.open_issues_count),
                     version_filtered_issues_path(version, :status_id => 'o')) 
 else 
 l(:label_roadmap_no_issues) 
 end 

 textilizable content, :text, :attachments => content.page.attachments,
        :edit_section_links => (@sections_editable && {:controller => 'wiki', :action => 'edit', :project_id => @page.project, :id => @page.title}) 

l(:label_version_new)
 labelled_form_for @version, :url => project_versions_path(@project) do |f| 
 render :partial => 'versions/form', :locals => { :f => f } 
 submit_tag l(:button_create) 
 end 

 back_url_hidden_field_tag 
 error_messages_for 'version' 
 f.text_field :name, :size => 60, :required => true 
 f.text_field :description, :size => 60 
 f.select :status, Version::VERSION_STATUSES.collect {|s| [l("version_status_#{s}"), s]} 
 f.text_field :wiki_page_title, :label => :label_wiki_page, :size => 60, :disabled => @project.wiki.nil? 
 f.date_field :effective_date, :size => 10 
 calendar_for('version_effective_date') 
 f.select :sharing, @version.allowed_sharings.collect {|v| [format_version_sharing(v), v]} 
 @version.custom_field_values.each do |value| 
 custom_field_tag_with_label :version, value 
 end 

end

  def edit
  end

  def update
    if params[:version]
      attributes = params[:version].dup
      attributes.delete('sharing') unless @version.allowed_sharings.include?(attributes['sharing'])
      @version.safe_attributes = attributes
      if @version.save
        respond_to do |format|
          format.html {
            flash[:notice] = l(:notice_successful_update)
            redirect_back_or_default settings_project_path(@project, :tab => 'versions')
          }
          format.api  { render_api_ok }
        end
      else
        respond_to do |format|
          format.html { render :action => 'edit' }
          format.api  { render_validation_errors(@version) }
        end
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

l(:label_version)
 labelled_form_for @version do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_save) 
 end 

 back_url_hidden_field_tag 
 error_messages_for 'version' 
 f.text_field :name, :size => 60, :required => true 
 f.text_field :description, :size => 60 
 f.select :status, Version::VERSION_STATUSES.collect {|s| [l("version_status_#{s}"), s]} 
 f.text_field :wiki_page_title, :label => :label_wiki_page, :size => 60, :disabled => @project.wiki.nil? 
 f.date_field :effective_date, :size => 10 
 calendar_for('version_effective_date') 
 f.select :sharing, @version.allowed_sharings.collect {|v| [format_version_sharing(v), v]} 
 @version.custom_field_values.each do |value| 
 custom_field_tag_with_label :version, value 
 end 

end

  def close_completed
    if request.put?
      @project.close_completed_versions
    end
    redirect_to settings_project_path(@project, :tab => 'versions')
  
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

  def destroy
    if @version.deletable?
      @version.destroy
      respond_to do |format|
        format.html { redirect_back_or_default settings_project_path(@project, :tab => 'versions') }
        format.api  { render_api_ok }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = l(:notice_unable_delete_version)
          redirect_to settings_project_path(@project, :tab => 'versions')
        }
        format.api  { head :unprocessable_entity }
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

end

  def status_by
    respond_to do |format|
      format.html { render :action => 'show' }
      format.js
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

 link_to(l(:button_edit), edit_version_path(@version), :class => 'icon icon-edit') if User.current.allowed_to?(:manage_versions, @version.project) 
 link_to_if_authorized(l(:button_edit_associated_wikipage, :page_title => @version.wiki_page_title), {:controller => 'wiki', :action => 'edit', :project_id => @version.project, :id => Wiki.titleize(@version.wiki_page_title)}, :class => 'icon icon-edit') unless @version.wiki_page_title.blank? || @version.project.wiki.nil? 
 delete_link version_path(@version, :back_url => url_for(:controller => 'versions', :action => 'index', :project_id => @version.project)) if User.current.allowed_to?(:manage_versions, @version.project) 
 call_hook(:view_versions_show_contextual, { :version => @version, :project => @project }) 
 @version.name 
 @version.css_classes 
 render :partial => 'versions/overview', :locals => {:version => @version} 
 render(:partial => "wiki/content", :locals => {:content => @version.wiki_page.content}) if @version.wiki_page 
 if @version.estimated_hours > 0 || User.current.allowed_to?(:view_time_entries, @project) 
 l(:label_time_tracking) 
 l(:field_estimated_hours) 
 html_hours(l_hours(@version.estimated_hours)) 
 if User.current.allowed_to_view_all_time_entries?(@project) 
 l(:label_spent_time) 
 link_to html_hours(l_hours(@version.spent_hours)),
                                        project_time_entries_path(@version.project, :set_filter => 1, :"issue.fixed_version_id" => @version.id) 
 end 
 end 
 render_issue_status_by(@version, params[:status_by]) if @version.fixed_issues.count > 0 
 if @issues.present? 
 form_tag({}) do 
 l(:label_related_issues) 
 @issues.each do |issue| 
 check_box_tag 'ids[]', issue.id, false, :id => nil 
 link_to_issue(issue, :project => (@project != issue.project)) 
 end 
 end 
 context_menu issues_context_menu_path 
 end 
 call_hook :view_versions_show_bottom, :version => @version 
 html_title @version.name 

 if version.completed? 
 format_date(version.effective_date) 
 elsif version.effective_date 
 due_date_distance_in_words(version.effective_date) 
 format_date(version.effective_date) 
 end 
h version.description 
 if version.custom_field_values.any? 
 render_custom_field_values(version) do |custom_field, formatted| 
 custom_field.name 
 formatted 
 end 
 end 
 if version.issues_count > 0 
 progress_bar([version.closed_percent, version.completed_percent],
                     :titles =>
                       ["%s: %0.0f%" % [l(:label_closed_issues_plural), version.closed_percent],
                        "%s: %0.0f%" % [l(:field_done_ratio), version.completed_percent]],
                     :legend => ('%0.0f%' % version.completed_percent)) 
 link_to(l(:label_x_issues, :count => version.issues_count),
                  version_filtered_issues_path(version, :status_id => '*')) 
 link_to_if(version.closed_issues_count > 0,
                      l(:label_x_closed_issues_abbr, :count => version.closed_issues_count),
                      version_filtered_issues_path(version, :status_id => 'c')) 
 link_to_if(version.open_issues_count > 0,
                     l(:label_x_open_issues_abbr, :count => version.open_issues_count),
                     version_filtered_issues_path(version, :status_id => 'o')) 
 else 
 l(:label_roadmap_no_issues) 
 end 

 textilizable content, :text, :attachments => content.page.attachments,
        :edit_section_links => (@sections_editable && {:controller => 'wiki', :action => 'edit', :project_id => @page.project, :id => @page.title}) 

end

  private

  def retrieve_selected_tracker_ids(selectable_trackers, default_trackers=nil)
    if ids = params[:tracker_ids]
      @selected_tracker_ids = (ids.is_a? Array) ? ids.collect { |id| id.to_i.to_s } : ids.split('/').collect { |id| id.to_i.to_s }
    else
      @selected_tracker_ids = (default_trackers || selectable_trackers).collect {|t| t.id.to_s }
    end
  end
end
