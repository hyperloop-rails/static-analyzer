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

class FilesController < ApplicationController

  layout 'project_website'
  helper 'project_items'

  before_filter :process_session
  before_filter  :obtain_file, :except => [:index, :new, :create]
  after_filter  :user_track, :only => [:index, :show]
  
  # GET /files
  # GET /files.xml
  def index
    file_conditions = {'project_id' => @active_project.id, 'is_visible' => true}
    file_conditions['is_private'] = false unless @logged_user.member_of_owner?
    
    sort_type = params[:orderBy]
    
    if ['filename'].include?(params[:orderBy])
      sort_order = 'ASC'
    else
      sort_type = 'created_on'
      sort_order = 'DESC'
    end
    
    @current_folder = nil
    @order = sort_type
    
    respond_to do |format|
      format.html {
        @content_for_sidebar = 'index_sidebar'
    
        @page = params[:page].to_i
        @page = 1 unless @page > 0
        
        result_set, @files = ProjectFile.find_grouped(sort_type, :conditions => file_conditions, :page => @page, :per_page => Rails.configuration.files_per_page, :order => "#{sort_type} #{sort_order}")
        @pagination = []
        result_set.total_pages.times {|page| @pagination << page+1}
        
        # Important files and folders (html only)
        @important_files = @active_project.project_files.important
        @important_files = @important_files.is_public unless @logged_user.member_of_owner?
        @folders = @active_project.folders
      }
      format.xml  {
        @files = ProjectFile.where(file_conditions)
                            .offset(params[:offset])
                            .limit(params[:limit] || Rails.configuration.files_per_page)
        
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
  
  if can? :create_file, @active_project
    if @folder.nil?
      @page_actions << {:title => :add_file, :url => new_file_path}
    else
      @page_actions << {:title => :add_file, :url => new_file_path(:folder_id => @folder.id)}
    end
  end

  if can? :create_folder, @active_project
    @page_actions << {:title => :add_folder, :url => new_folder_path}
  end

 if @files.empty? 
 t('no_files_in_location') 
 else 
  t('order_by') 

	temp_actions = [
		{:name => t('filename'), :url => {:page => (page == 0 ? nil : page), :orderBy => 'filename'}, :cond => true, :class => (order == 'filename' ? 'selected' : nil)},
		{:name => t('post_time'), :url => {:page => (page == 0 ? nil : page), :orderBy => 'created_on'}, :cond => true, :class => (order == 'created_on' ? 'selected' : nil)}
	]

 action_list temp_actions 
 pagination_links "#{url_for {}}?", pagination unless pagination.length <= 1 
 
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
  
  if can? :create_file, @active_project
    if @folder.nil?
      @page_actions << {:title => :add_file, :url => new_file_path}
    else
      @page_actions << {:title => :add_file, :url => new_file_path(:folder_id => @folder.id)}
    end
  end

  if can? :create_folder, @active_project
    @page_actions << {:title => :add_folder, :url => new_folder_path}
  end

 if @files.empty? 
 t('no_files_in_location') 
 else 
  t('order_by') 

	temp_actions = [
		{:name => t('filename'), :url => {:page => (page == 0 ? nil : page), :orderBy => 'filename'}, :cond => true, :class => (order == 'filename' ? 'selected' : nil)},
		{:name => t('post_time'), :url => {:page => (page == 0 ? nil : page), :orderBy => 'created_on'}, :cond => true, :class => (order == 'created_on' ? 'selected' : nil)}
	]

 action_list temp_actions 
 pagination_links "#{url_for {}}?", pagination unless pagination.length <= 1 
 
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

  # GET /files/1
  # GET /files/1.xml
  def show
    authorize! :show, @file
    
    respond_to do |format|
      format.html {
        @revisions = @file.project_file_revisions
        
        if @revisions.empty?
          error_status(true, :no_file_revisions)
          redirect_back_or_default files_path
        end
        
        @content_for_sidebar = 'index_sidebar'
        @pagination = []

        @folder = @file.project_folder
        @last_revision = @revisions[0]

        @current_folder = @file.project_folder
        @order = nil
        @page = nil
        @folders = @active_project.folders
        
        # Important files (html only)
        @important_files = @active_project.project_files.important
        @important_files = @important_files.is_public unless @logged_user.member_of_owner?
      }
      format.xml  { 
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
  
  if can? :create_file, @active_project
	@page_actions << {:title => :add_file, :url => new_file_path}
  end

  if can? :create_folder, @active_project
    @page_actions << {:title => :add_folder, :url => new_folder_path}
  end

 if @file.is_private 
 t('private_file') 
 t('private_file') 
 end 
 h @file.filename 
 @file.filetype_icon_url 
 h @file.filename 
 if @file.description 
 textilize @file.description 
 end 
 if !@folder.nil? 
 t('folder') 
 @folder.object_url 
 h @folder.name 
 end 
 if !@last_revision.nil? 
 t('last_revision') 
 if !@last_revision.created_by.nil? 
 t('revision_created_by', :number => @last_revision.revision_number,
		                                     :user => "<a href=\"#{@last_revision.created_by.object_url}\">#{h @last_revision.created_by.display_name}</a>",
		                                     :date => format_usertime(@last_revision.created_on, :revision_date_format_short)).html_safe 
 else 
 t('revision_created_by', :number => @last_revision.revision_number,
		                                     :date => format_usertime(@last_revision.created_on, :revision_date_format_short)).html_safe 
 end 
 end 
 t('tags') 
 tag_list @file 
 action_list actions_for_file(@file, @last_revision) 
 if !@revisions.empty? 
 t('revisions') 
 @revisions.each do |revision| 
 cycle('odd', 'even') 
 'lastRevision' if revision == @last_revision 
 revision.id 
 if !revision.created_by.nil? 
 t('revision_created_by', :number => revision.revision_number,
		                                     :user => "<a href=\"#{revision.created_by.object_url}\">#{h revision.created_by.display_name}</a>",
		                                     :date => format_usertime(revision.created_on, :revision_date_format)).html_safe 
 else 
 t('revision_created_by', :number => revision.revision_number,
		                                     :date => format_usertime(revision.created_on, :revision_date_format)).html_safe 
 end 
 if !revision.comment.empty? 
 textilize revision.comment 
 end 
 action_list actions_for_file_revision(@file, revision) 
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
 
 if can? :comment, @file 
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
 

  @page_actions = []
  
  if can? :create_file, @active_project
	@page_actions << {:title => :add_file, :url => new_file_path}
  end

  if can? :create_folder, @active_project
    @page_actions << {:title => :add_folder, :url => new_folder_path}
  end

 if @file.is_private 
 t('private_file') 
 t('private_file') 
 end 
 h @file.filename 
 @file.filetype_icon_url 
 h @file.filename 
 if @file.description 
 textilize @file.description 
 end 
 if !@folder.nil? 
 t('folder') 
 @folder.object_url 
 h @folder.name 
 end 
 if !@last_revision.nil? 
 t('last_revision') 
 if !@last_revision.created_by.nil? 
 t('revision_created_by', :number => @last_revision.revision_number,
		                                     :user => "<a href=\"#{@last_revision.created_by.object_url}\">#{h @last_revision.created_by.display_name}</a>",
		                                     :date => format_usertime(@last_revision.created_on, :revision_date_format_short)).html_safe 
 else 
 t('revision_created_by', :number => @last_revision.revision_number,
		                                     :date => format_usertime(@last_revision.created_on, :revision_date_format_short)).html_safe 
 end 
 end 
 t('tags') 
 tag_list @file 
 action_list actions_for_file(@file, @last_revision) 
 if !@revisions.empty? 
 t('revisions') 
 @revisions.each do |revision| 
 cycle('odd', 'even') 
 'lastRevision' if revision == @last_revision 
 revision.id 
 if !revision.created_by.nil? 
 t('revision_created_by', :number => revision.revision_number,
		                                     :user => "<a href=\"#{revision.created_by.object_url}\">#{h revision.created_by.display_name}</a>",
		                                     :date => format_usertime(revision.created_on, :revision_date_format)).html_safe 
 else 
 t('revision_created_by', :number => revision.revision_number,
		                                     :date => format_usertime(revision.created_on, :revision_date_format)).html_safe 
 end 
 if !revision.comment.empty? 
 textilize revision.comment 
 end 
 action_list actions_for_file_revision(@file, revision) 
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
 
 if can? :comment, @file 
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

  # GET /files/new
  # GET /files/new.xml
  def new
    authorize! :create_file, @active_project
    
    @file = @active_project.project_files.build()
    
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
  
  if can? :create_file, @active_project
	@page_actions << {:title => :add_file, :url => new_file_path}
  end

  if can? :create_folder, @active_project
    @page_actions << {:title => :add_folder, :url => new_folder_path}
  end

 form_tag( files_path, :multipart => true ) 
  error_messages_for :file 
 if @file.new_record? 
 t('file') 
 t('folder') 
 select 'file', 'folder_id', Folder.select_list(@active_project), {}, {:id => 'fileFormFolder'} 
 t('file_upload_info', :max => format_size(Rails.configuration.max_upload_size)) 
 else 
 check_box_tag 'file_data[updated_file]', '1', false, :class => 'checkbox', :id => 'fileFormUpdateFile', :onclick => "file_form_select_update()" 
 t('update_file') 
 t('file_update_info') 
 t('existing_file') 
 @file.download_url 
 h @file.filename 
 format_size @file.file_size 
 t('new_file') 
 check_box_tag 'file_data[version_file_change]', '1', false, :class => 'checkbox', :id => 'fileFormVersionChange', :onclick => "file_form_select_revision()" 
 t('new_revision') 
 t('revision_comment') 
 text_area_tag 'file_data[revision_comment]', '', :id => 'fileFormRevisionComment', :class => 'short' 
 end 
 t('description') 
 text_area 'file', 'description', :id => 'fileFormDescription', :class => 'short', :rows => 10, :cols => 40 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_file') 
 yesno_toggle 'file', 'is_private', :class => 'yes_no', :id => 'fileFormIsPrivate' 
 t('private_file_info') 
 t('important_file') 
 yesno_toggle 'file', 'is_important', :class => 'yes_no', :id => 'fileFormIsImportant' 
 t('important_file_info') 
 t('enable_comments') 
 yesno_toggle 'file', 'comments_enabled', :class => 'yes_no', :id => 'fileFormEnableComments' 
 t('enable_comments_info') 
 if Rails.configuration.allow_anonymous 
 t('enable_anonymous_comments') 
 yesno_toggle 'file', 'anonymous_comments_enabled', :class => 'yes_no', :id => 'fileFormEnableAnonymousComments' 
 t('enable_anonymous_comments_info') 
 end 
 end 
 t('tags') 
 text_field 'file', 'tags', :id => 'fileFormTags', :class => 'long' 
 t('tags_info') 
 
 t('add_file') 
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
  
  if can? :create_file, @active_project
	@page_actions << {:title => :add_file, :url => new_file_path}
  end

  if can? :create_folder, @active_project
    @page_actions << {:title => :add_folder, :url => new_folder_path}
  end

 form_tag( files_path, :multipart => true ) 
  error_messages_for :file 
 if @file.new_record? 
 t('file') 
 t('folder') 
 select 'file', 'folder_id', Folder.select_list(@active_project), {}, {:id => 'fileFormFolder'} 
 t('file_upload_info', :max => format_size(Rails.configuration.max_upload_size)) 
 else 
 check_box_tag 'file_data[updated_file]', '1', false, :class => 'checkbox', :id => 'fileFormUpdateFile', :onclick => "file_form_select_update()" 
 t('update_file') 
 t('file_update_info') 
 t('existing_file') 
 @file.download_url 
 h @file.filename 
 format_size @file.file_size 
 t('new_file') 
 check_box_tag 'file_data[version_file_change]', '1', false, :class => 'checkbox', :id => 'fileFormVersionChange', :onclick => "file_form_select_revision()" 
 t('new_revision') 
 t('revision_comment') 
 text_area_tag 'file_data[revision_comment]', '', :id => 'fileFormRevisionComment', :class => 'short' 
 end 
 t('description') 
 text_area 'file', 'description', :id => 'fileFormDescription', :class => 'short', :rows => 10, :cols => 40 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_file') 
 yesno_toggle 'file', 'is_private', :class => 'yes_no', :id => 'fileFormIsPrivate' 
 t('private_file_info') 
 t('important_file') 
 yesno_toggle 'file', 'is_important', :class => 'yes_no', :id => 'fileFormIsImportant' 
 t('important_file_info') 
 t('enable_comments') 
 yesno_toggle 'file', 'comments_enabled', :class => 'yes_no', :id => 'fileFormEnableComments' 
 t('enable_comments_info') 
 if Rails.configuration.allow_anonymous 
 t('enable_anonymous_comments') 
 yesno_toggle 'file', 'anonymous_comments_enabled', :class => 'yes_no', :id => 'fileFormEnableAnonymousComments' 
 t('enable_anonymous_comments_info') 
 end 
 end 
 t('tags') 
 text_field 'file', 'tags', :id => 'fileFormTags', :class => 'long' 
 t('tags_info') 
 
 t('add_file') 
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

  # GET /files/1/edit
  def edit
    authorize! :edit, @file
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
  
  if can? :create_file, @active_project
    @page_actions << {:title => :add_file, :url => new_file_path}
  end

  if can? :create_folder, @active_project
    @page_actions << {:title => :add_folder, :url => new_folder_path}
  end

 form_tag( file_path(:id => @file.id), :method => :put, :multipart => true ) 
  error_messages_for :file 
 if @file.new_record? 
 t('file') 
 t('folder') 
 select 'file', 'folder_id', Folder.select_list(@active_project), {}, {:id => 'fileFormFolder'} 
 t('file_upload_info', :max => format_size(Rails.configuration.max_upload_size)) 
 else 
 check_box_tag 'file_data[updated_file]', '1', false, :class => 'checkbox', :id => 'fileFormUpdateFile', :onclick => "file_form_select_update()" 
 t('update_file') 
 t('file_update_info') 
 t('existing_file') 
 @file.download_url 
 h @file.filename 
 format_size @file.file_size 
 t('new_file') 
 check_box_tag 'file_data[version_file_change]', '1', false, :class => 'checkbox', :id => 'fileFormVersionChange', :onclick => "file_form_select_revision()" 
 t('new_revision') 
 t('revision_comment') 
 text_area_tag 'file_data[revision_comment]', '', :id => 'fileFormRevisionComment', :class => 'short' 
 end 
 t('description') 
 text_area 'file', 'description', :id => 'fileFormDescription', :class => 'short', :rows => 10, :cols => 40 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_file') 
 yesno_toggle 'file', 'is_private', :class => 'yes_no', :id => 'fileFormIsPrivate' 
 t('private_file_info') 
 t('important_file') 
 yesno_toggle 'file', 'is_important', :class => 'yes_no', :id => 'fileFormIsImportant' 
 t('important_file_info') 
 t('enable_comments') 
 yesno_toggle 'file', 'comments_enabled', :class => 'yes_no', :id => 'fileFormEnableComments' 
 t('enable_comments_info') 
 if Rails.configuration.allow_anonymous 
 t('enable_anonymous_comments') 
 yesno_toggle 'file', 'anonymous_comments_enabled', :class => 'yes_no', :id => 'fileFormEnableAnonymousComments' 
 t('enable_anonymous_comments_info') 
 end 
 end 
 t('tags') 
 text_field 'file', 'tags', :id => 'fileFormTags', :class => 'long' 
 t('tags_info') 
 
 t('edit_file') 
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

  # POST /files
  # POST /files.xml
  def create
    authorize! :create_file, @active_project

    file_attribs = params[:file]
    @file = @active_project.project_files.build(file_attribs)
    @file.created_by = @logged_user

    # verify file data
    file_data = params[:file_data]
    if file_data.nil? or file_data[:file].nil?
      @file.errors.add(:file, I18n.t('required'))
    end
    
    # sort out other attributes
    @file.filename = file_data[:file] ? (file_data[:file].original_filename).sanitize_filename : nil
    @file.expiration_time = 0
    @file.is_visible = true

    saved = false

    ProjectFile.transaction do
      saved = @file.save

      if saved
        @file.add_revision(file_data[:file], 1, @logged_user, '')
        @file.tags = file_attribs[:tags]
      end
    end

    respond_to do |format|
      if saved
        format.html {
          error_status(false, :success_added_file)
          redirect_back_or_default(@file)
        }
        
        format.xml  { render :xml => @file.to_xml(:root => 'file'), :status => :created, :location => @file }
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
  
  if can? :create_file, @active_project
	@page_actions << {:title => :add_file, :url => new_file_path}
  end

  if can? :create_folder, @active_project
    @page_actions << {:title => :add_folder, :url => new_folder_path}
  end

 form_tag( files_path, :multipart => true ) 
  error_messages_for :file 
 if @file.new_record? 
 t('file') 
 t('folder') 
 select 'file', 'folder_id', Folder.select_list(@active_project), {}, {:id => 'fileFormFolder'} 
 t('file_upload_info', :max => format_size(Rails.configuration.max_upload_size)) 
 else 
 check_box_tag 'file_data[updated_file]', '1', false, :class => 'checkbox', :id => 'fileFormUpdateFile', :onclick => "file_form_select_update()" 
 t('update_file') 
 t('file_update_info') 
 t('existing_file') 
 @file.download_url 
 h @file.filename 
 format_size @file.file_size 
 t('new_file') 
 check_box_tag 'file_data[version_file_change]', '1', false, :class => 'checkbox', :id => 'fileFormVersionChange', :onclick => "file_form_select_revision()" 
 t('new_revision') 
 t('revision_comment') 
 text_area_tag 'file_data[revision_comment]', '', :id => 'fileFormRevisionComment', :class => 'short' 
 end 
 t('description') 
 text_area 'file', 'description', :id => 'fileFormDescription', :class => 'short', :rows => 10, :cols => 40 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_file') 
 yesno_toggle 'file', 'is_private', :class => 'yes_no', :id => 'fileFormIsPrivate' 
 t('private_file_info') 
 t('important_file') 
 yesno_toggle 'file', 'is_important', :class => 'yes_no', :id => 'fileFormIsImportant' 
 t('important_file_info') 
 t('enable_comments') 
 yesno_toggle 'file', 'comments_enabled', :class => 'yes_no', :id => 'fileFormEnableComments' 
 t('enable_comments_info') 
 if Rails.configuration.allow_anonymous 
 t('enable_anonymous_comments') 
 yesno_toggle 'file', 'anonymous_comments_enabled', :class => 'yes_no', :id => 'fileFormEnableAnonymousComments' 
 t('enable_anonymous_comments_info') 
 end 
 end 
 t('tags') 
 text_field 'file', 'tags', :id => 'fileFormTags', :class => 'long' 
 t('tags_info') 
 
 t('add_file') 
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
        
        format.xml  { render :xml => @file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /files/1
  # PUT /files/1.xml
  def update
    authorize! :edit, @file

    file_data = params[:file_data]
    unless file_data.nil?
      if file_data[:updated_file] and !file_data[:file]
        @file.errors.add(:file, I18n.t('required'))
      end
    end

    file_attribs = params[:file]
    @file.attributes = file_attribs
    @file.updated_by = @logged_user
    @file.is_visible = true
    
    saved = false

    ProjectFile.transaction do
      saved = @file.save
      
      if saved
        if file_data[:updated_file]
          if file_data[:version_file_change]
            @file.add_revision(file_data[:file], @file.project_file_revisions[0].revision_number+1, @logged_user, file_data[:revision_comment])
          else
            @file.update_revision(file_data[:file], @file.project_file_revisions[0], @logged_user, file_data[:revision_comment])
          end

          @file.filename = (file_data[:file].original_filename).sanitize_filename
        end

        @file.tags = file_attribs[:tags]
      end
    end
    
    respond_to do |format|
      if saved
        format.html {
          error_status(false, :success_edited_file)
          redirect_back_or_default(@file)
        }
        
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
  
  if can? :create_file, @active_project
    @page_actions << {:title => :add_file, :url => new_file_path}
  end

  if can? :create_folder, @active_project
    @page_actions << {:title => :add_folder, :url => new_folder_path}
  end

 form_tag( file_path(:id => @file.id), :method => :put, :multipart => true ) 
  error_messages_for :file 
 if @file.new_record? 
 t('file') 
 t('folder') 
 select 'file', 'folder_id', Folder.select_list(@active_project), {}, {:id => 'fileFormFolder'} 
 t('file_upload_info', :max => format_size(Rails.configuration.max_upload_size)) 
 else 
 check_box_tag 'file_data[updated_file]', '1', false, :class => 'checkbox', :id => 'fileFormUpdateFile', :onclick => "file_form_select_update()" 
 t('update_file') 
 t('file_update_info') 
 t('existing_file') 
 @file.download_url 
 h @file.filename 
 format_size @file.file_size 
 t('new_file') 
 check_box_tag 'file_data[version_file_change]', '1', false, :class => 'checkbox', :id => 'fileFormVersionChange', :onclick => "file_form_select_revision()" 
 t('new_revision') 
 t('revision_comment') 
 text_area_tag 'file_data[revision_comment]', '', :id => 'fileFormRevisionComment', :class => 'short' 
 end 
 t('description') 
 text_area 'file', 'description', :id => 'fileFormDescription', :class => 'short', :rows => 10, :cols => 40 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_file') 
 yesno_toggle 'file', 'is_private', :class => 'yes_no', :id => 'fileFormIsPrivate' 
 t('private_file_info') 
 t('important_file') 
 yesno_toggle 'file', 'is_important', :class => 'yes_no', :id => 'fileFormIsImportant' 
 t('important_file_info') 
 t('enable_comments') 
 yesno_toggle 'file', 'comments_enabled', :class => 'yes_no', :id => 'fileFormEnableComments' 
 t('enable_comments_info') 
 if Rails.configuration.allow_anonymous 
 t('enable_anonymous_comments') 
 yesno_toggle 'file', 'anonymous_comments_enabled', :class => 'yes_no', :id => 'fileFormEnableAnonymousComments' 
 t('enable_anonymous_comments_info') 
 end 
 end 
 t('tags') 
 text_field 'file', 'tags', :id => 'fileFormTags', :class => 'long' 
 t('tags_info') 
 
 t('edit_file') 
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
        
        format.xml  { render :xml => @file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /files/1
  # DELETE /files/1.xml
  def destroy
    authorize! :delete, @file
    
    @file.updated_by = @logged_user
    @file.destroy

    respond_to do |format|
      format.html {
        error_status(false, :success_deleted_file)
        redirect_to files_url
      }
      
      format.xml  { head :ok }
    end
  end
  
  # GET /files/1/download
  def download
    revision_id = params[:revision]

    unless revision_id.nil?
      begin
        @file_revision = ProjectFileRevision.where(:file_id => @file.id, :revision_number => revision_id).first!
      rescue ActiveRecord::RecordNotFound
        error_status(true, :invalid_file_revision)
        redirect_back_or_default files_path
        return
      end
    else
      @file_revision = @file.project_file_revisions[0]
    end

    if @file_revision.nil?
      render :text => '404 Not Found', :status => 404
      return
    end

    if @file_revision.data?
      redirect_to @file_revision.data.url, :status => 302
    else
      render :text => '404 Not Found', :status => 404
    end
  end
  
  # PUT /files/1/attach
  def attach
    rel_object_type = params[:object_type]
    rel_object_id = params[:object_id]

    if (rel_object_type.nil? or rel_object_id.nil?) or (!['Comment', 'Message'].include?(rel_object_type))
      error_status(true, :invalid_request)
      redirect_back_or_default :controller => 'files'
      return
    end

    # Find object we want to attach a file to
    begin
      @attach_object = Kernel.const_get(rel_object_type).find(params[:object_id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :invalid_object)
      redirect_back_or_default :controller => 'files'
      return
    end

    authorize! :add_file, @attach_object

    case request.request_method_symbol
    when :put
      attach_attribs = params[:attach]

      if attach_attribs[:what] == 'new_file'
        begin
          ProjectFile.handle_files(params[:uploaded_files], @attach_object, @logged_user, @attach_object.is_private)
          error_status(false, :success_added_new_file_to_object)
        rescue
          error_status(false, :error_adding_file_to_object)
        end

        redirect_back_or_default @attach_object.object_url
        return
      elsif attach_attribs[:what] == 'existing_file'
        begin
          existing_file = @active_project.project_files.find(attach_attribs[:file_id])
        rescue ActiveRecord::RecordNotFound
          error_status(true, :invalid_file)
          redirect_back_or_default @attach_object.object_url
          return
        end

        # Make sure its unique
        does_exist = @attach_object.project_file.any?{ |file| file == existing_file }
        if !does_exist
          AttachedFile.create!(:created_on => existing_file.created_on, 
                               :created_by => @logged_user, 
                               :rel_object => @attach_object, 
                               :project_file => existing_file)
          #@attach_object.project_file << existing_file
        end
        
        error_status(false, :success_added_file_to_object)
        redirect_back_or_default @attach_object.object_url
        return
      end

      error_status(true, :error_adding_file_to_object)
      redirect_back_or_default @attach_object.object_url
      return
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
 
 form_tag({:object_id => @attach_object.id, :object_type => @attach_object.class.to_s}, :method => :put, :multipart => true) 
 t('hint_attach_files', :link => "<a href=\"#{@attach_object.object_url}\">#{h(@attach_object.object_name)}</a>") 
 radio_button_tag 'attach[what]', 'existing_file', true, {:id => 'attachFormExistingFile', :class => 'checkbox', :onclick => 'file_form_attach_update_action()'} 
 t('attach_existing_file') 
 t('select_file') 
 select_tag 'attach[file_id]', options_for_select(select_file_options(@active_project, @attach_object)), {:id => 'attachFormSelectFile', :style => 'width: 300px'} 
 radio_button_tag 'attach[what]', 'new_file', true, {:id => 'attachFormNewFile', :class => 'checkbox', :onclick => 'file_form_attach_update_action()'} 
 t('upload_attach_to_message') 
  t('attach_files') 
 
 Rails.configuration.max_attachments 
 t('attach_files') 
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
  
  # PUT /files/1/detatch
  def detatch
    # params: manager, file_id, object_id
    rel_object_type = params[:object_type]
    rel_object_id = params[:object_id]

    if (rel_object_type.nil? or rel_object_id.nil?) or (!['Comment', 'Message'].include?(rel_object_type))
      error_status(true, :invalid_request)
      redirect_back_or_default files_path
      return
    end

    # Find object we want to attach a file to
    begin
      @attach_object = Kernel.const_get(rel_object_type).find(params[:object_id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :invalid_object)
      redirect_back_or_default files_path
      return
    end

    authorize! :add_file, @attach_object

    begin
      existing_file = @active_project.project_files.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :invalid_file)
      redirect_back_or_default @attach_object.object_url
      return
    end

    AttachedFile.clear_attachment(@attach_object, existing_file.id)

    error_status(false, :success_removed_file_from_object)
    redirect_back_or_default @attach_object.object_url
  end

private

  def obtain_file
     begin
        @file = @active_project.project_files.find(params[:id])
     rescue ActiveRecord::RecordNotFound
       error_status(true, :invalid_file)
       redirect_back_or_default files_path
       return false
     end
     
     return true
  end
  
end
