#==
# RailsCollab
# Copyright (C) 2007 - 2011 James S Urquhart
# Portions Copyright (C) René Scheibe
# Portions Copyright (C) Ariejan de Vroom
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

class ProjectsController < ApplicationController

  layout :project_layout

  before_filter :process_session
  before_filter :obtain_project, :except => [:index, :new, :create]
  after_filter  :user_track, :only => [:index, :search, :people]

  def index
    @projects = @logged_user.is_admin ? Project.all : @logged_user.projects
    respond_to do |format|
      format.html { render :layout => 'administration' }
      format.xml  { 
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :create_project, current_user
  	@page_actions << {:title => :add_project, :url => new_project_path}
  end

 if @projects.length > 0 
 t('name') 
 t('options') 
 @projects.each do |project| 
 if can?(:change_status, project) 
 project.is_active? ? checkbox_link(complete_project_path(:id => project.id), false, nil, {:method => :put}) : checkbox_link(open_project_path(:id => project.id), true, nil, {:method => :put}) 
 else 
 if project.is_active? 
 icon_url('not-checked') 
 t('active_project') 
 else 
 icon_url('checked') 
 t('finished_project') 
 end 
 end 
 link_to h(project.name), project_path(:id => project.id) 
 action_list actions_for_project(project) 
 end 
 else 
 t('no_projects_owned_by_company') 
 end 

end

      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :create_project, current_user
  	@page_actions << {:title => :add_project, :url => new_project_path}
  end

 if @projects.length > 0 
 t('name') 
 t('options') 
 @projects.each do |project| 
 if can?(:change_status, project) 
 project.is_active? ? checkbox_link(complete_project_path(:id => project.id), false, nil, {:method => :put}) : checkbox_link(open_project_path(:id => project.id), true, nil, {:method => :put}) 
 else 
 if project.is_active? 
 icon_url('not-checked') 
 t('active_project') 
 else 
 icon_url('checked') 
 t('finished_project') 
 end 
 end 
 link_to h(project.name), project_path(:id => project.id) 
 action_list actions_for_project(project) 
 end 
 else 
 t('no_projects_owned_by_company') 
 end 

end

  end
  
  def show
    respond_to do |format|
      format.html {
        when_fragment_expired "user#{@logged_user.id}_#{@project.id}_dblog", Time.now.utc + (60 * Rails.configuration.minutes_to_activity_log_expire) do
          @project_log_entries = (@logged_user.member_of_owner? ? @project.activities : @project.activities.is_public)[0..(Rails.configuration.project_logs_per_page-1)]
        end

        @time_now = Time.zone.now
        @late_milestones = @project.milestones.late
        @late_milstones = @late_milestones.is_public unless @logged_user.member_of_owner?
        @upcoming_milestones = Milestone.all_assigned_to(@logged_user, nil, @time_now.utc.to_date, (@time_now.utc + 14.days).to_date, [@project])

        @calendar_milestones = @upcoming_milestones.group_by do |obj| 
          date = obj.due_date.to_date
          "#{date.month}-#{date.day}"
        end

        @project_companies = @project.companies
        @important_messages = @project.messages.important
        @important_messages = @important_messages.is_public unless @logged_user.member_of_owner?
        @important_files = @project.project_files.important
        @important_files = @important_files.is_public unless @logged_user.member_of_owner?

        @content_for_sidebar = 'overview_sidebar'
      }
      format.xml  { 
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :create_message, @active_project
    @page_actions << {:title => :add_message, :url=> new_message_path(:active_project => @active_project.id)}
  end

  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path(:active_project => @active_project.id)}
  end
  
  if can? :create_milestone, @active_project
    @page_actions << {:title => :add_milestone, :url=> new_milestone_path(:active_project => @active_project.id)}
  end

  if can? :create_file, @active_project
    @page_actions << {:title => :add_file, :url=> new_file_path(:active_project => @active_project.id)}
  end

 if @active_project.description.chop and @active_project.show_description_in_overview 
 h @active_project.name 
 textilize @active_project.description 
 end 
 if @late_milestones.length > 0 or !@calendar_milestones.empty? 
 t('milestones_summary', :adjetives => [!@late_milestones.empty? ? t('late') : nil,
                           !@calendar_milestones.empty? ? t('upcoming') : nil].compact.to_sentence) 
 if @late_milestones.length > 0 
 t('late_milestones') 
 @late_milestones.each do |milestone| 
 unless milestone.assigned_to.nil? 
 h milestone.assigned_to.object_name 
 end 
 t('milestone_in', :milestone => link_to(h(milestone.name), milestone_path(:id => milestone.id, :active_project => milestone.project)), :project => link_to(h(milestone.project.name), project_path(:id => milestone.project.id))).html_safe 
 t('milestone_days_late', :days => milestone.days_late) 
 end 
 end 
 unless @calendar_milestones.empty? 
 t('due_in_next_n_days', :num => 14) 
 now = @time_now.to_date
      prev_month = now.month
      days_calendar now, now + 13.days, 'dayCal' do |date|
        if date == now
          calendar_block(t('today'), @calendar_milestones["#{date.month}-#{date.day}"], 'today', true) 
        else
          if date.month != prev_month 
            prev_month = date.month
            calendar_block(l(date, :format => '%b %d'), @calendar_milestones["#{date.month}-#{date.day}"], 'day')
          else
            calendar_block(date.day, @calendar_milestones["#{date.month}-#{date.day}"], 'day') 
          end
        end
      end 
 end 
 end 
 t('recent_activities') 
 cache "user#{@logged_user.id}_#{@active_project.id}_dblog" do 
 if @project_log_entries.length > 0 
 t('details') 
 t('log_date') 
  if application_logs.is_today? 
 elsif application_logs.is_yesterday? 
 else 
 end 
 "#{application_logs.rel_object_type.downcase}s.gif" 
 application_logs.rel_object_type 
 application_logs.rel_object_type 
 if not ['Comment', 'Message'].include?(application_logs.rel_object_type) 
 application_logs.friendly_action 
 end 
 application_logs.rel_object.nil? ? h(truncate(application_logs.object_name, :length => 50)) : link_to(h(truncate(application_logs.object_name, :length => 50)), application_logs.rel_object.object_url) 
 if show_project_column 
 if application_logs.is_today? 
 t('action_today_with_time', :time => format_usertime(application_logs.created_on, :action_today_fomat)) 
 elsif application_logs.is_yesterday? 
 t('action_yesterday') 
 else 
 format_usertime(application_logs.created_on, :action_past_format) 
 end 
 if not application_logs.created_by.nil? 
 link_to (h application_logs.created_by.display_name), user_path(:id => application_logs.created_by.id) 
 end 
 end 
 if show_project_column 
 if not application_logs.project.nil? 
 link_to (h application_logs.project.name), project_path(:id => application_logs.project.id) 
 end 
 else 
 if application_logs.is_today? 
 t('action_today_with_time', :time => format_usertime(application_logs.created_on, :action_today_fomat)).html_safe 
 elsif application_logs.is_yesterday? 
 t('action_yesterday') 
 else 
 format_usertime(application_logs.created_on, :action_past_format) 
 end 
 if not application_logs.created_by.nil? 
 t('action_by', :user => link_to(h(application_logs.created_by.display_name), user_path(:id => application_logs.created_by.id))).html_safe 
 end 
 end 
 
 else 
 t('no_recent_activities') 
 end 
 end 

end

      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :create_message, @active_project
    @page_actions << {:title => :add_message, :url=> new_message_path(:active_project => @active_project.id)}
  end

  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path(:active_project => @active_project.id)}
  end
  
  if can? :create_milestone, @active_project
    @page_actions << {:title => :add_milestone, :url=> new_milestone_path(:active_project => @active_project.id)}
  end

  if can? :create_file, @active_project
    @page_actions << {:title => :add_file, :url=> new_file_path(:active_project => @active_project.id)}
  end

 if @active_project.description.chop and @active_project.show_description_in_overview 
 h @active_project.name 
 textilize @active_project.description 
 end 
 if @late_milestones.length > 0 or !@calendar_milestones.empty? 
 t('milestones_summary', :adjetives => [!@late_milestones.empty? ? t('late') : nil,
                           !@calendar_milestones.empty? ? t('upcoming') : nil].compact.to_sentence) 
 if @late_milestones.length > 0 
 t('late_milestones') 
 @late_milestones.each do |milestone| 
 unless milestone.assigned_to.nil? 
 h milestone.assigned_to.object_name 
 end 
 t('milestone_in', :milestone => link_to(h(milestone.name), milestone_path(:id => milestone.id, :active_project => milestone.project)), :project => link_to(h(milestone.project.name), project_path(:id => milestone.project.id))).html_safe 
 t('milestone_days_late', :days => milestone.days_late) 
 end 
 end 
 unless @calendar_milestones.empty? 
 t('due_in_next_n_days', :num => 14) 
 now = @time_now.to_date
      prev_month = now.month
      days_calendar now, now + 13.days, 'dayCal' do |date|
        if date == now
          calendar_block(t('today'), @calendar_milestones["#{date.month}-#{date.day}"], 'today', true) 
        else
          if date.month != prev_month 
            prev_month = date.month
            calendar_block(l(date, :format => '%b %d'), @calendar_milestones["#{date.month}-#{date.day}"], 'day')
          else
            calendar_block(date.day, @calendar_milestones["#{date.month}-#{date.day}"], 'day') 
          end
        end
      end 
 end 
 end 
 t('recent_activities') 
 cache "user#{@logged_user.id}_#{@active_project.id}_dblog" do 
 if @project_log_entries.length > 0 
 t('details') 
 t('log_date') 
  if application_logs.is_today? 
 elsif application_logs.is_yesterday? 
 else 
 end 
 "#{application_logs.rel_object_type.downcase}s.gif" 
 application_logs.rel_object_type 
 application_logs.rel_object_type 
 if not ['Comment', 'Message'].include?(application_logs.rel_object_type) 
 application_logs.friendly_action 
 end 
 application_logs.rel_object.nil? ? h(truncate(application_logs.object_name, :length => 50)) : link_to(h(truncate(application_logs.object_name, :length => 50)), application_logs.rel_object.object_url) 
 if show_project_column 
 if application_logs.is_today? 
 t('action_today_with_time', :time => format_usertime(application_logs.created_on, :action_today_fomat)) 
 elsif application_logs.is_yesterday? 
 t('action_yesterday') 
 else 
 format_usertime(application_logs.created_on, :action_past_format) 
 end 
 if not application_logs.created_by.nil? 
 link_to (h application_logs.created_by.display_name), user_path(:id => application_logs.created_by.id) 
 end 
 end 
 if show_project_column 
 if not application_logs.project.nil? 
 link_to (h application_logs.project.name), project_path(:id => application_logs.project.id) 
 end 
 else 
 if application_logs.is_today? 
 t('action_today_with_time', :time => format_usertime(application_logs.created_on, :action_today_fomat)).html_safe 
 elsif application_logs.is_yesterday? 
 t('action_yesterday') 
 else 
 format_usertime(application_logs.created_on, :action_past_format) 
 end 
 if not application_logs.created_by.nil? 
 t('action_by', :user => link_to(h(application_logs.created_by.display_name), user_path(:id => application_logs.created_by.id))).html_safe 
 end 
 end 
 
 else 
 t('no_recent_activities') 
 end 
 end 

