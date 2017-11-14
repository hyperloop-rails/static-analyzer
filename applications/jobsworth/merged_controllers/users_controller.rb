# encoding: UTF-8
class UsersController < ApplicationController
  before_filter :protected_area, :except=>[:update_seen_news, :avatar, :auto_complete_for_project_name, :auto_complete_for_user_name]

  def index
    @users = User.where("users.company_id = ?", current_user.company_id)
                 .includes(:project_permissions => {:project => :customer})
                 .order("users.name")
                 .paginate(:page => params[:page], :per_page => 100)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 yield(:navigation) 
 @page_title = t("users.access_title", title: Setting.productName) 
 link_to t("users.new_user"), new_user_path, :class => "pull-right" 
 for user in @users 
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
 will_paginate @users 
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
    @user = User.new(params[:user])
    @user.company_id = current_user.company_id
    @user.customer_id = current_user.customer_id if @user.customer_id.blank?
    @user.time_zone = current_user.time_zone
    @user.create_projects = 0
    @user.option_tracktime = 0
    @user.build_work_plan

    render :layout => 'basic'
  end

  def create
    @user = User.new(params[:user])
    @user.company_id = current_user.company_id
    @user.email = params[:email]

    if @user.errors.size > 0
      flash[:error] = @user.errors.full_messages.join(". ")
      return ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 yield(:navigation) 
 @page_title = t("users.new_user_title", title: Setting.productName) 

  @user_ids = []
  @current_user.company.projects.each do |p|
    @user_ids << p.users.collect{ |pu| pu.id }
  end

  @user_ids = [0] if @user_ids.flatten.compact.size == 0
  @users = User.where("id IN (?)", @user_ids.flatten.compact.uniq).order("name").collect{|u| [u.name, u.id.to_s]}

 t("users.new_user") 
 form_tag({:action => 'create'}, :class => "form-horizontal", :multipart => true) do 
 t("users.name") 
 text_field 'user', 'name'  
 t("users.email") 
 text_field_tag 'email', '', :autocomplete => "off" 
 t("users.username") 
 text_field 'user', 'username', :autocomplete => "off" 
 t("users.password") 
 password_field 'user', 'password', :autocomplete => "off"  
 t("users.company") 
 hidden_field_tag("user[customer_id]", @user.customer_id, :id => "user_customer_id", :class => "auto_complete_id") 
 text_field :customer, :name, {:id=>"user_customer_name", :value => @user.customer.try(:name)} 
 @user.customer.nil? ? "#" : "/customers/edit/#{@user.customer.id}" 
 t("users.goto_company") 
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
 
  label_tag t("users.send_welcome_email") 
 check_box_tag :send_welcome_email, "1", params[:send_welcome_email] 
 t('users.welcome_message_header') 
 text_area_tag t("users.welcome_message"), "", :rows => 10, :class => "input-xxlarge", :placeholder => t("users.welcome_message_input") 
 t('users.welcome_message_optional') 
 
 t("permissions.copy_permissions") 
 t("tasks.no_one") 
 options_for_select @users, params[:copy_user].to_i 
 submit_tag t("button.create"), :class => 'btn btn-primary' 
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

    if @user.save
      if params[:copy_user].to_i > 0
        u = current_user.company.users.find(params[:copy_user])
        u.project_permissions.each do |perm|
          p = perm.dup
          p.user = @user
          p.save
        end
      end

      flash[:success] = t('flash.notice.model_created', model: User.model_name.human) +
                        t('hint.user.add_permissions')

      if params[:send_welcome_email]
        begin
          Signup.account_created(@user, current_user, params['welcome_message']).deliver
        rescue
          flash[:error] ||= ""
          flash[:error] += ("<br/>" + t('error.user.send_creation_email')).html_safe
        end
      end

      redirect_to edit_user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(". ")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 yield(:navigation) 
 @page_title = t("users.new_user_title", title: Setting.productName) 

  @user_ids = []
  @current_user.company.projects.each do |p|
    @user_ids << p.users.collect{ |pu| pu.id }
  end

  @user_ids = [0] if @user_ids.flatten.compact.size == 0
  @users = User.where("id IN (?)", @user_ids.flatten.compact.uniq).order("name").collect{|u| [u.name, u.id.to_s]}

 t("users.new_user") 
 form_tag({:action => 'create'}, :class => "form-horizontal", :multipart => true) do 
 t("users.name") 
 text_field 'user', 'name'  
 t("users.email") 
 text_field_tag 'email', '', :autocomplete => "off" 
 t("users.username") 
 text_field 'user', 'username', :autocomplete => "off" 
 t("users.password") 
 password_field 'user', 'password', :autocomplete => "off"  
 t("users.company") 
 hidden_field_tag("user[customer_id]", @user.customer_id, :id => "user_customer_id", :class => "auto_complete_id") 
 text_field :customer, :name, {:id=>"user_customer_name", :value => @user.customer.try(:name)} 
 @user.customer.nil? ? "#" : "/customers/edit/#{@user.customer.id}" 
 t("users.goto_company") 
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
 
  label_tag t("users.send_welcome_email") 
 check_box_tag :send_welcome_email, "1", params[:send_welcome_email] 
 t('users.welcome_message_header') 
 text_area_tag t("users.welcome_message"), "", :rows => 10, :class => "input-xxlarge", :placeholder => t("users.welcome_message_input") 
 t('users.welcome_message_optional') 
 
 t("permissions.copy_permissions") 
 t("tasks.no_one") 
 options_for_select @users, params[:copy_user].to_i 
 submit_tag t("button.create"), :class => 'btn btn-primary' 
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
 yield(:navigation) 
 @page_title = t("users.access_title", title: "#{@user.name} - #{Setting.productName}") 
 content_for :navigation do 
  user.name 
 active_class(selected, "general") 
 edit_user_path(user) 
 t("users.general") 
 if current_user.admin? 
 active_class(selected, "access") 
 access_user_path(user) 
 t("users.access_control") 
 end 
 active_class(selected, "emails") 
 emails_user_path(user) 
 t("users.email_addresses") 
 active_class(selected, "filters") 
 filters_user_path(user) 
 t("users.task_filters") 
 if current_user.admin? 
 active_class(selected, "projects") 
 projects_user_path(user) 
 t("users.project_permissions") 
 end 
 active_class(selected, "workplan") 
 workplan_user_path(user) 
 t("users.work_plan") 
 
 end 
 @user.name 
 link_to_tasks_filtered_by(t("users.view_tasks"), @user, :class => "btn btn-success pull-right") 
 form_tag(user_path(@user), :method => :put, :class => "form-horizontal", :multipart => true) do 
  t("users.name") 
 text_field 'user', 'name'  
 t("users.username") 
 text_field 'user', 'username', :autocomplete => "off" 
 t("users.password") 
 password_field 'user', 'password', :autocomplete => "off"  
 t("users.company") 
 hidden_field_tag("user[customer_id]", @user.customer_id, :id => "user_customer_id", :class => "auto_complete_id") 
 text_field :customer, :name, {:id=>"user_customer_name", :value => @user.customer.try(:name)} 
 @user.customer.nil? ? "#" : "/customers/edit/#{@user.customer.id}" 
 t("users.goto_company") 
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
 
 if @user.avatar? 
 t("users.current_avatar") 
 tag("img", {:src => @user.avatar_url(25), :border => 0 } ) 
 tag("img", {:src => @user.avatar_url, :border => 0 } ) 
 end 
 t("users.new_avatar") 
 file_field :user, :avatar 
 t 'hint.user.avatar' 
 t("users.language") 
 select 'user', 'locale', I18n.available_locales 
 t("users.location") 
 time_zone_select 'user', 'time_zone', TZInfo::Timezone.all.sort, :model => TZInfo::Timezone 
 t("users.receive_notifications") 
 check_box 'user', 'receive_notifications' 
 t("users.receive_own_notifications") 
 check_box 'user', 'receive_own_notifications' 
 t("users.auto_add_to_customer_tasks", customer: @user.customer.try(:name)) 
 check_box "user", "auto_add_to_customer_tasks" 
 t("users.active") 
 check_box(:user, :active) 
 t("users.private") 
 check_box(:user, :comment_private_by_default)
 t("users.time_format") 
 select 'user', 'time_format', [ ['16:00', '%H:%M'], ['4:00 PM', '%I:%M%p'] ] 
 t("users.date_format") 
 select 'user', 'date_format', [ ['1/21/2007', '%m/%d/%Y'], ['21/1/2007', '%d/%m/%Y'], ['2007-1-21', '%Y-%m-%d'] ] 
 t("users.track_time") 
 check_box 'user', 'option_tracktime' 
 t("users.show_avatars") 
 check_box 'user', 'option_avatars' 
 
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

  def access
    if request.put?
      if current_user.admin?
        flash[:success] = t('flash.notice.model_updated', model: t('users.access_control'))
        @user.set_access_control_attributes(params[:user])
        @user.save!
      end
    end

    if !current_user.admin?
      flash[:error] = t('flash.alert.access_denied_to_model', model: t('users.access_control'))
      redirect_to edit_user_path(@user)
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 yield(:navigation) 
 @page_title = t("users.access_title", title: "#{@user.name} - #{Setting.productName}") 
 content_for :navigation do 
  user.name 
 active_class(selected, "general") 
 edit_user_path(user) 
 t("users.general") 
 if current_user.admin? 
 active_class(selected, "access") 
 access_user_path(user) 
 t("users.access_control") 
 end 
 active_class(selected, "emails") 
 emails_user_path(user) 
 t("users.email_addresses") 
 active_class(selected, "filters") 
 filters_user_path(user) 
 t("users.task_filters") 
 if current_user.admin? 
 active_class(selected, "projects") 
 projects_user_path(user) 
 t("users.project_permissions") 
 end 
 active_class(selected, "workplan") 
 workplan_user_path(user) 
 t("users.work_plan") 
 
 end 
 @user.name 
 link_to_tasks_filtered_by(t("users.view_tasks"), @user, :class => "btn btn-success pull-right") 
 form_tag(access_user_path(@user), :method => :put, :class => "form-horizontal") do 
 t("permissions.administrator") 
 check_box 'user', 'admin' 
 t("permissions.create_projects") 
 check_box 'user', 'create_projects' 
 t("permissions.read_clients") 
 check_box(:user, :read_clients) 
 t("permissions.create_clients")  
 check_box(:user, :create_clients) 
 t("permissions.edit_clients") 
 check_box(:user, :edit_clients) 
 t("permissions.approve_work_logs") 
 check_box(:user, :can_approve_work_logs) 
 t("permissions.use_resources") 
 check_box 'user', 'use_resources' 
