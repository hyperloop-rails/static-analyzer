class StaticController < ApplicationController

  class Project
    extend ActiveModel::Naming

    attr_accessor :name

    def to_model
      self
    end

    def valid?()      true end
    def new_record?() true end
    def destroyed?()  true end

    def errors
      obj = Object.new
      def obj.[](key)         []  end
      def obj.full_messages() []  end
      obj
    end
  end

  def testcard
    @project = Project.new
    @project.name = 'Testcard Project'
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
 t('.done') 
 t('.in_progress') 
 t('.backlog') 
 t('.icebox') 
  

end

  end

end
