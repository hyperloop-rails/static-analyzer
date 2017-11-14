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

class WorkflowsController < ApplicationController
  layout 'admin'

  before_action :require_admin

  def index
    @roles = Role.sorted.select(&:consider_workflow?)
    @trackers = Tracker.sorted
    @workflow_counts = WorkflowTransition.group(:tracker_id, :role_id).count
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_workflow), workflows_edit_path], l(:field_summary) 
 if @roles.empty? || @trackers.empty? 
 l(:label_no_data) 
 else 
 @roles.each do |role| 
 content_tag(role.builtin? ? 'em' : 'span', role.name) 
 end 
 @trackers.each do |tracker| 
 cycle('odd', 'even') 
 tracker.name 
 @roles.each do |role| 
 count = @workflow_counts[[tracker.id, role.id]] || 0 
 link_to((count > 0 ? count : content_tag(:span, nil, :class => 'icon-only icon-not-ok')),
                  {:action => 'edit', :role_id => role, :tracker_id => tracker},
                  :title => l(:button_edit)) 
 end 
 end 
 end 

end

  def edit
    find_trackers_roles_and_statuses_for_edit

    if request.post? && @roles && @trackers && params[:transitions]
      transitions = params[:transitions].deep_dup
      transitions.each do |old_status_id, transitions_by_new_status|
        transitions_by_new_status.each do |new_status_id, transition_by_rule|
          transition_by_rule.reject! {|rule, transition| transition == 'no_change'}
        end
      end
      WorkflowTransition.replace_transitions(@trackers, @roles, transitions)
      flash[:notice] = l(:notice_successful_update)
      redirect_to_referer_or workflows_edit_path
      return
    end

    if @trackers && @roles && @statuses.any?
      workflows = WorkflowTransition.
        where(:role_id => @roles.map(&:id), :tracker_id => @trackers.map(&:id)).
        preload(:old_status, :new_status)
      @workflows = {}
      @workflows['always'] = workflows.select {|w| !w.author && !w.assignee}
      @workflows['author'] = workflows.select {|w| w.author}
      @workflows['assignee'] = workflows.select {|w| w.assignee}
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 render :partial => 'action_menu' 
 title l(:label_workflow) 
 link_to l(:label_status_transitions), workflows_edit_path(:role_id => @roles, :tracker_id => @trackers), :class => 'selected' 
 link_to l(:label_fields_permissions), workflows_permissions_path(:role_id => @roles, :tracker_id => @trackers) 
l(:text_workflow_edit)
 form_tag({}, :method => 'get') do 
l(:label_role)
 options_for_workflow_select 'role_id[]', Role.sorted.select(&:consider_workflow?), @roles, :id => 'role_id', :class => 'expandable' 
l(:label_tracker)
 options_for_workflow_select 'tracker_id[]', Tracker.sorted, @trackers, :id => 'tracker_id', :class => 'expandable' 
 submit_tag l(:button_edit), :name => nil 
 hidden_field_tag 'used_statuses_only', '0', :id => nil 
 check_box_tag 'used_statuses_only', '1', @used_statuses_only 
 l(:label_display_used_statuses_only) 
 end 
 if @trackers && @roles && @statuses.any? 
 form_tag({}, :id => 'workflow_form' ) do 
 @trackers.map {|tracker| hidden_field_tag 'tracker_id[]', tracker.id, :id => nil}.join.html_safe 
 @roles.map {|role| hidden_field_tag 'role_id[]', role.id, :id => nil}.join.html_safe 
 hidden_field_tag 'used_statuses_only', params[:used_statuses_only], :id => nil 
 render :partial => 'form', :locals => {:name => 'always', :workflows => @workflows['always']} 
 l(:label_additional_workflow_transitions_for_author) 
 render :partial => 'form', :locals => {:name => 'author', :workflows => @workflows['author']} 
 javascript_tag "hideFieldset($('#author_workflows'))" unless @workflows['author'].present? 
 l(:label_additional_workflow_transitions_for_assignee) 
 render :partial => 'form', :locals => {:name => 'assignee', :workflows => @workflows['assignee']} 
 javascript_tag "hideFieldset($('#assignee_workflows'))" unless @workflows['assignee'].present? 
 submit_tag l(:button_save) 
 end 
 end 
 javascript_tag do 
 end 

 link_to l(:button_copy), {:action => 'copy'}, :class => 'icon icon-copy' 
 link_to l(:field_summary), {:action => 'index'}, :class => 'icon icon-summary' 

 name 
 link_to_function('', "toggleCheckboxesBySelector('table.transitions-#{name} input')",
                           :title => "#{l(:button_check_all)}/#{l(:button_uncheck_all)}",
                           :class => 'icon-only icon-checked') 
