
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

 l(:label_query) 
 form_tag(query_path(@query), :method => :put, :id => "query-form") do 
 render :partial => 'form', :locals => {:query => @query} 
 submit_tag l(:button_save) 
 end 

 error_messages_for 'query' 
 hidden_field_tag 'gantt', '1' if params[:gantt] 
l(:field_name)
 text_field 'query', 'name', :size => 80 
 if User.current.admin? || User.current.allowed_to?(:manage_public_queries, @query.project) 
l(:field_visible)
 radio_button 'query', 'visibility', Query::VISIBILITY_PRIVATE 
 l(:label_visibility_private) 
 radio_button 'query', 'visibility', Query::VISIBILITY_PUBLIC 
 l(:label_visibility_public) 
 radio_button 'query', 'visibility', Query::VISIBILITY_ROLES 
 l(:label_visibility_roles) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'query[role_ids][]', role.id, @query.roles.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'query[role_ids][]', '' 
 end 
l(:field_is_for_all)
 check_box_tag 'query_is_for_all', 1, @query.project.nil?, :class => (User.current.admin? ? '' : 'disable-unless-private') 
 unless params[:gantt] 
 l(:label_options) 
l(:label_default_columns)
 check_box_tag 'default_columns', 1, @query.has_default_columns?, :id => 'query_default_columns',
      :onclick => 'if (this.checked) {$("#columns").hide();} else {$("#columns").show();}' 
 l(:field_group_by) 
 select 'query', 'group_by', @query.groupable_columns.collect {|c| [c.caption, c.name.to_s]}, :include_blank => true 
 l(:button_show) 
 available_block_columns_tags(@query) 
 l(:label_total_plural) 
 available_totalable_columns_tags(@query) 
 else 
 l(:label_options) 
 l(:button_show) 
 check_box_tag "query[draw_relations]", "1", @query.draw_relations 
 l(:label_related_issues) 
 check_box_tag "query[draw_progress_line]", "1", @query.draw_progress_line 
 l(:label_gantt_progress_line) 
 end 
 l(:label_filter_plural) 
 render :partial => 'queries/filters', :locals => {:query => query}
 unless params[:gantt] 
 l(:label_sort) 
 3.times do |i| 
 content_tag(:span, "#{i+1}:", :class => 'query_sort_criteria_count')
 label_tag "query_sort_criteria_attribute_" + i.to_s,
              l(:description_query_sort_criteria_attribute), :class => "hidden-for-sighted" 
 select_tag("query[sort_criteria][#{i}][]",
               options_for_select([[]] + query.available_columns.select(&:sortable?).collect {|column| [column.caption, column.name.to_s]}, @query.sort_criteria_key(i)),
               :id => "query_sort_criteria_attribute_" + i.to_s)
 label_tag "query_sort_criteria_direction_" + i.to_s,
              l(:description_query_sort_criteria_direction), :class => "hidden-for-sighted" 
 select_tag("query[sort_criteria][#{i}][]",
                options_for_select([[], [l(:label_ascending), 'asc'], [l(:label_descending), 'desc']], @query.sort_criteria_order(i)),
                :id => "query_sort_criteria_direction_" + i.to_s) 
 end 
 end 
 unless params[:gantt] 
 content_tag 'fieldset', :id => 'columns', :style => (query.has_default_columns? ? 'display:none;' : nil) do 
 l(:field_column_names) 
 render_query_columns_selection(query) 
 end 
 end 
 javascript_tag do 
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

class QueriesController < ApplicationController
  menu_item :issues
  before_action :find_query, :except => [:new, :create, :index]
  before_action :find_optional_project, :only => [:new, :create]

  accept_api_auth :index

  include QueriesHelper

  def index
    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit
    else
      @limit = per_page_option
    end
    scope = query_class.visible
    @query_count = scope.count
    @query_pages = Paginator.new @query_count, @limit, params['page']
    @queries = scope.
                    order("#{Query.table_name}.name").
                    limit(@limit).
                    offset(@offset).
                    to_a
    respond_to do |format|
      format.html {render_error :status => 406}
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

 link_to_if_authorized l(:label_query_new), new_project_query_path(:project_id => @project), :class => 'icon icon-add' 
 l(:label_query_plural) 
 if @queries.empty? 
