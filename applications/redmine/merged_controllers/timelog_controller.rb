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

class TimelogController < ApplicationController
  menu_item :time_entries

  before_action :find_time_entry, :only => [:show, :edit, :update]
  before_action :find_time_entries, :only => [:bulk_edit, :bulk_update, :destroy]
  before_action :authorize, :only => [:show, :edit, :update, :bulk_edit, :bulk_update, :destroy]

  before_action :find_optional_issue, :only => [:new, :create]
  before_action :find_optional_project, :only => [:index, :report]
  before_action :authorize_global, :only => [:new, :create, :index, :report]

  accept_rss_auth :index
  accept_api_auth :index, :show, :create, :update, :destroy

  rescue_from Query::StatementInvalid, :with => :query_statement_invalid

  helper :sort
  include SortHelper
  helper :issues
  include TimelogHelper
  helper :custom_fields
  include CustomFieldsHelper
  helper :queries
  include QueriesHelper

  def index
    retrieve_time_entry_query
    sort_init(@query.sort_criteria.empty? ? [['spent_on', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    scope = time_entry_scope(:order => sort_clause).
      preload(:issue => [:project, :tracker, :status, :assigned_to, :priority])

    respond_to do |format|
      format.html {
        @entry_count = scope.count
        @entry_pages = Paginator.new @entry_count, per_page_option, params['page']
        @entries = scope.offset(@entry_pages.offset).limit(@entry_pages.per_page).to_a

        render :layout => !request.xhr?
      }
      format.api  {
        @entry_count = scope.count
        @offset, @limit = api_offset_and_limit
        @entries = scope.offset(@offset).limit(@limit).preload(:custom_values => :custom_field).to_a
      }
      format.atom {
        entries = scope.limit(Setting.feeds_limit.to_i).reorder("#{TimeEntry.table_name}.created_on DESC").to_a
        render_feed(entries, :title => l(:label_spent_time))
      }
      format.csv {
        # Export all entries
        @entries = scope.to_a
        send_data(query_to_csv(@entries, @query, params), :type => 'text/csv; header=present', :filename => 'timelog.csv')
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

 link_to l(:button_log_time), 
            _new_time_entry_path(@project, @issue),
            :class => 'icon icon-time-add' if User.current.allowed_to?(:log_time, @project, :global => true) 
 @query.new_record? ? l(:label_spent_time) : @query.name 
 form_tag(_time_entries_path(@project, nil), :method => :get, :id => 'query_form') do 
 render :partial => 'date_range' 
 end 
 unless @entries.empty? 
 render_query_totals(@query) 
 render :partial => 'list', :locals => { :entries => @entries }
 pagination_links_full @entry_pages, @entry_count 
 other_formats_links do |f| 
 f.link_to_with_query_parameters 'Atom', :key => User.current.rss_key 
 f.link_to_with_query_parameters 'CSV', {}, :onclick => "showModal('csv-export-options', '330px'); return false;" 
 end 
 l(:label_export_options, :export_format => 'CSV') 
 form_tag(_time_entries_path(@project, nil, :format => 'csv'), :method => :get, :id => 'csv-export-form') do 
 query_as_hidden_field_tags @query 
 radio_button_tag 'columns', '', true 
 l(:description_selected_columns) 
 radio_button_tag 'columns', 'all' 
 l(:description_all_columns) 
 submit_tag l(:button_export), :name => nil, :onclick => "hideModal(this);" 
 submit_tag l(:button_cancel), :name => nil, :onclick => "hideModal(this);", :type => 'button' 
 end 
 end 
 content_for :sidebar do 
 render_sidebar_queries(TimeEntryQuery, @project) 
 end 
 html_title(@query.new_record? ? l(:label_spent_time) : @query.name, l(:label_details)) 
 content_for :header_tags do 
 auto_discovery_link_tag(:atom, {:issue_id => @issue, :format => 'atom', :key => User.current.rss_key}, :title => l(:label_spent_time)) 
 end 

 render :partial => 'queries/query_form' 
 query_params = request.query_parameters 
 link_to(l(:label_details), _time_entries_path(@project, nil, :params => query_params),
                                       :class => (action_name == 'index' ? 'selected' : nil)) 
 link_to(l(:label_report), _report_time_entries_path(@project, nil, :params => query_params),
                                       :class => (action_name == 'report' ? 'selected' : nil)) 

 form_tag({}) do 
 hidden_field_tag 'back_url', url_for(:params => request.query_parameters), :id => nil 
 check_box_tag 'check_all', '', false, :class => 'toggle-selection',
        :title => "#{l(:button_check_all)}/#{l(:button_uncheck_all)}" 
 @query.inline_columns.each do |column| 
 column_header(column) 
 end 
 grouped_query_results(entries, @query, @entry_count_by_group) do |entry, group_name, group_count, group_totals| 
 if group_name 
 reset_cycle 
 @query.inline_columns.size + 2 
 group_name 
 if group_count 
 group_count 
 end 
 group_totals 
 link_to_function("#{l(:button_collapse_all)}/#{l(:button_expand_all)}",
                             "toggleAllRowGroups(this)", :class => 'toggle-all') 
 end 
 entry.id 
 cycle("odd", "even") 
 check_box_tag("ids[]", entry.id, false, :id => nil) 
 raw @query.inline_columns.map {|column| "<td class=\"#{column.css_classes}\">#{column_content(column, entry)}</td>"}.join 
 if entry.editable_by?(User.current) 
 link_to l(:button_edit), edit_time_entry_path(entry),
                    :title => l(:button_edit),
                    :class => 'icon-only icon-edit' 
 link_to l(:button_delete), time_entry_path(entry),
                    :data => {:confirm => l(:text_are_you_sure)},
                    :method => :delete,
                    :title => l(:button_delete),
                    :class => 'icon-only icon-del' 
 end 
 @query.block_columns.each do |column|
       if (text = column_content(column, issue)) && text.present? 
 current_cycle 
 @query.inline_columns.size + 1 
 column.css_classes 
 text 
 end 
 end 
 end 
 end 
 context_menu time_entries_context_menu_path 

end

  def report
    retrieve_time_entry_query
    scope = time_entry_scope

    @report = Redmine::Helpers::TimeReport.new(@project, @issue, params[:criteria], params[:columns], scope)

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
      format.csv  { send_data(report_to_csv(@report), :type => 'text/csv; header=present', :filename => 'timelog.csv') }
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

 link_to l(:button_log_time), 
            _new_time_entry_path(@project, @issue),
            :class => 'icon icon-time-add' if User.current.allowed_to?(:log_time, @project, :global => true) 
 @query.new_record? ? l(:label_spent_time) : @query.name 
 form_tag(_report_time_entries_path(@project, nil), :method => :get, :id => 'query_form') do 
 @report.criteria.each do |criterion| 
 hidden_field_tag 'criteria[]', criterion, :id => nil 
 end 
 render :partial => 'timelog/date_range' 
 l(:label_details) 
 select_tag 'columns', options_for_select([[l(:label_year), 'year'],
                                                                            [l(:label_month), 'month'],
                                                                            [l(:label_week), 'week'],
                                                                            [l(:label_day_plural).titleize, 'day']], @report.columns),
                                                        :onchange => "this.form.submit();" 
 l(:button_add) 
 select_tag('criteria[]', options_for_select([[]] + (@report.available_criteria.keys - @report.criteria).collect{|k| [l_or_humanize(@report.available_criteria[k][:label]), k]}),
                                                          :onchange => "this.form.submit();",
                                                          :style => 'width: 200px',
                                                          :disabled => (@report.criteria.length >= 3),
                                                          :id => "criterias") 
 link_to l(:button_clear), {:project_id => @project, :issue_id => @issue, :period_type => params[:period_type], :period => params[:period], :from => @from, :to => @to, :columns => @report.columns}, :class => 'icon icon-reload' 
 end 
 unless @report.criteria.empty? 
 if @report.hours.empty? 
 l(:label_no_data) 
 else 
 @report.criteria.each do |criteria| 
 l_or_humanize(@report.available_criteria[criteria][:label]) 
 end 
 columns_width = (40 / (@report.periods.length+1)).to_i 
 @report.periods.each do |period| 
 columns_width 
 period 
 end 
 columns_width 
 l(:label_total_time) 
 render :partial => 'report_criteria', :locals => {:criterias => @report.criteria, :hours => @report.hours, :level => 0} 
 l(:label_total_time) 
 ('<td></td>' * (@report.criteria.size - 1)).html_safe 
 total = 0 
 @report.periods.each do |period| 
 sum = sum_hours(select_hours(@report.hours, @report.columns, period.to_s)); total += sum 
 html_hours("%.2f" % sum) if sum > 0 
 end 
 html_hours("%.2f" % total) if total > 0 
 other_formats_links do |f| 
 f.link_to 'CSV', :url => params 
 end 
 end 
 end 
 content_for :sidebar do 
 render_sidebar_queries(TimeEntryQuery, @project) 
 end 
 html_title(@query.new_record? ? l(:label_spent_time) : @query.name, l(:label_report)) 

 render :partial => 'queries/query_form' 
 query_params = request.query_parameters 
 link_to(l(:label_details), _time_entries_path(@project, nil, :params => query_params),
                                       :class => (action_name == 'index' ? 'selected' : nil)) 
 link_to(l(:label_report), _report_time_entries_path(@project, nil, :params => query_params),
                                       :class => (action_name == 'report' ? 'selected' : nil)) 

 @report.hours.collect {|h| h[criterias[level]].to_s}.uniq.each do |value| 
 hours_for_value = select_hours(hours, criterias[level], value) 
 next if hours_for_value.empty? 
 cycle('odd', 'even') 
 criterias.length > level+1 ? 'subtotal' : 'last-level' 
 ("<td></td>" * level).html_safe 
 format_criteria_value(@report.available_criteria[criterias[level]], value) 
 ("<td></td>" * (criterias.length - level - 1)).html_safe 
 total = 0 
 @report.periods.each do |period| 
 sum = sum_hours(select_hours(hours_for_value, @report.columns, period.to_s)); total += sum 
 html_hours("%.2f" % sum) if sum > 0 
 end 
 html_hours("%.2f" % total) if total > 0 
 if criterias.length > level+1 
 render(:partial => 'report_criteria', :locals => {:criterias => criterias, :hours => hours_for_value, :level => (level + 1)}) 
 end 
 end 

end

  def show
    respond_to do |format|
      # TODO: Implement html response
      format.html { head 406 }
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

end

  def new
    @time_entry ||= TimeEntry.new(:project => @project, :issue => @issue, :user => User.current, :spent_on => User.current.today)
    @time_entry.safe_attributes = params[:time_entry]
  
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

 l(:label_spent_time) 
 labelled_form_for @time_entry, :url => time_entry_path(@time_entry) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_save) 
 end 

 error_messages_for 'time_entry' 
 back_url_hidden_field_tag 
 if @time_entry.new_record? 
 if params[:project_id] 
 hidden_field_tag 'project_id', params[:project_id] 
 elsif params[:issue_id] 
 hidden_field_tag 'issue_id', params[:issue_id] 
 else 
 f.select :project_id, project_tree_options_for_select(Project.allowed_to(:log_time).to_a, :selected => @time_entry.project, :include_blank => true) 
 end 
 end 
 f.text_field :issue_id, :size => 6 
 if @time_entry.issue.try(:visible?) 
 "#{@time_entry.issue.tracker.name} ##{@time_entry.issue.id}: #{@time_entry.issue.subject}" 
 end 
 f.date_field :spent_on, :size => 10, :required => true 
 calendar_for('time_entry_spent_on') 
 f.text_field :hours, :size => 6, :required => true 
 f.text_field :comments, :size => 100, :maxlength => 1024 
 f.select :activity_id, activity_collection_for_select_options(@time_entry), :required => true 
 @time_entry.custom_field_values.each do |value| 
 custom_field_tag_with_label :time_entry, value 
 end 
 call_hook(:view_timelog_edit_form_bottom, { :time_entry => @time_entry, :form => f }) 
 javascript_tag do 
 if @time_entry.new_record? 
 escape_javascript new_time_entry_path(:format => 'js') 
 end 
 escape_javascript auto_complete_issues_path(:project_id => @project, :scope => (@project ? nil : 'all'))
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

 l(:label_spent_time) 
 labelled_form_for @time_entry, :url => time_entries_path do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_create) 
 submit_tag l(:button_create_and_continue), :name => 'continue' 
 end 

 error_messages_for 'time_entry' 
 back_url_hidden_field_tag 
 if @time_entry.new_record? 
 if params[:project_id] 
 hidden_field_tag 'project_id', params[:project_id] 
 elsif params[:issue_id] 
 hidden_field_tag 'issue_id', params[:issue_id] 
 else 
 f.select :project_id, project_tree_options_for_select(Project.allowed_to(:log_time).to_a, :selected => @time_entry.project, :include_blank => true) 
 end 
 end 
 f.text_field :issue_id, :size => 6 
 if @time_entry.issue.try(:visible?) 
 "#{@time_entry.issue.tracker.name} ##{@time_entry.issue.id}: #{@time_entry.issue.subject}" 
 end 
 f.date_field :spent_on, :size => 10, :required => true 
 calendar_for('time_entry_spent_on') 
 f.text_field :hours, :size => 6, :required => true 
 f.text_field :comments, :size => 100, :maxlength => 1024 
 f.select :activity_id, activity_collection_for_select_options(@time_entry), :required => true 
 @time_entry.custom_field_values.each do |value| 
 custom_field_tag_with_label :time_entry, value 
 end 
 call_hook(:view_timelog_edit_form_bottom, { :time_entry => @time_entry, :form => f }) 
 javascript_tag do 
 if @time_entry.new_record? 
 escape_javascript new_time_entry_path(:format => 'js') 
 end 
 escape_javascript auto_complete_issues_path(:project_id => @project, :scope => (@project ? nil : 'all'))
 end 

end

  def create
    @time_entry ||= TimeEntry.new(:project => @project, :issue => @issue, :user => User.current, :spent_on => User.current.today)
    @time_entry.safe_attributes = params[:time_entry]
    if @time_entry.project && !User.current.allowed_to?(:log_time, @time_entry.project)
      render_403
      return
    end

    call_hook(:controller_timelog_edit_before_save, { :params => params, :time_entry => @time_entry })

    if @time_entry.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_create)
          if params[:continue]
            options = {
              :time_entry => {
                :project_id => params[:time_entry][:project_id],
                :issue_id => @time_entry.issue_id,
                :activity_id => @time_entry.activity_id
              },
              :back_url => params[:back_url]
            }
            if params[:project_id] && @time_entry.project
              redirect_to new_project_time_entry_path(@time_entry.project, options)
            elsif params[:issue_id] && @time_entry.issue
              redirect_to new_issue_time_entry_path(@time_entry.issue, options)
            else
              redirect_to new_time_entry_path(options)
            end
          else
            redirect_back_or_default project_time_entries_path(@time_entry.project)
          end
        }
        format.api  { render :action => 'show', :status => :created, :location => time_entry_url(@time_entry) }
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.api  { render_validation_errors(@time_entry) }
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

 l(:label_spent_time) 
 labelled_form_for @time_entry, :url => time_entries_path do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_create) 
 submit_tag l(:button_create_and_continue), :name => 'continue' 
 end 

 error_messages_for 'time_entry' 
 back_url_hidden_field_tag 
 if @time_entry.new_record? 
 if params[:project_id] 
 hidden_field_tag 'project_id', params[:project_id] 
 elsif params[:issue_id] 
 hidden_field_tag 'issue_id', params[:issue_id] 
 else 
 f.select :project_id, project_tree_options_for_select(Project.allowed_to(:log_time).to_a, :selected => @time_entry.project, :include_blank => true) 
 end 
 end 
 f.text_field :issue_id, :size => 6 
 if @time_entry.issue.try(:visible?) 
 "#{@time_entry.issue.tracker.name} ##{@time_entry.issue.id}: #{@time_entry.issue.subject}" 
 end 
 f.date_field :spent_on, :size => 10, :required => true 
 calendar_for('time_entry_spent_on') 
 f.text_field :hours, :size => 6, :required => true 
 f.text_field :comments, :size => 100, :maxlength => 1024 
 f.select :activity_id, activity_collection_for_select_options(@time_entry), :required => true 
 @time_entry.custom_field_values.each do |value| 
 custom_field_tag_with_label :time_entry, value 
 end 
 call_hook(:view_timelog_edit_form_bottom, { :time_entry => @time_entry, :form => f }) 
 javascript_tag do 
 if @time_entry.new_record? 
 escape_javascript new_time_entry_path(:format => 'js') 
 end 
 escape_javascript auto_complete_issues_path(:project_id => @project, :scope => (@project ? nil : 'all'))
 end 

