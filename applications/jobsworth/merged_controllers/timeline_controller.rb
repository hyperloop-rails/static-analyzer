# encoding: UTF-8
# Filter WorkLogs in different ways, with pagination

class TimelineController < ApplicationController
  def index
    params[:filter_date] ||= 1
    params[:filter_project] ||= 0
    params[:filter_status] ||= -1
    @logs = EventLog.event_logs_for_timeline(current_user, params)

    if request.xhr?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = t("timeline.title", title: Setting.productName) 
 t("timeline.timeline") 

  @users = objects_to_names_and_ids(User.order('name').where(:company_id => current_user.company_id))
  filter_count = 0

 form_tag('/timeline/index') do 
 if current_user.projects.any? 
 t("billings.any_project") 
 projects = current_user.projects.includes(:customer).except(:order).order("customers.name, projects.name") 
 client_projects = grouped_client_projects_options(projects)
 client_projects.each do |c| 
 c.first 
 c.last.each do |p| 
p.last
 " selected" if p.last.to_s == params[:filter_project] 
 p.first 
 end 
 end 
 end 

      @status = [[t("filter_status.any_type"), "-1"],
                [t("filter_status.closed"), EventLog::TASK_COMPLETED.to_s],
                [t("filter_status.work_log"), EventLog::TASK_WORK_ADDED.to_s],
                [t("filter_status.resolution_change"), EventLog::TASK_REVERTED.to_s],
                [t("filter_status.created"), EventLog::TASK_CREATED.to_s],
                [t("filter_status.comment"), EventLog::TASK_COMMENT.to_s],
                [t("filter_status.modified"), EventLog::TASK_MODIFIED.to_s]]

      @status << [t("filter_status.wiki_additions"), EventLog::WIKI_CREATED.to_s] if current_user.company.show_wiki?
      @status << [t("filter_status.wiki_changes"), EventLog::WIKI_MODIFIED.to_s] if current_user.company.show_wiki?
      @status <<  [t("filter_status.password_request"), EventLog::RESOURCE_PASSWORD_REQUESTED.to_s] if current_user.use_resources?

    
 options_for_select @status, params[:filter_status] 
 @dates =  [[t("filter_date.start_point"), "0"],
                  [t("filter_date.now"), "1"],
                  [t("filter_date.custom"),"2"]] 
 options_for_select @dates, params[:filter_date] || 1 
 text_field '', '',
        {
          :id => 'start_date',
          :name => 'start_date',
          :size => 12,
          :value => (params[:start_date]) ? params[:start_date] : ""
        }
      
 end 
 day = 0; @logs.each do |log| 
 if day != tz.utc_to_local(log.started_at).day 
 day = tz.utc_to_local(log.started_at).day 
 I18n.l(tz.utc_to_local(log.started_at), format: "%A, %d %B %Y") 
 end 
 if  log.target_type == 'WorkLog' 
  date_format = current_user.time_format 
 log.access_level_id
 if log.comment? && (log.user_id.to_i == current_user.id || current_user.admin?)
 link_to("#{tz.utc_to_local(log.started_at).strftime(date_format)}", edit_work_log_path(log)) 
 else 
 "#{tz.utc_to_local(log.started_at).strftime(date_format)}"
 if log.duration > 0 
 "#{tz.utc_to_local(log.ended_at).strftime(date_format)}"
 end 
 end 
 link_to "#{TimeParser.format_duration(log.duration)}", edit_work_log_path(log) if (log.duration > 0 && ((log.user && log.user.id == current_user.id) || current_user.admin?) )
 if log.event_log 
 image_tag('accept.png', :alt => t("activities.complete")) if log.event_log.event_type == EventLog::TASK_COMPLETED 
 image_tag('cancel.png', :alt => t("activities.reverted")) if log.event_log.event_type == EventLog::TASK_REVERTED 
 log.task.type.try(:to_html) if log.event_log.event_type == EventLog::TASK_CREATED 
 image_tag('edit.png', :alt => t("button.edit")) if log.event_log.event_type == EventLog::TASK_MODIFIED 
 image_tag('comment_add.png', :alt => t("activities.new_comment")) if log.event_log.event_type == EventLog::TASK_COMMENT 
 image_tag('time_add.png', :alt => t("activities.work_done")) if log.event_log.event_type == EventLog::TASK_WORK_ADDED 
 image_tag('folder_add.png', :alt => t("activities.archived")) if log.event_log.event_type == EventLog::TASK_ARCHIVED 
 image_tag('folder_go.png', :alt => t("activities.archived")) if log.event_log.event_type == EventLog::TASK_RESTORED 
 end 
 if log.task_id.to_i > 0 && log.task 
 link_to_task log.task 
 end 
 "<br/>".html_safe if (log.task_id.to_i > 0) 
 if log.task_id.to_i > 0 
 if log.task.project 
 log.task.project.full_name 
 log.task.tags.each do |t| 
 t.name 
 simple_format(h(t.name.capitalize)) 
 end 
 end 
 end 
 "<small><span class=\"otheruser\">[".html_safe + log.user.name + "]</span></small>".html_safe if log.user 
 avatar_for log.user, 25 if log.user 
 if log.body && log.body.length > 0 
