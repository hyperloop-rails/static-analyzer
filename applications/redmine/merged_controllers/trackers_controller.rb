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

class TrackersController < ApplicationController
  layout 'admin'

  before_action :require_admin, :except => :index
  before_action :require_admin_or_api_request, :only => :index
  accept_api_auth :index

  def index
    @trackers = Tracker.sorted.to_a
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.api
    end
  
 link_to l(:label_tracker_new), new_tracker_path, :class => 'icon icon-add' 
 link_to l(:field_summary), fields_trackers_path, :class => 'icon icon-summary' 
l(:label_tracker_plural)
l(:label_tracker)
 for tracker in @trackers 
 cycle("odd", "even") 
 link_to tracker.name, edit_tracker_path(tracker) 
 unless tracker.workflow_rules.count > 0 
 l(:text_tracker_no_workflow) 
 link_to l(:button_edit), workflows_edit_path(:tracker_id => tracker) 
 end 
 reorder_handle(tracker) 
 delete_link tracker_path(tracker) 
 end 
 html_title(l(:label_tracker_plural)) 
 javascript_tag do 
 end 

end

  def new
    @tracker ||= Tracker.new
    @tracker.safe_attributes = params[:tracker]
    @trackers = Tracker.sorted.to_a
    @projects = Project.all
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_tracker_plural), trackers_path], l(:label_tracker_new) 
 labelled_form_for @tracker do |f| 
 render :partial => 'form', :locals => { :f => f } 
 end 

 error_messages_for 'tracker' 
 f.text_field :name, :required => true 
 f.select :default_status_id,
        IssueStatus.sorted.map {|s| [s.name, s.id]},
        :include_blank => @tracker.default_status.nil?,
        :required => true 
 f.check_box :is_in_roadmap 
 l(:field_core_fields) 
 Tracker::CORE_FIELDS.each do |field| 
 check_box_tag 'tracker[core_fields][]', field, @tracker.core_fields.include?(field), :id => nil 
 l("field_#{field}".sub(/_id$/, '')) 
 end 
 hidden_field_tag 'tracker[core_fields][]', '' 
 if IssueCustomField.all.any? 
 l(:label_custom_field_plural) 
 IssueCustomField.all.each do |field| 
 check_box_tag 'tracker[custom_field_ids][]',field.id, @tracker.custom_fields.to_a.include?(field), :id => nil 
 field.name 
 end 
 hidden_field_tag 'tracker[custom_field_ids][]', '' 
 end 
 if @tracker.new_record? && @trackers.any? 
 l(:label_copy_workflow_from) 
 select_tag(:copy_workflow_from, content_tag("option") + options_from_collection_for_select(@trackers, :id, :name)) 
 end 
 submit_tag l(@tracker.new_record? ? :button_create : :button_save) 
 if @projects.any? 
 l(:label_project_plural) 
 project_ids = @tracker.project_ids.to_a 
 render_project_nested_lists(@projects) do |p|
  content_tag('label', check_box_tag('tracker[project_ids][]', p.id, project_ids.include?(p.id), :id => nil) + ' ' + h(p))
end 
 hidden_field_tag('tracker[project_ids][]', '', :id => nil) 
 check_all_links 'tracker_project_ids' 
 end 

