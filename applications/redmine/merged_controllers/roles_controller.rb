
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_role_plural), roles_path], @role.name 
 labelled_form_for @role do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_save) 
 end 

 error_messages_for 'role' 
 unless @role.builtin? 
 f.text_field :name, :required => true 
 f.check_box :assignable 
 end 
 unless @role.anonymous? 
 f.select :issues_visibility, Role::ISSUES_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 end 
 unless @role.anonymous? 
 f.select :time_entries_visibility, Role::TIME_ENTRIES_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 end 
 f.select :users_visibility, Role::USERS_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 unless @role.builtin? 
 l(:label_member_management) 
 radio_button_tag 'role[all_roles_managed]', 1, @role.all_roles_managed?, :id => 'role_all_roles_managed_on',
              :data => {:disables => '.role_managed_role input'} 
 l(:label_member_management_all_roles) 
 radio_button_tag 'role[all_roles_managed]', 0, !@role.all_roles_managed?, :id => 'role_all_roles_managed_off',
              :data => {:enables => '.role_managed_role input'} 
 l(:label_member_management_selected_roles_only) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'role[managed_role_ids][]', role.id, @role.managed_roles.to_a.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'role[managed_role_ids][]', '' 
 end 
 if @role.new_record? && @roles.any? 
 l(:label_copy_workflow_from) 
 select_tag(:copy_workflow_from, content_tag("option") + options_from_collection_for_select(@roles, :id, :name, params[:copy_workflow_from] || @copy_from.try(:id))) 
 end 
 l(:label_permissions) 
 perms_by_module = @role.setable_permissions.group_by {|p| p.project_module.to_s} 
 perms_by_module.keys.sort.each do |mod| 
 mod.blank? ? l(:label_project) : l_or_humanize(mod, :prefix => 'project_module_') 
 perms_by_module[mod].each do |permission| 
 check_box_tag 'role[permissions][]', permission.name, (@role.permissions.include? permission.name),
              :id => "role_permissions_#{permission.name}",
              :data => {:shows => ".#{permission.name}_shown"} 
 l_or_humanize(permission.name, :prefix => 'permission_') 
 end 
 end 
 check_all_links 'permissions' 
 hidden_field_tag 'role[permissions][]', '' 
 l(:label_issue_tracking) 
 permissions = %w(view_issues add_issues edit_issues add_issue_notes delete_issues) 
 l(:label_tracker) 
 permissions.each do |permission| 
 "#{permission}_shown" 
 l("permission_#{permission}") 
 end 
 l(:label_tracker_all) 
 permissions.each do |permission| 
 "#{permission}_shown" 
 hidden_field_tag "role[permissions_all_trackers][#{permission}]", '0', :id => nil 
 check_box_tag "role[permissions_all_trackers][#{permission}]",
              '1',
              @role.permissions_all_trackers?(permission),
              :class => "#{permission}_shown",
              :data => {:disables => ".#{permission}_tracker"} 
 end 
 Tracker.sorted.all.each do |tracker| 
 cycle("odd", "even") 
 tracker.name 
 permissions.each do |permission| 
 "#{permission}_shown" 
 check_box_tag "role[permissions_tracker_ids][#{permission}][]",
                tracker.id,
                @role.permissions_tracker_ids?(permission, tracker.id),
                :class => "#{permission}_tracker",
                :id => "role_permissions_tracker_ids_add_issues_#{tracker.id}" 
 end 
 end 
 permissions.each do |permission| 
 hidden_field_tag "role[permissions_tracker_ids][#{permission}][]", '' 
 end 

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

class RolesController < ApplicationController
  layout 'admin'

  before_action :require_admin, :except => [:index, :show]
  before_action :require_admin_or_api_request, :only => [:index, :show]
  before_action :find_role, :only => [:show, :edit, :update, :destroy]
  accept_api_auth :index, :show

  require_sudo_mode :create, :update, :destroy

  def index
    respond_to do |format|
      format.html {
        @roles = Role.sorted.to_a
        render :layout => false if request.xhr?
      }
      format.api {
        @roles = Role.givable.to_a
      }
    end
  
 link_to l(:label_role_new), new_role_path, :class => 'icon icon-add' 
 link_to l(:label_permissions_report), permissions_roles_path, :class => 'icon icon-summary' 
l(:label_role_plural)
l(:label_role)
 for role in @roles 
 cycle("odd", "even") 
 role.builtin? ? "builtin" : "givable" 
 content_tag(role.builtin? ? 'em' : 'span', link_to(role.name, edit_role_path(role))) 
 reorder_handle(role) unless role.builtin? 
 link_to l(:button_copy), new_role_path(:copy => role), :class => 'icon icon-copy' 
 delete_link role_path(role) unless role.builtin? 
 end 
 html_title(l(:label_role_plural)) 
 javascript_tag do 
 end 

