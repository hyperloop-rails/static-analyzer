
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 custom_field_title @custom_field 
 labelled_form_for :custom_field, @custom_field, :url => custom_field_path(@custom_field), :html => {:method => :put, :id => 'custom_field_form'} do |f| 
 render :partial => 'form', :locals => { :f => f } 
 end 

 error_messages_for 'custom_field' 
 f.select :field_format, custom_field_formats_for_select(@custom_field), {}, :disabled => !@custom_field.new_record? 
 f.text_field :name, :size => 50, :required => true 
 f.text_area :description, :rows => 7 
 if @custom_field.format.multiple_supported 
 f.check_box :multiple 
 if !@custom_field.new_record? && @custom_field.multiple 
 l(:text_turning_multiple_off) 
 end 
 end 
 render_custom_field_format_partial f, @custom_field 
 call_hook(:view_custom_fields_form_upper_box, :custom_field => @custom_field, :form => f) 
 submit_tag l(:button_save) 
 case @custom_field.class.name
when "IssueCustomField" 
 f.check_box :is_required 
 f.check_box :is_for_all, :data => {:disables => '#custom_field_project_ids input'} 
 f.check_box :is_filter 
 if @custom_field.format.searchable_supported 
 f.check_box :searchable 
 end 
 l(:field_visible) 
 radio_button_tag 'custom_field[visible]', 1, @custom_field.visible?, :id => 'custom_field_visible_on',
              :data => {:disables => '.custom_field_role input'} 
 l(:label_visibility_public) 
 radio_button_tag 'custom_field[visible]', 0, !@custom_field.visible?, :id => 'custom_field_visible_off',
              :data => {:enables => '.custom_field_role input'} 
 l(:label_visibility_roles) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'custom_field[role_ids][]', role.id, @custom_field.roles.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'custom_field[role_ids][]', '' 
 when "UserCustomField" 
 f.check_box :is_required 
 f.check_box :visible 
 f.check_box :editable 
 f.check_box :is_filter 
 when "ProjectCustomField" 
 f.check_box :is_required 
 f.check_box :visible 
 if @custom_field.format.searchable_supported 
 f.check_box :searchable 
 end 
 f.check_box :is_filter 
 when "VersionCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 when "GroupCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 when "TimeEntryCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 else 
 f.check_box :is_required 
 end 
 call_hook(:"view_custom_fields_form_#{@custom_field.type.to_s.underscore}", :custom_field => @custom_field, :form => f) 
 if @custom_field.is_a?(IssueCustomField) 
l(:label_tracker_plural)
 Tracker.sorted.each do |tracker| 
 check_box_tag "custom_field[tracker_ids][]",
                      tracker.id,
                      (@custom_field.trackers.include? tracker),
                      :id => "custom_field_tracker_ids_#{tracker.id}" 
tracker.id
 tracker.name 
 end 
 hidden_field_tag "custom_field[tracker_ids][]", '' 
 check_all_links 'custom_field_tracker_ids' 
 l(:label_project_plural) 
 project_ids = @custom_field.project_ids.to_a 
 render_project_nested_lists(Project.all) do |p|
      content_tag('label', check_box_tag('custom_field[project_ids][]', p.id, project_ids.include?(p.id), :id => nil) + ' ' + p)
    end 
 hidden_field_tag('custom_field[project_ids][]', '', :id => nil) 
 check_all_links 'custom_field_project_ids' 
 end 
 include_calendar_headers_tags 

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

class CustomFieldsController < ApplicationController
  layout 'admin'

  before_action :require_admin
  before_action :build_new_custom_field, :only => [:new, :create]
  before_action :find_custom_field, :only => [:edit, :update, :destroy]
  accept_api_auth :index

  def index
    respond_to do |format|
      format.html {
        @custom_fields_by_type = CustomField.all.group_by {|f| f.class.name }
      }
      format.api {
        @custom_fields = CustomField.all
      }
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 link_to l(:label_custom_field_new), new_custom_field_path, :class => 'icon icon-add' 
 title l(:label_custom_field_plural) 
 if @custom_fields_by_type.present? 
 render_custom_fields_tabs(@custom_fields_by_type.keys) 
 else 
 l(:label_no_data) 
 end 
 javascript_tag do 
 end 