label(:user, :access_level_id, t("permissions.comment_access_level")) 
select :user, :access_level_id, AccessLevel.all.collect{|al| [al.name, al.id]}
 if @user.autologin && !@user.autologin.empty? 
 t("users.widget_key") 
 @user.autologin 
 end 
 submit_tag t("button.save"), :class => 'btn btn-primary' 
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

  def emails
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 yield(:navigation) 
 @page_title = t("users.access_title", title: "#{@user.name} - #{Setting.productName}") 
 content_for :navigation do 
  user.name 
 active_class(selected, "general") 
 edit_user_path(user) 
 t("users.general") 
 if current_user.admin? 
 active_class(selected, "access") 
 access_user_path(user) 
 t("users.access_control") 
 end 
 active_class(selected, "emails") 
 emails_user_path(user) 
 t("users.email_addresses") 
 active_class(selected, "filters") 
 filters_user_path(user) 
 t("users.task_filters") 
 if current_user.admin? 
 active_class(selected, "projects") 
 projects_user_path(user) 
 t("users.project_permissions") 
 end 
 active_class(selected, "workplan") 
 workplan_user_path(user) 
 t("users.work_plan") 
 
 end 
 @user.name 
 link_to_tasks_filtered_by(t("users.view_tasks"), @user, :class => "btn btn-success pull-right") 
 render @user.email_addresses 
 t("button.add") 
 @user.id 
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

  def tasks
    redirect_to [:workplan, @user]
  end

  def filters
    @private_filters = @user.private_task_filters.order("task_filters.name")
    @shared_filters = @user.shared_task_filters.order("task_filters.name")
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 yield(:navigation) 
 content_for :navigation do 
  user.name 
 active_class(selected, "general") 
 edit_user_path(user) 
 t("users.general") 
 if current_user.admin? 
 active_class(selected, "access") 
 access_user_path(user) 
 t("users.access_control") 
 end 
 active_class(selected, "emails") 
 emails_user_path(user) 
 t("users.email_addresses") 
 active_class(selected, "filters") 
 filters_user_path(user) 
 t("users.task_filters") 
 if current_user.admin? 
 active_class(selected, "projects") 
 projects_user_path(user) 
 t("users.project_permissions") 
 end 
 active_class(selected, "workplan") 
 workplan_user_path(user) 
 t("users.work_plan") 
 
 end 
 @user.name 
 link_to_tasks_filtered_by(t("users.view_tasks"), @user, :class => "btn btn-success pull-right") 
 if @shared_filters.size > 0 
 @shared_filters.each do |tf| 
 tf.id 
 select_task_filter_link(tf) 
 tf.user.name 
 link_to_toggle_status(tf, current_user) 
 if tf.user == current_user or current_user.admin? 
 link_to t("button.delete"), "#", {:class => "action_filter do_delete"} 
 end 
 end 
 end 
 t("users.no_shared_filters") if @shared_filters.size == 0 
 if @private_filters.size > 0 
 @private_filters.each do |tf| 
 tf.id 
 select_task_filter_link(tf) 
 t 'task_filters.shared' if tf.shared? 
 link_to_toggle_status(tf, current_user) 
 if tf.user == current_user or current_user.admin? 
 link_to t("button.delete"), "#", {:class => "action_filter do_delete"} 
 end 
 end 
 end 
 t("users.no_filters") if @private_filters.size == 0 
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

  def projects
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 yield(:navigation) 
 @page_title = t("users.access_title", title: Setting.productName) 
 content_for :navigation do 
  user.name 
 active_class(selected, "general") 
 edit_user_path(user) 
 t("users.general") 
 if current_user.admin? 
 active_class(selected, "access") 
 access_user_path(user) 
 t("users.access_control") 
 end 
 active_class(selected, "emails") 
 emails_user_path(user) 
 t("users.email_addresses") 
 active_class(selected, "filters") 
 filters_user_path(user) 
 t("users.task_filters") 
 if current_user.admin? 
 active_class(selected, "projects") 
 projects_user_path(user) 
 t("users.project_permissions") 
 end 
 active_class(selected, "workplan") 
 workplan_user_path(user) 
 t("users.work_plan") 
 
 end 
 @user.name 
 link_to_tasks_filtered_by(t("users.new_user"), @user, :class => "btn btn-success pull-right") 
  t("users.project") 
 t("permissions.read") 
 t("permissions.comment") 
 t("permissions.work") 
 t("permissions.close") 
 t("permissions.see_unwatched") 
 t("permissions.create") 
 t("permissions.edit") 
 t("permissions.assign") 
 t("permissions.milestones") 
 t("permissions.reports") 
 t("permissions.grant") 
 t("permissions.all") 
  project.dom_id 
 if user_edit 
 link_to project.name, "/projects/edit/#{project.id}" 
 else 
 link_to @user.name, "/users/edit/#{@user.id}" 
 end 

   perm = @user.project_permissions.where("project_id=?", project.id).first
   perms = ProjectPermission.permissions
 if current_user.admin? and perm 
 link_to_function image_tag("tick.png", :title => t("users.remove_all_access", user: escape_twice(@user.name)).html_safe),
              "jQuery.ajax({url: '#{url_for(:controller => 'projects', :action => 'ajax_remove_permission', :user_id => @user.id, :id => project.id, :user_edit => user_edit)}',
               success: function(response){ jQuery('#permission_list').html(response); }
               })" 
 for p in perms 
 link_to_function image_tag("tick.png", :title => t("users.remove_all_access", user: escape_twice(@user.name)).html_safe),
              "jQuery.ajax({url: '#{url_for(:controller => 'projects', :action => 'ajax_remove_permission', :user_id => @user.id, :id => project.id, :perm => p, :user_edit => user_edit )}',
               success: function(response){ jQuery('#permission_list').html(response); }
               })" if perm.can?(p) 
 link_to_function image_tag("delete.png", :title => t("users.grant_access", access: p, user: escape_twice(@user.name)).html_safe),
              "jQuery.ajax({url: '#{url_for(:controller => 'projects', :action => 'ajax_add_permission', :user_id => @user.id, :id => project.id, :perm => p, :user_edit => user_edit )}',
               success: function(response){ jQuery('#permission_list').html(response); }
               })" unless perm.can?(p) 
 end 
 end 
 
 if @user.active 
 t("users.add_project_to_user") 
 text_field :project, :name, {:id => "user_project_name_autocomplete", :value => "" }
 end 
 @user.id 
 
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

  def workplan
    @user_recent_work_logs = @user.work_logs.order(:started_at).reverse_order.includes(:task).limit(10)
    if request.put?
      if @user.work_plan.update_attributes(params[:user][:work_plan_attributes])
        flash[:success] = t('flash.notice.model_updated', model: WorkPlan.model_name.human)
      else
        flash[:error] = @user.work_plan.errors.full_messages.join(', ')
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 yield(:navigation) 
 @page_title = "User : #{@user.name} - #{Setting.productName}" 
 content_for :navigation do 
  user.name 
 active_class(selected, "general") 
 edit_user_path(user) 
 t("users.general") 
 if current_user.admin? 
 active_class(selected, "access") 
 access_user_path(user) 
 t("users.access_control") 
 end 
 active_class(selected, "emails") 
 emails_user_path(user) 
 t("users.email_addresses") 
 active_class(selected, "filters") 
 filters_user_path(user) 
 t("users.task_filters") 
 if current_user.admin? 
 active_class(selected, "projects") 
 projects_user_path(user) 
 t("users.project_permissions") 
 end 
 active_class(selected, "workplan") 
 workplan_user_path(user) 
 t("users.work_plan") 
 
 end 
 @user.name 
 link_to_tasks_filtered_by(t("users.new_user"), @user, :class => "btn btn-success pull-right") 
  t("users.recent_work") 
 @user_recent_work_logs.each do |wl| 
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
 t("users.next_tasks") 
 @user.schedule_tasks(:limit => 20, :save => false) do |task| 
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
 if @user.tasks.open_only.not_snoozed.count > 20 
 t("tasks.more_tasks") 
 end 
 
 form_tag(workplan_user_path(@user), :method => :put, :class => "form-horizontal") do 
 t("users.work_plan") 
  fields_for("user[work_plan_attributes]", @user.work_plan) do |f| 
 t("shared.monday_short") 
 t("shared.tuesday_short") 
 t("shared.wednesday_short") 
 t("shared.thursday_short") 
 t("shared.friday_short") 
 t("shared.saturday_short") 
 t("shared.sunday_short") 
 f.text_field 'monday', :class => "input-tiny" 
 f.text_field 'tuesday', :class => "input-tiny" 
 f.text_field 'wednesday', :class => "input-tiny"  
 f.text_field 'thursday', :class => "input-tiny"  
 f.text_field 'friday', :class => "input-tiny"  
 f.text_field 'saturday', :class => "input-tiny"  
 f.text_field 'sunday', :class => "input-tiny"  
 end 
 
 submit_tag t("button.update"), :class => 'btn btn-primary' 
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
    @user = User.where("company_id = ?", current_user.company_id).find(params[:id])

    if @user.update_attributes(params[:user].except(:admin))
      flash[:success] = t('flash.notice.model_updated', model: User.model_name.human)
      redirect_to edit_user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(". ")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = t("users.access_title", title: "#{@user.name} - #{Setting.productName}") 
 content_for :navigation do 
  user.name 
 active_class(selected, "general") 
 edit_user_path(user) 
 t("users.general") 
 if current_user.admin? 
 active_class(selected, "access") 
 access_user_path(user) 
 t("users.access_control") 
 end 
 active_class(selected, "emails") 
 emails_user_path(user) 
 t("users.email_addresses") 
 active_class(selected, "filters") 
 filters_user_path(user) 
 t("users.task_filters") 
 if current_user.admin? 
 active_class(selected, "projects") 
 projects_user_path(user) 
 t("users.project_permissions") 
 end 
 active_class(selected, "workplan") 
 workplan_user_path(user) 
 t("users.work_plan") 
 
 end 
 @user.name 
 link_to_tasks_filtered_by(t("users.view_tasks"), @user, :class => "btn btn-success pull-right") 
 form_tag(user_path(@user), :method => :put, :class => "form-horizontal", :multipart => true) do 
  t("users.name") 
 text_field 'user', 'name'  
 t("users.username") 
 text_field 'user', 'username', :autocomplete => "off" 
 t("users.password") 
 password_field 'user', 'password', :autocomplete => "off"  
 t("users.company") 
 hidden_field_tag("user[customer_id]", @user.customer_id, :id => "user_customer_id", :class => "auto_complete_id") 
 text_field :customer, :name, {:id=>"user_customer_name", :value => @user.customer.try(:name)} 
 @user.customer.nil? ? "#" : "/customers/edit/#{@user.customer.id}" 
 t("users.goto_company") 
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
 
 if @user.avatar? 
 t("users.current_avatar") 
 tag("img", {:src => @user.avatar_url(25), :border => 0 } ) 
 tag("img", {:src => @user.avatar_url, :border => 0 } ) 
 end 
 t("users.new_avatar") 
 file_field :user, :avatar 
 t 'hint.user.avatar' 
 t("users.language") 
 select 'user', 'locale', I18n.available_locales 
 t("users.location") 
 time_zone_select 'user', 'time_zone', TZInfo::Timezone.all.sort, :model => TZInfo::Timezone 
 t("users.receive_notifications") 
 check_box 'user', 'receive_notifications' 
 t("users.receive_own_notifications") 
 check_box 'user', 'receive_own_notifications' 
 t("users.auto_add_to_customer_tasks", customer: @user.customer.try(:name)) 
 check_box "user", "auto_add_to_customer_tasks" 
 t("users.active") 
 check_box(:user, :active) 
 t("users.private") 
 check_box(:user, :comment_private_by_default)
 t("users.time_format") 
 select 'user', 'time_format', [ ['16:00', '%H:%M'], ['4:00 PM', '%I:%M%p'] ] 
 t("users.date_format") 
 select 'user', 'date_format', [ ['1/21/2007', '%m/%d/%Y'], ['21/1/2007', '%d/%m/%Y'], ['2007-1-21', '%Y-%m-%d'] ] 
 t("users.track_time") 
 check_box 'user', 'option_tracktime' 
 t("users.show_avatars") 
 check_box 'user', 'option_avatars' 
 
 end 

