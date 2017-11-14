# encoding: UTF-8
# Controller handling admin activities

class AdminStatsController < ApplicationController
  before_filter :authorize_user_is_admin

  def index
    @users_from_this_year = User.from_this_year
    @users_total          = User.count

    @projects_from_this_year = Project.from_this_year
    @projects_total          = Project.count

    @tasks_from_this_year = TaskRecord.from_this_year
    @tasks_total          = TaskRecord.count

    @last_50_users = User.recent_users
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 t("admin_stats.admin_stats") 
 link_to t("admin_stats.admin"), :action => "index" 
 link_to t("admin_stats.news"), :action => "news" 
 t("admin_stats.active_users") 
 t("shared.today") 
 total_count_for(@users_from_this_year,"today","last_sign_in_at") 
 t("shared.this_week") 
 total_count_for(@users_from_this_year,"this_week","last_sign_in_at") 
 t("shared.this_month") 
 total_count_for(@users_from_this_year,"this_month","last_sign_in_at") 
 t("shared.this_year") 
 total_count_for(@users_from_this_year,"this_year","last_sign_in_at") 
 t("admin_stats.user_registrations") 
 t("shared.today") 
 total_count_for(@users_from_this_year,"today") 
 t("shared.yesterday") 
 total_count_for(@users_from_this_year,"yesterday") 
 t("shared.this_week") 
total_count_for(@users_from_this_year,"this_week") 
 t("shared.last_week") 
 total_count_for(@users_from_this_year, "last_week") 
 t("shared.this_month") 
 total_count_for(@users_from_this_year,"this_month") 
 t("shared.last_month") 
 total_count_for(@users_from_this_year,"last_month") 
 t("shared.this_year") 
 total_count_for(@users_from_this_year,"this_year") 
 t("shared.total") 
 @users_total 
 t("admin_stats.projects") 
 t("shared.today") 
 total_count_for(@projects_from_this_year,"today") 
 t("shared.yesterday") 
 total_count_for(@projects_from_this_year,"yesterday") 
 t("shared.this_week") 
total_count_for(@projects_from_this_year,"this_week") 
 t("shared.last_week") 
 total_count_for(@projects_from_this_year, "last_week") 
 t("shared.this_month") 
 total_count_for(@projects_from_this_year,"this_month") 
 t("shared.last_month") 
 total_count_for(@projects_from_this_year,"last_month") 
 t("shared.this_year") 
 total_count_for(@projects_from_this_year,"this_year") 
 t("shared.total") 
 @projects_total 
 t("shared.today") 
 total_count_for(@tasks_from_this_year,"today") 
 t("shared.yesterday") 
 total_count_for(@tasks_from_this_year,"yesterday") 
 t("shared.this_week") 