end

  def create
    @tracker = Tracker.new
    @tracker.safe_attributes = params[:tracker]
    if @tracker.save
      # workflow copy
      if !params[:copy_workflow_from].blank? && (copy_from = Tracker.find_by_id(params[:copy_workflow_from]))
        @tracker.workflow_rules.copy(copy_from)
      end
      flash[:notice] = l(:notice_successful_create)
      redirect_to trackers_path
      return
    end
    new
    render :action => 'new'
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_tracker_plural), trackers_path], l(:label_tracker_new) 
 labelled_form_for @tracker do |f| 
 render :partial => 'form', :locals => { :f => f } 
 end 

 error_messages_for 'tracker' 
 f.text_field :name, :required => true 
 f.select :default_status_id,
        IssueStatus.sorted.map {|s| [s.name, s.id]},
        :include_blank => @tracker.default_status.nil?,
        :required => true 
 f.check_box :is_in_roadmap 
 l(:field_core_fields) 
 Tracker::CORE_FIELDS.each do |field| 
 check_box_tag 'tracker[core_fields][]', field, @tracker.core_fields.include?(field), :id => nil 
 l("field_#{field}".sub(/_id$/, '')) 
 end 
 hidden_field_tag 'tracker[core_fields][]', '' 
 if IssueCustomField.all.any? 
 l(:label_custom_field_plural) 
 IssueCustomField.all.each do |field| 
 check_box_tag 'tracker[custom_field_ids][]',field.id, @tracker.custom_fields.to_a.include?(field), :id => nil 
 field.name 
 end 
 hidden_field_tag 'tracker[custom_field_ids][]', '' 
 end 
 if @tracker.new_record? && @trackers.any? 
 l(:label_copy_workflow_from) 
 select_tag(:copy_workflow_from, content_tag("option") + options_from_collection_for_select(@trackers, :id, :name)) 
 end 
 submit_tag l(@tracker.new_record? ? :button_create : :button_save) 
 if @projects.any? 
 l(:label_project_plural) 
 project_ids = @tracker.project_ids.to_a 
 render_project_nested_lists(@projects) do |p|
  content_tag('label', check_box_tag('tracker[project_ids][]', p.id, project_ids.include?(p.id), :id => nil) + ' ' + h(p))
end 
 hidden_field_tag('tracker[project_ids][]', '', :id => nil) 
 check_all_links 'tracker_project_ids' 
 end 

end

  def edit
    @tracker ||= Tracker.find(params[:id])
    @projects = Project.all
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_tracker_plural), trackers_path], @tracker.name 
 labelled_form_for @tracker do |f| 
 render :partial => 'form', :locals => { :f => f } 
 end 

 error_messages_for 'tracker' 
 f.text_field :name, :required => true 
 f.select :default_status_id,
        IssueStatus.sorted.map {|s| [s.name, s.id]},
        :include_blank => @tracker.default_status.nil?,
        :required => true 
 f.check_box :is_in_roadmap 
 l(:field_core_fields) 
 Tracker::CORE_FIELDS.each do |field| 
 check_box_tag 'tracker[core_fields][]', field, @tracker.core_fields.include?(field), :id => nil 
 l("field_#{field}".sub(/_id$/, '')) 
 end 
 hidden_field_tag 'tracker[core_fields][]', '' 
 if IssueCustomField.all.any? 
 l(:label_custom_field_plural) 
 IssueCustomField.all.each do |field| 
 check_box_tag 'tracker[custom_field_ids][]',field.id, @tracker.custom_fields.to_a.include?(field), :id => nil 
 field.name 
 end 
 hidden_field_tag 'tracker[custom_field_ids][]', '' 
 end 
 if @tracker.new_record? && @trackers.any? 
 l(:label_copy_workflow_from) 
 select_tag(:copy_workflow_from, content_tag("option") + options_from_collection_for_select(@trackers, :id, :name)) 
 end 
 submit_tag l(@tracker.new_record? ? :button_create : :button_save) 
 if @projects.any? 
 l(:label_project_plural) 
 project_ids = @tracker.project_ids.to_a 
 render_project_nested_lists(@projects) do |p|
  content_tag('label', check_box_tag('tracker[project_ids][]', p.id, project_ids.include?(p.id), :id => nil) + ' ' + h(p))
end 
 hidden_field_tag('tracker[project_ids][]', '', :id => nil) 
 check_all_links 'tracker_project_ids' 
 end 

