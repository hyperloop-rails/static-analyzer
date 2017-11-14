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

class ContextMenusController < ApplicationController
  helper :watchers
  helper :issues

  before_action :find_issues, :only => :issues

  def issues
    if (@issues.size == 1)
      @issue = @issues.first
    end
    @issue_ids = @issues.map(&:id).sort

    @allowed_statuses = @issues.map(&:new_statuses_allowed_to).reduce(:&)

    @can = {:edit => @issues.all?(&:attributes_editable?),
            :log_time => (@project && User.current.allowed_to?(:log_time, @project)),
            :copy => User.current.allowed_to?(:copy_issues, @projects) && Issue.allowed_target_projects.any?,
            :add_watchers => User.current.allowed_to?(:add_issue_watchers, @projects),
            :delete => @issues.all?(&:deletable?)
            }

    @assignables = @issues.map(&:assignable_users).reduce(:&)
    @trackers = @projects.map {|p| Issue.allowed_target_trackers(p) }.reduce(:&)
    @versions = @projects.map {|p| p.shared_versions.open}.reduce(:&)

    @priorities = IssuePriority.active.reverse
    @back = back_url

    @options_by_custom_field = {}
    if @can[:edit]
      custom_fields = @issues.map(&:editable_custom_fields).reduce(:&).reject(&:multiple?)
      custom_fields.each do |field|
        values = field.possible_values_options(@projects)
        if values.present?
          @options_by_custom_field[field] = values
        end
      end
    end

    @safe_attributes = @issues.map(&:safe_attribute_names).reduce(:&)
    render :layout => false
  
 call_hook(:view_issues_context_menu_start, {:issues => @issues, :can => @can, :back => @back }) 
 if @issue 
 context_menu_link l(:button_edit), edit_issue_path(@issue),
            :class => 'icon-edit', :disabled => !@can[:edit] 
 else 
 context_menu_link l(:button_edit), bulk_edit_issues_path(:ids => @issue_ids),
            :class => 'icon-edit', :disabled => !@can[:edit] 
 end 
 if @allowed_statuses.present? 
 l(:field_status) 
 @allowed_statuses.each do |s| 
 context_menu_link s.name, bulk_update_issues_path(:ids => @issue_ids, :issue => {:status_id => s}, :back_url => @back), :method => :post,
                                  :selected => (@issue && s == @issue.status), :disabled => !@can[:edit] 
 end 
 end 
 if @trackers.present? 
 l(:field_tracker) 
 @trackers.each do |t| 
 context_menu_link t.name, bulk_update_issues_path(:ids => @issue_ids, :issue => {'tracker_id' => t}, :back_url => @back), :method => :post,
                                  :selected => (@issue && t == @issue.tracker), :disabled => !@can[:edit] 
 end 
 end 
 if @safe_attributes.include?('priority_id') && @priorities.present? 
 l(:field_priority) 
 @priorities.each do |p| 
 context_menu_link p.name, bulk_update_issues_path(:ids => @issue_ids, :issue => {'priority_id' => p}, :back_url => @back), :method => :post,
                                  :selected => (@issue && p == @issue.priority), :disabled => (!@can[:edit] || @issues.detect {|i| !i.leaf?}) 
 end 
 end 
 if @safe_attributes.include?('fixed_version_id') && @versions.present? 
 l(:field_fixed_version) 
 @versions.sort.each do |v| 
 context_menu_link format_version_name(v), bulk_update_issues_path(:ids => @issue_ids, :issue => {'fixed_version_id' => v}, :back_url => @back), :method => :post,
                                  :selected => (@issue && v == @issue.fixed_version), :disabled => !@can[:edit] 
 end 
 context_menu_link l(:label_none), bulk_update_issues_path(:ids => @issue_ids, :issue => {'fixed_version_id' => 'none'}, :back_url => @back), :method => :post,
                                  :selected => (@issue && @issue.fixed_version.nil?), :disabled => !@can[:edit] 
 end 
 if @safe_attributes.include?('assigned_to_id') && @assignables.present? 
 l(:field_assigned_to) 
 if @assignables.include?(User.current) 
 context_menu_link "<< #{l(:label_me)} >>", bulk_update_issues_path(:ids => @issue_ids, :issue => {'assigned_to_id' => User.current}, :back_url => @back), :method => :post,
                                  :disabled => !@can[:edit] 
 end 
 @assignables.each do |u| 
 context_menu_link u.name, bulk_update_issues_path(:ids => @issue_ids, :issue => {'assigned_to_id' => u}, :back_url => @back), :method => :post,
                                  :selected => (@issue && u == @issue.assigned_to), :disabled => !@can[:edit] 
 end 
 context_menu_link l(:label_nobody), bulk_update_issues_path(:ids => @issue_ids, :issue => {'assigned_to_id' => 'none'}, :back_url => @back), :method => :post,
                                  :selected => (@issue && @issue.assigned_to.nil?), :disabled => !@can[:edit] 
 end 
 if @safe_attributes.include?('category_id') && @project && @project.issue_categories.any? 
 l(:field_category) 
 @project.issue_categories.each do |u| 
 context_menu_link u.name, bulk_update_issues_path(:ids => @issue_ids, :issue => {'category_id' => u}, :back_url => @back), :method => :post,
                                  :selected => (@issue && u == @issue.category), :disabled => !@can[:edit] 
 end 
 context_menu_link l(:label_none), bulk_update_issues_path(:ids => @issue_ids, :issue => {'category_id' => 'none'}, :back_url => @back), :method => :post,
                                  :selected => (@issue && @issue.category.nil?), :disabled => !@can[:edit] 
 end 
 if @safe_attributes.include?('done_ratio') && Issue.use_field_for_done_ratio? 
 l(:field_done_ratio) 
 (0..10).map{|x|x*10}.each do |p| 
 context_menu_link "#{p}%", bulk_update_issues_path(:ids => @issue_ids, :issue => {'done_ratio' => p}, :back_url => @back), :method => :post,
                                      :selected => (@issue && p == @issue.done_ratio), :disabled => (!@can[:edit] || @issues.detect {|i| !i.leaf?}) 
 end 
 end 
 @options_by_custom_field.each do |field, options| 
 field.id 
 field.name 
 options.each do |text, value| 
 bulk_update_custom_field_context_menu_link(field, text, value || text) 
 end 
 unless field.is_required? 
 bulk_update_custom_field_context_menu_link(field, l(:label_none), '__none__') 
 end 
 end 
 if @can[:add_watchers] 
 l(:label_issue_watchers) 
 context_menu_link l(:button_add),
                new_watchers_path(:object_type => 'issue', :object_id => @issue_ids),
                :remote => true,
                :class => 'icon-add' 
 end 
 if User.current.logged? 
 watcher_link(@issues, User.current) 
 end 
 unless @issue 
 context_menu_link l(:button_filter), _project_issues_path(@project, :set_filter => 1, :status_id => "*", :issue_id => @issue_ids.join(",")),
          :class => 'icon-list' 
 end 
 if @issue.present? 
 if @can[:log_time] 
 context_menu_link l(:button_log_time), new_issue_time_entry_path(@issue),
          :class => 'icon-time-add' 
 end 
 context_menu_link l(:button_copy), project_copy_issue_path(@project, @issue),
          :class => 'icon-copy', :disabled => !@can[:copy] 
 else 
 context_menu_link l(:button_copy), bulk_edit_issues_path(:ids => @issue_ids, :copy => '1'),
                          :class => 'icon-copy', :disabled => !@can[:copy] 
 end 
 context_menu_link l(:button_delete), issues_path(:ids => @issue_ids, :back_url => @back),
                            :method => :delete, :data => {:confirm => issues_destroy_confirmation_message(@issues)}, :class => 'icon-del', :disabled => !@can[:delete] 
 call_hook(:view_issues_context_menu_end, {:issues => @issues, :can => @can, :back => @back }) 