l(:label_no_data)
 else 
 @queries.each do |query| 
 cycle('odd', 'even') 
 link_to query.name, :controller => 'issues', :action => 'index', :project_id => @project, :query_id => query 
 if query.editable_by?(User.current) 
 link_to l(:button_edit), edit_query_path(query), :class => 'icon icon-edit' 
 delete_link query_path(query) 
 end 
 end 
 end 

end

  def new
    @query = query_class.new
    @query.user = User.current
    @query.project = @project
    @query.build_from_params(params)
  
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

 l(:label_query_new) 
 form_tag(@project ? project_queries_path(@project) : queries_path, :id => "query-form") do 
 hidden_field_tag 'type', @query.class.name 
 render :partial => 'form', :locals => {:query => @query} 
 submit_tag l(:button_save) 
 end 

 error_messages_for 'query' 
 hidden_field_tag 'gantt', '1' if params[:gantt] 
l(:field_name)
 text_field 'query', 'name', :size => 80 
 if User.current.admin? || User.current.allowed_to?(:manage_public_queries, @query.project) 
l(:field_visible)
 radio_button 'query', 'visibility', Query::VISIBILITY_PRIVATE 
 l(:label_visibility_private) 
 radio_button 'query', 'visibility', Query::VISIBILITY_PUBLIC 
 l(:label_visibility_public) 
 radio_button 'query', 'visibility', Query::VISIBILITY_ROLES 
 l(:label_visibility_roles) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'query[role_ids][]', role.id, @query.roles.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'query[role_ids][]', '' 
 end 
l(:field_is_for_all)
 check_box_tag 'query_is_for_all', 1, @query.project.nil?, :class => (User.current.admin? ? '' : 'disable-unless-private') 
 unless params[:gantt] 
 l(:label_options) 
l(:label_default_columns)
 check_box_tag 'default_columns', 1, @query.has_default_columns?, :id => 'query_default_columns',
      :onclick => 'if (this.checked) {$("#columns").hide();} else {$("#columns").show();}' 
 l(:field_group_by) 
 select 'query', 'group_by', @query.groupable_columns.collect {|c| [c.caption, c.name.to_s]}, :include_blank => true 
 l(:button_show) 
 available_block_columns_tags(@query) 
 l(:label_total_plural) 
 available_totalable_columns_tags(@query) 
 else 
 l(:label_options) 
 l(:button_show) 
 check_box_tag "query[draw_relations]", "1", @query.draw_relations 
 l(:label_related_issues) 
 check_box_tag "query[draw_progress_line]", "1", @query.draw_progress_line 
 l(:label_gantt_progress_line) 
 end 
 l(:label_filter_plural) 
 render :partial => 'queries/filters', :locals => {:query => query}
 unless params[:gantt] 
 l(:label_sort) 
 3.times do |i| 
 content_tag(:span, "#{i+1}:", :class => 'query_sort_criteria_count')
 label_tag "query_sort_criteria_attribute_" + i.to_s,
              l(:description_query_sort_criteria_attribute), :class => "hidden-for-sighted" 
 select_tag("query[sort_criteria][#{i}][]",
               options_for_select([[]] + query.available_columns.select(&:sortable?).collect {|column| [column.caption, column.name.to_s]}, @query.sort_criteria_key(i)),
               :id => "query_sort_criteria_attribute_" + i.to_s)
 label_tag "query_sort_criteria_direction_" + i.to_s,
              l(:description_query_sort_criteria_direction), :class => "hidden-for-sighted" 
 select_tag("query[sort_criteria][#{i}][]",
                options_for_select([[], [l(:label_ascending), 'asc'], [l(:label_descending), 'desc']], @query.sort_criteria_order(i)),
                :id => "query_sort_criteria_direction_" + i.to_s) 
 end 
 end 
 unless params[:gantt] 
 content_tag 'fieldset', :id => 'columns', :style => (query.has_default_columns? ? 'display:none;' : nil) do 
 l(:field_column_names) 
 render_query_columns_selection(query) 
 end 
 end 
 javascript_tag do 
 end 

end

  def create
    @query = query_class.new
    @query.user = User.current
    @query.project = @project
    update_query_from_params

    if @query.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to_items(:query_id => @query)
    else
      render :action => 'new', :layout => !request.xhr?
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

 l(:label_query_new) 
 form_tag(@project ? project_queries_path(@project) : queries_path, :id => "query-form") do 
 hidden_field_tag 'type', @query.class.name 
 render :partial => 'form', :locals => {:query => @query} 
 submit_tag l(:button_save) 
 end 

 error_messages_for 'query' 
 hidden_field_tag 'gantt', '1' if params[:gantt] 