end

  def update
    @tracker = Tracker.find(params[:id])
    @tracker.safe_attributes = params[:tracker]
    if @tracker.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_to trackers_path(:page => params[:page])
        }
        format.js { head 200 }
      end
    else
      respond_to do |format|
        format.html {
          edit
          render :action => 'edit'
        }
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

 title [l(:label_tracker_plural), trackers_path], @tracker.name 
 labelled_form_for @tracker do |f| 
 render :partial => 'form', :locals => { :f => f } 
 end 

 error_messages_for 'tracker' 
 f.text_field :name, :required => true 
 f.select :default_status_id,
        IssueStatus.sorted.map {|s| [s.name, s.id]},
        :include_blank => @tracker.default_status.nil?,
        :required => true 
 f.check_box :is_in_roadmap 
 l(:field_core_fields) 
 Tracker::CORE_FIELDS.each do |field| 
 check_box_tag 'tracker[core_fields][]', field, @tracker.core_fields.include?(field), :id => nil 
 l("field_#{field}".sub(/_id$/, '')) 
 end 
 hidden_field_tag 'tracker[core_fields][]', '' 
 if IssueCustomField.all.any? 
 l(:label_custom_field_plural) 
 IssueCustomField.all.each do |field| 
 check_box_tag 'tracker[custom_field_ids][]',field.id, @tracker.custom_fields.to_a.include?(field), :id => nil 
 field.name 
 end 
 hidden_field_tag 'tracker[custom_field_ids][]', '' 
 end 
 if @tracker.new_record? && @trackers.any? 
 l(:label_copy_workflow_from) 
 select_tag(:copy_workflow_from, content_tag("option") + options_from_collection_for_select(@trackers, :id, :name)) 
 end 
 submit_tag l(@tracker.new_record? ? :button_create : :button_save) 
 if @projects.any? 
 l(:label_project_plural) 
 project_ids = @tracker.project_ids.to_a 
 render_project_nested_lists(@projects) do |p|
  content_tag('label', check_box_tag('tracker[project_ids][]', p.id, project_ids.include?(p.id), :id => nil) + ' ' + h(p))
end 
 hidden_field_tag('tracker[project_ids][]', '', :id => nil) 
 check_all_links 'tracker_project_ids' 
 end 

end

  def destroy
    @tracker = Tracker.find(params[:id])
    unless @tracker.issues.empty?
      flash[:error] = l(:error_can_not_delete_tracker)
    else
      @tracker.destroy
    end
    redirect_to trackers_path
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  def fields
    if request.post? && params[:trackers]
      params[:trackers].each do |tracker_id, tracker_params|
        tracker = Tracker.find_by_id(tracker_id)
        if tracker
          tracker.core_fields = tracker_params[:core_fields]
          tracker.custom_field_ids = tracker_params[:custom_field_ids]
          tracker.save
        end
      end
      flash[:notice] = l(:notice_successful_update)
      redirect_to fields_trackers_path
      return
    end
    @trackers = Tracker.sorted.to_a
    @custom_fields = IssueCustomField.all.sort
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_tracker_plural), trackers_path], l(:field_summary) 
 if @trackers.any? 
 form_tag fields_trackers_path do 
 @trackers.each do |tracker| 
 link_to_function('', "toggleCheckboxesBySelector('input.tracker-#{tracker.id}')",
                               :title => "#{l(:button_check_all)}/#{l(:button_uncheck_all)}",
                               :class => 'icon-only icon-checked') 
 tracker.name 
 end 
 @trackers.size + 1 
 l(:field_core_fields) 
 Tracker::CORE_FIELDS.each do |field| 
 cycle("odd", "even") 
 link_to_function('', "toggleCheckboxesBySelector('input.core-field-#{field}')",
                               :title => "#{l(:button_check_all)}/#{l(:button_uncheck_all)}",
                               :class => 'icon-only icon-checked') 
 l("field_#{field}".sub(/_id$/, '')) 
 @trackers.each do |tracker| 
 check_box_tag "trackers[#{tracker.id}][core_fields][]", field, tracker.core_fields.include?(field),
                            :class => "tracker-#{tracker.id} core-field-#{field}", :id => nil 
 end 
 end 
 if @custom_fields.any? 
 @trackers.size + 1 
 l(:label_custom_field_plural) 
 @custom_fields.each do |field| 
 cycle("odd", "even") 
 link_to_function('', "toggleCheckboxesBySelector('input.custom-field-#{field.id}')",
                                 :title => "#{l(:button_check_all)}/#{l(:button_uncheck_all)}",
                                 :class => 'icon-only icon-checked') 
 field.name 
 @trackers.each do |tracker| 
 check_box_tag "trackers[#{tracker.id}][custom_field_ids][]", field.id, tracker.custom_fields.include?(field),
                              :class => "tracker-#{tracker.id} custom-field-#{field.id}", :id => nil 
 end 
 end 
 end 
 submit_tag l(:button_save) 
 @trackers.each do |tracker| 
 hidden_field_tag "trackers[#{tracker.id}][core_fields][]", '' 
 hidden_field_tag "trackers[#{tracker.id}][custom_field_ids][]", '' 
 end 
 end 
 else 
 l(:label_no_data) 
 end 

end
end