end

  def show
    respond_to do |format|
      format.api
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  def new
    # Prefills the form with 'Non member' role permissions by default
    @role = Role.new
    @role.safe_attributes = params[:role] || {:permissions => Role.non_member.permissions}
    if params[:copy].present? && @copy_from = Role.find_by_id(params[:copy])
      @role.copy_from(@copy_from)
    end
    @roles = Role.sorted.to_a
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_role_plural), roles_path], l(:label_role_new) 
 labelled_form_for @role do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_create) 
 end 

 error_messages_for 'role' 
 unless @role.builtin? 
 f.text_field :name, :required => true 
 f.check_box :assignable 
 end 
 unless @role.anonymous? 
 f.select :issues_visibility, Role::ISSUES_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 end 
 unless @role.anonymous? 
 f.select :time_entries_visibility, Role::TIME_ENTRIES_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 end 
 f.select :users_visibility, Role::USERS_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 unless @role.builtin? 
 l(:label_member_management) 
 radio_button_tag 'role[all_roles_managed]', 1, @role.all_roles_managed?, :id => 'role_all_roles_managed_on',
              :data => {:disables => '.role_managed_role input'} 
 l(:label_member_management_all_roles) 
 radio_button_tag 'role[all_roles_managed]', 0, !@role.all_roles_managed?, :id => 'role_all_roles_managed_off',
              :data => {:enables => '.role_managed_role input'} 
 l(:label_member_management_selected_roles_only) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'role[managed_role_ids][]', role.id, @role.managed_roles.to_a.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'role[managed_role_ids][]', '' 
 end 
 if @role.new_record? && @roles.any? 
 l(:label_copy_workflow_from) 
 select_tag(:copy_workflow_from, content_tag("option") + options_from_collection_for_select(@roles, :id, :name, params[:copy_workflow_from] || @copy_from.try(:id))) 
 end 
 l(:label_permissions) 
 perms_by_module = @role.setable_permissions.group_by {|p| p.project_module.to_s} 
 perms_by_module.keys.sort.each do |mod| 
 mod.blank? ? l(:label_project) : l_or_humanize(mod, :prefix => 'project_module_') 
 perms_by_module[mod].each do |permission| 
 check_box_tag 'role[permissions][]', permission.name, (@role.permissions.include? permission.name),
              :id => "role_permissions_#{permission.name}",
              :data => {:shows => ".#{permission.name}_shown"} 
 l_or_humanize(permission.name, :prefix => 'permission_') 
 end 
 end 
 check_all_links 'permissions' 
 hidden_field_tag 'role[permissions][]', '' 
 l(:label_issue_tracking) 
 permissions = %w(view_issues add_issues edit_issues add_issue_notes delete_issues) 
 l(:label_tracker) 
 permissions.each do |permission| 
 "#{permission}_shown" 
 l("permission_#{permission}") 
 end 
 l(:label_tracker_all) 
 permissions.each do |permission| 
 "#{permission}_shown" 
 hidden_field_tag "role[permissions_all_trackers][#{permission}]", '0', :id => nil 
 check_box_tag "role[permissions_all_trackers][#{permission}]",
              '1',
              @role.permissions_all_trackers?(permission),
              :class => "#{permission}_shown",
              :data => {:disables => ".#{permission}_tracker"} 
 end 
 Tracker.sorted.all.each do |tracker| 
 cycle("odd", "even") 
 tracker.name 
 permissions.each do |permission| 
 "#{permission}_shown" 
 check_box_tag "role[permissions_tracker_ids][#{permission}][]",
                tracker.id,
                @role.permissions_tracker_ids?(permission, tracker.id),
                :class => "#{permission}_tracker",
                :id => "role_permissions_tracker_ids_add_issues_#{tracker.id}" 
 end 
 end 
 permissions.each do |permission| 
 hidden_field_tag "role[permissions_tracker_ids][#{permission}][]", '' 
 end 