end

    end
  end

  def destroy
    if current_user.id == params[:id].to_i
      flash[:error] = t('error.user.delete_self')
      redirect_to(:controller => "customers", :action => 'index')
      return
    end

    @user = User.where("company_id = ?", current_user.company_id).find(params[:id])
    if @user.destroy
      flash[:success] = t('flash.notice.model_deleted', model: @user.name)
    else
      flash[:error] = @user.errors.full_messages.join(' ')
    end

    if @user.customer
      redirect_to edit_customer_path(@user.customer)
    else
      redirect_to root_path
    end
  end

  def update_seen_news
    if request.xhr?
      @user = current_user
      unless @user.nil?
        @user.seen_news_id = params[:id]
        @user.save
      end
    end
    render :nothing => true
  end

  def avatar
    @user = User.find(params[:id])
    unless @user.avatar?
      render :nothing => true
      return
    end
    if params[:large]
      send_file @user.avatar_large_path, :filename => "avatar", :type => 'image/jpeg', :disposition => 'inline'
    else
      send_file @user.avatar_path, :filename => "avatar", :type => 'image/jpeg', :disposition => 'inline'
    end
  end

  def auto_complete_for_project_name
    text = params[:term]
    if text.blank?
      return render :nothing => true
    end

    @projects = current_user.company.projects.where("lower(name) like ?", "%#{ text }%")

    if params[:user_id]
      user = User.find_by_id(params[:user_id])
      @projects = @projects - user.projects if user
    end

    render :json => @projects.collect{|project| {:value => project.name, :id=> project.id} }.to_json
  end

  def project
    @user = current_user.company.users.active.find(params[:id])

    project = current_user.company.projects.find(params[:project_id])

    ProjectPermission.create(:user => @user, :company => @user.company, :project => project)

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 yield(:navigation) 
 project.dom_id 
 if user_edit 
 link_to project.name, "/projects/edit/#{project.id}" 
 else 
 link_to @user.name, "/users/edit/#{@user.id}" 
 end 

   perm = @user.project_permissions.where("project_id=?", project.id).first
   perms = ProjectPermission.permissions
 if current_user.admin? and perm 
 link_to_function image_tag("tick.png", :title => t("users.remove_all_access", user: escape_twice(@user.name)).html_safe),
              "jQuery.ajax({url: '#{url_for(:controller => 'projects', :action => 'ajax_remove_permission', :user_id => @user.id, :id => project.id, :user_edit => user_edit)}',
               success: function(response){ jQuery('#permission_list').html(response); }
               })" 
 for p in perms 
 link_to_function image_tag("tick.png", :title => t("users.remove_all_access", user: escape_twice(@user.name)).html_safe),
              "jQuery.ajax({url: '#{url_for(:controller => 'projects', :action => 'ajax_remove_permission', :user_id => @user.id, :id => project.id, :perm => p, :user_edit => user_edit )}',
               success: function(response){ jQuery('#permission_list').html(response); }
               })" if perm.can?(p) 
 link_to_function image_tag("delete.png", :title => t("users.grant_access", access: p, user: escape_twice(@user.name)).html_safe),
              "jQuery.ajax({url: '#{url_for(:controller => 'projects', :action => 'ajax_add_permission', :user_id => @user.id, :id => project.id, :perm => p, :user_edit => user_edit )}',
               success: function(response){ jQuery('#permission_list').html(response); }
               })" unless perm.can?(p) 
 end 
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

  def auto_complete_for_user_name
    if (term = params[:term]).present?
      # the next line searches for names starting with given text OR surname (space started) starting with text of the active users
      @users = current_user.company.users.active.search_by_name(term).limit(50)

      if params[:project_id]
        project = Project.find_by_id(params[:project_id])
        @users = @users - project.users if project
      end

      render :json=> @users.collect{|user| {:value => user.to_s, :id=> user.id} }.to_json
    else
      render :nothing=> true
    end
  end

private
  def protected_area
    @user = User.where("company_id = ?", current_user.company_id).find_by_id(params[:id]) if params[:id]

    if Setting.contact_creation_allowed
      unless current_user.admin? or current_user.edit_clients? or current_user == @user
        flash[:error] = t('flash.alert.admin_permission_needed')
        redirect_to edit_user_path(current_user)
        return false
      end
    else
      unless current_user == @user
        redirect_to edit_user_path(current_user), alert: t('flash.alert.access_denied')
        return false
      end
    end
    true
  end

end