simple_format(h(log.body)) if log.body 
 end 
 
 else 
  date_format = current_user.time_format 
 "#{tz.utc_to_local(log.created_at).strftime(date_format)}"
 image_tag('page_add.png', :alt => t("activities.wiki_page_added")) if log.event_type == EventLog::WIKI_CREATED 
 image_tag('page_edit.png', :alt => t("activities.wiki_page_modified")) if log.event_type == EventLog::WIKI_MODIFIED 
 image_tag('package_add.png', :alt => t("activities.file_added")) if log.event_type == EventLog::FILE_UPLOADED 
 if log.target.is_a? TaskRecord 
 link_to_task log.target 
 elsif log.target.is_a? WikiPage 
 log.target.to_url 
 elsif log.target.is_a? ProjectFile 
 "#{link_to_task(log.target.task)} [".html_safe if log.target.task 
 "<a href=\"/project_files/show/#{log.target_id}\" title=\"<img src=/project_files/thumbnail/#{log.target_id}>\" rel=\"tooltip\">#{log.target.filename}</a>".html_safe 
 "]".html_safe if log.target.task 
 else 
 log_title_for(log) 
 end 
 "<br/>".html_safe if(log.user || (log.target.respond_to?(:task) && log.target.task) ) 
 "<span class=\"optional\">#{log.target.task.full_name}</span> ".html_safe if( log.target.respond_to?(:task) && log.target.task )
 "<small><span class=\"otheruser\">[#{log.user.name}]</span></small>".html_safe if log.user 
 avatar_for log.user, 25 if log.user 
 if log.body && log.body.length > 0 
 log.body.gsub(/\n/, "<br/>").html_safe  
 end 
 
 end 
 end 
 if @logs.count > 0 
 t("shared.load_more") 
 else 
 t("shared.no_item_found") 
 end 
 current_user.dateFormat 
 (I18n.l(tz.utc_to_local(@logs.last.started_at), format: "%A, %d %B %Y") rescue "") 
 @logs.count 
 params[:filter_project] 
 params[:filter_status] 
 params[:filter_date] 
 params[:start_date] 
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

    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = t("timeline.title", title: Setting.productName) 
 t("timeline.timeline") 

  @users = objects_to_names_and_ids(User.order('name').where(:company_id => current_user.company_id))
  filter_count = 0

 form_tag('/timeline/index') do 
 if current_user.projects.any? 
 t("billings.any_project") 
 projects = current_user.projects.includes(:customer).except(:order).order("customers.name, projects.name") 
 client_projects = grouped_client_projects_options(projects)
 client_projects.each do |c| 
 c.first 
 c.last.each do |p| 