total_count_for(@tasks_from_this_year,"this_week") 
 t("shared.last_week") 
 total_count_for(@tasks_from_this_year, "last_week") 
 t("shared.this_month") 
 total_count_for(@tasks_from_this_year,"this_month") 
 t("shared.last_month") 
 total_count_for(@tasks_from_this_year,"last_month") 
 t("shared.this_year") 
 total_count_for(@tasks_from_this_year,"this_year") 
 t("shared.total") 
 @tasks_total 
 t("admin_stats.last_registered_users") 
 t("admin_stats.name") 
 t("admin_stats.company") 
 t("admin_stats.email") 
 t("admin_stats.created") 
 t("admin_stats.timezone") 
 for u in @last_50_users 
 u.name 
 u.company.name 
 u.email 
 tz.utc_to_local(u.created_at).strftime("%d/%m %Y %H:%M") 
 u.time_zone 
 end 
 yield(:side_panel) 
  t("task_filters.filters") 
 t("task_filters.save_current") 
 filters_user_path(current_user) 
 t("task_filters.manage") 
 TaskFilter.recent_for(current_user).each do |filter| 
 select_task_filter_link(filter) 
 end 
 link_to_open_tasks 
 link_to_open_tasks(current_user) 
 link_to_unread_tasks(current_user) 
 current_user.visible_task_filters.each do |tf| 
 select_task_filter_link(tf) 
 end 
 
  cache(grouped_cache_key "tags/company_#{current_user.company_id}/", current_user.id) do 
 t("tags.tags") 
 if current_user.admin? 
 t("button.edit") 
 end 
 tag_links 
 end 
 
  current_user.id 
 current_user.id 
 t("tasks.next_tasks") 
 count = 5 if ( count.nil? || count < 5) 
 current_user.schedule_tasks(:limit => count, :save => false) do |task| 
  pill_date ||= task.estimate_date 
 time ||= :minutes_left 
 sorting_disabled ||= false 
 user.top_next_task == task ? 'top-next-task' : nil 
 human_future_date(pill_date, user.tz) 
 task.css_classes 
 link_to "<b>##{task.task_num}</b>".html_safe, task_view_path(task.task_num), 'data-taskid' => task.id, "data-content" => task_detail(task, user) 
 task.name 
 case time 
 when :minutes_left 
 "(" + TimeParser.format_duration(task.minutes_left) + ")" 
 when :worked_minutes 
 "(" + TimeParser.format_duration(task.worked_minutes, true) + ")" 
 end 
 unless sorting_disabled 
 link_to "<i class=\"icon-move\"></i>".html_safe, "#", :title => t("tasks.reorder_task"), :class => "pull-right" 
 end 
 
 end 
 if current_user.tasks.open_only.not_snoozed.count > count 
 t("tasks.more_tasks") 
 end 
 
 end 
  javascript_include_tag 'application' 
 yield :head 
 stylesheet_link_tag 'application' 
 auto_discovery_link_tag(:rss, {:controller => 'feeds', :action => 'rss', :id => current_user.uuid }) 
 csrf_meta_tag 
 @page_title || Setting.productName 
 if Setting.version 
 Setting.version 
 end 
 new_user_session_url 
  image_tag('spinner.gif', :border => 0) 
 
  if current_user.company.logo? 
 image_tag("/companies/show_logo/#{current_user.company.id}", :alt => "logo" ) 
 else 
 image_tag("logo.gif", :alt => "logo" ) 
 end 
 if total_today > 0 
 t("shared.worked_today", time: distance_of_time_in_words(total_today.minutes)) 
 end 
 if @current_sheet && @current_sheet.task 
  start_stop_work_link(@current_sheet.task) 
 cancel_work_link(@current_sheet.task) 
 pause_task_link(@current_sheet.task) 
 link_to(@current_sheet.task.issue_name + " - " + @current_sheet.task.project.name, edit_task_path(@current_sheet.task.task_num)) 
 percent = ((@current_sheet.task.worked_minutes + @current_sheet.duration / 60) / @current_sheet.task.duration.to_f  * 100).round unless (@current_sheet.task.duration.nil? or @current_sheet.task.duration == 0) 
 TimeParser.format_duration(@current_sheet.duration/60) 
 TimeParser.format_duration(@current_sheet.task.worked_minutes + @current_sheet.duration / 60) 
 percent.nil? ? 0 : percent 
 
 end 
 
  t('tabmenu.overview') 
 link_to t('tabmenu.dashboard'), :controller => 'activities', :action => 'index' 
 if current_user.admin? 
 link_to t('tabmenu.planning'), planning_tasks_path 
 end 
 if current_user.can_any?(current_user.projects, 'report') 
 billing_title = current_user.can_use_billing? ? 'billing' : 'reports'  
 link_to t("tabmenu.#{billing_title}"), :controller => 'billing', :action => 'index' 
 end 
 link_to t('tabmenu.history'), :controller => 'timeline', :action => 'index' 
 t('tabmenu.create') 
 link_to t('tabmenu.task'), :controller => 'tasks', :action => 'new' 
 if current_templates.size > 0 
 t('tabmenu.from_template') 
 current_templates.order("tasks.position_task_template").each do |task| 
 link_to task, clone_task_path(task.task_num) 
 end 
 end 
 if current_user.create_projects? 
 link_to t('tabmenu.project'), :controller => 'projects', :action => 'new' 
 end 
 link_to t('tabmenu.milestone'), new_milestone_path 
 if Setting.contact_creation_allowed && current_user.can_view_clients? 
 link_to t('tabmenu.person'), :controller => 'users', :action => 'new' 
 link_to t('tabmenu.company'), :controller => 'customers', :action => 'new' 
 end 
 if current_user.use_resources? 
 link_to(t('tabmenu.resource'), new_resource_path) 
 end 
 if menu_class("activities") == "active" 
 link_to t('tabmenu.add_new_widget'), '#', :id => "add-widget-menu-link" 
 end 
 menu_class("tasks") 
 link_to t('tabmenu.tasks'), :controller => 'tasks', :action => 'index' 
 menu_class("milestones") 
 link_to t('tabmenu.milestones'), milestones_path 
 if current_user.company.show_wiki? 
 menu_class("wiki") 
 link_to t('tabmenu.wiki'), :controller => 'wiki', :action => 'show', :id => nil 
 end 
 link_to t('tabmenu.projects'), :controller => 'projects', :action => 'index' 
  text_field_tag("keyword", "", :class => "search_filter input-xlarge", :placeholder => t('tabmenu.search'), :id => "menubar_search", :autocomplete => "off") 
 
 current_user.display_login 
 if current_user.admin? 
 link_to  t('tabmenu.my_account'), edit_user_path(current_user) 
 link_to t('tabmenu.company_settings'), :controller => 'companies', :action => 'edit', :id => current_user.company_id 
 else 
 link_to t('tabmenu.my_account'), edit_user_path(current_user) 
 end 
 link_to t('tabmenu.log_out'), destroy_user_session_path 
 
   flash.each do |key, val| 
key.to_s
 val 
 end 
 
 news = NewsItem.order("id desc").where("id > ?", current_user.seen_news_id).first
unless news.nil? 
 tz.utc_to_local(news.created_at).strftime("#{current_user.time_format} #{current_user.date_format}") 
 news.body 
 link_to( "[#{t("button.hide")}]", { :controller => 'users', :action => 'update_seen_news', :id => news.id}, :class => "right",
        :onclick => "jQuery('#news').fadeOut(500)",
        :remote => true) 
 end 
 
 content_for?(:content) ? yield(:content) : yield 
 current_user.id 
 current_user.dateFormat 
 

end

  end
end
