#==
# RailsCollab
# Copyright (C) 2007 - 2011 James S Urquhart
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

class TasksController < ApplicationController

  layout 'project_website'
  helper 'project_items'

  before_filter :process_session
  before_filter :grab_list, :except => [:create, :new]
  before_filter :grab_list_required, :only => [:index, :create, :new]
  after_filter  :user_track, :only => [:index, :show]
  
  # GET /tasks
  # GET /tasks.xml
  def index
    respond_to do |format|
      format.html {
        @open_task_lists = @active_project.task_lists.is_open
        @open_task_lists = @open_task_lists.is_public unless @logged_user.member_of_owner?
        @completed_task_lists = @active_project.task_lists.completed
        @completed_task_lists = @completed_task_lists.is_public unless @logged_user.member_of_owner?
        @content_for_sidebar = 'task_lists/index_sidebar'
      }
      format.xml  {
        @tasks = @task_list.tasks
        render :xml => @tasks.to_xml(:root => 'tasks')
      }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    begin
      @task = (@task_list||@active_project).tasks.find(params[:id])
      @task_list ||= @task.task_list
    rescue
      return error_status(true, :invalid_task)
    end
    
    respond_to do |format|
      format.html { }
      format.js { respond_with_task(@task) }
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
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
 form_tag search_project_path(:id => @active_project.id) 

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
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_comment') 
 
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
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
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
 form_tag search_project_path(:id => @active_project.id) 

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
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_comment') 
 
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

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    authorize! :create_task, @task_list
    
    @task = @task_list.tasks.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
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
 form_tag search_project_path(:id => @active_project.id) 

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
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  @page_actions = []
  
  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path}
  end

 form_tag new_task_path(:task_list_id => @task_list.id) do 
  task = form 
 error_messages_for :task, :object => task 
 if not task.new_record? and @no_show_list.nil? 
 task.id 
 t('task_list') 
 select 'task', 'task_list_id', TaskList.select_list(@active_project), {}, :id => "addTaskTaskList#{task.id}" 
 end 
 task.id 
 t('text') 
 text_area 'task', 'text', :id => "addTaskText#{task.id}", :class => 'short autofocus', :rows => 10, :cols => 40  
 task.id 
 t('assign_to') 
 assign_project_select 'task', 'assigned_to_id', @active_project, :id => "taskAssignedTo#{task.id}" 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => "taskSendNotification#{task.id}", :class => 'checkbox'  
 task.id 
 t('send_email_notification_to_user') 
 t('estimated_hours') 
 text_field 'task', 'estimated_hours', :id => 'addTaskHours', :class => 'short' 
 
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
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
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
 form_tag search_project_path(:id => @active_project.id) 

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
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  @page_actions = []
  
  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path}
  end

 form_tag new_task_path(:task_list_id => @task_list.id) do 
  task = form 
 error_messages_for :task, :object => task 
 if not task.new_record? and @no_show_list.nil? 
 task.id 
 t('task_list') 
 select 'task', 'task_list_id', TaskList.select_list(@active_project), {}, :id => "addTaskTaskList#{task.id}" 
 end 
 task.id 
 t('text') 
 text_area 'task', 'text', :id => "addTaskText#{task.id}", :class => 'short autofocus', :rows => 10, :cols => 40  
 task.id 
 t('assign_to') 
 assign_project_select 'task', 'assigned_to_id', @active_project, :id => "taskAssignedTo#{task.id}" 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => "taskSendNotification#{task.id}", :class => 'checkbox'  
 task.id 
 t('send_email_notification_to_user') 
 t('estimated_hours') 
 text_field 'task', 'estimated_hours', :id => 'addTaskHours', :class => 'short' 
 
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

  # GET /tasks/1/edit
  def edit
    begin
      @task = @task_list.tasks.find(params[:id])
    rescue
      return error_status(true, :invalid_task)
    end
    
    authorize! :edit, @task
    
    respond_to do |f|
      f.html
      f.js { respond_with_task(@task, 'ajax_form') }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
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
 form_tag search_project_path(:id => @active_project.id) 

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
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  @page_actions = []
  
  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path}
  end

 form_tag task_path(:task_list_id => @task.task_list_id, :id => @task.id), :method => :put do 
  task = form 
 error_messages_for :task, :object => task 
 if not task.new_record? and @no_show_list.nil? 
 task.id 
 t('task_list') 
 select 'task', 'task_list_id', TaskList.select_list(@active_project), {}, :id => "addTaskTaskList#{task.id}" 
 end 
 task.id 
 t('text') 
 text_area 'task', 'text', :id => "addTaskText#{task.id}", :class => 'short autofocus', :rows => 10, :cols => 40  
 task.id 
 t('assign_to') 
 assign_project_select 'task', 'assigned_to_id', @active_project, :id => "taskAssignedTo#{task.id}" 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => "taskSendNotification#{task.id}", :class => 'checkbox'  
 task.id 
 t('send_email_notification_to_user') 
 t('estimated_hours') 
 text_field 'task', 'estimated_hours', :id => 'addTaskHours', :class => 'short' 
 
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

  # POST /tasks
  # POST /tasks.xml
  def create
    authorize! :create_task, @task_list
    
    @task = @task_list.tasks.build(params[:task])
    @task.created_by = @logged_user
    
    respond_to do |format|
      if @task.save
        Notifier.deliver_task(@task.user, @task) if params[:send_notification] and @task.user
        flash[:notice] = 'ListItem was successfully created.'
        format.html { redirect_back_or_default(task_lists_path) }
        format.js { respond_with_task(@task) }
        format.xml  { render :xml => @task.to_xml(:root => 'task'), :status => :created, :location => @task }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
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
 form_tag search_project_path(:id => @active_project.id) 

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
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  @page_actions = []
  
  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path}
  end

 form_tag new_task_path(:task_list_id => @task_list.id) do 
  task = form 
 error_messages_for :task, :object => task 
 if not task.new_record? and @no_show_list.nil? 
 task.id 
 t('task_list') 
 select 'task', 'task_list_id', TaskList.select_list(@active_project), {}, :id => "addTaskTaskList#{task.id}" 
 end 
 task.id 
 t('text') 
 text_area 'task', 'text', :id => "addTaskText#{task.id}", :class => 'short autofocus', :rows => 10, :cols => 40  
 task.id 
 t('assign_to') 
 assign_project_select 'task', 'assigned_to_id', @active_project, :id => "taskAssignedTo#{task.id}" 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => "taskSendNotification#{task.id}", :class => 'checkbox'  
 task.id 
 t('send_email_notification_to_user') 
 t('estimated_hours') 
 text_field 'task', 'estimated_hours', :id => 'addTaskHours', :class => 'short' 
 
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
 }
        format.js { respond_with_task(@task) }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    begin
      @task = @task_list.tasks.find(params[:id])
    rescue
      return error_status(true, :invalid_task)
    end
    
    authorize! :edit, @task
    
    @task.updated_by = @logged_user

    respond_to do |format|
      if @task.update_attributes(params[:task])
        Notifier.deliver_task(@task.user, @task) if params[:send_notification] and @task.user
        flash[:notice] = 'ListItem was successfully updated.'
        format.html { redirect_back_or_default(task_lists_path) }
        format.js { respond_with_task(@task) }
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
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
 form_tag search_project_path(:id => @active_project.id) 

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
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  @page_actions = []
  
  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path}
  end

 form_tag task_path(:task_list_id => @task.task_list_id, :id => @task.id), :method => :put do 
  task = form 
 error_messages_for :task, :object => task 
 if not task.new_record? and @no_show_list.nil? 
 task.id 
 t('task_list') 
 select 'task', 'task_list_id', TaskList.select_list(@active_project), {}, :id => "addTaskTaskList#{task.id}" 
 end 
 task.id 
 t('text') 
 text_area 'task', 'text', :id => "addTaskText#{task.id}", :class => 'short autofocus', :rows => 10, :cols => 40  
 task.id 
 t('assign_to') 
 assign_project_select 'task', 'assigned_to_id', @active_project, :id => "taskAssignedTo#{task.id}" 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => "taskSendNotification#{task.id}", :class => 'checkbox'  
 task.id 
 t('send_email_notification_to_user') 
 t('estimated_hours') 
 text_field 'task', 'estimated_hours', :id => 'addTaskHours', :class => 'short' 
 
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
 }
        format.js { respond_with_task(@task) }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    begin
      @task = @task_list.tasks.find(params[:id])
    rescue
      return error_status(true, :invalid_task)
    end
    
    authorize! :delete, @task
    
    @task.updated_by = @logged_user
    @task.destroy

    respond_to do |format|
      format.html { redirect_back_or_default(task_lists_url) }
      format.js { render :json => { :id => @task.id } }
      format.xml  { head :ok }
    end
  end

  # PUT /tasks/1/status
  # PUT /tasks/1/status.xml
  def status
    begin
      @task = @task_list.tasks.find(params[:id])
    rescue
      return error_status(true, :invalid_task)
    end
    
    authorize! :complete, @task
    
    @task.set_completed(params[:task][:completed] == 'true', @logged_user)
    @task.order = @task_list.tasks.length
    @task.save

    respond_to do |format|
      format.html { redirect_back_or_default(task_lists_url) }
      format.js { respond_with_task(@task) }
      format.xml  { head :ok }
    end

  end

protected

  def respond_with_task(task, partial='show')
    task_class = task.is_completed? ? 'completedTasks' : 'openTasks'
    if task.errors
      render :json => {:task_class => task_class, :id => task.id, :content => render_to_string({:partial => partial, :collection => [task]})}
    else
      render :json => {:task_class => task_class, :id => task.id, :errors => task.errors}, :status => :unprocessable_entity
    end
  end
  
  def grab_list_required
    if params[:task_list_id].nil?
      error_status(true, :invalid_task)
      return false
    end
    grab_list
  end

  def grab_list
    return if params[:task_list_id].nil?
    begin
      @task_list = @active_project.task_lists.find(params[:task_list_id])
      authorize! :show, @task_list
    rescue ActiveRecord::RecordNotFound
      error_status(true, :invalid_task)
      return false
    end
    
    true
  end
end
