#==
# RailsCollab
# Copyright (C) 2007 - 2011 James S Urquhart
# Portions Copyright (C) René Scheibe
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

class DashboardController < ApplicationController
  after_filter  :user_track
  helper :dashboard

  def index
    when_fragment_expired "user#{@logged_user.id}_dblog", Time.now.utc + (60 * Rails.configuration.minutes_to_activity_log_expire) do
      if @active_projects.length > 0
        project_ids = @active_projects.collect{ |project| project.id }

        activity_conditions = @logged_user.member_of_owner? ?
          { :project_id => project_ids } :
          { :project_id => project_ids, :is_private => false }

        @activity_log = Activity.where(activity_conditions).order('created_on DESC, id DESC').limit(Rails.configuration.project_logs_per_page)
      else
        @activity_log = []
      end
    end

    @time_now = Time.zone.now
    @late_milestones = Milestone.all_assigned_to(@logged_user,
                                                        nil,
                                                        nil,
                                                        (@time_now - 1.day).utc.to_date,
                                                        nil,
                                                        true)
    @upcoming_milestones = Milestone.all_assigned_to(@logged_user,
                                                            nil,
                                                            @time_now.utc.to_date,
                                                            (@time_now.utc + 14.days).to_date,
                                                            nil,
                                                            true)
    
    @calendar_milestones = @upcoming_milestones.group_by do |obj|
      date = obj.due_date.to_date
      "#{date.month}-#{date.day}"
    end

    @online_users = User.get_online
    @my_projects = @active_projects
    @content_for_sidebar = 'index_sidebar'
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'company_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var LOGGED_USER_ID=#{@logged_user.id};" 
 link_to site_name, :controller => 'dashboard' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag :controller => 'dashboard', :action => 'search' 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  if @logged_user.is_admin?
      @page_actions = [{:title => :add_project, :url=> new_project_path}]
  end

 if @logged_user.member_of_owner? and !Company.owner.hide_welcome_info 
 t('welcome_to_new_account') 
 t('welcome_to_new_account_info', :user => h(@logged_user.display_name), :url => "<a href=\"#{Rails.configuration.site_url}\">#{Rails.configuration.site_url}</a>").html_safe 
 new_account_steps(@logged_user).each do |step| 
 raw step[:del] ? "<del>#{step[:title]}</del>" : "#{step[:title]}" 
 raw step[:del] ? "<del>#{step[:content]}</del>" : "#{step[:content]}" 
 end 
 if @logged_user.is_admin 
 link_to t('hide_welcome_info').html_safe, hide_welcome_info_company_path(Company.owner), :method => 'put' 
 end 
 end 
 if @late_milestones.length > 0 or !@calendar_milestones.empty? 
 t('milestones_summary', :adjetives => [!@late_milestones.empty? ? t('late') : nil,
                           !@calendar_milestones.empty? ? t('upcoming') : nil].compact.to_sentence) 
 if @late_milestones.length > 0 
 t('late_milestones') 
 @late_milestones.each do |milestone| 
 unless milestone.assigned_to.nil? 
 h milestone.assigned_to.object_name 
 end 
 t('milestone_in', :milestone => link_to(h(milestone.name), milestone_path(:id => milestone.id, :active_project => milestone.project)), :project => link_to(h(milestone.project.name), project_path(:id => milestone.project.id))).html_safe 
 t('milestone_days_late', :days => milestone.days_late) 
 end 
 end 
 unless @calendar_milestones.empty? 
 t('due_in_next_n_days', :num => 14) 
 now = @time_now.to_date
      prev_month = now.month
      days_calendar now, now + 13.days, 'dayCal' do |date|
        if date == now
          calendar_block(t('today'), @calendar_milestones["#{date.month}-#{date.day}"], 'today', true) 
        else
          if date.month != prev_month 
            prev_month = date.month
            calendar_block(l(date, :format => '%b %d'), @calendar_milestones["#{date.month}-#{date.day}"], 'day')
          else
            calendar_block(date.day, @calendar_milestones["#{date.month}-#{date.day}"], 'day') 
          end
        end
      end 
 end 
 end 
 cache "user#{@logged_user.id}_dblog" do 
 if @activity_log.length > 0 
 t('details') 
 t('project') 
  if application_logs.is_today? 
 elsif application_logs.is_yesterday? 
 else 
 end 
 "#{application_logs.rel_object_type.downcase}s.gif" 
 application_logs.rel_object_type 
 application_logs.rel_object_type 
 if not ['Comment', 'Message'].include?(application_logs.rel_object_type) 
 application_logs.friendly_action 
 end 
 application_logs.rel_object.nil? ? h(truncate(application_logs.object_name, :length => 50)) : link_to(h(truncate(application_logs.object_name, :length => 50)), application_logs.rel_object.object_url) 
 if show_project_column 
 if application_logs.is_today? 
 t('action_today_with_time', :time => format_usertime(application_logs.created_on, :action_today_fomat)) 
 elsif application_logs.is_yesterday? 
 t('action_yesterday') 
 else 
 format_usertime(application_logs.created_on, :action_past_format) 
 end 
 if not application_logs.created_by.nil? 
 link_to (h application_logs.created_by.display_name), user_path(:id => application_logs.created_by.id) 
 end 
 end 
 if show_project_column 
 if not application_logs.project.nil? 
 link_to (h application_logs.project.name), project_path(:id => application_logs.project.id) 
 end 
 else 
 if application_logs.is_today? 
 t('action_today_with_time', :time => format_usertime(application_logs.created_on, :action_today_fomat)).html_safe 
 elsif application_logs.is_yesterday? 
 t('action_yesterday') 
 else 
 format_usertime(application_logs.created_on, :action_past_format) 
 end 
 if not application_logs.created_by.nil? 
 t('action_by', :user => link_to(h(application_logs.created_by.display_name), user_path(:id => application_logs.created_by.id))).html_safe 
 end 
 end 
 
 else 
 t('no_recent_activities') 
 end 
 end 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  def my_projects
    # Create the sorted projects list
    sort_type = params[:orderBy]
    sort_type = 'priority' unless ['name'].include?(params[:orderBy])
    @sorted_projects = @active_projects.sort_by do |item|
      item[sort_type].nil? ? 0 : item[sort_type]
    end

    @finished_projects = @logged_user.finished_projects
    @content_for_sidebar = 'my_projects_sidebar'
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'company_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var LOGGED_USER_ID=#{@logged_user.id};" 
 link_to site_name, :controller => 'dashboard' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag :controller => 'dashboard', :action => 'search' 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  @page_actions = []
  if @logged_user.is_admin?
      @page_actions << {:title => :add_project, :url=> new_project_path}
  end
  
  @page_actions += [
  	{:title => :order_by_name, :url => '/dashboard/my_projects?orderBy=name'},
  	{:title => :order_by_priority, :url => '/dashboard/my_projects?orderBy=priority'}
  ]

 if @sorted_projects.length > 0 
 @sorted_projects.each do |project| 
 link_to (h project.name), project_path(:id => project.id) 
 if not project.description.nil? and project.description.strip.length > 0 
 textilize project.description 
 end 
 if project.companies.length > 0 
 t('companies_involved_in') 

    project.companies.collect do |company|
    link_to( (h company.name), company_path(:id => company.id) )
    end.join(', ').html_safe
    
 end 
 if not project.created_by.nil? 
 t('started_on') 
 "#{format_usertime(project.created_on, :project_created_format)} | " 
 link_to (h project.created_by.display_name), user_path(:id => project.created_by.id) 
 else 
 t('started_on') 
 format_usertime(project.created_on, :project_created_format)  
 end 
 end 
 else 
 t('no_active_projects') 
 end 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  def my_tasks
    @has_assigned_tasks = nil
    @projects_milestonestasks = @active_projects.collect do |project|
    @has_assigned_tasks ||= true unless (project.milestones_by_user(@logged_user).empty? and 
                                         project.tasks_by_user(@logged_user).empty?)

      {
        :name       => project.name,
        :id         => project.id,
        :milestones => project.milestones_by_user(@logged_user),
        :tasks      => project.tasks_by_user(@logged_user)
      }
    end
    @has_assigned_tasks ||= false

    @content_for_sidebar = 'my_tasks_sidebar'
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'company_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var LOGGED_USER_ID=#{@logged_user.id};" 
 link_to site_name, :controller => 'dashboard' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag :controller => 'dashboard', :action => 'search' 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 if @projects_milestonestasks.length > 0 
 @projects_milestonestasks.each do |project| 
 if project[:milestones].length > 0 or project[:tasks].length > 0 
 link_to (h project[:name]), project_path(:id => project[:id]) 
 if project[:milestones].length > 0 
 link_to t('milestones'), milestones_path(:active_project => project[:id]) 
 project[:milestones].each do |milestone| 
 checkbox_link complete_milestone_path(:id => milestone.id, :active_project => milestone.project_id), false, nil, {:method => :put} 
 if not milestone.assigned_to.nil? 
 h milestone.assigned_to.object_name 
 else 
 t('anyone') 
 end 
 link_to (h milestone.name), milestone_path(:id => milestone.id, :active_project => project[:id]) 
 if milestone.is_upcoming? 
 t('milestone_days_left', :days => milestone.days_left) 
 elsif milestone.is_late? 
 t('milestone_days_late', :days => milestone.days_late) 
 elsif milestone.is_today? 
 t('today') 
 end 
 end 
 end 
 if project[:tasks].length > 0 
 link_to t('tasks'), task_lists_path(:active_project => project[:id]) 
 project[:tasks].each do |task| 
 if task.is_completed? 
 end 
 link_to '', status_task_path(:task_list_id => task.task_list_id, :id => task.id, :active_project => project[:id]) 
 if not task.assigned_to.nil? 
 h task.assigned_to.object_name  
 else 
 t('anyone') 
 end 
 h task.text 
 if not task.task_list.nil? 
 t('tasks_in_list', :list => link_to(h(task.task_list.name), task_list_path(:id => task.task_list_id, :active_project => project[:id]))) 
 end 
 end 
 end 
 end 
 end 
 else 
 t('no_active_projects') 
 end  
 if not @has_assigned_tasks 
 t('no_tasks_assigned_to_you') 
 end 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  def milestones
    @time_now = Time.zone.now
    
    @date_start = @time_now.utc.to_date.beginning_of_month
    @date_end = @date_start + 3.months - 1.day
    
    assignee = unless params[:assigned_to].nil? or params[:assigned_to].empty?
      if params[:assigned_to][0] == 99 # c
        Company.find(params[:assigned_to][1...(params[:assigned_to].length)].to_i)
      else
        User.find(params[:assigned_to])
      end
    else
      nil
    end
    
    @late_milestones = Milestone.all_assigned_to(@logged_user,
                                                        assignee,
                                                        nil,
                                                        @date_start-1,
                                                        nil,
                                                        true)

    @milestones = Milestone.all_assigned_to(@logged_user, 
                                                   assignee,
                                                   @date_start, 
                                                   @date_end, nil, true).group_by do |obj| 
      date = obj.due_date.to_date
      "#{date.month}-#{date.day}"
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'company_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var LOGGED_USER_ID=#{@logged_user.id};" 
 link_to site_name, :controller => 'dashboard' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag :controller => 'dashboard', :action => 'search' 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 if @late_milestones.length > 0 
 t('late_milestones') 
 if @late_milestones.length > 0 
 @late_milestones.each do |milestone| 
 t('milestone_days_late', :days => milestone.days_late) 
 t('milestone_in', :milestone => link_to(h(milestone.name), milestone_path(:id => milestone.id, :active_project => milestone.project)), :project => link_to(h(milestone.project.name), project_path(:id => milestone.project.id))).html_safe 
 unless milestone.assigned_to.nil? 
 h milestone.assigned_to.object_name 
 end 
 end 
 end 
 end 
 now = @time_now.to_date