end

  def create
    @role = Role.new
    @role.safe_attributes = params[:role]
    if request.post? && @role.save
      # workflow copy
      if !params[:copy_workflow_from].blank? && (copy_from = Role.find_by_id(params[:copy_workflow_from]))
        @role.workflow_rules.copy(copy_from)
      end
      flash[:notice] = l(:notice_successful_create)
      redirect_to roles_path
    else
      @roles = Role.sorted.to_a
      render :action => 'new'
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_role_plural), roles_path], l(:label_role_new) 
 labelled_form_for @role do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_create) 
 end 

 error_messages_for 'role' 
 unless @role.builtin? 
 f.text_field :name, :required => true 
 f.check_box :assignable 
 end 
 unless @role.anonymous? 
 f.select :issues_visibility, Role::ISSUES_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 end 
 unless @role.anonymous? 
 f.select :time_entries_visibility, Role::TIME_ENTRIES_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 end 
 f.select :users_visibility, Role::USERS_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 unless @role.builtin? 
 l(:label_member_management) 
 radio_button_tag 'role[all_roles_managed]', 1, @role.all_roles_managed?, :id => 'role_all_roles_managed_on',
              :data => {:disables => '.role_managed_role input'} 
 l(:label_member_management_all_roles) 
 radio_button_tag 'role[all_roles_managed]', 0, !@role.all_roles_managed?, :id => 'role_all_roles_managed_off',
              :data => {:enables => '.role_managed_role input'} 
 l(:label_member_management_selected_roles_only) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'role[managed_role_ids][]', role.id, @role.managed_roles.to_a.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'role[managed_role_ids][]', '' 
 end 
 if @role.new_record? && @roles.any? 
 l(:label_copy_workflow_from) 
 select_tag(:copy_workflow_from, content_tag("option") + options_from_collection_for_select(@roles, :id, :name, params[:copy_workflow_from] || @copy_from.try(:id))) 
 end 
 l(:label_permissions) 
 perms_by_module = @role.setable_permissions.group_by {|p| p.project_module.to_s} 
 perms_by_module.keys.sort.each do |mod| 
 mod.blank? ? l(:label_project) : l_or_humanize(mod, :prefix => 'project_module_') 
 perms_by_module[mod].each do |permission| 
 check_box_tag 'role[permissions][]', permission.name, (@role.permissions.include? permission.name),
              :id => "role_permissions_#{permission.name}",
              :data => {:shows => ".#{permission.name}_shown"} 
 l_or_humanize(permission.name, :prefix => 'permission_') 
 end 
 end 
 check_all_links 'permissions' 
 hidden_field_tag 'role[permissions][]', '' 
 l(:label_issue_tracking) 
 permissions = %w(view_issues add_issues edit_issues add_issue_notes delete_issues) 
 l(:label_tracker) 
 permissions.each do |permission| 
 "#{permission}_shown" 
 l("permission_#{permission}") 
 end 
 l(:label_tracker_all) 
 permissions.each do |permission| 
 "#{permission}_shown" 
 hidden_field_tag "role[permissions_all_trackers][#{permission}]", '0', :id => nil 
 check_box_tag "role[permissions_all_trackers][#{permission}]",
              '1',
              @role.permissions_all_trackers?(permission),
              :class => "#{permission}_shown",
              :data => {:disables => ".#{permission}_tracker"} 
 end 
 Tracker.sorted.all.each do |tracker| 
 cycle("odd", "even") 
 tracker.name 
 permissions.each do |permission| 
 "#{permission}_shown" 
 check_box_tag "role[permissions_tracker_ids][#{permission}][]",
                tracker.id,
                @role.permissions_tracker_ids?(permission, tracker.id),
                :class => "#{permission}_tracker",
                :id => "role_permissions_tracker_ids_add_issues_#{tracker.id}" 
 end 
 end 
 permissions.each do |permission| 
 hidden_field_tag "role[permissions_tracker_ids][#{permission}][]", '' 
 end 

