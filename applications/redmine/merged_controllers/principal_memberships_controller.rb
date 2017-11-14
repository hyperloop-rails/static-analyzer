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

class PrincipalMembershipsController < ApplicationController
  layout 'admin'

  before_action :require_admin
  before_action :find_principal, :only => [:new, :create]
  before_action :find_membership, :only => [:update, :destroy]

  def new
    @projects = Project.active.all
    @roles = Role.find_all_givable
    respond_to do |format|
      format.html
      format.js
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 l(:label_add_projects) 
 form_for :membership, :url => user_memberships_path(@principal), :method => :post do |f| 
 render :partial => 'new_form' 
 submit_tag l(:button_add), :name => nil 
 end 

 l(:label_project_plural) 
 toggle_checkboxes_link('.projects-selection input:enabled') 
 render_project_nested_lists(@projects) do |p| 
 check_box_tag('membership[project_ids][]', p.id, false, :id => nil, :disabled => @principal.member_of?(p)) 
 p 
 end 
 l(:label_role_plural) 
 toggle_checkboxes_link('.roles-selection input') 
 @roles.each do |role| 
 check_box_tag 'membership[role_ids][]', role.id, false, :id => nil 
 role 
 end 

end

  def create
    @members = Member.create_principal_memberships(@principal, params[:membership])
    respond_to do |format|
      format.html { redirect_to_principal @principal }
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

  def update
    @membership.attributes = params[:membership]
    @membership.save
    respond_to do |format|
      format.html { redirect_to_principal @principal }
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

  def destroy
    if @membership.deletable?
      @membership.destroy
    end
    respond_to do |format|
      format.html { redirect_to_principal @principal }
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

  def find_principal
    principal_id = params[:user_id] || params[:group_id]
    @principal = Principal.find(principal_id)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_membership
    @membership = Member.find(params[:id])
    @principal = @membership.principal
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def redirect_to_principal(principal)
    redirect_to edit_polymorphic_path(principal, :tab => 'memberships')
  end
end
