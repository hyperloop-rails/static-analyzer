class StoriesController < ApplicationController

  include ActionView::Helpers::TextHelper

  def index
    @project = current_user.projects.with_stories_notes.find(params[:project_id])
    @stories = @project.stories
    respond_to do |format|
      format.json { render :json => @stories }
      format.csv do
        render :csv => @stories.order(:position), :filename => @project.csv_filename
      end
    end
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
 yield :title_bar 
 show_messages 
 Story.csv_headers.join(',') 

  CSV.generate do |csv|
    @stories.each do |story|
      csv << story.to_csv
    end
  end


end

  end

  def show
    @project = current_user.projects.find(params[:project_id])
    @story = @project.stories.find(params[:id])
    render :json => @story
  end

  def update
    @project = current_user.projects.find(params[:project_id])
    @story = @project.stories.find(params[:id])
    @story.acting_user = current_user
    respond_to do |format|
      if @story.update_attributes(allowed_params)
        format.html { redirect_to project_url(@project) }
        format.js   { render :json => @story }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  
 show_messages 
  
 form_for(resource, :as => resource_name, :url => password_path(resource_name), :html => { :method => :put }) do |f| 
 devise_error_messages! 
 f.hidden_field :reset_password_token 
 f.label :password, "New password" 
 f.password_field :password 
 f.label :password_confirmation, "Confirm new password" 
 f.password_field :password_confirmation 
 f.submit "Change my password" 
 end 
  if controller_name != 'sessions' 
 link_to "Sign in", new_session_path(resource_name) 
 end 
 unless Fulcrum::Application.config.fulcrum.disable_registration 
 if devise_mapping.registerable? && controller_name != 'registrations' 
 link_to "Sign up", new_registration_path(resource_name) 
 end 
 end 
 if devise_mapping.recoverable? && controller_name != 'passwords' 
 link_to "Forgot your password?", new_password_path(resource_name) 
 end 
 if devise_mapping.confirmable? && controller_name != 'confirmations' 
 link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name) 
 end 
 if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' 
 link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name) 
 end 
 if devise_mapping.omniauthable? 
 resource_class.omniauth_providers.each do |provider| 
 link_to "Sign in with #{provider.to_s.titleize}", omniauth_authorize_path(resource_name, provider) 
 end 
 end 
 

end
 }
        format.js   { render :json => @story, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = current_user.projects.find(params[:project_id])
    @story = @project.stories.find(params[:id])
    @story.destroy
    head :ok
  end

  def done
    @project = current_user.projects.find(params[:project_id])
    @stories = @project.stories.done
    render :json => @stories
  end
  def backlog
    @project = current_user.projects.find(params[:project_id])
    @stories = @project.stories.backlog
    render :json => @stories
  end
  def in_progress
    @project = current_user.projects.find(params[:project_id])
    @stories = @project.stories.in_progress
    render :json => @stories
  end

  def create
    @project = current_user.projects.find(params[:project_id])
    @story = @project.stories.build(allowed_params)
    @story.requested_by_id = current_user.id unless @story.requested_by_id
    respond_to do |format|
      if @story.save
        format.html { redirect_to project_url(@project) }
        format.js   { render :json => @story }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  
 show_messages 
  
 form_for(resource, :as => resource_name, :url => unlock_path(resource_name), :html => { :method => :post }) do |f| 
 devise_error_messages! 
 f.label :email 
 f.email_field :email 
 f.submit "Resend unlock instructions" 
 end 
  if controller_name != 'sessions' 
 link_to "Sign in", new_session_path(resource_name) 
 end 
 unless Fulcrum::Application.config.fulcrum.disable_registration 
 if devise_mapping.registerable? && controller_name != 'registrations' 
 link_to "Sign up", new_registration_path(resource_name) 
 end 
 end 
 if devise_mapping.recoverable? && controller_name != 'passwords' 
 link_to "Forgot your password?", new_password_path(resource_name) 
 end 
 if devise_mapping.confirmable? && controller_name != 'confirmations' 
 link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name) 
 end 
 if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' 
 link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name) 
 end 
 if devise_mapping.omniauthable? 
 resource_class.omniauth_providers.each do |provider| 
 link_to "Sign in with #{provider.to_s.titleize}", omniauth_authorize_path(resource_name, provider) 
 end 
 end 
 

end
 }
        format.js   { render :json => @story, :status => :unprocessable_entity }
      end
    end
  end

  def start
    state_change(:start!)
  end

  def finish
    state_change(:finish!)
  end

  def deliver
    state_change(:deliver!)
  end

  def accept
    state_change(:accept!)
  end

  def reject
    state_change(:reject!)
  end

  # CSV import form
  def import
    @project = current_user.projects.find(params[:project_id])
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
  
 form_tag import_upload_project_stories_path(@project), :multipart => true 
 file_field_tag :csv 
 submit_tag :import 
 if @stories 
 @stories.each_with_index do |story, index| 
 if story.valid? 
 index + 1 
 story.title 
 story.story_type 
 else 
 index + 1 
 story.errors.full_messages.join(', ') 
 end 
 end 
 end 

end

  end

  # CSV import
  def import_upload

    @project = current_user.projects.find(params[:project_id])

    # Do not send any email notifications during the import process
    @project.suppress_notifications = true

    if params[:csv].blank?

      flash[:alert] = "You must select a file for import"

    else

      begin
        @stories = @project.stories.from_csv(File.read(params[:csv].path))
        @valid_stories    = @stories.select(&:valid?)
        @invalid_stories  = @stories.reject(&:valid?)

        flash[:notice] = I18n.t(
          'imported n stories', :count => @valid_stories.count
        )

        unless @invalid_stories.empty?
          flash[:alert] = I18n.t(
            'n stories failed to import', :count => @invalid_stories.count
          )
        end
      rescue CSV::MalformedCSVError => e
        flash[:alert] = "Unable to import CSV: #{e.message}"
      end

    end

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
  
 form_tag import_upload_project_stories_path(@project), :multipart => true 
 file_field_tag :csv 
 submit_tag :import 
 if @stories 
 @stories.each_with_index do |story, index| 
 if story.valid? 
 index + 1 
 story.title 
 story.story_type 
 else 
 index + 1 
 story.errors.full_messages.join(', ') 
 end 
 end 
 end 

end


  end

  private
  def state_change(transition)
    @project = current_user.projects.find(params[:project_id])

    @story = @project.stories.find(params[:id])
    @story.send(transition)

    redirect_to project_url(@project)
  end

  def allowed_params
    params.require(:story).permit(:title, :description, :estimate, :story_type, :state, :requested_by_id, :owned_by_id, :position, :labels)
  end
end