l(:label_current_status)
 @statuses.length 
l(:label_new_statuses_allowed)
 for new_status in @statuses 
 75 / @statuses.size 
 link_to_function('', "toggleCheckboxesBySelector('table.transitions-#{name} input.new-status-#{new_status.id}')",
                           :title => "#{l(:button_check_all)}/#{l(:button_uncheck_all)}",
                           :class => 'icon-only icon-checked') 
 new_status.name 
 end 
 for old_status in [nil] + @statuses 
 next if old_status.nil? && name != 'always' 
 cycle("odd", "even") 
 link_to_function('', "toggleCheckboxesBySelector('table.transitions-#{name} input.old-status-#{old_status.try(:id) || 0}')",
                           :title => "#{l(:button_check_all)}/#{l(:button_uncheck_all)}",
                           :class => 'icon-only icon-checked') 
 old_status ? old_status.name : content_tag('em', l(:label_issue_new)) 
 for new_status in @statuses 
 checked = workflows.detect {|w| w.old_status == old_status && w.new_status == new_status} 
 checked ? 'enabled' : '' 
 transition_tag workflows, old_status, new_status, name 
 end 
 end 

end

  def permissions
    find_trackers_roles_and_statuses_for_edit

    if request.post? && @roles && @trackers && params[:permissions]
      permissions = params[:permissions].deep_dup
      permissions.each { |field, rule_by_status_id|
        rule_by_status_id.reject! {|status_id, rule| rule == 'no_change'}
      }
      WorkflowPermission.replace_permissions(@trackers, @roles, permissions)
      flash[:notice] = l(:notice_successful_update)
      redirect_to_referer_or workflows_permissions_path
      return
    end

    if @roles && @trackers
      @fields = (Tracker::CORE_FIELDS_ALL - @trackers.map(&:disabled_core_fields).reduce(:&)).map {|field| [field, l("field_"+field.sub(/_id$/, ''))]}
      @custom_fields = @trackers.map(&:custom_fields).flatten.uniq.sort
      @permissions = WorkflowPermission.rules_by_status_id(@trackers, @roles)
      @statuses.each {|status| @permissions[status.id] ||= {}}
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 render :partial => 'action_menu' 
 title l(:label_workflow) 
 link_to l(:label_status_transitions), workflows_edit_path(:role_id => @roles, :tracker_id => @trackers) 
 link_to l(:label_fields_permissions), workflows_permissions_path(:role_id => @roles, :tracker_id => @trackers), :class => 'selected' 
l(:text_workflow_edit)
 form_tag({}, :method => 'get') do 
l(:label_role)
 options_for_workflow_select 'role_id[]', Role.sorted.select(&:consider_workflow?), @roles, :id => 'role_id', :class => 'expandable' 
l(:label_tracker)
 options_for_workflow_select 'tracker_id[]', Tracker.sorted, @trackers, :id => 'tracker_id', :class => 'expandable' 
 submit_tag l(:button_edit), :name => nil 
 hidden_field_tag 'used_statuses_only', '0', :id => nil 
 check_box_tag 'used_statuses_only', '1', @used_statuses_only 
 l(:label_display_used_statuses_only) 
 end 
 if @trackers && @roles && @statuses.any? 
 form_tag({}, :id => 'workflow_form' ) do 
 @trackers.map {|tracker| hidden_field_tag 'tracker_id[]', tracker.id, :id => nil}.join.html_safe 
 @roles.map {|role| hidden_field_tag 'role_id[]', role.id, :id => nil}.join.html_safe 
 hidden_field_tag 'used_statuses_only', params[:used_statuses_only], :id => nil 
 @statuses.length 
l(:label_issue_status)
 for status in @statuses 
 75 / @statuses.size 
 status.name 
 end 
 @statuses.size + 1 
 l(:field_core_fields) 
 @fields.each do |field, name| 
 cycle("odd", "even") 
 name 
 content_tag('span', '*', :class => 'required') if field_required?(field) 
 for status in @statuses 
 @permissions[status.id][field].try(:join, ' ') 
 field_permission_tag(@permissions, status, field, @roles) 
 unless status == @statuses.last 
 end 
 end 
 end 
 if @custom_fields.any? 
 @statuses.size + 1 
 l(:label_custom_field_plural) 
 @custom_fields.each do |field| 
 cycle("odd", "even") 
 field.name 
 content_tag('span', '*', :class => 'required') if field_required?(field) 
 for status in @statuses 
 @permissions[status.id][field.id.to_s].try(:join, ' ') 
 field_permission_tag(@permissions, status, field, @roles) 
 unless status == @statuses.last 
 end 
 end 
 end 
 end 
 submit_tag l(:button_save) 
 end 
 end 
 javascript_tag do 
 end 

 link_to l(:button_copy), {:action => 'copy'}, :class => 'icon icon-copy' 
 link_to l(:field_summary), {:action => 'index'}, :class => 'icon icon-summary' 

