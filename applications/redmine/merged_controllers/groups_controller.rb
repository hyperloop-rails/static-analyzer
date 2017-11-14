
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 l(:label_user_new) 
 form_for(@group, :url => group_users_path(@group), :method => :post) do |f| 
 render :partial => 'new_users_form' 
 submit_tag l(:button_add) 
 end 

 label_tag "user_search", l(:label_user_search) 
 text_field_tag 'user_search', nil 
 javascript_tag "observeSearchfield('user_search', null, '#{ escape_javascript autocomplete_for_user_group_path(@group) }')" 
 render_principals_for_new_group_users(@group) 


 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_group_plural), groups_path], @group.name 
 render_tabs group_settings_tabs(@group) 

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

class GroupsController < ApplicationController
  layout 'admin'

  before_action :require_admin
  before_action :find_group, :except => [:index, :new, :create]
  accept_api_auth :index, :show, :create, :update, :destroy, :add_users, :remove_user

  require_sudo_mode :add_users, :remove_user, :create, :update, :destroy, :edit_membership, :destroy_membership

  helper :custom_fields
  helper :principal_memberships

  def index
    respond_to do |format|
      format.html {
        @groups = Group.sorted.to_a
        @user_count_by_group_id = user_count_by_group_id
      }
      format.api {
        scope = Group.sorted
        scope = scope.givable unless params[:builtin] == '1'
        @groups = scope.to_a
      }
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 link_to l(:label_group_new), new_group_path, :class => 'icon icon-add' 
 title l(:label_group_plural) 
 if @groups.any? 
l(:label_group)
l(:label_user_plural)
 @groups.each do |group| 
 group.id 
 cycle 'odd', 'even' 
 "builtin" if group.builtin? 
 link_to group, edit_group_path(group) 
 (@user_count_by_group_id[group.id] || 0) unless group.builtin? 
 delete_link group unless group.builtin? 
 end 
 else 
 l(:label_no_data) 
 end 

end

  def show
    respond_to do |format|
      format.html
      format.api
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_group_plural), groups_path], @group.name 
 @group.users.each do |user| 
 user 
 end 

end

  def new
    @group = Group.new
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_group_plural), groups_path], l(:label_group_new) 
 labelled_form_for @group do |f| 
 render :partial => 'form', :locals => { :f => f } 
 f.submit l(:button_create) 
 f.submit l(:button_create_and_continue), :name => 'continue' 
 end 

 error_messages_for @group 
 f.text_field :name, :required => true, :size => 60,
           :disabled => !@group.safe_attribute?('name')  
 @group.custom_field_values.each do |value| 
 custom_field_tag_with_label :group, value 
 end 

end

  def create
    @group = Group.new
    @group.safe_attributes = params[:group]

    respond_to do |format|
      if @group.save
        format.html {
          flash[:notice] = l(:notice_successful_create)
          redirect_to(params[:continue] ? new_group_path : groups_path)
        }
        format.api  { render :action => 'show', :status => :created, :location => group_url(@group) }
      else
        format.html { render :action => "new" }
        format.api  { render_validation_errors(@group) }
      end
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_group_plural), groups_path], @group.name 
 @group.users.each do |user| 
 user 
 end 

 title [l(:label_group_plural), groups_path], l(:label_group_new) 
 labelled_form_for @group do |f| 
 render :partial => 'form', :locals => { :f => f } 
 f.submit l(:button_create) 
 f.submit l(:button_create_and_continue), :name => 'continue' 
 end 

 error_messages_for @group 
 f.text_field :name, :required => true, :size => 60,
           :disabled => !@group.safe_attribute?('name')  
 @group.custom_field_values.each do |value| 
 custom_field_tag_with_label :group, value 
 end 

end

  def edit
  end

  def update
    @group.safe_attributes = params[:group]

    respond_to do |format|
      if @group.save
        flash[:notice] = l(:notice_successful_update)
        format.html { redirect_to(groups_path) }
        format.api  { render_api_ok }
      else
        format.html { render :action => "edit" }
        format.api  { render_validation_errors(@group) }
      end
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_group_plural), groups_path], @group.name 
 render_tabs group_settings_tabs(@group) 

end

  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_path) }
      format.api  { render_api_ok }
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  def new_users
  end

  def add_users
    @users = User.not_in_group(@group).where(:id => (params[:user_id] || params[:user_ids])).to_a
    @group.users << @users
    respond_to do |format|
      format.html { redirect_to edit_group_path(@group, :tab => 'users') }
      format.js
      format.api {
        if @users.any?
          render_api_ok
        else
          render_api_errors "#{l(:label_user)} #{l('activerecord.errors.messages.invalid')}"
        end
      }
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  def remove_user
    @group.users.delete(User.find(params[:user_id])) if request.delete?
    respond_to do |format|
      format.html { redirect_to edit_group_path(@group, :tab => 'users') }
      format.js
      format.api { render_api_ok }
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  def autocomplete_for_user
    respond_to do |format|
      format.js
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  private

  def find_group
    @group = Group.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def user_count_by_group_id
    h = User.joins(:groups).group('group_id').count
    h.keys.each do |key|
      h[key.to_i] = h.delete(key)
    end
    h
  end
end
