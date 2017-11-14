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

class CalendarsController < ApplicationController
  menu_item :calendar
  before_action :find_optional_project

  rescue_from Query::StatementInvalid, :with => :query_statement_invalid

  helper :issues
  helper :projects
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper

  def show
    if params[:year] and params[:year].to_i > 1900
      @year = params[:year].to_i
      if params[:month] and params[:month].to_i > 0 and params[:month].to_i < 13
        @month = params[:month].to_i
      end
    end
    @year ||= User.current.today.year
    @month ||= User.current.today.month

    @calendar = Redmine::Helpers::Calendar.new(Date.civil(@year, @month, 1), current_language, :month)
    retrieve_query
    @query.group_by = nil
    if @query.valid?
      events = []
      events += @query.issues(:include => [:tracker, :assigned_to, :priority],
                              :conditions => ["((start_date BETWEEN ? AND ?) OR (due_date BETWEEN ? AND ?))", @calendar.startdt, @calendar.enddt, @calendar.startdt, @calendar.enddt]
                              )
      events += @query.versions(:conditions => ["effective_date BETWEEN ? AND ?", @calendar.startdt, @calendar.enddt])

      @calendar.events = events
    end

    render :action => 'show', :layout => false if request.xhr?
  
 @query.new_record? ? l(:label_calendar) : @query.name 
 form_tag({:controller => 'calendars', :action => 'show', :project_id => @project},
             :method => :get, :id => 'query_form') do 
 hidden_field_tag 'set_filter', '1' 
 @query.new_record? ? "" : "collapsed" 
 l(:label_filter_plural) 
 @query.new_record? ? "" : "display: none;" 
 render :partial => 'queries/filters', :locals => {:query => @query} 
 link_to_previous_month(@year, @month, :accesskey => accesskey(:previous)) 
 link_to_next_month(@year, @month, :accesskey => accesskey(:next)) 
 label_tag('month', l(:label_month)) 
 select_month(@month, :prefix => "month", :discard_type => true) 
 label_tag('year', l(:label_year)) 
 select_year(@year, :prefix => "year", :discard_type => true) 
 link_to_function l(:button_apply), '$("#query_form").submit()', :class => 'icon icon-checked' 
 link_to l(:button_clear), { :project_id => @project, :set_filter => 1 }, :class => 'icon icon-reload' 
 end 
 error_messages_for 'query' 
 if @query.valid? 
 render :partial => 'common/calendar', :locals => {:calendar => @calendar} 
 call_hook(:view_calendars_show_bottom, :year => @year, :month => @month, :project => @project, :query => @query) 
 l(:text_tip_issue_begin_day) 
 l(:text_tip_issue_end_day) 
 l(:text_tip_issue_begin_end_day) 
 end 
 content_for :sidebar do 
 render :partial => 'issues/sidebar' 
 end 
 html_title(l(:label_calendar)) 

 javascript_tag do 
 raw_json Query.operators_labels 
 raw_json Query.operators_by_filter_type 
 raw_json query.available_filters_as_json 
 raw_json l(:label_day_plural) 
 raw_json query.all_projects_values 
 query.filters.each do |field, options| 
 field 
 raw_json query.operator_for(field) 
 raw_json query.values_for(field) 
 end 
 end 
 label_tag('add_filter_select', l(:label_filter_add)) 
 select_tag 'add_filter_select', filters_options_for_select(query), :name => nil 
 hidden_field_tag 'f[]', '' 
 include_calendar_headers_tags 

 l(:label_week) 
 7.times do |i| 
 day_name( (calendar.first_wday+i)%7 ) 
 end 
 day = calendar.startdt
while day <= calendar.enddt 
 ("<td class='week-number' title='#{ l(:label_week) }'>#{(day+(11-day.cwday)%7).cweek}</td>".html_safe) if day.cwday == calendar.first_wday 
 day.month==calendar.month ? 'even' : 'odd' 
 ' today' if User.current.today == day 
 day.day 
 calendar.events_on(day).each do |i| 
 if i.is_a? Issue 
 i.css_classes 
 'starting' if day == i.start_date 
 'ending' if day == i.due_date 
 "#{i.project} -" unless @project && @project == i.project 
 link_to_issue i, :truncate => 30 
 render_issue_tooltip i 
 else 
 "#{i.project} -" unless @project && @project == i.project 
 link_to_version i
 end 
 end 
 '</tr><tr>'.html_safe if day.cwday==calendar.last_wday and day!=calendar.enddt 
 day = day + 1
end 

 l(:label_issue_plural) 
 link_to l(:label_issue_view_all), _project_issues_path(@project, :set_filter => 1) 
 if @project 
 link_to l(:field_summary), project_issues_report_path(@project) 
 end 
 if User.current.allowed_to?(:view_calendar, @project, :global => true) 
 link_to l(:label_calendar), _project_calendar_path(@project) 
 end 
 if User.current.allowed_to?(:view_gantt, @project, :global => true) 
 link_to l(:label_gantt), _project_gantt_path(@project) 
 end 
 if User.current.allowed_to?(:import_issues, @project, :global => true) 
 link_to l(:button_import), new_issues_import_path 
 end 
 call_hook(:view_issues_sidebar_issues_bottom) 
 call_hook(:view_issues_sidebar_planning_bottom) 
 render_sidebar_queries(IssueQuery, @project) 
 call_hook(:view_issues_sidebar_queries_bottom) 

end
end