end

  def edit
  end

  def update
    @role.safe_attributes = params[:role]
    if @role.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_to roles_path(:page => params[:page])
        }
        format.js { head 200 }
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.js { head 422 }
      end
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_role_plural), roles_path], @role.name 
 labelled_form_for @role do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_save) 
 end 

 error_messages_for 'role' 
 unless @role.builtin? 
 f.text_field :name, :required => true 
 f.check_box :assignable 
 end 
 unless @role.anonymous? 
 f.select :issues_visibility, Role::ISSUES_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 end 
 unless @role.anonymous? 
 f.select :time_entries_visibility, Role::TIME_ENTRIES_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 end 
 f.select :users_visibility, Role::USERS_VISIBILITY_OPTIONS.collect {|v| [l(v.last), v.first]} 
 unless @role.builtin? 
 l(:label_member_management) 
 radio_button_tag 'role[all_roles_managed]', 1, @role.all_roles_managed?, :id => 'role_all_roles_managed_on',
              :data => {:disables => '.role_managed_role input'} 
 l(:label_member_management_all_roles) 
 radio_button_tag 'role[all_roles_managed]', 0, !@role.all_roles_managed?, :id => 'role_all_roles_managed_off',
              :data => {:enables => '.role_managed_role input'} 
 l(:label_member_management_selected_roles_only) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'role[managed_role_ids][]', role.id, @role.managed_roles.to_a.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'role[managed_role_ids][]', '' 
 end 
 if @role.new_record? && @roles.any? 
 l(:label_copy_workflow_from) 
 select_tag(:copy_workflow_from, content_tag("option") + options_from_collection_for_select(@roles, :id, :name, params[:copy_workflow_from] || @copy_from.try(:id))) 
 end 
 l(:label_permissions) 
 perms_by_module = @role.setable_permissions.group_by {|p| p.project_module.to_s} 
 perms_by_module.keys.sort.each do |mod| 
 mod.blank? ? l(:label_project) : l_or_humanize(mod, :prefix => 'project_module_') 
 perms_by_module[mod].each do |permission| 
 check_box_tag 'role[permissions][]', permission.name, (@role.permissions.include? permission.name),
              :id => "role_permissions_#{permission.name}",
              :data => {:shows => ".#{permission.name}_shown"} 
 l_or_humanize(permission.name, :prefix => 'permission_') 
 end 
 end 
 check_all_links 'permissions' 
 hidden_field_tag 'role[permissions][]', '' 
 l(:label_issue_tracking) 
 permissions = %w(view_issues add_issues edit_issues add_issue_notes delete_issues) 
 l(:label_tracker) 
 permissions.each do |permission| 
 "#{permission}_shown" 
 l("permission_#{permission}") 
 end 
 l(:label_tracker_all) 
 permissions.each do |permission| 
 "#{permission}_shown" 
 hidden_field_tag "role[permissions_all_trackers][#{permission}]", '0', :id => nil 
 check_box_tag "role[permissions_all_trackers][#{permission}]",
              '1',
              @role.permissions_all_trackers?(permission),
              :class => "#{permission}_shown",
              :data => {:disables => ".#{permission}_tracker"} 
 end 
 Tracker.sorted.all.each do |tracker| 
 cycle("odd", "even") 
 tracker.name 
 permissions.each do |permission| 
 "#{permission}_shown" 
 check_box_tag "role[permissions_tracker_ids][#{permission}][]",
                tracker.id,
                @role.permissions_tracker_ids?(permission, tracker.id),
                :class => "#{permission}_tracker",
                :id => "role_permissions_tracker_ids_add_issues_#{tracker.id}" 
 end 
 end 
 permissions.each do |permission| 
 hidden_field_tag "role[permissions_tracker_ids][#{permission}][]", '' 
 end 

end

  def destroy
    @role.destroy
    redirect_to roles_path
  rescue
    flash[:error] =  l(:error_can_not_remove_role)
    redirect_to roles_path
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  def permissions
    @roles = Role.sorted.to_a
    @permissions = Redmine::AccessControl.permissions.select { |p| !p.public? }
    if request.post?
      @roles.each do |role|
        role.permissions = params[:permissions][role.id.to_s]
        role.save
      end
      flash[:notice] = l(:notice_successful_update)
      redirect_to roles_path
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_role_plural), roles_path], l(:label_permissions_report) 
 form_tag(permissions_roles_path, :id => 'permissions_form') do 
 hidden_field_tag 'permissions[0]', '', :id => nil 
l(:label_permissions)
 @roles.each do |role| 
 link_to_function('',
                             "toggleCheckboxesBySelector('input.role-#{role.id}')",
                             :title => "#{l(:button_check_all)}/#{l(:button_uncheck_all)}",
                             :class => 'icon-only icon-checked') 
 content_tag(role.builtin? ? 'em' : 'span', role.name) 
 end 
 perms_by_module = @permissions.group_by {|p| p.project_module.to_s} 
 perms_by_module.keys.sort.each do |mod| 
 unless mod.blank? 
 l_or_humanize(mod, :prefix => 'project_module_') 
 @roles.each do |role| 
 role.name 
 end 
 end 
 perms_by_module[mod].each do |permission| 
 cycle('odd', 'even') 
 permission.name 
 link_to_function('',
                                 "toggleCheckboxesBySelector('.permission-#{permission.name} input')",
                                 :title => "#{l(:button_check_all)}/#{l(:button_uncheck_all)}",
                                 :class => 'icon-only icon-checked') 
 l_or_humanize(permission.name, :prefix => 'permission_') 
 @roles.each do |role| 
 if role.setable_permissions.include? permission 
 check_box_tag "permissions[#{role.id}][]", permission.name, (role.permissions.include? permission.name), :id => nil, :class => "role-#{role.id}" 
 end 
 end 
 end 
 end 
 check_all_links 'permissions_form' 
 submit_tag l(:button_save) 
 end 

end

  private

  def find_role
    @role = Role.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