end

  def edit
    @time_entry.safe_attributes = params[:time_entry]
  end

  def update
    @time_entry.safe_attributes = params[:time_entry]

    call_hook(:controller_timelog_edit_before_save, { :params => params, :time_entry => @time_entry })

    if @time_entry.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_back_or_default project_time_entries_path(@time_entry.project)
        }
        format.api  { render_api_ok }
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.api  { render_validation_errors(@time_entry) }
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

 l(:label_spent_time) 
 labelled_form_for @time_entry, :url => time_entry_path(@time_entry) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_save) 
 end 

 error_messages_for 'time_entry' 
 back_url_hidden_field_tag 
 if @time_entry.new_record? 
 if params[:project_id] 
 hidden_field_tag 'project_id', params[:project_id] 
 elsif params[:issue_id] 
 hidden_field_tag 'issue_id', params[:issue_id] 
 else 
 f.select :project_id, project_tree_options_for_select(Project.allowed_to(:log_time).to_a, :selected => @time_entry.project, :include_blank => true) 
 end 
 end 
 f.text_field :issue_id, :size => 6 
 if @time_entry.issue.try(:visible?) 
 "#{@time_entry.issue.tracker.name} ##{@time_entry.issue.id}: #{@time_entry.issue.subject}" 
 end 
 f.date_field :spent_on, :size => 10, :required => true 
 calendar_for('time_entry_spent_on') 
 f.text_field :hours, :size => 6, :required => true 
 f.text_field :comments, :size => 100, :maxlength => 1024 
 f.select :activity_id, activity_collection_for_select_options(@time_entry), :required => true 
 @time_entry.custom_field_values.each do |value| 
 custom_field_tag_with_label :time_entry, value 
 end 
 call_hook(:view_timelog_edit_form_bottom, { :time_entry => @time_entry, :form => f }) 
 javascript_tag do 
 if @time_entry.new_record? 
 escape_javascript new_time_entry_path(:format => 'js') 
 end 
 escape_javascript auto_complete_issues_path(:project_id => @project, :scope => (@project ? nil : 'all'))
 end 

