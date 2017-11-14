# encoding: UTF-8
class WorkLogsController < ApplicationController
  before_filter :load_log, :only => [ :edit, :update, :destroy ]
  before_filter :load_task_and_build_log, :only => [ :new, :create ]

  include WorkLogsHelper

  def new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = t("work_logs.title", title: Setting.productName) 
 t("work_logs.new_title") 
 form_for(@log, :as => :work_log, :html => {:class => "form-horizontal"}) do |f| 
  hidden_field_tag :task_id, @log.task.task_num 
 if current_user.option_tracktime.to_i == 1 
 label :started_at, @log.human_name(:started_at) 
 if @log.new_record? 
 text_field(:work_log, :started_at, :value => Time.now.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 else 
 text_field(:work_log, :started_at, :value => @log.started_at.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 end 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 if @log.worktime? 
 label :work_log, :customer_name, t("work_logs.client") 
 select :work_log, :customer_id, work_log_customer_options(@log) 
 t("work_logs.time_worked") 
 text_field(:work_log, :duration, :value => TimeParser.format_duration(@log.duration),
            :size => 10, :rel => 'tooltip', :title => t("work_logs.time_worked_tooltip"), "data-placement" => "right") 
 end 
 end 
 @log.human_name :body 
 text_area(:work_log, :body, :rows => 10, :value => @log.body, :class => "input-xxlarge") 
 
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

  def create
    params[:work_log][:duration] = TimeParser.parse_time(params[:work_log][:duration])

    @log.attributes = params[:work_log]
    @log.user = current_user
    @log.project = @task.project

    if @log.save
      flash[:success] = t('flash.notice.model_created', model: WorkLog.model_name.human)
      redirect_to tasks_path
    else
      flash[:error] = @log.errors.full_messages.join(". ")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = t("work_logs.title", title: Setting.productName) 
 t("work_logs.new_title") 
 form_for(@log, :as => :work_log, :html => {:class => "form-horizontal"}) do |f| 
  hidden_field_tag :task_id, @log.task.task_num 
 if current_user.option_tracktime.to_i == 1 
 label :started_at, @log.human_name(:started_at) 
 if @log.new_record? 
 text_field(:work_log, :started_at, :value => Time.now.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 else 
 text_field(:work_log, :started_at, :value => @log.started_at.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 end 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 if @log.worktime? 
 label :work_log, :customer_name, t("work_logs.client") 
 select :work_log, :customer_id, work_log_customer_options(@log) 
 t("work_logs.time_worked") 
 text_field(:work_log, :duration, :value => TimeParser.format_duration(@log.duration),
            :size => 10, :rel => 'tooltip', :title => t("work_logs.time_worked_tooltip"), "data-placement" => "right") 
 end 
 end 
 @log.human_name :body 
 text_area(:work_log, :body, :rows => 10, :value => @log.body, :class => "input-xxlarge") 
 
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

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = t("work_logs.title", title: Setting.productName) 
 t("work_logs.edit_title") 
 @log.task 
 form_for(@log, :as => :work_log, :html => {:class => "form-horizontal"}) do |f| 
  hidden_field_tag :task_id, @log.task.task_num 
 if current_user.option_tracktime.to_i == 1 
 label :started_at, @log.human_name(:started_at) 
 if @log.new_record? 
 text_field(:work_log, :started_at, :value => Time.now.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 else 
 text_field(:work_log, :started_at, :value => @log.started_at.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 end 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 if @log.worktime? 
 label :work_log, :customer_name, t("work_logs.client") 
 select :work_log, :customer_id, work_log_customer_options(@log) 
 t("work_logs.time_worked") 
 text_field(:work_log, :duration, :value => TimeParser.format_duration(@log.duration),
            :size => 10, :rel => 'tooltip', :title => t("work_logs.time_worked_tooltip"), "data-placement" => "right") 
 end 
 end 
 @log.human_name :body 
 text_area(:work_log, :body, :rows => 10, :value => @log.body, :class => "input-xxlarge") 
 
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

  def update
    params[:work_log][:duration] = TimeParser.parse_time(params[:work_log][:duration])

    @log.attributes = params[:work_log]
    @log.project = @task.project

    if @log.save
      flash[:success] = t('flash.notice.model_saved', model: WorkLog.model_name.human)
      redirect_to tasks_path
    else
      flash[:error] = @log.errors.full_messages.join(". ")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = t("work_logs.title", title: Setting.productName) 
 t("work_logs.edit_title") 
 @log.task 
 form_for(@log, :as => :work_log, :html => {:class => "form-horizontal"}) do |f| 
  hidden_field_tag :task_id, @log.task.task_num 
 if current_user.option_tracktime.to_i == 1 
 label :started_at, @log.human_name(:started_at) 
 if @log.new_record? 
 text_field(:work_log, :started_at, :value => Time.now.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 else 
 text_field(:work_log, :started_at, :value => @log.started_at.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 end 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 if @log.worktime? 
 label :work_log, :customer_name, t("work_logs.client") 
 select :work_log, :customer_id, work_log_customer_options(@log) 
 t("work_logs.time_worked") 
 text_field(:work_log, :duration, :value => TimeParser.format_duration(@log.duration),
            :size => 10, :rel => 'tooltip', :title => t("work_logs.time_worked_tooltip"), "data-placement" => "right") 
 end 
 end 
 @log.human_name :body 
 text_area(:work_log, :body, :rows => 10, :value => @log.body, :class => "input-xxlarge") 
 
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

  def destroy
    if can_delete_log?(@log)
      @log.destroy
      flash[:success] = t('flash.notice.model_deleted', model: WorkLog.model_name.human)
    else
      flash[:error] = t('flash.alert.access_denied_to_model', model: WorkLog.model_name.human)
    end

    redirect_to tasks_path
  end

  def update_work_log
    unless current_user.can_approve_work_logs?
      render :nothing => true
      return false
    end
    log = WorkLog.accessed_by(current_user).find(params[:id])
    log.status= params[:work_log][:status]

    render :text => log.save.to_s
  end

  private

  # Loads the log using the given params
  def load_log
    @log = WorkLog.all_accessed_by(current_user).find(params[:id])
    @task = @log.task
  end

  # Loads the task new logs should be linked to
  def load_task_and_build_log
    @task = current_user.company.tasks.find_by_task_num(params[:task_id])
    @log  = current_user.company.work_logs.build(params[:work_log])
    @log.task = @task
    @log.started_at = Time.now.utc - @log.duration
  end

end
