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

class UsersController < ApplicationController

  layout 'administration'
  
  before_filter :process_session
  before_filter :obtain_user, :except => [:index, :create, :new]
  after_filter :user_track, :only => [:index, :show]

  def index
    respond_to do |format|
      format.html {
        redirect_to companies_path
      }
      format.xml  {
        if @logged_user.is_admin
          @users = User.all
          render :xml => @users.to_xml(:root => 'user')
        else
          return error_status(true, :insufficient_permissions)
        end
      }
    end
  end

  def new
    authorize! :create_user, current_user

    @user = User.new
    @company = @logged_user.company
    @permissions = Person.permission_names()

    @send_email = params[:new_account_notification] == 'false' ? false : true
    @permissions = Person.permission_names()
    @projects = @active_projects
    
    begin
      if @logged_user.member_of_owner? and !params[:company_id].nil?
        @company = Company.find(params[:company_id])
      end
    rescue ActiveRecord::RecordNotFound
      error_status(true, :invalid_company)
      redirect_back_or_default :controller => 'dashboard'
      return
    end

    @user.company_id = @company.id
    @user.time_zone = @company.time_zone
    
    respond_to do |format|
      format.html {}
      format.xml  { 
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
 
 form_tag users_path 
  error_messages_for :user 
 if @logged_user.is_admin 
 t('administration_options_info') 
 t('username') 
 text_field 'user', 'username', :id => 'userFormUsername' 
 if @logged_user.member_of_owner? 
 t('company') 
 select 'user', 'company_id', Company.select_list, {}, {:id => 'userFormCompany'} 
 t('options') 
 t('administrator') 
 yesno_toggle 'user', 'is_admin', :id => 'userFormIsAdmin', :class => 'checkbox'  
 t('auto_assign_to_new_projects') 
 yesno_toggle 'user', 'auto_assign', :id => 'userFormAutoAssign', :class => 'checkbox'  
 end 
 else 
 t('username') 
 @user.username 
 end 
 t('display_name') 
 text_field 'user', 'display_name', :id => 'userFormDisplayName', :class => 'medium' 
 t('email_address') 
 text_field 'user', 'email', :id => 'profileFormEmail', :class => 'long' 
 t('timezone') 
 time_zone_select 'user', 'time_zone', nil, {}, {:id => 'profileFormTimezone', :class => 'long'} 
 t('password') 
 if @user.new_record? 
 t('generate_password') 
 end 
 t('password') 
 t('repeat_password') 
 if @user.new_record? 
 t('send_account_email_notification') 
 yesno_toggle_tag 'new_account_notification', !!@send_email, :id => 'userFormEmailNotificationYes', :class => 'checkbox' 
 t('send_account_email_notication_info') 
 else 
 t('contact_info') 
 t('title') 
 text_field 'user', 'title', :id => 'userFormTitle' 
 t('office') 
 text_field 'user', 'office_number', :id => 'userFormOfficeNumber' 
 t('office') 
 text_field 'user', 'office_number_ext', :id => 'userFormOfficeNumberExt' 
 t('fax') 
 text_field 'user', 'fax_number', :id => 'userFormFaxNumber' 
 t('mobile') 
 text_field 'user', 'mobile_number', :id => 'userFormMobileNumber' 
 t('home') 
 text_field 'user', 'home_number', :id => 'userFormHomeNumber' 
 all_im_values = @user.im_info 
 if all_im_values.length > 0 
 t('instant_messengers') 
 t('service') 
 t('value') 
 t('primary_im') 
 @count = 0 
 all_im_values.each do |im_value| 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 "userFormIm#{@count}" 
 im_value.im_type.name 
 text_field_tag "user[im_values][#{im_value.im_type_id}][value]", im_value.value, :id => "userFormIm#{@count}" 
 radio_button_tag "user[default_im_value]", im_value.im_type_id, im_value.is_default, :id => 'im_default', :class => 'checkbox' 
 @count += 1 
 end 
 t('instant_messengers_info') 
 end 
 end 
 if @logged_user.member_of_owner? and @user.new_record? and !@active_projects.empty? 
 @permissions.keys.join('\',\'')
 t('permissions') 
  if @companies.length > 0
 form_tag permissions_project_path(:id => @active_project.id), :method => :put 
 @companies.each do |company| 
 if company.users.length > 0 
 company.logo_url 
 h company.name 
 if company.is_owner? 
 h company.name 
 company.id 
 else 
 check_box_tag "project_company[]", "#{company.id}", company.is_part_of(@active_project), {:id => "projectCompany#{@active_project.id}_#{company.id}", :class => 'checkbox', :onclick => "permissions_form_project_select_company('#{@active_project.id}_#{company.id}')"} 
 "project_company[]" 
 h company.name 
 end 
 "#{@active_project.id}_#{company.id}" 
 unless company.is_part_of(@active_project) 
 end 
 unless company.users.empty? 
  perm_id = "#{project.id}_#{company.id}_#{permissions_users.id}" 
 if permissions_users.owner_of_owner? 
 render_icon 'ok', 'Ok' 
 h permissions_users.display_name 
 "people_#{permissions_users.id}" 
 else 
 check_box_tag "people[]", "#{permissions_users.id}", permissions_users.member_of(@active_project), {:id => "projectPermissions#{perm_id}", :class => 'checkbox', :onclick => "permissions_form_project_select('#{perm_id}')"} 
 "projectPermissions#{perm_id}" 
 h permissions_users.display_name 
 end 
 if permissions_users.is_admin? 
 t('administrator') 
 end 
 unless company.is_owner? 
 perm_id 
 unless permissions_users.member_of(project) 
 end 
 check_box_tag "people_#{permissions_users.id}_all", "1", permissions_users.has_all_permissions(project), {:id => "projectPermissions#{perm_id}All", :class => 'checkbox', :onclick => "permissions_form_project_select_all('#{perm_id}')"} 
 "projectPermissions#{perm_id}All" 
 t('all') 
 @permissions.keys.each do |permission| 
 check_box_tag "people_permissions[#{permissions_users.id}][]", "#{permission}", permissions_users.has_permission(project, permission), {:id => "projectPermission#{perm_id}#{permission}", :class => 'checkbox normal', :onclick => "permissions_form_project_select_item('#{perm_id}')"} 
 "projectPermissions#{perm_id}#{permission}" 
 @permissions[permission] 
 end 
 end 
 
 else 
 t('company_no_users') 
 end 
 end 
 end 
 t('update_people') 
 end 
 @permissions.keys.join('\',\'')
 
 end 
 
 t('add_user') 
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
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
 
 form_tag users_path 
  error_messages_for :user 
 if @logged_user.is_admin 
 t('administration_options_info') 
 t('username') 
 text_field 'user', 'username', :id => 'userFormUsername' 
 if @logged_user.member_of_owner? 
 t('company') 
 select 'user', 'company_id', Company.select_list, {}, {:id => 'userFormCompany'} 
 t('options') 
 t('administrator') 
 yesno_toggle 'user', 'is_admin', :id => 'userFormIsAdmin', :class => 'checkbox'  
 t('auto_assign_to_new_projects') 
 yesno_toggle 'user', 'auto_assign', :id => 'userFormAutoAssign', :class => 'checkbox'  
 end 
 else 
 t('username') 
 @user.username 
 end 
 t('display_name') 
 text_field 'user', 'display_name', :id => 'userFormDisplayName', :class => 'medium' 
 t('email_address') 
 text_field 'user', 'email', :id => 'profileFormEmail', :class => 'long' 
 t('timezone') 
 time_zone_select 'user', 'time_zone', nil, {}, {:id => 'profileFormTimezone', :class => 'long'} 
 t('password') 
 if @user.new_record? 
 t('generate_password') 
 end 
 t('password') 
 t('repeat_password') 
 if @user.new_record? 
 t('send_account_email_notification') 
 yesno_toggle_tag 'new_account_notification', !!@send_email, :id => 'userFormEmailNotificationYes', :class => 'checkbox' 
 t('send_account_email_notication_info') 
 else 
 t('contact_info') 
 t('title') 
 text_field 'user', 'title', :id => 'userFormTitle' 
 t('office') 
 text_field 'user', 'office_number', :id => 'userFormOfficeNumber' 
 t('office') 
 text_field 'user', 'office_number_ext', :id => 'userFormOfficeNumberExt' 
 t('fax') 
 text_field 'user', 'fax_number', :id => 'userFormFaxNumber' 
 t('mobile') 
 text_field 'user', 'mobile_number', :id => 'userFormMobileNumber' 
 t('home') 
 text_field 'user', 'home_number', :id => 'userFormHomeNumber' 
 all_im_values = @user.im_info 
 if all_im_values.length > 0 
 t('instant_messengers') 
 t('service') 
 t('value') 
 t('primary_im') 
 @count = 0 
 all_im_values.each do |im_value| 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 "userFormIm#{@count}" 
 im_value.im_type.name 
 text_field_tag "user[im_values][#{im_value.im_type_id}][value]", im_value.value, :id => "userFormIm#{@count}" 
 radio_button_tag "user[default_im_value]", im_value.im_type_id, im_value.is_default, :id => 'im_default', :class => 'checkbox' 
 @count += 1 
 end 
 t('instant_messengers_info') 
 end 
 end 
 if @logged_user.member_of_owner? and @user.new_record? and !@active_projects.empty? 
 @permissions.keys.join('\',\'')
 t('permissions') 
  if @companies.length > 0
 form_tag permissions_project_path(:id => @active_project.id), :method => :put 
 @companies.each do |company| 
 if company.users.length > 0 
 company.logo_url 
 h company.name 
 if company.is_owner? 
 h company.name 
 company.id 
 else 
 check_box_tag "project_company[]", "#{company.id}", company.is_part_of(@active_project), {:id => "projectCompany#{@active_project.id}_#{company.id}", :class => 'checkbox', :onclick => "permissions_form_project_select_company('#{@active_project.id}_#{company.id}')"} 
 "project_company[]" 
 h company.name 
 end 
 "#{@active_project.id}_#{company.id}" 
 unless company.is_part_of(@active_project) 
 end 
 unless company.users.empty? 
  perm_id = "#{project.id}_#{company.id}_#{permissions_users.id}" 
 if permissions_users.owner_of_owner? 
 render_icon 'ok', 'Ok' 
 h permissions_users.display_name 
 "people_#{permissions_users.id}" 
 else 
 check_box_tag "people[]", "#{permissions_users.id}", permissions_users.member_of(@active_project), {:id => "projectPermissions#{perm_id}", :class => 'checkbox', :onclick => "permissions_form_project_select('#{perm_id}')"} 
 "projectPermissions#{perm_id}" 
 h permissions_users.display_name 
 end 
 if permissions_users.is_admin? 
 t('administrator') 
 end 
 unless company.is_owner? 
 perm_id 
 unless permissions_users.member_of(project) 
 end 
 check_box_tag "people_#{permissions_users.id}_all", "1", permissions_users.has_all_permissions(project), {:id => "projectPermissions#{perm_id}All", :class => 'checkbox', :onclick => "permissions_form_project_select_all('#{perm_id}')"} 
 "projectPermissions#{perm_id}All" 
 t('all') 
 @permissions.keys.each do |permission| 
 check_box_tag "people_permissions[#{permissions_users.id}][]", "#{permission}", permissions_users.has_permission(project, permission), {:id => "projectPermission#{perm_id}#{permission}", :class => 'checkbox normal', :onclick => "permissions_form_project_select_item('#{perm_id}')"} 
 "projectPermissions#{perm_id}#{permission}" 
 @permissions[permission] 
 end 
 end 
 
 else 
 t('company_no_users') 
 end 
 end 
 end 
 t('update_people') 
 end 
 @permissions.keys.join('\',\'')
 
 end 
 
 t('add_user') 
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
  
  def create
    authorize! :create_user, current_user

    @user = User.new
    @company = @logged_user.company
    @permissions = Person.permission_names()

    @send_email = params[:new_account_notification] == 'false' ? false : true
    @permissions = Person.permission_names()
    @projects = @active_projects
    
    user_attribs = params[:user]

    # Process extra parameters

    @user.username = user_attribs[:username]
    new_account_password = nil

    if user_attribs.has_key?(:generate_password)
      @user.password = @user.password_confirmation = Base64.encode64(Digest::SHA1.digest("#{rand(1 << 64)}/#{Time.now.to_f}/#{@user.username}"))[0..7]
    else
      unless user_attribs[:password].blank?
        @user.password = user_attribs[:password]
        @user.password_confirmation = user_attribs[:password_confirmation]
      end
    end
      
    new_account_password = @user.password

    if @logged_user.member_of_owner?
      @user.company_id = user_attribs[:company_id]
      if @user.member_of_owner?
        @user.is_admin = user_attribs[:is_admin]
        @user.auto_assign = user_attribs[:auto_assign]
      end
    else
      @user.company_id = @company.id
    end

    # Process core parameters

    @user.attributes = user_attribs
    @user.created_by = @logged_user

    # Send it off
    saved = @user.save
    if saved
      # Time to update permissions
      update_project_permissions(@user, params[:user_project], params[:project_permission])
      # ... and send details!
      Notifier.deliver_account_new_info(@user, new_account_password) if @send_email
    end
    
    respond_to do |format|
      if saved
        format.html {
          error_status(false, :success_added_user)
          redirect_back_or_default :controller => 'administration', :action => 'people'
        }
        
        format.xml  { render :xml => @user.to_xml(:root => 'user'), :status => :created, :location => @user }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
 
 form_tag users_path 
  error_messages_for :user 
 if @logged_user.is_admin 
 t('administration_options_info') 
 t('username') 
 text_field 'user', 'username', :id => 'userFormUsername' 
 if @logged_user.member_of_owner? 
 t('company') 
 select 'user', 'company_id', Company.select_list, {}, {:id => 'userFormCompany'} 
 t('options') 
 t('administrator') 
 yesno_toggle 'user', 'is_admin', :id => 'userFormIsAdmin', :class => 'checkbox'  
 t('auto_assign_to_new_projects') 
 yesno_toggle 'user', 'auto_assign', :id => 'userFormAutoAssign', :class => 'checkbox'  
 end 
 else 
 t('username') 
 @user.username 
 end 
 t('display_name') 
 text_field 'user', 'display_name', :id => 'userFormDisplayName', :class => 'medium' 
 t('email_address') 
 text_field 'user', 'email', :id => 'profileFormEmail', :class => 'long' 
 t('timezone') 
 time_zone_select 'user', 'time_zone', nil, {}, {:id => 'profileFormTimezone', :class => 'long'} 
 t('password') 
 if @user.new_record? 
 t('generate_password') 
 end 
 t('password') 
 t('repeat_password') 
 if @user.new_record? 
 t('send_account_email_notification') 
 yesno_toggle_tag 'new_account_notification', !!@send_email, :id => 'userFormEmailNotificationYes', :class => 'checkbox' 
 t('send_account_email_notication_info') 
 else 
 t('contact_info') 
 t('title') 
 text_field 'user', 'title', :id => 'userFormTitle' 
 t('office') 
 text_field 'user', 'office_number', :id => 'userFormOfficeNumber' 
 t('office') 
 text_field 'user', 'office_number_ext', :id => 'userFormOfficeNumberExt' 
 t('fax') 
 text_field 'user', 'fax_number', :id => 'userFormFaxNumber' 
 t('mobile') 
 text_field 'user', 'mobile_number', :id => 'userFormMobileNumber' 
 t('home') 
 text_field 'user', 'home_number', :id => 'userFormHomeNumber' 
 all_im_values = @user.im_info 
 if all_im_values.length > 0 
 t('instant_messengers') 
 t('service') 
 t('value') 
 t('primary_im') 
 @count = 0 
 all_im_values.each do |im_value| 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 "userFormIm#{@count}" 
 im_value.im_type.name 
 text_field_tag "user[im_values][#{im_value.im_type_id}][value]", im_value.value, :id => "userFormIm#{@count}" 
 radio_button_tag "user[default_im_value]", im_value.im_type_id, im_value.is_default, :id => 'im_default', :class => 'checkbox' 
 @count += 1 
 end 
 t('instant_messengers_info') 
 end 
 end 
 if @logged_user.member_of_owner? and @user.new_record? and !@active_projects.empty? 
 @permissions.keys.join('\',\'')
 t('permissions') 
  if @companies.length > 0
 form_tag permissions_project_path(:id => @active_project.id), :method => :put 
 @companies.each do |company| 
 if company.users.length > 0 
 company.logo_url 
 h company.name 
 if company.is_owner? 
 h company.name 
 company.id 
 else 
 check_box_tag "project_company[]", "#{company.id}", company.is_part_of(@active_project), {:id => "projectCompany#{@active_project.id}_#{company.id}", :class => 'checkbox', :onclick => "permissions_form_project_select_company('#{@active_project.id}_#{company.id}')"} 
 "project_company[]" 
 h company.name 
 end 
 "#{@active_project.id}_#{company.id}" 
 unless company.is_part_of(@active_project) 
 end 
 unless company.users.empty? 
  perm_id = "#{project.id}_#{company.id}_#{permissions_users.id}" 
 if permissions_users.owner_of_owner? 
 render_icon 'ok', 'Ok' 
 h permissions_users.display_name 
 "people_#{permissions_users.id}" 
 else 
 check_box_tag "people[]", "#{permissions_users.id}", permissions_users.member_of(@active_project), {:id => "projectPermissions#{perm_id}", :class => 'checkbox', :onclick => "permissions_form_project_select('#{perm_id}')"} 
 "projectPermissions#{perm_id}" 
 h permissions_users.display_name 
 end 
 if permissions_users.is_admin? 
 t('administrator') 
 end 
 unless company.is_owner? 
 perm_id 
 unless permissions_users.member_of(project) 
 end 
 check_box_tag "people_#{permissions_users.id}_all", "1", permissions_users.has_all_permissions(project), {:id => "projectPermissions#{perm_id}All", :class => 'checkbox', :onclick => "permissions_form_project_select_all('#{perm_id}')"} 
 "projectPermissions#{perm_id}All" 
 t('all') 
 @permissions.keys.each do |permission| 
 check_box_tag "people_permissions[#{permissions_users.id}][]", "#{permission}", permissions_users.has_permission(project, permission), {:id => "projectPermission#{perm_id}#{permission}", :class => 'checkbox normal', :onclick => "permissions_form_project_select_item('#{perm_id}')"} 
 "projectPermissions#{perm_id}#{permission}" 
 @permissions[permission] 
 end 
 end 
 
 else 
 t('company_no_users') 
 end 
 end 
 end 
 t('update_people') 
 end 
 @permissions.keys.join('\',\'')
 
 end 
 
 t('add_user') 
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
        
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    authorize! :update_profile, @user
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
 
 form_tag user_path(:id => @user.id), :method => :put 
  error_messages_for :user 
 if @logged_user.is_admin 
 t('administration_options_info') 
 t('username') 
 text_field 'user', 'username', :id => 'userFormUsername' 
 if @logged_user.member_of_owner? 
 t('company') 
 select 'user', 'company_id', Company.select_list, {}, {:id => 'userFormCompany'} 
 t('options') 
 t('administrator') 
 yesno_toggle 'user', 'is_admin', :id => 'userFormIsAdmin', :class => 'checkbox'  
 t('auto_assign_to_new_projects') 
 yesno_toggle 'user', 'auto_assign', :id => 'userFormAutoAssign', :class => 'checkbox'  
 end 
 else 
 t('username') 
 @user.username 
 end 
 t('display_name') 
 text_field 'user', 'display_name', :id => 'userFormDisplayName', :class => 'medium' 
 t('email_address') 
 text_field 'user', 'email', :id => 'profileFormEmail', :class => 'long' 
 t('timezone') 
 time_zone_select 'user', 'time_zone', nil, {}, {:id => 'profileFormTimezone', :class => 'long'} 
 t('password') 
 if @user.new_record? 
 t('generate_password') 
 end 
 t('password') 
 t('repeat_password') 
 if @user.new_record? 
 t('send_account_email_notification') 
 yesno_toggle_tag 'new_account_notification', !!@send_email, :id => 'userFormEmailNotificationYes', :class => 'checkbox' 
 t('send_account_email_notication_info') 
 else 
 t('contact_info') 
 t('title') 
 text_field 'user', 'title', :id => 'userFormTitle' 
 t('office') 
 text_field 'user', 'office_number', :id => 'userFormOfficeNumber' 
 t('office') 
 text_field 'user', 'office_number_ext', :id => 'userFormOfficeNumberExt' 
 t('fax') 
 text_field 'user', 'fax_number', :id => 'userFormFaxNumber' 
 t('mobile') 
 text_field 'user', 'mobile_number', :id => 'userFormMobileNumber' 
 t('home') 
 text_field 'user', 'home_number', :id => 'userFormHomeNumber' 
 all_im_values = @user.im_info 
 if all_im_values.length > 0 
 t('instant_messengers') 
 t('service') 
 t('value') 
 t('primary_im') 
 @count = 0 
 all_im_values.each do |im_value| 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 "userFormIm#{@count}" 
 im_value.im_type.name 
 text_field_tag "user[im_values][#{im_value.im_type_id}][value]", im_value.value, :id => "userFormIm#{@count}" 
 radio_button_tag "user[default_im_value]", im_value.im_type_id, im_value.is_default, :id => 'im_default', :class => 'checkbox' 
 @count += 1 
 end 
 t('instant_messengers_info') 
 end 
 end 
 if @logged_user.member_of_owner? and @user.new_record? and !@active_projects.empty? 
 @permissions.keys.join('\',\'')
 t('permissions') 
  if @companies.length > 0
 form_tag permissions_project_path(:id => @active_project.id), :method => :put 
 @companies.each do |company| 
 if company.users.length > 0 
 company.logo_url 
 h company.name 
 if company.is_owner? 
 h company.name 
 company.id 
 else 
 check_box_tag "project_company[]", "#{company.id}", company.is_part_of(@active_project), {:id => "projectCompany#{@active_project.id}_#{company.id}", :class => 'checkbox', :onclick => "permissions_form_project_select_company('#{@active_project.id}_#{company.id}')"} 
 "project_company[]" 
 h company.name 
 end 
 "#{@active_project.id}_#{company.id}" 
 unless company.is_part_of(@active_project) 
 end 
 unless company.users.empty? 
  perm_id = "#{project.id}_#{company.id}_#{permissions_users.id}" 
 if permissions_users.owner_of_owner? 
 render_icon 'ok', 'Ok' 
 h permissions_users.display_name 
 "people_#{permissions_users.id}" 
 else 
 check_box_tag "people[]", "#{permissions_users.id}", permissions_users.member_of(@active_project), {:id => "projectPermissions#{perm_id}", :class => 'checkbox', :onclick => "permissions_form_project_select('#{perm_id}')"} 
 "projectPermissions#{perm_id}" 
 h permissions_users.display_name 
 end 
 if permissions_users.is_admin? 
 t('administrator') 
 end 
 unless company.is_owner? 
 perm_id 
 unless permissions_users.member_of(project) 
 end 
 check_box_tag "people_#{permissions_users.id}_all", "1", permissions_users.has_all_permissions(project), {:id => "projectPermissions#{perm_id}All", :class => 'checkbox', :onclick => "permissions_form_project_select_all('#{perm_id}')"} 
 "projectPermissions#{perm_id}All" 
 t('all') 
 @permissions.keys.each do |permission| 
 check_box_tag "people_permissions[#{permissions_users.id}][]", "#{permission}", permissions_users.has_permission(project, permission), {:id => "projectPermission#{perm_id}#{permission}", :class => 'checkbox normal', :onclick => "permissions_form_project_select_item('#{perm_id}')"} 
 "projectPermissions#{perm_id}#{permission}" 
 @permissions[permission] 
 end 
 end 
 
 else 
 t('company_no_users') 
 end 
 end 
 end 
 t('update_people') 
 end 
 @permissions.keys.join('\',\'')
 
 end 
 
 t('edit_user') 
 form_tag( avatar_user_path(:id => @user.id), :multipart => true, :method => :put ) 
 error_messages_for :user 
 t('current_avatar') 
 if @user.has_avatar? 
 @user.avatar_url 
 h @user.display_name 
 link_to t('delete_current_avatar'), avatar_user_path(:id => @user.id), {:onclick => :avatar_confirm_delete, :method => :delete} 
 else 
 t('avatar_not_uploaded') 
 end 
 t('new_avatar') 
 if @user.has_avatar? 
 t('avatar_upload_info') 
 end 
 t('update_avatar') 
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
  
  def update
    authorize! :update_profile, @user
  	
    @projects = @active_projects
    @permissions = Person.permission_names()
    
    user_params = params[:user]

    # Process IM Values
    all_im_values = user_params[:im_values] || {}
    all_im_values.reject! do |key, value|
      value[:value].strip.length == 0
    end

    if user_params[:default_im_value].nil?
      default_value = '-1'
    else
      default_value = user_params[:default_im_value]
    end

    real_im_values = all_im_values.collect do |type_id,value|
      real_im_value = value[:value]
      ImValue.new(:im_type_id => type_id.to_i, :user_id => @user.id, :value => real_im_value, :is_default => (default_value == type_id))
    end

    # Process extra parameters

    if @logged_user.is_admin?
      @user.username = user_params[:username]

      if @logged_user.member_of_owner?
        @user.company_id = user_params[:company_id] unless user_params[:company_id].nil?
        if @user.member_of_owner?
          @user.is_admin = user_params[:is_admin]
          @user.auto_assign = user_params[:auto_assign]
        end
      end
    end

    unless user_params[:password].blank?
      @user.password = user_params[:password]
      @user.password_confirmation = user_params[:password_confirmation]
    end

    # Process core parameters

    @user.attributes = user_params

    # Send it off
    saved = @user.save
    if saved
      # Re-create ImValues for user
      ActiveRecord::Base.connection.execute("DELETE FROM user_im_values WHERE user_id = #{@user.id}")
      real_im_values.each do |im_value|
        im_value.save
      end
    end

    respond_to do |format|
      if saved
        format.html {
          error_status(false, :success_updated_profile)
          redirect_back_or_default :controller => 'administration', :action => 'people'
        }
        
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
 
 form_tag user_path(:id => @user.id), :method => :put 
  error_messages_for :user 
 if @logged_user.is_admin 
 t('administration_options_info') 
 t('username') 
 text_field 'user', 'username', :id => 'userFormUsername' 
 if @logged_user.member_of_owner? 
 t('company') 
 select 'user', 'company_id', Company.select_list, {}, {:id => 'userFormCompany'} 
 t('options') 
 t('administrator') 
 yesno_toggle 'user', 'is_admin', :id => 'userFormIsAdmin', :class => 'checkbox'  
 t('auto_assign_to_new_projects') 
 yesno_toggle 'user', 'auto_assign', :id => 'userFormAutoAssign', :class => 'checkbox'  
 end 
 else 
 t('username') 
 @user.username 
 end 
 t('display_name') 
 text_field 'user', 'display_name', :id => 'userFormDisplayName', :class => 'medium' 
 t('email_address') 
 text_field 'user', 'email', :id => 'profileFormEmail', :class => 'long' 
 t('timezone') 
 time_zone_select 'user', 'time_zone', nil, {}, {:id => 'profileFormTimezone', :class => 'long'} 
 t('password') 
 if @user.new_record? 
 t('generate_password') 
 end 
 t('password') 
 t('repeat_password') 
 if @user.new_record? 
 t('send_account_email_notification') 
 yesno_toggle_tag 'new_account_notification', !!@send_email, :id => 'userFormEmailNotificationYes', :class => 'checkbox' 
 t('send_account_email_notication_info') 
 else 
 t('contact_info') 
 t('title') 
 text_field 'user', 'title', :id => 'userFormTitle' 
 t('office') 
 text_field 'user', 'office_number', :id => 'userFormOfficeNumber' 
 t('office') 
 text_field 'user', 'office_number_ext', :id => 'userFormOfficeNumberExt' 
 t('fax') 
 text_field 'user', 'fax_number', :id => 'userFormFaxNumber' 
 t('mobile') 
 text_field 'user', 'mobile_number', :id => 'userFormMobileNumber' 
 t('home') 
 text_field 'user', 'home_number', :id => 'userFormHomeNumber' 
 all_im_values = @user.im_info 
 if all_im_values.length > 0 
 t('instant_messengers') 
 t('service') 
 t('value') 
 t('primary_im') 
 @count = 0 
 all_im_values.each do |im_value| 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 "userFormIm#{@count}" 
 im_value.im_type.name 
 text_field_tag "user[im_values][#{im_value.im_type_id}][value]", im_value.value, :id => "userFormIm#{@count}" 
 radio_button_tag "user[default_im_value]", im_value.im_type_id, im_value.is_default, :id => 'im_default', :class => 'checkbox' 
 @count += 1 
 end 
 t('instant_messengers_info') 
 end 
 end 
 if @logged_user.member_of_owner? and @user.new_record? and !@active_projects.empty? 
 @permissions.keys.join('\',\'')
 t('permissions') 
  if @companies.length > 0
 form_tag permissions_project_path(:id => @active_project.id), :method => :put 
 @companies.each do |company| 
 if company.users.length > 0 
 company.logo_url 
 h company.name 
 if company.is_owner? 
 h company.name 
 company.id 
 else 
 check_box_tag "project_company[]", "#{company.id}", company.is_part_of(@active_project), {:id => "projectCompany#{@active_project.id}_#{company.id}", :class => 'checkbox', :onclick => "permissions_form_project_select_company('#{@active_project.id}_#{company.id}')"} 
 "project_company[]" 
 h company.name 
 end 
 "#{@active_project.id}_#{company.id}" 
 unless company.is_part_of(@active_project) 
 end 
 unless company.users.empty? 
  perm_id = "#{project.id}_#{company.id}_#{permissions_users.id}" 
 if permissions_users.owner_of_owner? 
 render_icon 'ok', 'Ok' 
 h permissions_users.display_name 
 "people_#{permissions_users.id}" 
 else 
 check_box_tag "people[]", "#{permissions_users.id}", permissions_users.member_of(@active_project), {:id => "projectPermissions#{perm_id}", :class => 'checkbox', :onclick => "permissions_form_project_select('#{perm_id}')"} 
 "projectPermissions#{perm_id}" 
 h permissions_users.display_name 
 end 
 if permissions_users.is_admin? 
 t('administrator') 
 end 
 unless company.is_owner? 
 perm_id 
 unless permissions_users.member_of(project) 
 end 
 check_box_tag "people_#{permissions_users.id}_all", "1", permissions_users.has_all_permissions(project), {:id => "projectPermissions#{perm_id}All", :class => 'checkbox', :onclick => "permissions_form_project_select_all('#{perm_id}')"} 
 "projectPermissions#{perm_id}All" 
 t('all') 
 @permissions.keys.each do |permission| 
 check_box_tag "people_permissions[#{permissions_users.id}][]", "#{permission}", permissions_users.has_permission(project, permission), {:id => "projectPermission#{perm_id}#{permission}", :class => 'checkbox normal', :onclick => "permissions_form_project_select_item('#{perm_id}')"} 
 "projectPermissions#{perm_id}#{permission}" 
 @permissions[permission] 
 end 
 end 
 
 else 
 t('company_no_users') 
 end 
 end 
 end 
 t('update_people') 
 end 
 @permissions.keys.join('\',\'')
 
 end 
 
 t('edit_user') 
 form_tag( avatar_user_path(:id => @user.id), :multipart => true, :method => :put ) 
 error_messages_for :user 
 t('current_avatar') 
 if @user.has_avatar? 
 @user.avatar_url 
 h @user.display_name 
 link_to t('delete_current_avatar'), avatar_user_path(:id => @user.id), {:onclick => :avatar_confirm_delete, :method => :delete} 
 else 
 t('avatar_not_uploaded') 
 end 
 t('new_avatar') 
 if @user.has_avatar? 
 t('avatar_upload_info') 
 end 
 t('update_avatar') 
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
        
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def current
    @user = @logged_user
    authorize! :update_profile, @user

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
 
 form_tag user_path(:id => @user.id), :method => :put 
  error_messages_for :user 
 if @logged_user.is_admin 
 t('administration_options_info') 
 t('username') 
 text_field 'user', 'username', :id => 'userFormUsername' 
 if @logged_user.member_of_owner? 
 t('company') 
 select 'user', 'company_id', Company.select_list, {}, {:id => 'userFormCompany'} 
 t('options') 
 t('administrator') 
 yesno_toggle 'user', 'is_admin', :id => 'userFormIsAdmin', :class => 'checkbox'  
 t('auto_assign_to_new_projects') 
 yesno_toggle 'user', 'auto_assign', :id => 'userFormAutoAssign', :class => 'checkbox'  
 end 
 else 
 t('username') 
 @user.username 
 end 
 t('display_name') 
 text_field 'user', 'display_name', :id => 'userFormDisplayName', :class => 'medium' 
 t('email_address') 
 text_field 'user', 'email', :id => 'profileFormEmail', :class => 'long' 
 t('timezone') 
 time_zone_select 'user', 'time_zone', nil, {}, {:id => 'profileFormTimezone', :class => 'long'} 
 t('password') 
 if @user.new_record? 
 t('generate_password') 
 end 
 t('password') 
 t('repeat_password') 
 if @user.new_record? 
 t('send_account_email_notification') 
 yesno_toggle_tag 'new_account_notification', !!@send_email, :id => 'userFormEmailNotificationYes', :class => 'checkbox' 
 t('send_account_email_notication_info') 
 else 
 t('contact_info') 
 t('title') 
 text_field 'user', 'title', :id => 'userFormTitle' 
 t('office') 
 text_field 'user', 'office_number', :id => 'userFormOfficeNumber' 
 t('office') 
 text_field 'user', 'office_number_ext', :id => 'userFormOfficeNumberExt' 
 t('fax') 
 text_field 'user', 'fax_number', :id => 'userFormFaxNumber' 
 t('mobile') 
 text_field 'user', 'mobile_number', :id => 'userFormMobileNumber' 
 t('home') 
 text_field 'user', 'home_number', :id => 'userFormHomeNumber' 
 all_im_values = @user.im_info 
 if all_im_values.length > 0 
 t('instant_messengers') 
 t('service') 
 t('value') 
 t('primary_im') 
 @count = 0 
 all_im_values.each do |im_value| 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 "userFormIm#{@count}" 
 im_value.im_type.name 
 text_field_tag "user[im_values][#{im_value.im_type_id}][value]", im_value.value, :id => "userFormIm#{@count}" 
 radio_button_tag "user[default_im_value]", im_value.im_type_id, im_value.is_default, :id => 'im_default', :class => 'checkbox' 
 @count += 1 
 end 
 t('instant_messengers_info') 
 end 
 end 
 if @logged_user.member_of_owner? and @user.new_record? and !@active_projects.empty? 
 @permissions.keys.join('\',\'')
 t('permissions') 
  if @companies.length > 0
 form_tag permissions_project_path(:id => @active_project.id), :method => :put 
 @companies.each do |company| 
 if company.users.length > 0 
 company.logo_url 
 h company.name 
 if company.is_owner? 
 h company.name 
 company.id 
 else 
 check_box_tag "project_company[]", "#{company.id}", company.is_part_of(@active_project), {:id => "projectCompany#{@active_project.id}_#{company.id}", :class => 'checkbox', :onclick => "permissions_form_project_select_company('#{@active_project.id}_#{company.id}')"} 
 "project_company[]" 
 h company.name 
 end 
 "#{@active_project.id}_#{company.id}" 
 unless company.is_part_of(@active_project) 
 end 
 unless company.users.empty? 
  perm_id = "#{project.id}_#{company.id}_#{permissions_users.id}" 
 if permissions_users.owner_of_owner? 
 render_icon 'ok', 'Ok' 
 h permissions_users.display_name 
 "people_#{permissions_users.id}" 
 else 
 check_box_tag "people[]", "#{permissions_users.id}", permissions_users.member_of(@active_project), {:id => "projectPermissions#{perm_id}", :class => 'checkbox', :onclick => "permissions_form_project_select('#{perm_id}')"} 
 "projectPermissions#{perm_id}" 
 h permissions_users.display_name 
 end 
 if permissions_users.is_admin? 
 t('administrator') 
 end 
 unless company.is_owner? 
 perm_id 
 unless permissions_users.member_of(project) 
 end 
 check_box_tag "people_#{permissions_users.id}_all", "1", permissions_users.has_all_permissions(project), {:id => "projectPermissions#{perm_id}All", :class => 'checkbox', :onclick => "permissions_form_project_select_all('#{perm_id}')"} 
 "projectPermissions#{perm_id}All" 
 t('all') 
 @permissions.keys.each do |permission| 
 check_box_tag "people_permissions[#{permissions_users.id}][]", "#{permission}", permissions_users.has_permission(project, permission), {:id => "projectPermission#{perm_id}#{permission}", :class => 'checkbox normal', :onclick => "permissions_form_project_select_item('#{perm_id}')"} 
 "projectPermissions#{perm_id}#{permission}" 
 @permissions[permission] 
 end 
 end 
 
 else 
 t('company_no_users') 
 end 
 end 
 end 
 t('update_people') 
 end 
 @permissions.keys.join('\',\'')
 
 end 
 
 t('edit_user') 
 form_tag( avatar_user_path(:id => @user.id), :multipart => true, :method => :put ) 
 error_messages_for :user 
 t('current_avatar') 
 if @user.has_avatar? 
 @user.avatar_url 
 h @user.display_name 
 link_to t('delete_current_avatar'), avatar_user_path(:id => @user.id), {:onclick => :avatar_confirm_delete, :method => :delete} 
 else 
 t('avatar_not_uploaded') 
 end 
 t('new_avatar') 
 if @user.has_avatar? 
 t('avatar_upload_info') 
 end 
 t('update_avatar') 
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

  def destroy
    authorize! :delete, @user
    
    old_name = @user.display_name
    #@user.updated_by = @logged_user
    @user.destroy
    
    respond_to do |format|
      format.html {
        error_status(false, :success_deleted_user, {:name => old_name})
        redirect_back_or_default :controller => 'administration', :action => 'people'
      }
      
      format.xml  { head :ok }
    end
  end

  def avatar
    authorize! :update_profile, @user
    
    case request.request_method_symbol
    when :put
      user_attribs = params[:user]

      new_avatar = user_attribs[:avatar]
      @user.errors.add(:avatar, 'Required') if new_avatar.nil?
      @user.avatar = new_avatar

      if @user.errors.empty?
        if @user.save
          error_status(false, :success_updated_avatar)
        else
          error_status(true, :error_updating_avatar)
        end
        
        redirect_to edit_user_path(:id => @user.id)
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
 
 form_tag user_path(:id => @user.id), :method => :put 
  error_messages_for :user 
 if @logged_user.is_admin 
 t('administration_options_info') 
 t('username') 
 text_field 'user', 'username', :id => 'userFormUsername' 
 if @logged_user.member_of_owner? 
 t('company') 
 select 'user', 'company_id', Company.select_list, {}, {:id => 'userFormCompany'} 
 t('options') 
 t('administrator') 
 yesno_toggle 'user', 'is_admin', :id => 'userFormIsAdmin', :class => 'checkbox'  
 t('auto_assign_to_new_projects') 
 yesno_toggle 'user', 'auto_assign', :id => 'userFormAutoAssign', :class => 'checkbox'  
 end 
 else 
 t('username') 
 @user.username 
 end 
 t('display_name') 
 text_field 'user', 'display_name', :id => 'userFormDisplayName', :class => 'medium' 
 t('email_address') 
 text_field 'user', 'email', :id => 'profileFormEmail', :class => 'long' 
 t('timezone') 
 time_zone_select 'user', 'time_zone', nil, {}, {:id => 'profileFormTimezone', :class => 'long'} 
 t('password') 
 if @user.new_record? 
 t('generate_password') 
 end 
 t('password') 
 t('repeat_password') 
 if @user.new_record? 
 t('send_account_email_notification') 
 yesno_toggle_tag 'new_account_notification', !!@send_email, :id => 'userFormEmailNotificationYes', :class => 'checkbox' 
 t('send_account_email_notication_info') 
 else 
 t('contact_info') 
 t('title') 
 text_field 'user', 'title', :id => 'userFormTitle' 
 t('office') 
 text_field 'user', 'office_number', :id => 'userFormOfficeNumber' 
 t('office') 
 text_field 'user', 'office_number_ext', :id => 'userFormOfficeNumberExt' 
 t('fax') 
 text_field 'user', 'fax_number', :id => 'userFormFaxNumber' 
 t('mobile') 
 text_field 'user', 'mobile_number', :id => 'userFormMobileNumber' 
 t('home') 
 text_field 'user', 'home_number', :id => 'userFormHomeNumber' 
 all_im_values = @user.im_info 
 if all_im_values.length > 0 
 t('instant_messengers') 
 t('service') 
 t('value') 
 t('primary_im') 
 @count = 0 
 all_im_values.each do |im_value| 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 "userFormIm#{@count}" 
 im_value.im_type.name 
 text_field_tag "user[im_values][#{im_value.im_type_id}][value]", im_value.value, :id => "userFormIm#{@count}" 
 radio_button_tag "user[default_im_value]", im_value.im_type_id, im_value.is_default, :id => 'im_default', :class => 'checkbox' 
 @count += 1 
 end 
 t('instant_messengers_info') 
 end 
 end 
 if @logged_user.member_of_owner? and @user.new_record? and !@active_projects.empty? 
 @permissions.keys.join('\',\'')
 t('permissions') 
  if @companies.length > 0
 form_tag permissions_project_path(:id => @active_project.id), :method => :put 
 @companies.each do |company| 
 if company.users.length > 0 
 company.logo_url 
 h company.name 
 if company.is_owner? 
 h company.name 
 company.id 
 else 
 check_box_tag "project_company[]", "#{company.id}", company.is_part_of(@active_project), {:id => "projectCompany#{@active_project.id}_#{company.id}", :class => 'checkbox', :onclick => "permissions_form_project_select_company('#{@active_project.id}_#{company.id}')"} 
 "project_company[]" 
 h company.name 
 end 
 "#{@active_project.id}_#{company.id}" 
 unless company.is_part_of(@active_project) 
 end 
 unless company.users.empty? 
  perm_id = "#{project.id}_#{company.id}_#{permissions_users.id}" 
 if permissions_users.owner_of_owner? 
 render_icon 'ok', 'Ok' 
 h permissions_users.display_name 
 "people_#{permissions_users.id}" 
 else 
 check_box_tag "people[]", "#{permissions_users.id}", permissions_users.member_of(@active_project), {:id => "projectPermissions#{perm_id}", :class => 'checkbox', :onclick => "permissions_form_project_select('#{perm_id}')"} 
 "projectPermissions#{perm_id}" 
 h permissions_users.display_name 
 end 
 if permissions_users.is_admin? 
 t('administrator') 
 end 
 unless company.is_owner? 
 perm_id 
 unless permissions_users.member_of(project) 
 end 
 check_box_tag "people_#{permissions_users.id}_all", "1", permissions_users.has_all_permissions(project), {:id => "projectPermissions#{perm_id}All", :class => 'checkbox', :onclick => "permissions_form_project_select_all('#{perm_id}')"} 
 "projectPermissions#{perm_id}All" 
 t('all') 
 @permissions.keys.each do |permission| 
 check_box_tag "people_permissions[#{permissions_users.id}][]", "#{permission}", permissions_users.has_permission(project, permission), {:id => "projectPermission#{perm_id}#{permission}", :class => 'checkbox normal', :onclick => "permissions_form_project_select_item('#{perm_id}')"} 
 "projectPermissions#{perm_id}#{permission}" 
 @permissions[permission] 
 end 
 end 
 
 else 
 t('company_no_users') 
 end 
 end 
 end 
 t('update_people') 
 end 
 @permissions.keys.join('\',\'')
 
 end 
 
 t('edit_user') 
 form_tag( avatar_user_path(:id => @user.id), :multipart => true, :method => :put ) 
 error_messages_for :user 
 t('current_avatar') 
 if @user.has_avatar? 
 @user.avatar_url 
 h @user.display_name 
 link_to t('delete_current_avatar'), avatar_user_path(:id => @user.id), {:onclick => :avatar_confirm_delete, :method => :delete} 
 else 
 t('avatar_not_uploaded') 
 end 
 t('new_avatar') 
 if @user.has_avatar? 
 t('avatar_upload_info') 
 end 
 t('update_avatar') 
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
    when :delete
      @user.avatar = nil
      @user.save

      error_status(false, :success_deleted_avatar)
      redirect_to edit_user_path(:id => @user.id)
    end
  end

  def show
    authorize! :show, @user
    
    respond_to do |format|
      format.html { }
      
      format.xml  {
        if @user.is_admin
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
  if can?(:update_profile, @user)
	  @page_actions += [{:title => :edit, :url => edit_user_path(:id => @user.id)}]
  end
  
  if can?(:update_permissions, @user)
  	@page_actions << {:title => :update_permissions, :url => permissions_user_path(:id => @user.id)}
  end


   card.avatar_url 
 h card.display_name 
 h card.display_name 
 t('title') 
 card.title ? (h card.title) : t('not_applicable') 
 t('company') 
 link_to card.company.name, company_path(:id => card.company.id) 
 t('contact_online') 
 t('email_address') 
 h card.email 
 h card.email 
 if !card.im_values.empty? 
 card.im_values.each do |im_value| 
 next if im_value.value.blank? 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 h im_value.value 
 if im_value.is_default 
 t('primary_im') 
 end 
 end 
 end 
 if !card.office_number.nil? or !card.fax_number.nil? or !card.mobile_number.nil? or !card.home_number.nil? 
 t('contact_offline') 
 if !card.office_number.nil? and !card.office_number.empty? 
 t('office') 
 h(card.office_number) 
 end 
 if !card.fax_number.nil? and !card.fax_number.empty? 
 t('fax') 
 h(card.fax_number) 
 end 
 if !card.mobile_number.nil? and !card.mobile_number.empty? 
 t('mobile') 
 h(card.mobile_number) 
 end 
 if !card.home_number.nil? and !card.home_number.empty? 
 t('home') 
 h(card.home_number) 
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

        else
          attribs = [:id,
                     :company_id,
                     :avatar_file_name,
                     :display-name,
                     :email,
                     :fax,
                     :home_number,
                     :mobile_number,
                     :office_number,
                     :office_number_ext,
                     :time_zone,
                     :title]
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
  if can?(:update_profile, @user)
	  @page_actions += [{:title => :edit, :url => edit_user_path(:id => @user.id)}]
  end
  
  if can?(:update_permissions, @user)
  	@page_actions << {:title => :update_permissions, :url => permissions_user_path(:id => @user.id)}
  end


   card.avatar_url 
 h card.display_name 
 h card.display_name 
 t('title') 
 card.title ? (h card.title) : t('not_applicable') 
 t('company') 
 link_to card.company.name, company_path(:id => card.company.id) 
 t('contact_online') 
 t('email_address') 
 h card.email 
 h card.email 
 if !card.im_values.empty? 
 card.im_values.each do |im_value| 
 next if im_value.value.blank? 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 h im_value.value 
 if im_value.is_default 
 t('primary_im') 
 end 
 end 
 end 
 if !card.office_number.nil? or !card.fax_number.nil? or !card.mobile_number.nil? or !card.home_number.nil? 
 t('contact_offline') 
 if !card.office_number.nil? and !card.office_number.empty? 
 t('office') 
 h(card.office_number) 
 end 
 if !card.fax_number.nil? and !card.fax_number.empty? 
 t('fax') 
 h(card.fax_number) 
 end 
 if !card.mobile_number.nil? and !card.mobile_number.empty? 
 t('mobile') 
 h(card.mobile_number) 
 end 
 if !card.home_number.nil? and !card.home_number.empty? 
 t('home') 
 h(card.home_number) 
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
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
  if can?(:update_profile, @user)
	  @page_actions += [{:title => :edit, :url => edit_user_path(:id => @user.id)}]
  end
  
  if can?(:update_permissions, @user)
  	@page_actions << {:title => :update_permissions, :url => permissions_user_path(:id => @user.id)}
  end


   card.avatar_url 
 h card.display_name 
 h card.display_name 
 t('title') 
 card.title ? (h card.title) : t('not_applicable') 
 t('company') 
 link_to card.company.name, company_path(:id => card.company.id) 
 t('contact_online') 
 t('email_address') 
 h card.email 
 h card.email 
 if !card.im_values.empty? 
 card.im_values.each do |im_value| 
 next if im_value.value.blank? 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 h im_value.value 
 if im_value.is_default 
 t('primary_im') 
 end 
 end 
 end 
 if !card.office_number.nil? or !card.fax_number.nil? or !card.mobile_number.nil? or !card.home_number.nil? 
 t('contact_offline') 
 if !card.office_number.nil? and !card.office_number.empty? 
 t('office') 
 h(card.office_number) 
 end 
 if !card.fax_number.nil? and !card.fax_number.empty? 
 t('fax') 
 h(card.fax_number) 
 end 
 if !card.mobile_number.nil? and !card.mobile_number.empty? 
 t('mobile') 
 h(card.mobile_number) 
 end 
 if !card.home_number.nil? and !card.home_number.empty? 
 t('home') 
 h(card.home_number) 
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

  def permissions
    authorize! :update_profile, @user

    @projects = @user.company.projects
    @permissions = Person.permission_names()

    case request.request_method_symbol
    when :put
      update_project_permissions(@user, params[:user_project], params[:project_permission], @projects)
      #Activity.new_log(@project, @logged_user, :edit, true)
      error_status(false, :success_updated_permissions)
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
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
 
 @permissions.keys.join('\',\'')
 unless @projects.empty? 
 form_tag permissions_user_path(:id => @user.id), :method => :put 
  if @companies.length > 0
 form_tag permissions_project_path(:id => @active_project.id), :method => :put 
 @companies.each do |company| 
 if company.users.length > 0 
 company.logo_url 
 h company.name 
 if company.is_owner? 
 h company.name 
 company.id 
 else 
 check_box_tag "project_company[]", "#{company.id}", company.is_part_of(@active_project), {:id => "projectCompany#{@active_project.id}_#{company.id}", :class => 'checkbox', :onclick => "permissions_form_project_select_company('#{@active_project.id}_#{company.id}')"} 
 "project_company[]" 
 h company.name 
 end 
 "#{@active_project.id}_#{company.id}" 
 unless company.is_part_of(@active_project) 
 end 
 unless company.users.empty? 
  perm_id = "#{project.id}_#{company.id}_#{permissions_users.id}" 
 if permissions_users.owner_of_owner? 
 render_icon 'ok', 'Ok' 
 h permissions_users.display_name 
 "people_#{permissions_users.id}" 
 else 
 check_box_tag "people[]", "#{permissions_users.id}", permissions_users.member_of(@active_project), {:id => "projectPermissions#{perm_id}", :class => 'checkbox', :onclick => "permissions_form_project_select('#{perm_id}')"} 
 "projectPermissions#{perm_id}" 
 h permissions_users.display_name 
 end 
 if permissions_users.is_admin? 
 t('administrator') 
 end 
 unless company.is_owner? 
 perm_id 
 unless permissions_users.member_of(project) 
 end 
 check_box_tag "people_#{permissions_users.id}_all", "1", permissions_users.has_all_permissions(project), {:id => "projectPermissions#{perm_id}All", :class => 'checkbox', :onclick => "permissions_form_project_select_all('#{perm_id}')"} 
 "projectPermissions#{perm_id}All" 
 t('all') 
 @permissions.keys.each do |permission| 
 check_box_tag "people_permissions[#{permissions_users.id}][]", "#{permission}", permissions_users.has_permission(project, permission), {:id => "projectPermission#{perm_id}#{permission}", :class => 'checkbox normal', :onclick => "permissions_form_project_select_item('#{perm_id}')"} 
 "projectPermissions#{perm_id}#{permission}" 
 @permissions[permission] 
 end 
 end 
 
 else 
 t('company_no_users') 
 end 
 end 
 end 
 t('update_people') 
 end 
 @permissions.keys.join('\',\'')
 
 t('update_permissions') 
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

  private
  
  def update_project_permissions(user, project_ids, project_permission, old_projects = nil)
    project_ids ||= []

    # Grab the list of project id's specified
    project_list = Project.where(:id => project_ids & user.project_ids)

    # Associate project permissions with user
    project_list.each do |project|
      permission_list = project_permission.nil? ? nil : project_permission[project.id.to_s]

      # Find permission list
      person = project.people.find_or_create_by_user_id user.id

      # Reset and update permissions
      person.reset_permissions
      person.update_str permission_list unless permission_list.nil?
      person.save
    end

    unless old_projects.nil?
    # Delete all permissions that aren't in the project list
      delete_list = old_projects.collect do |project|
        project.id unless project_list.include?(project)
      end.compact

      unless delete_list.empty?
        Person.delete_all(:user_id => user.id, :project_id => delete_list)
      end
    end
  end

  def obtain_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :invalid_user)
      redirect_back_or_default :controller => 'dashboard'
      return false
    end

    true
  end
end
