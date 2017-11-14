
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(@enumeration.option_name), enumerations_path], @enumeration.name 
 labelled_form_for :enumeration, @enumeration, :url => enumeration_path(@enumeration), :html => {:method => :put} do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_save) 
 end 

 error_messages_for 'enumeration' 
 f.text_field :name 
 f.check_box :active 
 f.check_box :is_default 
 @enumeration.custom_field_values.each do |value| 
 custom_field_tag_with_label :enumeration, value 
 end 


 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(@enumeration.option_name), enumerations_path], l(:label_enumeration_new) 
 labelled_form_for :enumeration, @enumeration, :url => enumerations_path do |f| 
 f.hidden_field :type  
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_create) 
 end 

 error_messages_for 'enumeration' 
 f.text_field :name 
 f.check_box :active 
 f.check_box :is_default 
 @enumeration.custom_field_values.each do |value| 
 custom_field_tag_with_label :enumeration, value 
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

class EnumerationsController < ApplicationController
  layout 'admin'

  before_action :require_admin, :except => :index
  before_action :require_admin_or_api_request, :only => :index
  before_action :build_new_enumeration, :only => [:new, :create]
  before_action :find_enumeration, :only => [:edit, :update, :destroy]
  accept_api_auth :index

  helper :custom_fields

  def index
    respond_to do |format|
      format.html
      format.api {
        @klass = Enumeration.get_subclass(params[:type])
        if @klass
          @enumerations = @klass.shared.sorted.to_a
        else
          render_404
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

l(:label_enumerations)
 Enumeration.get_subclasses.each do |klass| 
 l(klass::OptionName) 
 enumerations = klass.shared 
 if enumerations.any? 
 l(:field_name) 
 l(:field_is_default) 
 l(:field_active) 
 enumerations.each do |enumeration| 
 cycle('odd', 'even') 
 link_to enumeration, edit_enumeration_path(enumeration) 
 checked_image enumeration.is_default? 
 checked_image enumeration.active? 
 reorder_handle(enumeration, :url => enumeration_path(enumeration), :param => 'enumeration') 
 delete_link enumeration_path(enumeration) 
 end 
 reset_cycle 
 end 
 link_to l(:label_enumeration_new), new_enumeration_path(:type => klass.name) 
 end 
 html_title(l(:label_enumerations)) 
 javascript_tag do 
 end 

end

  def new
  end

  def create
    if request.post? && @enumeration.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to enumerations_path
    else
      render :action => 'new'
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(@enumeration.option_name), enumerations_path], l(:label_enumeration_new) 
 labelled_form_for :enumeration, @enumeration, :url => enumerations_path do |f| 
 f.hidden_field :type  
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_create) 
 end 

 error_messages_for 'enumeration' 
 f.text_field :name 
 f.check_box :active 
 f.check_box :is_default 
 @enumeration.custom_field_values.each do |value| 
 custom_field_tag_with_label :enumeration, value 
 end 

end

  def edit
  end

  def update
    if @enumeration.update_attributes(params[:enumeration])
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_to enumerations_path
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

 title [l(@enumeration.option_name), enumerations_path], @enumeration.name 
 labelled_form_for :enumeration, @enumeration, :url => enumeration_path(@enumeration), :html => {:method => :put} do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_save) 
 end 

 error_messages_for 'enumeration' 
 f.text_field :name 
 f.check_box :active 
 f.check_box :is_default 
 @enumeration.custom_field_values.each do |value| 
 custom_field_tag_with_label :enumeration, value 
 end 

end

  def destroy
    if !@enumeration.in_use?
      # No associated objects
      @enumeration.destroy
      redirect_to enumerations_path
      return
    elsif params[:reassign_to_id].present? && (reassign_to = @enumeration.class.find_by_id(params[:reassign_to_id].to_i))
      @enumeration.destroy(reassign_to)
      redirect_to enumerations_path
      return
    end
    @enumerations = @enumeration.class.system.to_a - [@enumeration]
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(@enumeration.option_name), enumerations_path], @enumeration.name 
 form_tag({}, :method => :delete) do 
 l(:text_enumeration_destroy_question, :name => @enumeration.name, :count => @enumeration.objects_count) 
 l(:text_enumeration_category_reassign_to) 
 select_tag 'reassign_to_id', (content_tag('option', "--- #{l(:actionview_instancetag_blank_option)} ---", :value => '') + options_from_collection_for_select(@enumerations, 'id', 'name')) 
 submit_tag l(:button_apply) 
 link_to l(:button_cancel), enumerations_path 
 end 

end

  private

  def build_new_enumeration
    class_name = params[:enumeration] && params[:enumeration][:type] || params[:type]
    @enumeration = Enumeration.new_subclass_instance(class_name, params[:enumeration])
    if @enumeration.nil?
      render_404
    end
  end

  def find_enumeration
    @enumeration = Enumeration.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