p.last
 " selected" if p.last.to_s == params[:filter_project] 
 p.first 
 end 
 end 
 end 

      @status = [[t("filter_status.any_type"), "-1"],
                [t("filter_status.closed"), EventLog::TASK_COMPLETED.to_s],
                [t("filter_status.work_log"), EventLog::TASK_WORK_ADDED.to_s],
                [t("filter_status.resolution_change"), EventLog::TASK_REVERTED.to_s],
                [t("filter_status.created"), EventLog::TASK_CREATED.to_s],
                [t("filter_status.comment"), EventLog::TASK_COMMENT.to_s],
                [t("filter_status.modified"), EventLog::TASK_MODIFIED.to_s]]

      @status << [t("filter_status.wiki_additions"), EventLog::WIKI_CREATED.to_s] if current_user.company.show_wiki?
      @status << [t("filter_status.wiki_changes"), EventLog::WIKI_MODIFIED.to_s] if current_user.company.show_wiki?
      @status <<  [t("filter_status.password_request"), EventLog::RESOURCE_PASSWORD_REQUESTED.to_s] if current_user.use_resources?

    
 options_for_select @status, params[:filter_status] 
 @dates =  [[t("filter_date.start_point"), "0"],
                  [t("filter_date.now"), "1"],
                  [t("filter_date.custom"),"2"]] 
 options_for_select @dates, params[:filter_date] || 1 
 text_field '', '',
        {
          :id => 'start_date',
          :name => 'start_date',
          :size => 12,
          :value => (params[:start_date]) ? params[:start_date] : ""
        }
      
 end 
 day = 0; @logs.each do |log| 
 if day != tz.utc_to_local(log.started_at).day 
 day = tz.utc_to_local(log.started_at).day 
 I18n.l(tz.utc_to_local(log.started_at), format: "%A, %d %B %Y") 
 end 
 if  log.target_type == 'WorkLog' 
  date_format = current_user.time_format 
 log.access_level_id
 if log.comment? && (log.user_id.to_i == current_user.id || current_user.admin?)
 link_to("#{tz.utc_to_local(log.started_at).strftime(date_format)}", edit_work_log_path(log)) 
 else 
 "#{tz.utc_to_local(log.started_at).strftime(date_format)}"
 if log.duration > 0 
 "#{tz.utc_to_local(log.ended_at).strftime(date_format)}"
 end 
 end 
 link_to "#{TimeParser.format_duration(log.duration)}", edit_work_log_path(log) if (log.duration > 0 && ((log.user && log.user.id == current_user.id) || current_user.admin?) )
 if log.event_log 
 image_tag('accept.png', :alt => t("activities.complete")) if log.event_log.event_type == EventLog::TASK_COMPLETED 
 image_tag('cancel.png', :alt => t("activities.reverted")) if log.event_log.event_type == EventLog::TASK_REVERTED 
 log.task.type.try(:to_html) if log.event_log.event_type == EventLog::TASK_CREATED 
 image_tag('edit.png', :alt => t("button.edit")) if log.event_log.event_type == EventLog::TASK_MODIFIED 
 image_tag('comment_add.png', :alt => t("activities.new_comment")) if log.event_log.event_type == EventLog::TASK_COMMENT 
 image_tag('time_add.png', :alt => t("activities.work_done")) if log.event_log.event_type == EventLog::TASK_WORK_ADDED 
 image_tag('folder_add.png', :alt => t("activities.archived")) if log.event_log.event_type == EventLog::TASK_ARCHIVED 
 image_tag('folder_go.png', :alt => t("activities.archived")) if log.event_log.event_type == EventLog::TASK_RESTORED 
 end 
 if log.task_id.to_i > 0 && log.task 
 link_to_task log.task 
 end 
 "<br/>".html_safe if (log.task_id.to_i > 0) 
 if log.task_id.to_i > 0 
 if log.task.project 
 log.task.project.full_name 
 log.task.tags.each do |t| 
 t.name 
 simple_format(h(t.name.capitalize)) 
 end 
 end 
 end 
 "<small><span class=\"otheruser\">[".html_safe + log.user.name + "]</span></small>".html_safe if log.user 
 avatar_for log.user, 25 if log.user 
 if log.body && log.body.length > 0 