months_calendar @date_start, @date_end, 'monthsCal', Rails.configuration.first_day_of_week.to_i do |date|
  unless date == now
    calendar_block(date.day, @milestones["#{date.month}-#{date.day}"], 'day')  
  else
    calendar_block(t('today'), @milestones["#{date.month}-#{date.day}"], 'today', true)
  end
end 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  def search
    @current_search = params[:search_id]

    unless @current_search.nil?
      @last_search = @current_search

      current_page = params[:page].to_i
      current_page = 1 unless current_page > 0

      @search_results, @total_search_results = Project.search_for_user(@last_search, @logged_user, {:page => current_page, :per_page => Rails.configuration.search_results_per_page})

      @tag_names = []
      @pagination = []
      @start_search_results = Rails.configuration.search_results_per_page * (current_page-1)
      (@total_search_results.to_f / Rails.configuration.search_results_per_page).ceil.times {|page| @pagination << page+1}
    else
      @last_search = I18n.t('search_box_default')
      @search_results = []

      @tag_names = []
    end

    @content_for_sidebar = 'projects/search_sidebar'
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'company_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var LOGGED_USER_ID=#{@logged_user.id};" 
 link_to site_name, :controller => 'dashboard' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag :controller => 'dashboard', :action => 'search' 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 form_tag :action => 'search' 
 text_field_tag 'search_id', @last_search 
 t('search') 
 if !@search_results.empty? 
 t('search_displaying_results_for', {:start => @start_search_results, 
                                                   :finish => @start_search_results+@search_results.length, 
                                                   :total => @total_search_results,
                                                   :search => h(@current_search)}) 
 @search_results.each do |obj| 
 t('search_dashboard', :type => t(obj.class.to_s), 
                                        :name => link_to(obj.object_name, obj.object_url),
                                        :project => link_to(obj.project.object_name, obj.project.object_url)) 
 end 
 pagination_links  "/dashboard/search?search_id=#{CGI::escape(@last_search)}&", @pagination unless @pagination.length <= 1 
 elsif !@current_search.nil? 
 t('search_no_matching_objects', {:search => h(@current_search)}) 
 end 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end
end