l(:field_name)
 text_field 'query', 'name', :size => 80 
 if User.current.admin? || User.current.allowed_to?(:manage_public_queries, @query.project) 
l(:field_visible)
 radio_button 'query', 'visibility', Query::VISIBILITY_PRIVATE 
 l(:label_visibility_private) 
 radio_button 'query', 'visibility', Query::VISIBILITY_PUBLIC 
 l(:label_visibility_public) 
 radio_button 'query', 'visibility', Query::VISIBILITY_ROLES 
 l(:label_visibility_roles) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'query[role_ids][]', role.id, @query.roles.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'query[role_ids][]', '' 
 end 
l(:field_is_for_all)
 check_box_tag 'query_is_for_all', 1, @query.project.nil?, :class => (User.current.admin? ? '' : 'disable-unless-private') 
 unless params[:gantt] 
 l(:label_options) 
l(:label_default_columns)
 check_box_tag 'default_columns', 1, @query.has_default_columns?, :id => 'query_default_columns',
      :onclick => 'if (this.checked) {$("#columns").hide();} else {$("#columns").show();}' 
 l(:field_group_by) 
 select 'query', 'group_by', @query.groupable_columns.collect {|c| [c.caption, c.name.to_s]}, :include_blank => true 
 l(:button_show) 
 available_block_columns_tags(@query) 
 l(:label_total_plural) 
 available_totalable_columns_tags(@query) 
 else 
 l(:label_options) 
 l(:button_show) 
 check_box_tag "query[draw_relations]", "1", @query.draw_relations 
 l(:label_related_issues) 
 check_box_tag "query[draw_progress_line]", "1", @query.draw_progress_line 
 l(:label_gantt_progress_line) 
 end 
 l(:label_filter_plural) 
 render :partial => 'queries/filters', :locals => {:query => query}
 unless params[:gantt] 
 l(:label_sort) 
 3.times do |i| 
 content_tag(:span, "#{i+1}:", :class => 'query_sort_criteria_count')
 label_tag "query_sort_criteria_attribute_" + i.to_s,
              l(:description_query_sort_criteria_attribute), :class => "hidden-for-sighted" 
 select_tag("query[sort_criteria][#{i}][]",
               options_for_select([[]] + query.available_columns.select(&:sortable?).collect {|column| [column.caption, column.name.to_s]}, @query.sort_criteria_key(i)),
               :id => "query_sort_criteria_attribute_" + i.to_s)
 label_tag "query_sort_criteria_direction_" + i.to_s,
              l(:description_query_sort_criteria_direction), :class => "hidden-for-sighted" 
 select_tag("query[sort_criteria][#{i}][]",
                options_for_select([[], [l(:label_ascending), 'asc'], [l(:label_descending), 'desc']], @query.sort_criteria_order(i)),
                :id => "query_sort_criteria_direction_" + i.to_s) 
 end 
 end 
 unless params[:gantt] 
 content_tag 'fieldset', :id => 'columns', :style => (query.has_default_columns? ? 'display:none;' : nil) do 
 l(:field_column_names) 
 render_query_columns_selection(query) 
 end 
 end 
 javascript_tag do 
 end 

end

  def edit
  end

  def update
    update_query_from_params

    if @query.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to_items(:query_id => @query)
    else
      render :action => 'edit'
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

 l(:label_query) 
 form_tag(query_path(@query), :method => :put, :id => "query-form") do 
 render :partial => 'form', :locals => {:query => @query} 
 submit_tag l(:button_save) 
 end 

 error_messages_for 'query' 
 hidden_field_tag 'gantt', '1' if params[:gantt] 
l(:field_name)
 text_field 'query', 'name', :size => 80 
 if User.current.admin? || User.current.allowed_to?(:manage_public_queries, @query.project) 
l(:field_visible)
 radio_button 'query', 'visibility', Query::VISIBILITY_PRIVATE 
 l(:label_visibility_private) 
 radio_button 'query', 'visibility', Query::VISIBILITY_PUBLIC 
 l(:label_visibility_public) 
 radio_button 'query', 'visibility', Query::VISIBILITY_ROLES 
 l(:label_visibility_roles) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'query[role_ids][]', role.id, @query.roles.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'query[role_ids][]', '' 
 end 
