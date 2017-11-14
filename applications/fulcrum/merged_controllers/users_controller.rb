class UsersController < ApplicationController

  respond_to :html, :json

  def index
    @project = current_user.projects.find(params[:project_id])
    @users = @project.users
    @user = User.new
    respond_with(@users)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "#{@project.name} - " if @project 
 t('fulcrum') 
 csrf_meta_tag 
 stylesheet_link_tag :application 
 javascript_include_tag :application 
 javascript_tag do 
 I18n.default_locale 
 I18n.locale 
 end 
 link_to t('fulcrum'), root_path 
 if current_user 
 ' class="secondary"'.html_safe if current_user.projects.present? 
 link_to Project.model_name.human(:count => 2), root_path 
 if current_user.projects.present? 
 current_user.projects.each do |project| 
 link_to project, project 
 end 
 end 
 link_to current_user.email, edit_user_registration_path 
 link_to t('log out'), destroy_user_session_path,
                      :method => :delete 
 else 
 link_to t('log in'), new_user_session_path 
 unless Fulcrum::Application.config.fulcrum.disable_registration 
 link_to t('sign up'), new_user_registration_path 
 end 
 end 
 project.name 
 if defined? show_column_toggles 
 end 
 link_to_unless_current Story.model_name.human(:count => 2), project_path(project) 
 link_to_unless_current User.model_name.human(:count => 2), project_users_path(project) 
 link_to_unless_current t('edit'), edit_project_path(project) 
 link_to_unless_current t('import'), import_project_stories_path(project) 
 link_to t('export'), project_stories_path(project, :format => :csv) 
 show_messages 
  
 @users.each do |user| 
 user 
 link_to 'Remove', project_user_path(@project, user),
      :confirm => "Are you sure you want to remove #{user.email} from this project?",
      :method => :delete 
 end 
 form_for project_users_path(@project, @user) do |f| 
 fields_for :user do |u| 
 u.label :email 
 u.text_field :email 
 u.label :name 
 u.text_field :name 
 u.label :initials 
 u.text_field :initials 
 u.submit 'Add user' 
 end 
 end 

end

  end

  def create
    @project = current_user.projects.find(params[:project_id])
    @users = @project.users
    @user = User.find_or_create_by(email: params[:user][:email]) do |u|
      # Set to true if the user was not found
      u.was_created = true
      u.name = params[:user][:name]
      u.initials = params[:user][:initials]
    end

    if @user.new_record? && !@user.save
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "#{@project.name} - " if @project 
 t('fulcrum') 
 csrf_meta_tag 
 stylesheet_link_tag :application 
 javascript_include_tag :application 
 javascript_tag do 
 I18n.default_locale 
 I18n.locale 
 end 
 link_to t('fulcrum'), root_path 
 if current_user 
 ' class="secondary"'.html_safe if current_user.projects.present? 
 link_to Project.model_name.human(:count => 2), root_path 
 if current_user.projects.present? 
 current_user.projects.each do |project| 
 link_to project, project 
 end 
 end 
 link_to current_user.email, edit_user_registration_path 
 link_to t('log out'), destroy_user_session_path,
                      :method => :delete 
 else 
 link_to t('log in'), new_user_session_path 
 unless Fulcrum::Application.config.fulcrum.disable_registration 
 link_to t('sign up'), new_user_registration_path 
 end 
 end 
 project.name 
 if defined? show_column_toggles 
 end 
 link_to_unless_current Story.model_name.human(:count => 2), project_path(project) 
 link_to_unless_current User.model_name.human(:count => 2), project_users_path(project) 
 link_to_unless_current t('edit'), edit_project_path(project) 
 link_to_unless_current t('import'), import_project_stories_path(project) 
 link_to t('export'), project_stories_path(project, :format => :csv) 
 show_messages 
  
 @users.each do |user| 
 user 
 link_to 'Remove', project_user_path(@project, user),
      :confirm => "Are you sure you want to remove #{user.email} from this project?",
      :method => :delete 
 end 
 form_for project_users_path(@project, @user) do |f| 
 fields_for :user do |u| 
 u.label :email 
 u.text_field :email 
 u.label :name 
 u.text_field :name 
 u.label :initials 
 u.text_field :initials 
 u.submit 'Add user' 
 end 
 end 

end

    end

    if @project.users.include?(@user)
      flash[:alert] = "#{@user.email} is already a member of this project"
    else
      @project.users << @user
      if @user.was_created
        flash[:notice] = "#{@user.email} was sent an invite to join this project"
      else
        flash[:notice] = "#{@user.email} was added to this project"
      end
    end

    redirect_to project_users_url(@project)
  end

  def destroy
    @project = current_user.projects.find(params[:project_id])
    @user = @project.users.find(params[:id])
    @project.users.delete(@user)
    redirect_to project_users_url(@project)
  end

end