end

  def copy
    @roles = Role.sorted.select(&:consider_workflow?)
    @trackers = Tracker.sorted

    if params[:source_tracker_id].blank? || params[:source_tracker_id] == 'any'
      @source_tracker = nil
    else
      @source_tracker = Tracker.find_by_id(params[:source_tracker_id].to_i)
    end
    if params[:source_role_id].blank? || params[:source_role_id] == 'any'
      @source_role = nil
    else
      @source_role = Role.find_by_id(params[:source_role_id].to_i)
    end
    @target_trackers = params[:target_tracker_ids].blank? ?
        nil : Tracker.where(:id => params[:target_tracker_ids]).to_a
    @target_roles = params[:target_role_ids].blank? ?
        nil : Role.where(:id => params[:target_role_ids]).to_a
    if request.post?
      if params[:source_tracker_id].blank? || params[:source_role_id].blank? || (@source_tracker.nil? && @source_role.nil?)
        flash.now[:error] = l(:error_workflow_copy_source)
      elsif @target_trackers.blank? || @target_roles.blank?
        flash.now[:error] = l(:error_workflow_copy_target)
      else
        WorkflowRule.copy(@source_tracker, @source_role, @target_trackers, @target_roles)
        flash[:notice] = l(:notice_successful_update)
        redirect_to workflows_copy_path(:source_tracker_id => @source_tracker, :source_role_id => @source_role)
      end
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_workflow), workflows_edit_path], l(:button_copy) 
 form_tag({}, :id => 'workflow_copy_form') do 
 l(:label_copy_source) 
 l(:label_tracker) 
 select_tag('source_tracker_id',
                  content_tag('option', "--- #{l(:actionview_instancetag_blank_option)} ---", :value => '') +
                  content_tag('option', "--- #{ l(:label_copy_same_as_target) } ---", :value => 'any') +
                  options_from_collection_for_select(@trackers, 'id', 'name', @source_tracker && @source_tracker.id)) 
 l(:label_role) 
 select_tag('source_role_id',
                  content_tag('option', "--- #{l(:actionview_instancetag_blank_option)} ---", :value => '') +
                  content_tag('option', "--- #{ l(:label_copy_same_as_target) } ---", :value => 'any') +
                  options_from_collection_for_select(@roles, 'id', 'name', @source_role && @source_role.id)) 
 l(:label_copy_target) 
 l(:label_tracker) 
 select_tag 'target_tracker_ids',
                  content_tag('option', "--- #{l(:actionview_instancetag_blank_option)} ---", :value => '', :disabled => true) +
                  options_from_collection_for_select(@trackers, 'id', 'name', @target_trackers && @target_trackers.map(&:id)), :multiple => true 
 l(:label_role) 
 select_tag 'target_role_ids',
                  content_tag('option', "--- #{l(:actionview_instancetag_blank_option)} ---", :value => '', :disabled => true) +
                  options_from_collection_for_select(@roles, 'id', 'name', @target_roles && @target_roles.map(&:id)), :multiple => true 
 submit_tag l(:button_copy) 
 end 

end

  private

  def find_trackers_roles_and_statuses_for_edit
    find_roles
    find_trackers
    find_statuses
  end

  def find_roles
    ids = Array.wrap(params[:role_id])
    if ids == ['all']
      @roles = Role.sorted.to_a
    elsif ids.present?
      @roles = Role.where(:id => ids).to_a
    end
    @roles = nil if @roles.blank?
  end

  def find_trackers
    ids = Array.wrap(params[:tracker_id])
    if ids == ['all']
      @trackers = Tracker.sorted.to_a
    elsif ids.present?
      @trackers = Tracker.where(:id => ids).to_a
    end
    @trackers = nil if @trackers.blank?
  end

  def find_statuses
    @used_statuses_only = (params[:used_statuses_only] == '0' ? false : true)
    if @trackers && @used_statuses_only
      @statuses = @trackers.map(&:issue_statuses).flatten.uniq.sort.presence
    end
    @statuses ||= IssueStatus.sorted.to_a
  end
end