l(:field_is_for_all)
 check_box_tag 'query_is_for_all', 1, @query.project.nil?, :class => (User.current.admin? ? '' : 'disable-unless-private') 
 unless params[:gantt] 
 l(:label_options) 
l(:label_default_columns)
 check_box_tag 'default_columns', 1, @query.has_default_columns?, :id => 'query_default_columns',
      :onclick => 'if (this.checked) {$("#columns").hide();} else {$("#columns").show();}' 
 l(:field_group_by) 
 select 'query', 'group_by', @query.groupable_columns.collect {|c| [c.caption, c.name.to_s]}, :include_blank => true 
 l(:button_show) 
 available_block_columns_tags(@query) 
 l(:label_total_plural) 
 available_totalable_columns_tags(@query) 
 else 
 l(:label_options) 
 l(:button_show) 
 check_box_tag "query[draw_relations]", "1", @query.draw_relations 
 l(:label_related_issues) 
 check_box_tag "query[draw_progress_line]", "1", @query.draw_progress_line 
 l(:label_gantt_progress_line) 
 end 
 l(:label_filter_plural) 
 render :partial => 'queries/filters', :locals => {:query => query}
 unless params[:gantt] 
 l(:label_sort) 
 3.times do |i| 
 content_tag(:span, "#{i+1}:", :class => 'query_sort_criteria_count')
 label_tag "query_sort_criteria_attribute_" + i.to_s,
              l(:description_query_sort_criteria_attribute), :class => "hidden-for-sighted" 
 select_tag("query[sort_criteria][#{i}][]",
               options_for_select([[]] + query.available_columns.select(&:sortable?).collect {|column| [column.caption, column.name.to_s]}, @query.sort_criteria_key(i)),
               :id => "query_sort_criteria_attribute_" + i.to_s)
 label_tag "query_sort_criteria_direction_" + i.to_s,
              l(:description_query_sort_criteria_direction), :class => "hidden-for-sighted" 
 select_tag("query[sort_criteria][#{i}][]",
                options_for_select([[], [l(:label_ascending), 'asc'], [l(:label_descending), 'desc']], @query.sort_criteria_order(i)),
                :id => "query_sort_criteria_direction_" + i.to_s) 
 end 
 end 
 unless params[:gantt] 
 content_tag 'fieldset', :id => 'columns', :style => (query.has_default_columns? ? 'display:none;' : nil) do 
 l(:field_column_names) 
 render_query_columns_selection(query) 
 end 
 end 
 javascript_tag do 
 end 

end

  def destroy
    @query.destroy
    redirect_to_items(:set_filter => 1)
  
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

  private

  def find_query
    @query = Query.find(params[:id])
    @project = @query.project
    render_403 unless @query.editable_by?(User.current)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_optional_project
    @project = Project.find(params[:project_id]) if params[:project_id]
    render_403 unless User.current.allowed_to?(:save_queries, @project, :global => true)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def update_query_from_params
    @query.project = params[:query_is_for_all] ? nil : @project
    @query.build_from_params(params)
    @query.column_names = nil if params[:default_columns]
    @query.sort_criteria = params[:query] && params[:query][:sort_criteria]
    @query.name = params[:query] && params[:query][:name]
    if User.current.allowed_to?(:manage_public_queries, @query.project) || User.current.admin?
      @query.visibility = (params[:query] && params[:query][:visibility]) || Query::VISIBILITY_PRIVATE
      @query.role_ids = params[:query] && params[:query][:role_ids]
    else
      @query.visibility = Query::VISIBILITY_PRIVATE
    end
    @query
  end

  def redirect_to_items(options)
    method = "redirect_to_#{@query.class.name.underscore}"
    send method, options
  end

  def redirect_to_issue_query(options)
    if params[:gantt]
      if @project
        redirect_to project_gantt_path(@project, options)
      else
        redirect_to issues_gantt_path(options)
      end
    else
      redirect_to _project_issues_path(@project, options)
    end
  end

  def redirect_to_time_entry_query(options)
    redirect_to _time_entries_path(@project, nil, options)
  end

  # Returns the Query subclass, IssueQuery by default
  # for compatibility with previous behaviour
  def query_class
    Query.get_subclass(params[:type] || 'IssueQuery')
  end
end