end

  def bulk_edit
    @available_activities = TimeEntryActivity.shared.active
    @custom_fields = TimeEntry.first.available_custom_fields
  
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

 l(:label_bulk_edit_selected_time_entries) 
 @time_entries.each do |entry| 
 content_tag 'li',
        link_to("#{format_date(entry.spent_on)} - #{entry.project}: #{l(:label_f_hour_plural, :value => entry.hours)}", edit_time_entry_path(entry)) 
 end 
 form_tag(bulk_update_time_entries_path, :id => 'bulk_edit_form') do 
 @time_entries.collect {|i| hidden_field_tag('ids[]', i.id, :id => nil)}.join.html_safe 
 l(:field_issue) 
 text_field :time_entry, :issue_id, :size => 6 
 l(:field_spent_on) 
 date_field :time_entry, :spent_on, :size => 10 
 calendar_for('time_entry_spent_on') 
 l(:field_hours) 
 text_field :time_entry, :hours, :size => 6 
 if @available_activities.any? 
 l(:field_activity) 
 select_tag('time_entry[activity_id]', content_tag('option', l(:label_no_change_option), :value => '') + options_from_collection_for_select(@available_activities, :id, :name)) 
 end 
 l(:field_comments) 
 text_field(:time_entry, :comments, :size => 100) 
 @custom_fields.each do |custom_field| 
 h(custom_field.name) 
 custom_field_tag_for_bulk_edit('time_entry', custom_field, @time_entries) 
 end 
 call_hook(:view_time_entries_bulk_edit_details_bottom, { :time_entries => @time_entries }) 
 submit_tag l(:button_submit) 
 end 