end

  def new
    @custom_field.field_format = 'string' if @custom_field.field_format.blank?
    @custom_field.default_value = nil
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 custom_field_title @custom_field 
 labelled_form_for :custom_field, @custom_field, :url => custom_fields_path, :html => {:id => 'custom_field_form'} do |f| 
 render :partial => 'form', :locals => { :f => f } 
 hidden_field_tag 'type', @custom_field.type 
 end 
 javascript_tag do 
 new_custom_field_path(:format => 'js') 
 end 

 error_messages_for 'custom_field' 
 f.select :field_format, custom_field_formats_for_select(@custom_field), {}, :disabled => !@custom_field.new_record? 
 f.text_field :name, :size => 50, :required => true 
 f.text_area :description, :rows => 7 
 if @custom_field.format.multiple_supported 
 f.check_box :multiple 
 if !@custom_field.new_record? && @custom_field.multiple 
 l(:text_turning_multiple_off) 
 end 
 end 
 render_custom_field_format_partial f, @custom_field 
 call_hook(:view_custom_fields_form_upper_box, :custom_field => @custom_field, :form => f) 
 submit_tag l(:button_save) 
 case @custom_field.class.name
when "IssueCustomField" 
 f.check_box :is_required 
 f.check_box :is_for_all, :data => {:disables => '#custom_field_project_ids input'} 
 f.check_box :is_filter 
 if @custom_field.format.searchable_supported 
 f.check_box :searchable 
 end 
 l(:field_visible) 
 radio_button_tag 'custom_field[visible]', 1, @custom_field.visible?, :id => 'custom_field_visible_on',
              :data => {:disables => '.custom_field_role input'} 
 l(:label_visibility_public) 
 radio_button_tag 'custom_field[visible]', 0, !@custom_field.visible?, :id => 'custom_field_visible_off',
              :data => {:enables => '.custom_field_role input'} 
 l(:label_visibility_roles) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'custom_field[role_ids][]', role.id, @custom_field.roles.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'custom_field[role_ids][]', '' 
 when "UserCustomField" 
 f.check_box :is_required 
 f.check_box :visible 
 f.check_box :editable 
 f.check_box :is_filter 
 when "ProjectCustomField" 
 f.check_box :is_required 
 f.check_box :visible 
 if @custom_field.format.searchable_supported 
 f.check_box :searchable 
 end 
 f.check_box :is_filter 
 when "VersionCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 when "GroupCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 when "TimeEntryCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 else 
 f.check_box :is_required 
 end 
 call_hook(:"view_custom_fields_form_#{@custom_field.type.to_s.underscore}", :custom_field => @custom_field, :form => f) 
 if @custom_field.is_a?(IssueCustomField) 
l(:label_tracker_plural)
 Tracker.sorted.each do |tracker| 
 check_box_tag "custom_field[tracker_ids][]",
                      tracker.id,
                      (@custom_field.trackers.include? tracker),
                      :id => "custom_field_tracker_ids_#{tracker.id}" 
tracker.id
 tracker.name 
 end 
 hidden_field_tag "custom_field[tracker_ids][]", '' 
 check_all_links 'custom_field_tracker_ids' 
 l(:label_project_plural) 
 project_ids = @custom_field.project_ids.to_a 
 render_project_nested_lists(Project.all) do |p|
      content_tag('label', check_box_tag('custom_field[project_ids][]', p.id, project_ids.include?(p.id), :id => nil) + ' ' + p)
    end 
 hidden_field_tag('custom_field[project_ids][]', '', :id => nil) 
 check_all_links 'custom_field_project_ids' 
 end 
 include_calendar_headers_tags 