simple_format(h(log.body)) if log.body 
 end 
 
 else 
  date_format = current_user.time_format 
 "#{tz.utc_to_local(log.created_at).strftime(date_format)}"
 image_tag('page_add.png', :alt => t("activities.wiki_page_added")) if log.event_type == EventLog::WIKI_CREATED 
 image_tag('page_edit.png', :alt => t("activities.wiki_page_modified")) if log.event_type == EventLog::WIKI_MODIFIED 
 image_tag('package_add.png', :alt => t("activities.file_added")) if log.event_type == EventLog::FILE_UPLOADED 
 if log.target.is_a? TaskRecord 
 link_to_task log.target 
 elsif log.target.is_a? WikiPage 
 log.target.to_url 
 elsif log.target.is_a? ProjectFile 
 "#{link_to_task(log.target.task)} [".html_safe if log.target.task 
 "<a href=\"/project_files/show/#{log.target_id}\" title=\"<img src=/project_files/thumbnail/#{log.target_id}>\" rel=\"tooltip\">#{log.target.filename}</a>".html_safe 
 "]".html_safe if log.target.task 
 else 
 log_title_for(log) 
 end 
 "<br/>".html_safe if(log.user || (log.target.respond_to?(:task) && log.target.task) ) 
 "<span class=\"optional\">#{log.target.task.full_name}</span> ".html_safe if( log.target.respond_to?(:task) && log.target.task )
 "<small><span class=\"otheruser\">[#{log.user.name}]</span></small>".html_safe if log.user 
 avatar_for log.user, 25 if log.user 
 if log.body && log.body.length > 0 
 log.body.gsub(/\n/, "<br/>").html_safe  
 end 
 
 end 
 end 
 if @logs.count > 0 
 t("shared.load_more") 
 else 
 t("shared.no_item_found") 
 end 
 current_user.dateFormat 
 (I18n.l(tz.utc_to_local(@logs.last.started_at), format: "%A, %d %B %Y") rescue "") 
 @logs.count 
 params[:filter_project] 
 params[:filter_status] 
 params[:filter_date] 
 params[:start_date] 
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
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = t("timeline.title", title: Setting.productName) 
 t("timeline.timeline") 

  @users = objects_to_names_and_ids(User.order('name').where(:company_id => current_user.company_id))
  filter_count = 0

 form_tag('/timeline/index') do 
 if current_user.projects.any? 
 t("billings.any_project") 
 projects = current_user.projects.includes(:customer).except(:order).order("customers.name, projects.name") 
 client_projects = grouped_client_projects_options(projects)
 client_projects.each do |c| 
 c.first 
 c.last.each do |p| 
p.last
 " selected" if p.last.to_s == params[:filter_project] 
 p.first 
 end 
 end 
 end 

      @status = [[t("filter_status.any_type"), "-1"],
                [t("filter_status.closed"), EventLog::TASK_COMPLETED.to_s],
                [t("filter_status.work_log"), EventLog::TASK_WORK_ADDED.to_s],
                [t("filter_status.resolution_change"), EventLog::TASK_REVERTED.to_s],
                [t("filter_status.created"), EventLog::TASK_CREATED.to_s],
                [t("filter_status.comment"), EventLog::TASK_COMMENT.to_s],
                [t("filter_status.modified"), EventLog::TASK_MODIFIED.to_s]]

      @status << [t("filter_status.wiki_additions"), EventLog::WIKI_CREATED.to_s] if current_user.company.show_wiki?
      @status << [t("filter_status.wiki_changes"), EventLog::WIKI_MODIFIED.to_s] if current_user.company.show_wiki?
      @status <<  [t("filter_status.password_request"), EventLog::RESOURCE_PASSWORD_REQUESTED.to_s] if current_user.use_resources?

    
 options_for_select @status, params[:filter_status] 
 @dates =  [[t("filter_date.start_point"), "0"],
                  [t("filter_date.now"), "1"],
                  [t("filter_date.custom"),"2"]] 
 options_for_select @dates, params[:filter_date] || 1 
 text_field '', '',
        {
          :id => 'start_date',
          :name => 'start_date',
          :size => 12,
          :value => (params[:start_date]) ? params[:start_date] : ""
        }
      
 end 
 day = 0; @logs.each do |log| 
 if day != tz.utc_to_local(log.started_at).day 
 day = tz.utc_to_local(log.started_at).day 
 I18n.l(tz.utc_to_local(log.started_at), format: "%A, %d %B %Y") 
 end 
 if  log.target_type == 'WorkLog' 
  date_format = current_user.time_format 
 log.access_level_id
 if log.comment? && (log.user_id.to_i == current_user.id || current_user.admin?)
 link_to("#{tz.utc_to_local(log.started_at).strftime(date_format)}", edit_work_log_path(log)) 
 else 
 "#{tz.utc_to_local(log.started_at).strftime(date_format)}"
 if log.duration > 0 
 "#{tz.utc_to_local(log.ended_at).strftime(date_format)}"
 end 
 end 
 link_to "#{TimeParser.format_duration(log.duration)}", edit_work_log_path(log) if (log.duration > 0 && ((log.user && log.user.id == current_user.id) || current_user.admin?) )
 if log.event_log 
 image_tag('accept.png', :alt => t("activities.complete")) if log.event_log.event_type == EventLog::TASK_COMPLETED 
 image_tag('cancel.png', :alt => t("activities.reverted")) if log.event_log.event_type == EventLog::TASK_REVERTED 
 log.task.type.try(:to_html) if log.event_log.event_type == EventLog::TASK_CREATED 
 image_tag('edit.png', :alt => t("button.edit")) if log.event_log.event_type == EventLog::TASK_MODIFIED 
 image_tag('comment_add.png', :alt => t("activities.new_comment")) if log.event_log.event_type == EventLog::TASK_COMMENT 
 image_tag('time_add.png', :alt => t("activities.work_done")) if log.event_log.event_type == EventLog::TASK_WORK_ADDED 
 image_tag('folder_add.png', :alt => t("activities.archived")) if log.event_log.event_type == EventLog::TASK_ARCHIVED 
 image_tag('folder_go.png', :alt => t("activities.archived")) if log.event_log.event_type == EventLog::TASK_RESTORED 
 end 
 if log.task_id.to_i > 0 && log.task 
 link_to_task log.task 
 end 
 "<br/>".html_safe if (log.task_id.to_i > 0) 
 if log.task_id.to_i > 0 
 if log.task.project 
 log.task.project.full_name 
 log.task.tags.each do |t| 
 t.name 
 simple_format(h(t.name.capitalize)) 
 end 
 end 
 end 
 "<small><span class=\"otheruser\">[".html_safe + log.user.name + "]</span></small>".html_safe if log.user 
 avatar_for log.user, 25 if log.user 
 if log.body && log.body.length > 0 