end

  end

  def search
    @current_search = params[:search_id]

    unless @current_search.nil?
      @last_search = @current_search

      current_page = params[:page].to_i
      current_page = 1 unless current_page > 0

      @search_results, @total_search_results = @project.search(@last_search, !@logged_user.member_of_owner?, {:page => current_page, :per_page => Rails.configuration.search_results_per_page})

      @tag_names, @total_search_tags = @project.search(@last_search, !@logged_user.member_of_owner?, {}, true)
      @pagination = []
      @start_search_results = Rails.configuration.search_results_per_page * (current_page-1)
      (@total_search_results.to_f / Rails.configuration.search_results_per_page).ceil.times {|page| @pagination << page+1}
    else
      @last_search = I18n.t('search_box_default')
      @search_results = []

      @tag_names = Tag.list_by_project(@project, !@logged_user.member_of_owner?, false)
    end
    
    respond_to do |format|
      format.html {
        @content_for_sidebar = 'search_sidebar' 
      }
      format.xml {
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag :action => 'search' 
 text_field_tag 'search_id', @last_search 
 t('search') 
 if !@search_results.empty? 
 t('search_displaying_results_for', {:start => @start_search_results, 
                                                   :finish => @start_search_results+@search_results.length, 
                                                   :total => @total_search_results,
                                                   :search => h(@current_search)}).html_safe 
 @search_results.each do |obj| 
 t('search_project', :type => t(obj.class.to_s), 
                                      :name => link_to(obj.object_name, obj.object_url)).html_safe 
 end 
 pagination_links  "#{search_project_path(@active_project)}?search_id=#{CGI::escape(@last_search)}&", @pagination unless @pagination.length <= 1 
 elsif !@current_search.nil? 
 t('search_no_matching_objects', {:search => h(@current_search)}).html_safe 
 end 

end
 
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag :action => 'search' 
 text_field_tag 'search_id', @last_search 
 t('search') 
 if !@search_results.empty? 
 t('search_displaying_results_for', {:start => @start_search_results, 
                                                   :finish => @start_search_results+@search_results.length, 
                                                   :total => @total_search_results,
                                                   :search => h(@current_search)}).html_safe 
 @search_results.each do |obj| 
 t('search_project', :type => t(obj.class.to_s), 
                                      :name => link_to(obj.object_name, obj.object_url)).html_safe 
 end 
 pagination_links  "#{search_project_path(@active_project)}?search_id=#{CGI::escape(@last_search)}&", @pagination unless @pagination.length <= 1 
 elsif !@current_search.nil? 
 t('search_no_matching_objects', {:search => h(@current_search)}).html_safe 
 end 

end

  end

  def people
    authorize! :show, @project

    @project_companies = @project.companies

    respond_to do |format|
      format.html {
      }
      format.xml {
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :manage, @project
    @page_actions << {:title => :permissions, :url=> permissions_project_path(:id => @active_project.id)}
  end

  company = people_list; company_card = company 
 h company.name 
 link_to company do 
 company_card.logo_url 
 h company_card.name 
 end 
 link_to (h company_card.name), company 
 if company_card.email? 
 h company_card.email 
 h company_card.email 
 end 
 if company_card.homepage? 
 link_to h(company_card.homepage), company_card.homepage 
 end 
 if company_card.fax_number? 
 t('fax') 
 h(company_card.fax_number) 
 end 
 if company_card.phone_number? 
 t('home') 
 h(company_card.phone_number) 
 end 
 if company_card.address? 
 h company_card.address 
 end 
 if company_card.address2? 
 h company_card.address2 
 end 
 if company_card.city? and company_card.state? 
 h company_card.city 
 h company_card.state 
 if company_card.zipcode? 
 h company_card.zipcode 
 end 
 if company_card.country? 
 h company_card.country 
 end 
 end 
 if can? :edit, company_card 
 action_list actions_for_company(company) 
 end 
 num_users = 1 
 users = @active_project.nil? ? company.users : company.users_on_project(@active_project) 
 (users.sort{ |x,y| x.display_name <=> y.display_name }).each do |user| 
 user_card = user 
 link_to user do 
 user_card.avatar_url 
 h user_card.display_name 
 end 
 link_to (h user_card.display_name), user 
 if user_card.title? 
 h user_card.title 
 end 
 h user_card.email 
 h user_card.email 
 user_card.im_values.each do |im_value| 
 next if im_value.value.blank? 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 h im_value.value 
 end 
 if user_card.office_number? 
 t('office') 
 h(user_card.office_number) 
 end 
 if user_card.fax_number? 
 t('fax') 
 h(user_card.fax_number) 
 end 
 if user_card.mobile_number? 
 t('mobile') 
 h(user_card.mobile_number) 
 end 
 if user_card.home_number? 
 t('home') 
 h(user_card.home_number) 
 end 
 if user_card.owner_of_owner? 
 t('owner') 
 end 
 if can?(:update_profile, user_card) 
 action_list actions_for_user(user_card) 
 end 
 num_users += 1 
 if num_users % 3 == 0 
 end 
 end 
 unless num_users % 3 == 0 
 end 
 
 if can? :manage, @project 
 t('permissions_info', :link => link_to(t('permissions_form'), permissions_project_path(:id => @active_project.id))).html_safe 
 end 

end
 
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :manage, @project
    @page_actions << {:title => :permissions, :url=> permissions_project_path(:id => @active_project.id)}
  end

  company = people_list; company_card = company 
 h company.name 
 link_to company do 
 company_card.logo_url 
 h company_card.name 
 end 
 link_to (h company_card.name), company 
 if company_card.email? 
 h company_card.email 
 h company_card.email 
 end 
 if company_card.homepage? 
 link_to h(company_card.homepage), company_card.homepage 
 end 
 if company_card.fax_number? 
 t('fax') 
 h(company_card.fax_number) 
 end 
 if company_card.phone_number? 
 t('home') 
 h(company_card.phone_number) 
 end 
 if company_card.address? 
 h company_card.address 
 end 
 if company_card.address2? 
 h company_card.address2 
 end 
 if company_card.city? and company_card.state? 
 h company_card.city 
 h company_card.state 
 if company_card.zipcode? 
 h company_card.zipcode 
 end 
 if company_card.country? 
 h company_card.country 
 end 
 end 
 if can? :edit, company_card 
 action_list actions_for_company(company) 
 end 
 num_users = 1 
 users = @active_project.nil? ? company.users : company.users_on_project(@active_project) 
 (users.sort{ |x,y| x.display_name <=> y.display_name }).each do |user| 
 user_card = user 
 link_to user do 
 user_card.avatar_url 
 h user_card.display_name 
 end 
 link_to (h user_card.display_name), user 
 if user_card.title? 
 h user_card.title 
 end 
 h user_card.email 
 h user_card.email 
 user_card.im_values.each do |im_value| 
 next if im_value.value.blank? 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 h im_value.value 
 end 
 if user_card.office_number? 
 t('office') 
 h(user_card.office_number) 
 end 
 if user_card.fax_number? 
 t('fax') 
 h(user_card.fax_number) 
 end 
 if user_card.mobile_number? 
 t('mobile') 
 h(user_card.mobile_number) 
 end 
 if user_card.home_number? 
 t('home') 
 h(user_card.home_number) 
 end 
 if user_card.owner_of_owner? 
 t('owner') 
 end 
 if can?(:update_profile, user_card) 
 action_list actions_for_user(user_card) 
 end 
 num_users += 1 
 if num_users % 3 == 0 
 end 
 end 
 unless num_users % 3 == 0 
 end 
 
 if can? :manage, @project 
 t('permissions_info', :link => link_to(t('permissions_form'), permissions_project_path(:id => @active_project.id))).html_safe 
 end 

end

  end

  def permissions
    authorize! :manage, @project

    case request.request_method_symbol
    when :get
      @people = @project.users
      @user_projects = @logged_user.projects

      @companies = [Company.owner]
      @permissions = Person.permission_names()
      clients = Company.owner.clients
      if clients.length > 0
        @companies += clients
      end
    when :post, :put
      # Sort out changes to the company set
      @project.companies.clear
      @project.companies << Company.owner
      if params[:project_company]
        valid_companies = Company.where(:id => params[:project_company]).select('id')
        valid_companies.each{ |valid_company| @project.companies << valid_company unless valid_company.is_owner? }
      end

      valid_user_ids = params[:people] || []

      # Grab the old user set
      people = @project.people.all :include => {:user => :company}

      # Destroy the Person entry for each non-active user
      people.each do |person|
        user = person.user
        next if user.owner_of_owner?

        # Have a look to see if it is on our list
        has_valid_user = valid_user_ids.include? user.id.to_s
        # Have another look to see if his company is enabled
        has_valid_company = valid_companies.include? user.company

        if has_valid_user and has_valid_company
          permissions = params[:people_permissions] ? params[:people_permissions][user.id.to_s] : nil
          person.reset_permissions
          person.update_str permissions unless permissions.nil?
          person.ensure_permissions if person.user.member_of_owner?
          person.save
        else
          # Exterminate! (maybe better if this was a single query?)
          person.destroy
        end
        valid_user_ids.delete user.id.to_s if has_valid_user

        # Also check if he is activated
        #
      end

      # Create new Person entries for new users

      users = User.where(:id => valid_user_ids).includes(:company)
      users.each do |user|
        next unless valid_companies.include? user.company
        person = @project.people.create(:user => user)
        permissions = params[:people_permissions] ? params[:people_permissions][id] : nil
        person.reset_permissions
        person.update_str permissions unless permissions.nil?
        person.ensure_permissions if person.user.member_of_owner?
        person.save
      end

      # Now we can do the log keeping!
      #@project.updated_by = @logged_user

      error_status(false, :success_updated_permissions)
      redirect_to people_project_path(:id => @project.id)
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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

  end

  def users
    authorize! :manage, @project

    case request.request_method_symbol
    when :delete
      user = User.find(params[:user_id])
      unless user.owner_of_owner?
        Person.delete_all(['user_id = ? AND project_id = ?', params[:user], @project.id])
      end
    end

    respond_to do |format|
      format.html { redirect_back_or_default people_project_path(:id => @project.id) }
      format.xml  { render :xml => :ok }
    end
  end

  def companies
    authorize! :manage, @project

    case request.request_method_symbol
    when :delete
      company = Company.find(params[:company_id])
      unless company.is_owner?
        company_user_ids = company.users.collect{ |user| user.id }
        Person.delete_all({ :user_id => company_user_ids, :project_id => @project.id })
        @project.companies.delete(company)
      end
    end
    
    respond_to do |format|
      format.html { redirect_back_or_default people_project_path(:id => @project.id) }
      format.xml  { render :xml => :ok }
    end
  end

  def new
    authorize! :create_project, current_user

    @project = Project.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag projects_path 
  error_messages_for :project 
 t('name') 
 text_field 'project', 'name', :id => 'projectFormName', :class => 'long' 
 t('priority') 
 text_field 'project', 'priority', :id => 'projectPriority', :class => 'long' 
 t('description') 
 text_area 'project', 'description', :id => 'projectFormDescription', :class => 'short', :rows => 10, :cols => 40 
 t('project_show_description_in_overview') 
 yesno_toggle 'project', 'show_description_in_overview', :id => 'projectFormShowDescription', :class => 'yes_no'  
 
 t('add_project') 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag projects_path 
  error_messages_for :project 
 t('name') 
 text_field 'project', 'name', :id => 'projectFormName', :class => 'long' 
 t('priority') 
 text_field 'project', 'priority', :id => 'projectPriority', :class => 'long' 
 t('description') 
 text_area 'project', 'description', :id => 'projectFormDescription', :class => 'short', :rows => 10, :cols => 40 
 t('project_show_description_in_overview') 
 yesno_toggle 'project', 'show_description_in_overview', :id => 'projectFormShowDescription', :class => 'yes_no'  
 
 t('add_project') 

end

  end

  def create
    authorize! :create_project, current_user

    @project = Project.new
    
    project_attribs = params[:project]

    @project.attributes = project_attribs
    @project.created_by = @logged_user
    @project.companies << Company.owner

    @auto_assign_users = Company.owner.auto_assign_users
    saved = @project.save

    if saved
      # Add auto assigned people (note: we assume default permissions are all access)
      @auto_assign_users.each do |user|
        @project.users << user unless (user == @logged_user)
      end

      @project.users << @logged_user

      # Add default folders
      Rails.configuration.default_project_folders.each do |folder_name|
        folder = Folder.new(:name => folder_name)
        folder.project = @project
        folder.save
      end

      # Add default message categories
      Rails.configuration.default_project_message_categories.each do |category_name|
        category = Category.new(:name => category_name)
        category.project = @project
        category.save
      end
    end
    
    respond_to do |format|
      if saved
        format.html {
          error_status(false, :success_added_project)
          redirect_to permissions_project_path(:id => @project.id)
        }
        
        format.xml  { render :xml => @project.to_xml(:root => 'project'), :status => :created, :location => @project }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag projects_path 
  error_messages_for :project 
 t('name') 
 text_field 'project', 'name', :id => 'projectFormName', :class => 'long' 
 t('priority') 
 text_field 'project', 'priority', :id => 'projectPriority', :class => 'long' 
 t('description') 
 text_area 'project', 'description', :id => 'projectFormDescription', :class => 'short', :rows => 10, :cols => 40 
 t('project_show_description_in_overview') 
 yesno_toggle 'project', 'show_description_in_overview', :id => 'projectFormShowDescription', :class => 'yes_no'  
 
 t('add_project') 

end
 }
        
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    authorize! :edit, @project
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag project_path(:id => @active_project.id), :method => :put 
  error_messages_for :project 
 t('name') 
 text_field 'project', 'name', :id => 'projectFormName', :class => 'long' 
 t('priority') 
 text_field 'project', 'priority', :id => 'projectPriority', :class => 'long' 
 t('description') 
 text_area 'project', 'description', :id => 'projectFormDescription', :class => 'short', :rows => 10, :cols => 40 
 t('project_show_description_in_overview') 
 yesno_toggle 'project', 'show_description_in_overview', :id => 'projectFormShowDescription', :class => 'yes_no'  
 
 t('save_changes') 
 t('or') 
 link_to t('cancel'), :back 

end

  end

  def update
    authorize! :edit, @project

    @project.attributes = params[:project]
    @project.updated_by = @logged_user
    
    respond_to do |format|
      if @project.save
        format.html {
          error_status(false, :success_edited_project)
          redirect_back_or_default(@project)
        }
        
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag project_path(:id => @active_project.id), :method => :put 
  error_messages_for :project 
 t('name') 
 text_field 'project', 'name', :id => 'projectFormName', :class => 'long' 
 t('priority') 
 text_field 'project', 'priority', :id => 'projectPriority', :class => 'long' 
 t('description') 
 text_area 'project', 'description', :id => 'projectFormDescription', :class => 'short', :rows => 10, :cols => 40 
 t('project_show_description_in_overview') 
 yesno_toggle 'project', 'show_description_in_overview', :id => 'projectFormShowDescription', :class => 'yes_no'  
 
 t('save_changes') 
 t('or') 
 link_to t('cancel'), :back 

end
 }
        
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :delete, @project

    @project.updated_by = @logged_user
    @project.destroy
    
    respond_to do |format|
      format.html {
        error_status(false, :success_deleted_project)
        redirect_back_or_default(:controller => 'dashboard')
      }
      
      format.xml  { head :ok }
    end
  end

  def complete
    authorize! :change_status, @project
    return error_status(true, :project_already_completed) unless @project.is_active?

    @project.set_completed(true, @logged_user)
    saved = @project.save
    
    respond_to do |format|
      format.html {
        error_status(false, :error_saving) unless saved
        redirect_back_or_default :controller => 'administration', :action => 'projects'
      }
      
      format.xml  { head :ok }
    end
  end

  def open
    authorize! :change_status, @project
    return error_status(true, :project_already_open) if @project.is_active?

    @project.set_completed(false, @logged_user)
    saved = @project.save

    respond_to do |format|
      format.html {
        error_status(false, :error_saving) unless saved
        redirect_back_or_default :controller => 'administration', :action => 'projects'
      }
      
      format.xml  { head :ok }
    end
  end

protected

  def project_layout
    ['new', 'create', 'edit' 'update'].include?(action_name) ? 'administration' : 'project_website'
  end

   def obtain_project
     begin
        @project = Project.find(params[:id])
        @active_project = @project
     rescue ActiveRecord::RecordNotFound
       error_status(true, :invalid_project)
       redirect_back_or_default :controller => 'dashboard'
       return false
     end
     
     return true
  end
end