end

  def create
    if @custom_field.save
      flash[:notice] = l(:notice_successful_create)
      call_hook(:controller_custom_fields_new_after_save, :params => params, :custom_field => @custom_field)
      redirect_to edit_custom_field_path(@custom_field)
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

 custom_field_title @custom_field 
 labelled_form_for :custom_field, @custom_field, :url => custom_fields_path, :html => {:id => 'custom_field_form'} do |f| 
 render :partial => 'form', :locals => { :f => f } 
 hidden_field_tag 'type', @custom_field.type 
 end 
 javascript_tag do 
 new_custom_field_path(:format => 'js') 
 end 

 error_messages_for 'custom_field' 
 f.select :field_format, custom_field_formats_for_select(@custom_field), {}, :disabled => !@custom_field.new_record? 
 f.text_field :name, :size => 50, :required => true 
 f.text_area :description, :rows => 7 
 if @custom_field.format.multiple_supported 
 f.check_box :multiple 
 if !@custom_field.new_record? && @custom_field.multiple 
 l(:text_turning_multiple_off) 
 end 
 end 
 render_custom_field_format_partial f, @custom_field 
 call_hook(:view_custom_fields_form_upper_box, :custom_field => @custom_field, :form => f) 
 submit_tag l(:button_save) 
 case @custom_field.class.name
when "IssueCustomField" 
 f.check_box :is_required 
 f.check_box :is_for_all, :data => {:disables => '#custom_field_project_ids input'} 
 f.check_box :is_filter 
 if @custom_field.format.searchable_supported 
 f.check_box :searchable 
 end 
 l(:field_visible) 
 radio_button_tag 'custom_field[visible]', 1, @custom_field.visible?, :id => 'custom_field_visible_on',
              :data => {:disables => '.custom_field_role input'} 
 l(:label_visibility_public) 
 radio_button_tag 'custom_field[visible]', 0, !@custom_field.visible?, :id => 'custom_field_visible_off',
              :data => {:enables => '.custom_field_role input'} 
 l(:label_visibility_roles) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'custom_field[role_ids][]', role.id, @custom_field.roles.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'custom_field[role_ids][]', '' 
 when "UserCustomField" 
 f.check_box :is_required 
 f.check_box :visible 
 f.check_box :editable 
 f.check_box :is_filter 
 when "ProjectCustomField" 
 f.check_box :is_required 
 f.check_box :visible 
 if @custom_field.format.searchable_supported 
 f.check_box :searchable 
 end 
 f.check_box :is_filter 
 when "VersionCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 when "GroupCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 when "TimeEntryCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 else 
 f.check_box :is_required 
 end 
 call_hook(:"view_custom_fields_form_#{@custom_field.type.to_s.underscore}", :custom_field => @custom_field, :form => f) 
 if @custom_field.is_a?(IssueCustomField) 
l(:label_tracker_plural)
 Tracker.sorted.each do |tracker| 
 check_box_tag "custom_field[tracker_ids][]",
                      tracker.id,
                      (@custom_field.trackers.include? tracker),
                      :id => "custom_field_tracker_ids_#{tracker.id}" 
tracker.id
 tracker.name 
 end 
 hidden_field_tag "custom_field[tracker_ids][]", '' 
 check_all_links 'custom_field_tracker_ids' 
 l(:label_project_plural) 
 project_ids = @custom_field.project_ids.to_a 
 render_project_nested_lists(Project.all) do |p|
      content_tag('label', check_box_tag('custom_field[project_ids][]', p.id, project_ids.include?(p.id), :id => nil) + ' ' + p)
    end 
 hidden_field_tag('custom_field[project_ids][]', '', :id => nil) 
 check_all_links 'custom_field_project_ids' 
 end 
 include_calendar_headers_tags 

end

  def edit
  end

  def update
    @custom_field.safe_attributes = params[:custom_field]
    if @custom_field.save
      call_hook(:controller_custom_fields_edit_after_save, :params => params, :custom_field => @custom_field)
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_back_or_default edit_custom_field_path(@custom_field)
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

 custom_field_title @custom_field 
 labelled_form_for :custom_field, @custom_field, :url => custom_field_path(@custom_field), :html => {:method => :put, :id => 'custom_field_form'} do |f| 
 render :partial => 'form', :locals => { :f => f } 
 end 

 error_messages_for 'custom_field' 
 f.select :field_format, custom_field_formats_for_select(@custom_field), {}, :disabled => !@custom_field.new_record? 
 f.text_field :name, :size => 50, :required => true 
 f.text_area :description, :rows => 7 
 if @custom_field.format.multiple_supported 
 f.check_box :multiple 
 if !@custom_field.new_record? && @custom_field.multiple 
 l(:text_turning_multiple_off) 
 end 
 end 
 render_custom_field_format_partial f, @custom_field 
 call_hook(:view_custom_fields_form_upper_box, :custom_field => @custom_field, :form => f) 
 submit_tag l(:button_save) 
 case @custom_field.class.name