end

  def bulk_update
    attributes = parse_params_for_bulk_update(params[:time_entry])

    unsaved_time_entry_ids = []
    @time_entries.each do |time_entry|
      time_entry.reload
      time_entry.safe_attributes = attributes
      call_hook(:controller_time_entries_bulk_edit_before_save, { :params => params, :time_entry => time_entry })
      unless time_entry.save
        logger.info "time entry could not be updated: #{time_entry.errors.full_messages}" if logger && logger.info?
        # Keep unsaved time_entry ids to display them in flash error
        unsaved_time_entry_ids << time_entry.id
      end
    end
    set_flash_from_bulk_time_entry_save(@time_entries, unsaved_time_entry_ids)
    redirect_back_or_default project_time_entries_path(@projects.first)
  
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
    destroyed = TimeEntry.transaction do
      @time_entries.each do |t|
        unless t.destroy && t.destroyed?
          raise ActiveRecord::Rollback
        end
      end
    end

    respond_to do |format|
      format.html {
        if destroyed
          flash[:notice] = l(:notice_successful_delete)
        else
          flash[:error] = l(:notice_unable_delete_time_entry)
        end
        redirect_back_or_default project_time_entries_path(@projects.first)
      }
      format.api  {
        if destroyed
          render_api_ok
        else
          render_validation_errors(@time_entries)
        end
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

end

private
  def find_time_entry
    @time_entry = TimeEntry.find(params[:id])
    unless @time_entry.editable_by?(User.current)
      render_403
      return false
    end
    @project = @time_entry.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_time_entries
    @time_entries = TimeEntry.where(:id => params[:id] || params[:ids]).to_a
    raise ActiveRecord::RecordNotFound if @time_entries.empty?
    raise Unauthorized unless @time_entries.all? {|t| t.editable_by?(User.current)}
    @projects = @time_entries.collect(&:project).compact.uniq
    @project = @projects.first if @projects.size == 1
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def set_flash_from_bulk_time_entry_save(time_entries, unsaved_time_entry_ids)
    if unsaved_time_entry_ids.empty?
      flash[:notice] = l(:notice_successful_update) unless time_entries.empty?
    else
      flash[:error] = l(:notice_failed_to_save_time_entries,
                        :count => unsaved_time_entry_ids.size,
                        :total => time_entries.size,
                        :ids => '#' + unsaved_time_entry_ids.join(', #'))
    end
  end

  def find_optional_issue
    if params[:issue_id].present?
      @issue = Issue.find(params[:issue_id])
      @project = @issue.project
    else
      find_optional_project
    end
  end

  def find_optional_project
    if params[:project_id].present?
      @project = Project.find(params[:project_id])
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # Returns the TimeEntry scope for index and report actions
  def time_entry_scope(options={})
    @query.results_scope(options)
  end

  def retrieve_time_entry_query
    retrieve_query(TimeEntryQuery, false)
  end
end
