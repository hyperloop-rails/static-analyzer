# encoding: UTF-8
# Handle CRUD dealing with Customers

class CustomersController < ApplicationController
  before_filter :authorize_user_can_create_customers, :only => [:new, :create]
  before_filter :authorize_user_can_edit_customers,   :only => [:edit, :update, :destroy]
  before_filter :authorize_user_can_read_customers,   :only => [:show]

  def show
    @customer = Customer.from_company(current_user.company_id).find(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
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

  def new
    @customer = current_user.company.customers.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = "#{t('customers.new')} - #{Setting.productName}" 
 form_for(@customer, :html => {:class => "form-horizontal"}) do |f| 
 t('customers.new') 
  if !@customer.internal_customer? 
 f.label :name 
 f.text_field 'name'  
 end 
 f.label :contact_name 
 f.text_field 'contact_name' 
 f.label :active 
 check_box(:customer, :active) 
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
 
 
 submit_tag t("button.create"), :class => "btn btn-primary" 
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
    @customer         = Customer.new(params[:customer])
    @customer.company = current_user.company

    if @customer.save
      redirect_to root_path, notice: t('flash.notice.model_created', model: Customer.model_name.human)
    else
      flash[:error] = @customer.errors.full_messages.join(".")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = "#{t('customers.new')} - #{Setting.productName}" 
 form_for(@customer, :html => {:class => "form-horizontal"}) do |f| 
 t('customers.new') 
  if !@customer.internal_customer? 
 f.label :name 
 f.text_field 'name'  
 end 
 f.label :contact_name 
 f.text_field 'contact_name' 
 f.label :active 
 check_box(:customer, :active) 
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
 
 
 submit_tag t("button.create"), :class => "btn btn-primary" 
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
    @customer = Customer.from_company(current_user.company_id).where(:id => params[:id]).includes(:projects).first
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = "Customer : #{@customer.name} - #{Setting.productName}" 
 form_for(@customer, :html => {:class => "form-horizontal"}) do |f| 
 link_to_tasks_filtered_by(t("customers.view_tasks"), @customer, :class => "btn btn-success pull-right") 
 @customer.name 
  if !@customer.internal_customer? 
 f.label :name 
 f.text_field 'name'  
 end 
 f.label :contact_name 
 f.text_field 'contact_name' 
 f.label :active 
 check_box(:customer, :active) 
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
 
 
 submit_tag t("button.save"), :class => "btn btn-primary" 
 if current_user.admin?
 link_to t("button.delete"), customer_path(@customer), :method => "delete", :confirm => "Really delete #{@customer.name}?", :class => "btn btn-mini btn-danger pull-right" 
 end 
 end 
 t("customers.view_tasks") 
 create_users_link(@customer) 
 link_to(t("customers.create_site"), new_organizational_unit_path(:customer_id => @customer.id)) 
 if current_user.use_resources? 
 link_to(t("customers.create_resource"), new_resource_path(:customer_id => @customer.id)) 
 end 
 t("customers.active_users") 
 t("customers.inactive_users") 
 t("customers.current_projects") 
 t("customers.completed_projects") 
 if current_user.company.use_score_rules? 
 t("customers.score_rules") 
 end 
 t("customers.sites") 
 if current_user.use_resources? 
 t("customers.resources") 
 end 
 t("customers.services") 
 for user in @customer.users.active 
  link_to(user.name, "/users/edit/#{user.id}") 
 t("users.email") 
 h user.email 
 h user.email 
 t("users.last_login") 
 if user.last_sign_in_at 
 t("shared.time_ago", time: distance_of_time_in_words(user.last_sign_in_at, Time.now.utc)) 
 else 
 t("shared.never") 
 end 
 
  values = object.all_custom_attribute_values
  values.each do |value|
    if (value.value)

 value.custom_attribute.display_name 
 value.value.gsub("\n", "<br/>").html_safe 
 end 
 end 
 
 if user.projects.size > 0 
 t("users.projects") 
 link_to_function t("users.n_projects", n: user.projects.size), "jQuery('#projects-#{user.dom_id}').toggle();" 
user.dom_id
 user.projects.collect{|project| link_to_tasks_filtered_by(project.full_name, project)}.join("<br/> ").html_safe 
 end 
end 
 for user in @customer.users.where(:active => false) 
  link_to(user.name, "/users/edit/#{user.id}") 
 t("users.email") 
 h user.email 
 h user.email 
 t("users.last_login") 
 if user.last_sign_in_at 
 t("shared.time_ago", time: distance_of_time_in_words(user.last_sign_in_at, Time.now.utc)) 
 else 
 t("shared.never") 
 end 
 
  values = object.all_custom_attribute_values
  values.each do |value|
    if (value.value)

 value.custom_attribute.display_name 
 value.value.gsub("\n", "<br/>").html_safe 
 end 
 end 
 
 if user.projects.size > 0 
 t("users.projects") 
 link_to_function t("users.n_projects", n: user.projects.size), "jQuery('#projects-#{user.dom_id}').toggle();" 
user.dom_id
 user.projects.collect{|project| link_to_tasks_filtered_by(project.full_name, project)}.join("<br/> ").html_safe 
 end 
end 
 if current_user.company.use_score_rules? 
 container_name 
 container_id 
 
 end 
 for @org_unit in @customer.organizational_units.active 
 link_to(@org_unit, edit_organizational_unit_path(@org_unit)) 
 end 
  service_level_agreement.id 
 link_to service_level_agreement.customer.name, edit_customer_path(service_level_agreement.customer) 
 link_to service_level_agreement.service.name, edit_service_path(service_level_agreement.service) 
 check_box_tag "billable", true, service_level_agreement.billable 
 t("service_level_agreements.billable") 
 image_tag("indicator.gif ", :class => "ajax hide")
 t("service_level_agreements.saved") 
 link_to "#", :class => "delete" do 
 end 
 
 if current_user.use_resources? 
 resources_without_parents(@customer.resources).each do |r| 
  
   style = "margin-left: #{ depth * 24 }px" 
   class_name = depth > 0 ? "child depth_#{ depth }" : ""

 class_name 
 style 
 link_to resource.name, edit_resource_path(resource) 
 child_resources(resource, @resources).each do |r| 
  
   style = "margin-left: #{ depth * 24 }px" 
   class_name = depth > 0 ? "child depth_#{ depth }" : ""

 class_name 
 style 
 link_to resource.name, edit_resource_path(resource) 
 child_resources(resource, @resources).each do |r| 
  
   style = "margin-left: #{ depth * 24 }px" 
   class_name = depth > 0 ? "child depth_#{ depth }" : ""

 class_name 
 style 
 link_to resource.name, edit_resource_path(resource) 
 child_resources(resource, @resources).each do |r| 
  
   style = "margin-left: #{ depth * 24 }px" 
   class_name = depth > 0 ? "child depth_#{ depth }" : ""

 class_name 
 style 
 link_to resource.name, edit_resource_path(resource) 
 child_resources(resource, @resources).each do |r| 
 render(:partial => "resource", 
  :locals => { :resource => r, :depth => depth + 1 }) 
 end 
 
 end 
 
 end 
 
 end 
 
 end 
 end 
 if @customer.projects.in_progress.size > 0 
  link_to_tasks_filtered_by project, :class => "pull-left name" 
 number_to_percentage(project.progress, :precision => 0) 
 if current_user.can?(project, 'grant') || current_user.can?(project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, { :controller => 'projects', :action => 'edit', :id => project },
        :class => "pull-left hide action", :rel => "tooltip", :title => t("projects.edit_project_html", project: escape_twice(project.name)) 
 end 
 if current_user.can?(project, 'see_unwatched') 
 link_to '<i class="icon-list-alt"></i>'.html_safe, { :controller => 'projects', :action => 'show', :id => project },
        :class => "pull-left hide action", :rel => "tooltip", :title => t("projects.view_project_html", project: escape_twice(project.name)) 
 end 
 for milestone in project.milestones.active.scheduled.order("due_at, milestones.name").includes(:user) 
  milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  
end 
 for milestone in project.milestones.active.unscheduled.order("due_at, milestones.name").includes(:user) 
  milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  
end 
 if project.completed_milestones_count > 0 
 t("projects.n_completed_milestones", n: project.completed_milestones_count) 
 end
 
 else 
 t("customers.no_project_in_process") 
 end 
 if @customer.projects.completed.size > 0 
  link_to_tasks_filtered_by project, :class => "pull-left name" 
 number_to_percentage(project.progress, :precision => 0) 
 if current_user.can?(project, 'grant') || current_user.can?(project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, { :controller => 'projects', :action => 'edit', :id => project },
        :class => "pull-left hide action", :rel => "tooltip", :title => t("projects.edit_project_html", project: escape_twice(project.name)) 
 end 
 if current_user.can?(project, 'see_unwatched') 
 link_to '<i class="icon-list-alt"></i>'.html_safe, { :controller => 'projects', :action => 'show', :id => project },
        :class => "pull-left hide action", :rel => "tooltip", :title => t("projects.view_project_html", project: escape_twice(project.name)) 
 end 
 for milestone in project.milestones.active.scheduled.order("due_at, milestones.name").includes(:user) 
  milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  
end 
 for milestone in project.milestones.active.unscheduled.order("due_at, milestones.name").includes(:user) 
  milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  
end 
 if project.completed_milestones_count > 0 
 t("projects.n_completed_milestones", n: project.completed_milestones_count) 
 end
 
 else 
 t("customers.no_project_completed") 
 end 
 @customer.id 
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
    @customer = Customer.from_company(current_user.company_id).find(params[:id])

    if @customer.update_attributes(params[:customer])
      flash[:success] = t('flash.notice.model_updated', model: Customer.model_name.human)
      redirect_to :action => :edit, :id => @customer.id
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @page_title = "Customer : #{@customer.name} - #{Setting.productName}" 
 form_for(@customer, :html => {:class => "form-horizontal"}) do |f| 
 link_to_tasks_filtered_by(t("customers.view_tasks"), @customer, :class => "btn btn-success pull-right") 
 @customer.name 
  if !@customer.internal_customer? 
 f.label :name 
 f.text_field 'name'  
 end 
 f.label :contact_name 
 f.text_field 'contact_name' 
 f.label :active 
 check_box(:customer, :active) 
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
 
 
 submit_tag t("button.save"), :class => "btn btn-primary" 
 if current_user.admin?
 link_to t("button.delete"), customer_path(@customer), :method => "delete", :confirm => "Really delete #{@customer.name}?", :class => "btn btn-mini btn-danger pull-right" 
 end 
 end 
 t("customers.view_tasks") 
 create_users_link(@customer) 
 link_to(t("customers.create_site"), new_organizational_unit_path(:customer_id => @customer.id)) 
 if current_user.use_resources? 
 link_to(t("customers.create_resource"), new_resource_path(:customer_id => @customer.id)) 
 end 
 t("customers.active_users") 
 t("customers.inactive_users") 
 t("customers.current_projects") 
 t("customers.completed_projects") 
 if current_user.company.use_score_rules? 
 t("customers.score_rules") 
 end 
 t("customers.sites") 
 if current_user.use_resources? 
 t("customers.resources") 
 end 
 t("customers.services") 
 for user in @customer.users.active 
  link_to(user.name, "/users/edit/#{user.id}") 
 t("users.email") 
 h user.email 
 h user.email 
 t("users.last_login") 
 if user.last_sign_in_at 
 t("shared.time_ago", time: distance_of_time_in_words(user.last_sign_in_at, Time.now.utc)) 
 else 
 t("shared.never") 
 end 
 
  values = object.all_custom_attribute_values
  values.each do |value|
    if (value.value)

 value.custom_attribute.display_name 
 value.value.gsub("\n", "<br/>").html_safe 
 end 
 end 
 
 if user.projects.size > 0 
 t("users.projects") 
 link_to_function t("users.n_projects", n: user.projects.size), "jQuery('#projects-#{user.dom_id}').toggle();" 
user.dom_id
 user.projects.collect{|project| link_to_tasks_filtered_by(project.full_name, project)}.join("<br/> ").html_safe 
 end 
end 
 for user in @customer.users.where(:active => false) 
  link_to(user.name, "/users/edit/#{user.id}") 
 t("users.email") 
 h user.email 
 h user.email 
 t("users.last_login") 
 if user.last_sign_in_at 
 t("shared.time_ago", time: distance_of_time_in_words(user.last_sign_in_at, Time.now.utc)) 
 else 
 t("shared.never") 
 end 
 
  values = object.all_custom_attribute_values
  values.each do |value|
    if (value.value)

 value.custom_attribute.display_name 
 value.value.gsub("\n", "<br/>").html_safe 
 end 
 end 
 
 if user.projects.size > 0 
 t("users.projects") 
 link_to_function t("users.n_projects", n: user.projects.size), "jQuery('#projects-#{user.dom_id}').toggle();" 
user.dom_id
 user.projects.collect{|project| link_to_tasks_filtered_by(project.full_name, project)}.join("<br/> ").html_safe 
 end 
end 
 if current_user.company.use_score_rules? 
 container_name 
 container_id 
 
 end 
 for @org_unit in @customer.organizational_units.active 
 link_to(@org_unit, edit_organizational_unit_path(@org_unit)) 
 end 
  service_level_agreement.id 
 link_to service_level_agreement.customer.name, edit_customer_path(service_level_agreement.customer) 
 link_to service_level_agreement.service.name, edit_service_path(service_level_agreement.service) 
 check_box_tag "billable", true, service_level_agreement.billable 
 t("service_level_agreements.billable") 
 image_tag("indicator.gif ", :class => "ajax hide")
 t("service_level_agreements.saved") 
 link_to "#", :class => "delete" do 
 end 
 
 if current_user.use_resources? 
 resources_without_parents(@customer.resources).each do |r| 
  
   style = "margin-left: #{ depth * 24 }px" 
   class_name = depth > 0 ? "child depth_#{ depth }" : ""

 class_name 
 style 
 link_to resource.name, edit_resource_path(resource) 
 child_resources(resource, @resources).each do |r| 
  
   style = "margin-left: #{ depth * 24 }px" 
   class_name = depth > 0 ? "child depth_#{ depth }" : ""

 class_name 
 style 
 link_to resource.name, edit_resource_path(resource) 
 child_resources(resource, @resources).each do |r| 
  
   style = "margin-left: #{ depth * 24 }px" 
   class_name = depth > 0 ? "child depth_#{ depth }" : ""

 class_name 
 style 
 link_to resource.name, edit_resource_path(resource) 
 child_resources(resource, @resources).each do |r| 
  
   style = "margin-left: #{ depth * 24 }px" 
   class_name = depth > 0 ? "child depth_#{ depth }" : ""

 class_name 
 style 
 link_to resource.name, edit_resource_path(resource) 
 child_resources(resource, @resources).each do |r| 
 render(:partial => "resource", 
  :locals => { :resource => r, :depth => depth + 1 }) 
 end 
 
 end 
 
 end 
 
 end 
 
 end 
 end 
 if @customer.projects.in_progress.size > 0 
  link_to_tasks_filtered_by project, :class => "pull-left name" 
 number_to_percentage(project.progress, :precision => 0) 
 if current_user.can?(project, 'grant') || current_user.can?(project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, { :controller => 'projects', :action => 'edit', :id => project },
        :class => "pull-left hide action", :rel => "tooltip", :title => t("projects.edit_project_html", project: escape_twice(project.name)) 
 end 
 if current_user.can?(project, 'see_unwatched') 
 link_to '<i class="icon-list-alt"></i>'.html_safe, { :controller => 'projects', :action => 'show', :id => project },
        :class => "pull-left hide action", :rel => "tooltip", :title => t("projects.view_project_html", project: escape_twice(project.name)) 
 end 
 for milestone in project.milestones.active.scheduled.order("due_at, milestones.name").includes(:user) 
  milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  
end 
 for milestone in project.milestones.active.unscheduled.order("due_at, milestones.name").includes(:user) 
  milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  
end 
 if project.completed_milestones_count > 0 
 t("projects.n_completed_milestones", n: project.completed_milestones_count) 
 end
 
 else 
 t("customers.no_project_in_process") 
 end 
 if @customer.projects.completed.size > 0 
  link_to_tasks_filtered_by project, :class => "pull-left name" 
 number_to_percentage(project.progress, :precision => 0) 
 if current_user.can?(project, 'grant') || current_user.can?(project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, { :controller => 'projects', :action => 'edit', :id => project },
        :class => "pull-left hide action", :rel => "tooltip", :title => t("projects.edit_project_html", project: escape_twice(project.name)) 
 end 
 if current_user.can?(project, 'see_unwatched') 
 link_to '<i class="icon-list-alt"></i>'.html_safe, { :controller => 'projects', :action => 'show', :id => project },
        :class => "pull-left hide action", :rel => "tooltip", :title => t("projects.view_project_html", project: escape_twice(project.name)) 
 end 
 for milestone in project.milestones.active.scheduled.order("due_at, milestones.name").includes(:user) 
  milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  
end 
 for milestone in project.milestones.active.unscheduled.order("due_at, milestones.name").includes(:user) 
  milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  
end 
 if project.completed_milestones_count > 0 
 t("projects.n_completed_milestones", n: project.completed_milestones_count) 
 end
 
 else 
 t("customers.no_project_completed") 
 end 
 @customer.id 
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
    @customer = Customer.from_company(current_user.company_id).find(params[:id])

    case
    when @customer.has_projects?
      flash[:error] = t('flash.error.destroy_dependents_of_model',
                        dependents: @customer.human_name(:projects),
                        model: @customer.name)

    when @customer == current_company.internal_customer
      flash[:error] = t('error.company.delete_own_company')

    else
      flash[:success] = t('flash.notice.model_deleted', model: Customer.model_name.human)
      @customer.destroy
    end

    redirect_to root_path
  end

  ###
  # Returns the list to use for auto completes for customer names.
  ###
  def auto_complete_for_customer_name
    text = params[:term]
    if !text.blank?
      customer_table = Customer.arel_table
      @customers = current_user.company.customers.order('name').where(customer_table[:name].matches("#{text}%").or(customer_table[:name].matches("%#{text}%"))).limit(50)
      render :json=> @customers.collect{|customer| {:value => customer.name, :id=> customer.id} }.to_json
    else
      render :nothing=> true
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 @customers.each do |c| 
 c.id 
 c 
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

  def search
    search_criteria = params[:term].strip

    @customers = []
    @users = []
    @tasks = []
    @projects = []
    @resources = []
    @limit = 5
    unless search_criteria.blank?
      if search_criteria.to_i > 0

        @tasks = TaskRecord.all_accessed_by(current_user).where(:task_num => search_criteria)
      elsif params[:entity]
        @limit = 100000
        if params[:entity] =~ /user/
          @users = current_user.company.users.where('lower(name) LIKE ?', '%' + search_criteria.downcase + '%').where(:active => true)
        elsif params[:entity] =~ /customer/
          @customers = current_user.company.customers.where('lower(name) LIKE ?', '%' + search_criteria.downcase + '%').where(:active => true)
        elsif params[:entity] =~ /task/
          @tasks = TaskRecord.all_accessed_by(current_user).where('lower(tasks.name) LIKE ?', '%' + search_criteria.downcase + '%').where("tasks.status = 0")
        elsif params[:entity] =~ /resource/
          @resources = current_user.company.resources.where('lower(name) like ?', '%' + search_criteria.downcase + '%') if current_user.use_resources?
        elsif params[:entity] =~ /project/
          @projects = current_user.projects.where('lower(name) like ?', '%' + search_criteria.downcase + '%')
        end
      else
        @customers = current_user.company.customers.where('lower(name) LIKE ?', '%' + search_criteria.downcase + '%').where(:active => true)
        @users = current_user.company.users.where('lower(name) LIKE ?', '%' + search_criteria.downcase + '%').where(:active => true)
        @tasks = TaskRecord.all_accessed_by(current_user).where('lower(tasks.name) LIKE ?', '%' + search_criteria.downcase + '%').where("tasks.status = 0")
        @resources = current_user.company.resources.where('lower(name) like ?', '%' + search_criteria.downcase + '%') if current_user.use_resources?
        @projects = current_user.projects.where('lower(name) like ?', '%' + search_criteria.downcase + '%')
      end
    end

    html = render_to_string :partial => "customers/search_autocomplete", :locals => {:users => @users, :customers => @customers, :tasks => @tasks, :projects => @projects, :resources => @resources, :limit => @limit }
    render :json=> { :success => true, :html => html }
  end

  private

  def authorize_user_can_create_customers
    deny_access unless Setting.contact_creation_allowed && (current_user.admin? || current_user.create_clients?)
  end

  def authorize_user_can_edit_customers
    deny_access unless current_user.admin? || current_user.edit_clients?
  end

  def authorize_user_can_read_customers
    deny_access unless current_user.admin? || current_user.read_clients?
  end

  def deny_access
    flash[:error] = t('flash.alert.access_denied')
    redirect_from_last
  end
end

