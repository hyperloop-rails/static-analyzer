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

class ActivitiesController < ApplicationController
  menu_item :activity
  before_action :find_optional_project
  accept_rss_auth :index

  def index
    @days = Setting.activity_days_default.to_i

    if params[:from]
      begin; @date_to = params[:from].to_date + 1; rescue; end
    end

    @date_to ||= User.current.today + 1
    @date_from = @date_to - @days
    @with_subprojects = params[:with_subprojects].nil? ? Setting.display_subprojects_issues? : (params[:with_subprojects] == '1')
    if params[:user_id].present?
      @author = User.active.find(params[:user_id])
    end

    @activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
                                                             :with_subprojects => @with_subprojects,
                                                             :author => @author)
    pref = User.current.pref
    @activity.scope_select {|t| !params["show_#{t}"].nil?}
    if @activity.scope.present?
      if params[:submit].present?
        pref.activity_scope = @activity.scope
        pref.save
      end
    else
      if @author.nil?
        scope = pref.activity_scope & @activity.event_types
        @activity.scope = scope.present? ? scope : :default
      else
        @activity.scope = :all
      end
    end

    events = @activity.events(@date_from, @date_to)

    if events.empty? || stale?(:etag => [@activity.scope, @date_to, @date_from, @with_subprojects, @author, events.first, events.size, User.current, current_language])
      respond_to do |format|
        format.html {
          @events_by_day = events.group_by {|event| User.current.time_to_date(event.event_datetime)}
          render :layout => false if request.xhr?
        }
        format.atom {
          title = l(:label_activity)
          if @author
            title = @author.name
          elsif @activity.scope.size == 1
            title = l("label_#{@activity.scope.first.singularize}_plural")
          end
          render_feed(events, :title => "#{@project || Setting.app_title}: #{title}")
        }
      end
    end

  rescue ActiveRecord::RecordNotFound
    render_404
  
 @author.nil? ? l(:label_activity) : l(:label_user_activity, link_to_user(@author)).html_safe 
 l(:label_date_from_to, :start => format_date(@date_to - @days), :end => format_date(@date_to-1)) 
 @events_by_day.keys.sort.reverse.each do |day| 
 format_activity_day(day) 
 sort_activity_events(@events_by_day[day]).each do |e, in_group| 
 e.event_type 
 "grouped" if in_group 
 User.current.logged? && e.respond_to?(:event_author) && User.current == e.event_author ? 'me' : nil 
 avatar(e.event_author, :size => "24") if e.respond_to?(:event_author) 
 format_time(e.event_datetime, false) 
 content_tag('span', e.project, :class => 'project') if @project.nil? || @project != e.project 
 link_to format_activity_title(e.event_title), e.event_url 
 "grouped" if in_group 
 format_activity_description(e.event_description) 
 link_to_user(e.event_author) if e.respond_to?(:event_author) 
 end 
 end 
 content_tag('p', l(:label_no_data), :class => 'nodata') if @events_by_day.empty? 
 link_to("\xc2\xab " + l(:label_previous),
                   {:params => request.query_parameters.merge(:from => @date_to - @days - 1)},
                   :title => l(:label_date_from_to, :start => format_date(@date_to - 2*@days), :end => format_date(@date_to - @days - 1)),
                   :accesskey => accesskey(:previous)) 
 unless @date_to >= User.current.today 
 link_to(l(:label_next) + " \xc2\xbb",
                   {:params => request.query_parameters.merge(:from => @date_to + @days - 1)},
                   :title => l(:label_date_from_to, :start => format_date(@date_to), :end => format_date(@date_to + @days - 1)),
                   :accesskey => accesskey(:next)) 
 end 
 other_formats_links do |f| 
 f.link_to_with_query_parameters 'Atom', 'from' => nil, :key => User.current.rss_key 
 end 
 content_for :header_tags do 
 auto_discovery_link_tag(:atom, :params => request.query_parameters.merge(:from => nil, :key => User.current.rss_key), :format => 'atom') 
 end 
 content_for :sidebar do 
 form_tag({}, :method => :get, :id => 'activity_scope_form') do 
 l(:label_activity) 
 @activity.event_types.each do |t| 
 check_box_tag "show_#{t}", 1, @activity.scope.include?(t) 
t
 link_to(l("label_#{t.singularize}_plural"),
                  {"show_#{t}" => 1, :user_id => params[:user_id], :from => params[:from]})
 end 
 if @project && @project.descendants.active.any? 
 hidden_field_tag 'with_subprojects', 0, :id => nil 
 check_box_tag 'with_subprojects', 1, @with_subprojects 
l(:label_subproject_plural)
 end 
 hidden_field_tag('user_id', params[:user_id]) unless params[:user_id].blank? 
 hidden_field_tag('from', params[:from]) unless params[:from].blank? 
 submit_tag l(:button_apply), :class => 'button-small', :name => 'submit' 
 end 
 end 
 html_title(l(:label_activity), @author) 

end

  private

  # TODO: refactor, duplicated in projects_controller
  def find_optional_project
    return true unless params[:id]
    @project = Project.find(params[:id])
    authorize
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
