#==
# RailsCollab
# Copyright (C) 2011 James S Urquhart
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

class Ability
  include CanCan::Ability

  def initialize(user)
	end
    # Task

    def can_create_task_TaskList(task_list)
      task_list.project.is_active? and user.member_of(task_list.project) and (!(task_list.is_private and !user.member_of_owner?) and can?(:manage, task_list))
    end

    def can_edit_Task(task)
      task_list = task.task_list
      project = task_list.project
      
      if !user.member_of(project) or !project.is_active? or user.is_anonymous?
        false
      elsif user.is_admin
        true
      elsif (task.assigned_to == user) or (task.assigned_to == user.company) or task.assigned_to.nil?
        true
      elsif task.created_by_id == user.id and (task.created_on + 3.minutes) < Time.now.utc # Owner editable for 3 mins
        true
      else
        can? :edit, task_list
      end
    end

    def can_delete_Task(task)
      can? :delete, task.task_list
    end

    def can_show_Task(task)
      can?(:show, task.task_list) or can?(:edit, task)
    end

    def can_complete_Task(task)
      can? :edit, task
    end

    def can_comment_Task(task)
      can? :comment, task.task_list
    end

    # TaskList

    def can_create_task_list_Project(project)
      project.is_active? and user.has_permission(project, :can_manage_tasks)
    end

    def can_manage_TaskList(task_list)
      task_list.project.is_active? and user.has_permission(task_list.project, :can_manage_tasks)
    end

    def can_edit_TaskList(task_list)
      if !task_list.project.is_active? or !user.member_of(task_list.project) or user.is_anonymous?
        false
      elsif user.is_admin
        true
      else
        !(task_list.is_private and !user.member_of_owner?) and user.id == task_list.created_by_id
      end
    end

    def can_delete_TaskList(task_list)
      task_list.project.is_active? and user.member_of(task_list.project) and user.is_admin
    end

    def can_show_TaskList(task_list)
      user.member_of(task_list.project) and !(task_list.is_private and !user.member_of_owner?)
    end

    def can_comment_TaskList(task_list)
      task_list.project.is_active? and task_list.project.has_member(user) and !user.is_anonymous?
    end

    # TimeRecord

    def can_create_time_TimeRecord(project)
      project.is_active? and user.has_permission(project, :can_manage_time)
    end

    def can_edit_TimeRecord(project_time)
      if (!user.member_of(project_time.project))
        false
      else
        (user.is_admin or project_time.created_by_id == user.id) and project_time.project.is_active?
      end
    end

    def can_delete_TimeRecord(project_time)
      project_time.project.is_active? and user.member_of(project_time.project) and user.is_admin
    end

    def can_show_TimeRecord(project_time)
      if !project_time.project.has_member(user)
        false
      elsif user.has_permission(project_time.project, :can_manage_time)
        true
      elsif project_time.is_private and !user.member_of_owner?
        false
      else
        true
      end
    end

    def can_manage_time_Project(project)
      project.is_active? and user.has_permission(project, :can_manage_time)
    end

    def can_manage_TimeRecord(project_time)
      project_time.project.is_active? and user.has_permission(project_time.project, :can_manage_time)
    end

    # Milestone

    def can_create_milestone_Project(project)
      project.is_active? and user.has_permission(project, :can_manage_milestones)
    end

    def can_edit_Milestone(milestone)
      if (!milestone.project.is_active? or !user.member_of(milestone.project))
        false
      else
        user.is_admin or milestone.created_by_id == user.id
      end
    end

    def can_delete_Milestone(milestone)
      milestone.project.is_active? and user.member_of(milestone.project) and user.is_admin
    end

    def can_show_Milestone(milestone)
      user.member_of(milestone.project) and !(milestone.is_private and !user.member_of_owner?)
    end

    def can_manage_Milestone(milestone)
      milestone.project.is_active? and user.has_permission(milestone.project, :can_manage_milestones)
    end
    
    def can_change_status_Milestone(milestone)
      if can?(:edit, milestone)
        true
      else
        milestone_assigned_to = milestone.assigned_to
        (milestone_assigned_to == user) or (milestone_assigned_to == user.company)
      end
    end
    
    def can_comment_Milestone(milestone)
      milestone.project.is_active? and milestone.project.has_member(user) and !user.is_anonymous?
    end

    # Category

    def can_create_message_category_Project(project)
      project.is_active? and user.has_permission(project, :can_manage_messages)
    end

    def can_edit_Category(category)
      category.project.is_active? and user.has_permission(category.project, :can_manage_messages)
    end

    def can_delete_Category(category)
      category.project.is_active? and user.has_permission(category.project, :can_manage_messages)
    end

    def can_show_Category(category)
      category.project.has_member(user)
    end

    def can_manage_Category(category)
      category.project.is_active? and user.has_permission(category.project, :can_manage_messages)
    end

    # Message

    def can_create_message_Project(project)
      project.is_active? and user.has_permission(project, :can_manage_messages)
    end

    def can_edit_Message(message)
      if !message.project.is_active? or !user.member_of(message.project)
        false
      elsif user.is_admin
        true
      else
        !(message.is_private and !user.member_of_owner?) and user.id == message.created_by_id
      end
    end

    def can_delete_Message(message)
      user.is_admin and message.project.is_active? and user.member_of(message.project)
    end

    def can_show_Message(message)
      if !user.member_of(message.project)
        false
      else
        !(message.is_private and !user.member_of_owner?)
      end
    end
    
    def can_subscribe_Message(message)
      message.comments_enabled and message.project.is_active? and user.member_of(message.project) and !(message.is_private and !user.member_of_owner?)
    end

    def can_manage_Message(message)
      message.project.is_active? and user.has_permission(message.project, :can_manage_messages)
    end

    def can_add_file_Message(message)
      can?(:edit, message) and user.has_permission(message.project, :can_upload_files)
    end
    
    def can_change_options_Message(message)
      user.member_of_owner? and can?(:edit, message)
    end
    
    def can_comment_Message(message)
      project = message.project
      if user.is_anonymous?
        message.anonymous_comments_enabled and project.is_active? and user.member_of(project) and !message.is_private
      else
        message.comments_enabled and project.is_active? and user.member_of(project) and !(message.is_private and !user.member_of_owner?)
      end
    end

    # Folder

    def can_create_folder_Project(project)
      folder.project.is_active? and user.has_permission(folder.project, :can_manage_files)
    end

    def can_edit_Folder(folder)
      folder.project.is_active? and user.has_permission(folder.project, :can_manage_files)
    end

    def can_delete_Folder(folder)
      folder.project.is_active? and user.has_permission(folder.project, :can_manage_files)
    end

    def can_show_Folder(folder)
      folder.project.has_member(user)
    end

    def can_manage_Folder(folder)
      folder.project.is_active? and user.has_permission(folder.project, :can_manage_files)
    end

    # ProjectFile

    def can_create_file_Project(project)
      project.is_active? and user.has_permission(project, :can_upload_files)
    end

    def can_edit_ProjectFile(project_file)
      if (!project_file.project.is_active? or !(user.member_of(project_file.project) and user.has_permission(project_file.project, :can_manage_files)))
        false
      elsif user.is_admin
        true
      else
        !(project_file.is_private and !user.member_of_owner?) and user.id == project_file.created_by_id
      end
    end

    def can_delete_ProjectFile(project_file)
      user.is_admin and project_file.project.is_active? and user.member_of(project_file.project)
    end

    def can_show_ProjectFile(project_file)
      if !user.member_of(project_file.project)
        false
      else
        !(project_file.is_private and !user.member_of_owner?)
      end
    end

    def can_manage_ProjectFile(project_file)
      project_file.project.is_active? and user.has_permission(project_file.project, :can_manage_files)
    end

    def can_download_ProjectFile(project_file)
      can? :show, project_file
    end
    
    def can_change_options_ProjectFile(project_file)
      user.member_of_owner? and can?(:edit, project_file)
    end
    
    def can_comment_ProjectFile(project_file)
      project = project_file.project
      if user.is_anonymous?
        project_file.anonymous_comments_enabled and project.is_active? and user.member_of(project) and !project_file.is_private
      else
        project_file.comments_enabled and project.is_active? and user.member_of(project) and !(project_file.is_private and !user.member_of_owner?)
      end
    end

    # Project

    def can_create_project_User(user)
      user.member_of_owner? and user.is_admin
    end

    def can_edit_Project(project)
      user.member_of_owner? and user.is_admin
    end

    def can_delete_Project(project)
      user.member_of_owner? and user.is_admin
    end

    def can_show_Project(project)
      project.has_member(user) or (user.member_of_owner? and user.is_admin)
    end

    def can_manage_Project(project)
      user.member_of_owner? and user.is_admin
    end
    
    def can_remove_company_Project(project, company)
      if company.is_owner?
        false
      else
        user.member_of_owner? and user.is_admin
      end
    end

    def can_remove_user_Project(project, target_user)
      if target_user.owner_of_owner?
        false
      else
        user.member_of_owner? and user.is_admin
      end
    end

    def can_change_status_Project(project)
      can? :edit, project
    end

    # Comment

    def can_edit_Comment(comment)
      comment_project = comment.rel_object.project

      if comment_project.is_active? and comment_project.has_member(user)
        if (user.member_of_owner? and user.is_admin)
          true
        elsif comment.created_by == user and !user.is_anonymous?
          now = Time.now.utc
          (now <= (comment.created_on + (60 * Rails.configuration.minutes_to_comment_edit_expire)))
        end
      end

      false
    end

    def can_delete_Comment(comment)
      can? :delete, comment.rel_object
    end

    def can_show_Comment(comment)
      if (comment.is_private and !user.member_of_owner?)
        false
      else
        can? :show, comment.rel_object
      end
    end

    def can_add_file_Comment(comment)
      can?(:edit, comment) and (comment.new_record? and user.has_permission(comment.rel_object.project, :can_upload_files))
    end

    # Company

    def can_create_company_User(user)
      user.is_admin and user.member_of_owner?
    end

    def can_edit_Company(company)
      user.is_admin and (user.company == company or user.member_of_owner?)
    end

    def can_delete_Company(company)
      user.is_admin and user.member_of_owner?
    end

    def can_show_Company(company)
      true
    end

    def can_add_client_Company(company)
      user.is_admin and user.member_of_owner?
    end

    def can_remove_Company(company)
      !company.is_owner? and user.is_admin and user.member_of_owner?
    end

    def can_manage_Company(company)
      user.is_admin and !company.is_owner?
    end

    # User

    def can_create_user_User(user)
      user.member_of_owner? and user.is_admin
    end

    def can_delete_User(target_user)
      if target_user.owner_of_owner? or user.id == target_user.id
        false
      else
        user.is_admin
      end
    end

    def can_show_User(target_user)
      user.member_of_owner? or user.company_id == target_user.company_id or target_user.member_of_owner?
    end
    
    def can_update_profile_User(target_user)
      (target_user.id == user.id and !user.is_anonymous?) or (user.member_of_owner? and user.is_admin)
    end

    def can_update_permissions_User(target_user)
      if target_user.owner_of_owner?
        false
      else
        user.member_of_owner? and user.is_admin
      end
    end
    
    # WikiPage
    
    def can_create_wiki_page_Project(project)
      project.is_active? and user.member_of(project) and user.has_permission(project, :can_manage_wiki_pages)
    end

    def can_edit_WikiPage(page)
      page.project.is_active? and user.member_of(page.project) and user.has_permission(page.project, :can_manage_wiki_pages)
    end

    def can_delete_WikiPage(page)
      user.is_admin and page.project.is_active? and user.member_of(page.project)
    end


end