end

  def time_entries
    @time_entries = TimeEntry.where(:id => params[:ids]).preload(:project).to_a
    (render_404; return) unless @time_entries.present?
    if (@time_entries.size == 1)
      @time_entry = @time_entries.first
    end

    @projects = @time_entries.collect(&:project).compact.uniq
    @project = @projects.first if @projects.size == 1
    @activities = TimeEntryActivity.shared.active

    edit_allowed = @time_entries.all? {|t| t.editable_by?(User.current)}
    @can = {:edit => edit_allowed, :delete => edit_allowed}
    @back = back_url

    @options_by_custom_field = {}
    if @can[:edit]
      custom_fields = @time_entries.map(&:editable_custom_fields).reduce(:&).reject(&:multiple?)
      custom_fields.each do |field|
        values = field.possible_values_options(@projects)
        if values.present?
          @options_by_custom_field[field] = values
        end
      end
    end

    render :layout => false
  
 if !@time_entry.nil? 
 context_menu_link l(:button_edit), {:controller => 'timelog', :action => 'edit', :id => @time_entry},
            :class => 'icon-edit', :disabled => !@can[:edit] 
 else 
 context_menu_link l(:button_edit), {:controller => 'timelog', :action => 'bulk_edit', :ids => @time_entries.collect(&:id)},
            :class => 'icon-edit', :disabled => !@can[:edit] 
 end 
 call_hook(:view_time_entries_context_menu_start, {:time_entries => @time_entries, :can => @can, :back => @back }) 
 if @activities.present? 
 l(:field_activity) 
 @activities.each do |u| 
 context_menu_link u.name, {:controller => 'timelog', :action => 'bulk_update', :ids => @time_entries.collect(&:id), :time_entry => {'activity_id' => u}, :back_url => @back}, :method => :post,
                                  :selected => (@time_entry && u == @time_entry.activity), :disabled => !@can[:edit] 
 end 
 context_menu_link l(:label_none), {:controller => 'timelog', :action => 'bulk_update', :ids => @time_entries.collect(&:id), :time_entry => {'activity_id' => 'none'}, :back_url => @back}, :method => :post,
                                  :selected => (@time_entry && @time_entry.activity.nil?), :disabled => !@can[:edit] 
 end 
 @options_by_custom_field.each do |field, options| 
 field.id 
 field.name 
 options.each do |text, value| 
 bulk_update_time_entry_custom_field_context_menu_link(field, text, value || text) 
 end 
 unless field.is_required? 
 bulk_update_time_entry_custom_field_context_menu_link(field, l(:label_none), '__none__') 
 end 
 end 
 call_hook(:view_time_entries_context_menu_end, {:time_entries => @time_entries, :can => @can, :back => @back }) 
 context_menu_link l(:button_delete),
      {:controller => 'timelog', :action => 'destroy', :ids => @time_entries.collect(&:id), :back_url => @back},
      :method => :delete, :data => {:confirm => l(:text_time_entries_destroy_confirmation)}, :class => 'icon-del', :disabled => !@can[:delete] 

end
end