when "IssueCustomField" 
 f.check_box :is_required 
 f.check_box :is_for_all, :data => {:disables => '#custom_field_project_ids input'} 
 f.check_box :is_filter 
 if @custom_field.format.searchable_supported 
 f.check_box :searchable 
 end 
 l(:field_visible) 
 radio_button_tag 'custom_field[visible]', 1, @custom_field.visible?, :id => 'custom_field_visible_on',
              :data => {:disables => '.custom_field_role input'} 
 l(:label_visibility_public) 
 radio_button_tag 'custom_field[visible]', 0, !@custom_field.visible?, :id => 'custom_field_visible_off',
              :data => {:enables => '.custom_field_role input'} 
 l(:label_visibility_roles) 
 Role.givable.sorted.each do |role| 
 check_box_tag 'custom_field[role_ids][]', role.id, @custom_field.roles.include?(role), :id => nil 
 role.name 
 end 
 hidden_field_tag 'custom_field[role_ids][]', '' 
 when "UserCustomField" 
 f.check_box :is_required 
 f.check_box :visible 
 f.check_box :editable 
 f.check_box :is_filter 
 when "ProjectCustomField" 
 f.check_box :is_required 
 f.check_box :visible 
 if @custom_field.format.searchable_supported 
 f.check_box :searchable 
 end 
 f.check_box :is_filter 
 when "VersionCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 when "GroupCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 when "TimeEntryCustomField" 
 f.check_box :is_required 
 f.check_box :is_filter 
 else 
 f.check_box :is_required 
 end 
 call_hook(:"view_custom_fields_form_#{@custom_field.type.to_s.underscore}", :custom_field => @custom_field, :form => f) 
 if @custom_field.is_a?(IssueCustomField) 
l(:label_tracker_plural)
 Tracker.sorted.each do |tracker| 
 check_box_tag "custom_field[tracker_ids][]",
                      tracker.id,
                      (@custom_field.trackers.include? tracker),
                      :id => "custom_field_tracker_ids_#{tracker.id}" 
tracker.id
 tracker.name 
 end 
 hidden_field_tag "custom_field[tracker_ids][]", '' 
 check_all_links 'custom_field_tracker_ids' 
 l(:label_project_plural) 
 project_ids = @custom_field.project_ids.to_a 
 render_project_nested_lists(Project.all) do |p|
      content_tag('label', check_box_tag('custom_field[project_ids][]', p.id, project_ids.include?(p.id), :id => nil) + ' ' + p)
    end 
 hidden_field_tag('custom_field[project_ids][]', '', :id => nil) 
 check_all_links 'custom_field_project_ids' 
 end 
 include_calendar_headers_tags 

end

  def destroy
    begin
      @custom_field.destroy
    rescue
      flash[:error] = l(:error_can_not_delete_custom_field)
    end
    redirect_to custom_fields_path(:tab => @custom_field.class.name)
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  private

  def build_new_custom_field
    @custom_field = CustomField.new_subclass_instance(params[:type])
    if @custom_field.nil?
      render :action => 'select_type'
    else
      @custom_field.safe_attributes = params[:custom_field]
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 custom_field_title @custom_field 
 selected = 0 
 form_tag new_custom_field_path, :method => 'get' do 
 l(:label_custom_field_select_type) 
 custom_field_type_options.each do |name, type| 
 radio_button_tag 'type', type, 1==selected+=1 
 name 
 end 
 submit_tag l(:label_next).html_safe + " &#187;".html_safe, :name => nil 
 end 

end

  def find_custom_field
    @custom_field = CustomField.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