simple_format(h(log.body)) if log.body 
 end 
 
 else 
  date_format = current_user.time_format 
 "#{tz.utc_to_local(log.created_at).strftime(date_format)}"
 image_tag('page_add.png', :alt => t("activities.wiki_page_added")) if log.event_type == EventLog::WIKI_CREATED 
 image_tag('page_edit.png', :alt => t("activities.wiki_page_modified")) if log.event_type == EventLog::WIKI_MODIFIED 
 image_tag('package_add.png', :alt => t("activities.file_added")) if log.event_type == EventLog::FILE_UPLOADED 
 if log.target.is_a? TaskRecord 
 link_to_task log.target 
 elsif log.target.is_a? WikiPage 
 log.target.to_url 
 elsif log.target.is_a? ProjectFile 
 "#{link_to_task(log.target.task)} [".html_safe if log.target.task 
 "<a href=\"/project_files/show/#{log.target_id}\" title=\"<img src=/project_files/thumbnail/#{log.target_id}>\" rel=\"tooltip\">#{log.target.filename}</a>".html_safe 
 "]".html_safe if log.target.task 
 else 
 log_title_for(log) 
 end 
 "<br/>".html_safe if(log.user || (log.target.respond_to?(:task) && log.target.task) ) 
 "<span class=\"optional\">#{log.target.task.full_name}</span> ".html_safe if( log.target.respond_to?(:task) && log.target.task )
 "<small><span class=\"otheruser\">[#{log.user.name}]</span></small>".html_safe if log.user 
 avatar_for log.user, 25 if log.user 
 if log.body && log.body.length > 0 
 log.body.gsub(/\n/, "<br/>").html_safe  
 end 
 
 end 
 end 
 if @logs.count > 0 
 t("shared.load_more") 
 else 
 t("shared.no_item_found") 
 end 
 current_user.dateFormat 
 (I18n.l(tz.utc_to_local(@logs.last.started_at), format: "%A, %d %B %Y") rescue "") 
 @logs.count 
 params[:filter_project] 
 params[:filter_status] 
 params[:filter_date] 
 params[:start_date] 
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
