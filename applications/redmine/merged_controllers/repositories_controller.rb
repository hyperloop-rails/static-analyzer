
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 l(:label_statistics) 
 tag("embed",
        :type => "image/svg+xml", :src => url_for(:controller => 'repositories',
        :action => 'graph', :id => @project,
        :repository_id => @repository.identifier_param,
        :graph => "commits_per_month")) 
 tag("embed",
        :type => "image/svg+xml", :src => url_for(:controller => 'repositories',
        :action => 'graph', :id => @project,
        :repository_id => @repository.identifier_param,
        :graph => "commits_per_author")) 
 link_to l(:button_back), :action => 'show', :id => @project 
 html_title(l(:label_repository), l(:label_statistics)) 


 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 l(:label_repository) 
 labelled_form_for :repository, @repository, :url => repository_path(@repository), :html => {:method => :put, :id => 'repository-form'} do |f| 
 render :partial => 'form', :locals => {:f => f} 
 end 

 error_messages_for 'repository' 
 label_tag('repository_scm', l(:label_scm)) 
 scm_select_tag(@repository) 
 if @repository && ! @repository.class.scm_available 
 l(:text_scm_command_not_available) 
 end 
 f.check_box :is_default, :label => :field_repository_is_default 
 f.text_field :identifier, :disabled => @repository.identifier_frozen? 
 unless @repository.identifier_frozen? 
 l(:text_length_between, :min => 1, :max => Repository::IDENTIFIER_MAX_LENGTH) 
 l(:text_repository_identifier_info).html_safe 
 end 
 button_disabled = true 
 if @repository 
  button_disabled = ! @repository.class.scm_available 
 repository_field_tags(f, @repository) 
 end 
 submit_tag(@repository.new_record? ? l(:button_create) : l(:button_save), :disabled => button_disabled) 
 link_to l(:button_cancel), settings_project_path(@project, :tab => 'repositories') 

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

require 'SVG/Graph/Bar'
require 'SVG/Graph/BarHorizontal'
require 'digest/sha1'
require 'redmine/scm/adapters'

class ChangesetNotFound < Exception; end
class InvalidRevisionParam < Exception; end

class RepositoriesController < ApplicationController
  menu_item :repository
  menu_item :settings, :only => [:new, :create, :edit, :update, :destroy, :committers]
  default_search_scope :changesets

  before_action :find_project_by_project_id, :only => [:new, :create]
  before_action :find_repository, :only => [:edit, :update, :destroy, :committers]
  before_action :find_project_repository, :except => [:new, :create, :edit, :update, :destroy, :committers]
  before_action :find_changeset, :only => [:revision, :add_related_issue, :remove_related_issue]
  before_action :authorize
  accept_rss_auth :revisions

  rescue_from Redmine::Scm::Adapters::CommandFailed, :with => :show_error_command_failed

  def new
    scm = params[:repository_scm] || (Redmine::Scm::Base.all & Setting.enabled_scm).first
    @repository = Repository.factory(scm)
    @repository.is_default = @project.repository.nil?
    @repository.project = @project
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 l(:label_repository_new) 
 labelled_form_for :repository, @repository, :url => project_repositories_path(@project), :html => {:id => 'repository-form'} do |f| 
 render :partial => 'form', :locals => {:f => f} 
 end 

 error_messages_for 'repository' 
 label_tag('repository_scm', l(:label_scm)) 
 scm_select_tag(@repository) 
 if @repository && ! @repository.class.scm_available 
 l(:text_scm_command_not_available) 
 end 
 f.check_box :is_default, :label => :field_repository_is_default 
 f.text_field :identifier, :disabled => @repository.identifier_frozen? 
 unless @repository.identifier_frozen? 
 l(:text_length_between, :min => 1, :max => Repository::IDENTIFIER_MAX_LENGTH) 
 l(:text_repository_identifier_info).html_safe 
 end 
 button_disabled = true 
 if @repository 
  button_disabled = ! @repository.class.scm_available 
 repository_field_tags(f, @repository) 
 end 
 submit_tag(@repository.new_record? ? l(:button_create) : l(:button_save), :disabled => button_disabled) 
 link_to l(:button_cancel), settings_project_path(@project, :tab => 'repositories') 

end

  def create
    attrs = pickup_extra_info
    @repository = Repository.factory(params[:repository_scm])
    @repository.safe_attributes = params[:repository]
    if attrs[:attrs_extra].keys.any?
      @repository.merge_extra_info(attrs[:attrs_extra])
    end
    @repository.project = @project
    if request.post? && @repository.save
      redirect_to settings_project_path(@project, :tab => 'repositories')
    else
      render :action => 'new'
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 l(:label_repository_new) 
 labelled_form_for :repository, @repository, :url => project_repositories_path(@project), :html => {:id => 'repository-form'} do |f| 
 render :partial => 'form', :locals => {:f => f} 
 end 

 error_messages_for 'repository' 
 label_tag('repository_scm', l(:label_scm)) 
 scm_select_tag(@repository) 
 if @repository && ! @repository.class.scm_available 
 l(:text_scm_command_not_available) 
 end 
 f.check_box :is_default, :label => :field_repository_is_default 
 f.text_field :identifier, :disabled => @repository.identifier_frozen? 
 unless @repository.identifier_frozen? 
 l(:text_length_between, :min => 1, :max => Repository::IDENTIFIER_MAX_LENGTH) 
 l(:text_repository_identifier_info).html_safe 
 end 
 button_disabled = true 
 if @repository 
  button_disabled = ! @repository.class.scm_available 
 repository_field_tags(f, @repository) 
 end 
 submit_tag(@repository.new_record? ? l(:button_create) : l(:button_save), :disabled => button_disabled) 
 link_to l(:button_cancel), settings_project_path(@project, :tab => 'repositories') 

end

  def edit
  end

  def update
    attrs = pickup_extra_info
    @repository.safe_attributes = attrs[:attrs]
    if attrs[:attrs_extra].keys.any?
      @repository.merge_extra_info(attrs[:attrs_extra])
    end
    @repository.project = @project
    if @repository.save
      redirect_to settings_project_path(@project, :tab => 'repositories')
    else
      render :action => 'edit'
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 l(:label_repository) 
 labelled_form_for :repository, @repository, :url => repository_path(@repository), :html => {:method => :put, :id => 'repository-form'} do |f| 
 render :partial => 'form', :locals => {:f => f} 
 end 

 error_messages_for 'repository' 
 label_tag('repository_scm', l(:label_scm)) 
 scm_select_tag(@repository) 
 if @repository && ! @repository.class.scm_available 
 l(:text_scm_command_not_available) 
 end 
 f.check_box :is_default, :label => :field_repository_is_default 
 f.text_field :identifier, :disabled => @repository.identifier_frozen? 
 unless @repository.identifier_frozen? 
 l(:text_length_between, :min => 1, :max => Repository::IDENTIFIER_MAX_LENGTH) 
 l(:text_repository_identifier_info).html_safe 
 end 
 button_disabled = true 
 if @repository 
  button_disabled = ! @repository.class.scm_available 
 repository_field_tags(f, @repository) 
 end 
 submit_tag(@repository.new_record? ? l(:button_create) : l(:button_save), :disabled => button_disabled) 
 link_to l(:button_cancel), settings_project_path(@project, :tab => 'repositories') 

end

  def pickup_extra_info
    p       = {}
    p_extra = {}
    params[:repository].each do |k, v|
      if k =~ /^extra_/
        p_extra[k] = v
      else
        p[k] = v
      end
    end
    {:attrs => p, :attrs_extra => p_extra}
  end
  private :pickup_extra_info

  def committers
    @committers = @repository.committers
    @users = @project.users.to_a
    additional_user_ids = @committers.collect(&:last).collect(&:to_i) - @users.collect(&:id)
    @users += User.where(:id => additional_user_ids).to_a unless additional_user_ids.empty?
    @users.compact!
    @users.sort!
    if request.post? && params[:committers].is_a?(Hash)
      # Build a hash with repository usernames as keys and corresponding user ids as values
      @repository.committer_ids = params[:committers].values.inject({}) {|h, c| h[c.first] = c.last; h}
      flash[:notice] = l(:notice_successful_update)
      redirect_to settings_project_path(@project, :tab => 'repositories')
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 l(:label_repository) 
 simple_format(l(:text_repository_usernames_mapping)) 
 if @committers.empty? 
 l(:label_no_data) 
 else 
 form_tag({}) do 
 l(:field_login) 
 l(:label_user) 
 i = 0 
 @committers.each do |committer, user_id| 
 cycle 'odd', 'even' 
 committer 
 hidden_field_tag "committers[#{i}][]", committer, :id => nil 
 select_tag "committers[#{i}][]",
                      content_tag(
                            'option',
                            "-- #{l :actionview_instancetag_blank_option} --",
                            :value => ''
                          ) +
                        options_from_collection_for_select(
                            @users, 'id', 'name', user_id.to_i
                          ) 
 i += 1 
 end 
 submit_tag(l(:button_save)) 
 end 
 end 

end

  def destroy
    @repository.destroy if request.delete?
    redirect_to settings_project_path(@project, :tab => 'repositories')
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  def show
    @repository.fetch_changesets if @project.active? && Setting.autofetch_changesets? && @path.empty?

    @entries = @repository.entries(@path, @rev)
    @changeset = @repository.find_changeset_by_name(@rev)
    if request.xhr?
      @entries ? render(:partial => 'dir_list_content') : head(200)
    else
      (show_error_not_found; return) unless @entries
      @changesets = @repository.latest_changesets(@path, @rev)
      @properties = @repository.properties(@path, @rev)
      @repositories = @project.repositories
      render :action => 'show'
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 call_hook(:view_repositories_show_contextual, { :repository => @repository, :project => @project }) 
 render :partial => 'navigation' 
 render :partial => 'breadcrumbs',
               :locals => { :path => @path, :kind => 'dir', :revision => @rev } 
 if !@entries.nil? && authorize_for('repositories', 'browse') 
 render :partial => 'dir_list' 
 end 
 render_properties(@properties) 
 if authorize_for('repositories', 'revisions') 
 if @changesets && !@changesets.empty? 
 l(:label_latest_revision_plural) 
 render :partial => 'revisions',
              :locals => {:project => @project, :path => @path,
                          :revisions => @changesets, :entry => nil }
 end 
 has_branches = (!@repository.branches.nil? && @repository.branches.length > 0)
     sep = '' 
 if @repository.supports_all_revisions? && @path.blank? 
 link_to l(:label_view_all_revisions), :action => 'revisions', :id => @project,
                :repository_id => @repository.identifier_param 
 sep = '|' 
 end 
 if @repository.supports_directory_revisions? &&
         ( has_branches || !@path.blank? || !@rev.blank? ) 
 sep 
 link_to l(:label_view_revisions),
                   :action => 'changes',
                   :path   => to_path_param(@path),
                   :id     => @project,
                   :repository_id => @repository.identifier_param,
                   :rev    => @rev 
 end 
 if @repository.supports_all_revisions? 
 content_for :header_tags do 
 auto_discovery_link_tag(
                   :atom,
                   :action => 'revisions', :id => @project,
                   :repository_id => @repository.identifier_param,
                   :key => User.current.rss_key) 
 end 
 other_formats_links do |f| 
 f.link_to 'Atom',
                  :url => {:action => 'revisions', :id => @project,
                           :repository_id => @repository.identifier_param,
                           :key => User.current.rss_key} 
 end 
 end 
 end 
 if @repositories.size > 1 
 content_for :sidebar do 
 l(:label_repository_plural) 
 @repositories.sort.collect {|repo|
          link_to repo.name, 
                  {:controller => 'repositories', :action => 'show',
                   :id => @project, :repository_id => repo.identifier_param, :rev => nil, :path => nil},
                  :class => 'repository' + (repo == @repository ? ' selected' : '')
        }.join('<br />').html_safe 
 end 
 end 
 content_for :header_tags do 
 stylesheet_link_tag "scm" 
 end 
 html_title(l(:label_repository)) 

 content_for :header_tags do 
 javascript_include_tag 'repository_navigation' 
 end 
 link_to l(:label_statistics),
            {:action => 'stats', :id => @project, :repository_id => @repository.identifier_param},
            :class => 'icon icon-stats' if @repository.supports_all_revisions? 
 form_tag({:action => controller.action_name,
             :id => @project,
             :repository_id => @repository.identifier_param,
             :path => to_path_param(@path),
             :rev => nil},
            {:method => :get, :id => 'revision_selector'}) do 
 if !@repository.branches.nil? && @repository.branches.length > 0 
 l(:label_branch) 
 select_tag :branch,
                   options_for_select([''] + @repository.branches, @rev),
                   :id => 'branch' 
 end 
 if !@repository.tags.nil? && @repository.tags.length > 0 
 l(:label_tag) 
 select_tag :tag,
                   options_for_select([''] + @repository.tags, @rev),
                   :id => 'tag' 
 end 
 if @repository.supports_all_revisions? 
 l(:label_revision) 
 text_field_tag 'rev', @rev, :size => 8 
 end 
 end 

 link_to(@repository.identifier.present? ? @repository.identifier : 'root',
      :action => 'show', :id => @project,
      :repository_id => @repository.identifier_param,
      :path => nil, :rev => @rev) 

dirs = path.split('/')
if 'file' == kind
    filename = dirs.pop
end
link_path = ''
dirs.each do |dir|
    next if dir.blank?
    link_path << '/' unless link_path.empty?
    link_path << "#{dir}"
    
 link_to dir, :action => 'show', :id => @project, :repository_id => @repository.identifier_param,
                :path => to_path_param(link_path), :rev => @rev 
 end 
 if filename 
 link_to filename,
                   :action => 'changes', :id => @project, :repository_id => @repository.identifier_param,
                   :path => to_path_param("#{link_path}/#{filename}"), :rev => @rev 
 end 

  # @rev is revsion or Git and Mercurial branch or tag.
  # For Mercurial *tip*, @rev and @changeset are nil.
  rev_text = @changeset.nil? ? @rev : format_revision(@changeset)

 "@ #{rev_text}" unless rev_text.blank? 
 html_title(with_leading_slash(path)) 

 l(:field_name) 
 l(:field_filesize) 
 if @repository.report_last_commit 
 l(:label_revision)  
 l(:label_age)       
 l(:field_author)    
 l(:field_comments)  
 end 
 render :partial => 'dir_list_content' 

 show_revision_graph = ( @repository.supports_revision_graph? && path.blank? ) 
 if show_revision_graph && revisions && revisions.any?
    indexed_commits, graph_space = index_commits(revisions, @repository.branches) do |scmid|
                             url_for(
                               :controller => 'repositories',
                               :action => 'revision',
                               :id => project,
                               :repository_id => @repository.identifier_param,
                               :rev => scmid)
                         end
    render :partial => 'revision_graph',
         :locals => {
            :commits => indexed_commits,
            :space => graph_space
        }
end 
 form_tag(
      {:controller => 'repositories', :action => 'diff', :id => project,
       :repository_id => @repository.identifier_param, :path => to_path_param(path)},
      :method => :get
     ) do 
 l(:label_date) 
 l(:field_author) 
 l(:field_comments) 
 show_diff = revisions.size > 1 
 line_num = 1 
 revisions.each do |changeset| 
 cycle 'odd', 'even' 
 id_style = (show_revision_graph ? "padding-left:#{(graph_space + 1) * 20}px" : nil) 
 content_tag(:td, :class => 'id', :style => id_style) do 
 link_to_revision(changeset, @repository) 
 end 
 radio_button_tag('rev', changeset.identifier, (line_num==1), :id => "cb-#{line_num}", :onclick => "$('#cbto-#{line_num+1}').prop('checked',true);") if show_diff && (line_num < revisions.size) 
 radio_button_tag('rev_to', changeset.identifier, (line_num==2), :id => "cbto-#{line_num}", :onclick => "if ($('#cb-#{line_num}').prop('checked')) {$('#cb-#{line_num-1}').prop('checked',true);}") if show_diff && (line_num > 1) 
 format_time(changeset.committed_on) 
 changeset.author.to_s.truncate(30) 
 textilizable(truncate_at_line_break(changeset.comments)) 
 line_num += 1 
 end 
 submit_tag(l(:label_view_diff), :name => nil) if show_diff 
 end 

 @entries.each do |entry| 
 tr_id = Digest::MD5.hexdigest(entry.path)
   depth = params[:depth].to_i 
  ent_path = Redmine::CodesetUtil.replace_invalid_utf8(entry.path)   
  ent_name = Redmine::CodesetUtil.replace_invalid_utf8(entry.name)   
 tr_id 
 params[:parent_id] 
 entry.kind 
18 * depth

           @repository.report_last_commit ? "filename" : "filename_no_report" 
 if entry.is_dir? 
 tr_id 
 escape_javascript(url_for(
                       :action => 'show',
                       :id     => @project,
                       :repository_id => @repository.identifier_param,
                       :path   => to_path_param(ent_path),
                       :rev    => @rev,
                       :depth  => (depth + 1),
                       :parent_id => tr_id)) 
 end 
  link_to ent_name,
          {:action => (entry.is_dir? ? 'show' : 'changes'), :id => @project, :repository_id => @repository.identifier_param, :path => to_path_param(ent_path), :rev => @rev},
          :class => (entry.is_dir? ? 'icon icon-folder' : "icon icon-file #{Redmine::MimeType.css_class_of(ent_name)}")
 (entry.size ? number_to_human_size(entry.size) : "?") unless entry.is_dir? 
 if @repository.report_last_commit 
 link_to_revision(entry.changeset, @repository) if entry.changeset 
 distance_of_time_in_words(entry.lastrev.time, Time.now) if entry.lastrev && entry.lastrev.time 
 entry.author 
 entry.changeset.comments.truncate(50) if entry.changeset 
 end 
 end 

 javascript_tag do 
 commits.to_json.html_safe 
 space 
 end 
 content_for :header_tags do 
 javascript_include_tag 'raphael' 
 javascript_include_tag 'revision_graph' 
 end 

end

  alias_method :browse, :show

  def changes
    @entry = @repository.entry(@path, @rev)
    (show_error_not_found; return) unless @entry
    @changesets = @repository.latest_changesets(@path, @rev, Setting.repository_log_display_limit.to_i)
    @properties = @repository.properties(@path, @rev)
    @changeset = @repository.find_changeset_by_name(@rev)
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 call_hook(:view_repositories_show_contextual, { :repository => @repository, :project => @project }) 
 render :partial => 'navigation' 
 render :partial => 'breadcrumbs', :locals => { :path => @path, :kind => (@entry ? @entry.kind : nil), :revision => @rev } 
 render :partial => 'link_to_functions' 
 render_properties(@properties) 
 render(:partial => 'revisions',
           :locals => {:project => @project, :path => @path, :revisions => @changesets, :entry => @entry }) unless @changesets.empty? 
 content_for :header_tags do 
   stylesheet_link_tag "scm" 
 end 
 html_title(l(:label_change_plural)) 

 content_for :header_tags do 
 javascript_include_tag 'repository_navigation' 
 end 
 link_to l(:label_statistics),
            {:action => 'stats', :id => @project, :repository_id => @repository.identifier_param},
            :class => 'icon icon-stats' if @repository.supports_all_revisions? 
 form_tag({:action => controller.action_name,
             :id => @project,
             :repository_id => @repository.identifier_param,
             :path => to_path_param(@path),
             :rev => nil},
            {:method => :get, :id => 'revision_selector'}) do 
 if !@repository.branches.nil? && @repository.branches.length > 0 
 l(:label_branch) 
 select_tag :branch,
                   options_for_select([''] + @repository.branches, @rev),
                   :id => 'branch' 
 end 
 if !@repository.tags.nil? && @repository.tags.length > 0 
 l(:label_tag) 
 select_tag :tag,
                   options_for_select([''] + @repository.tags, @rev),
                   :id => 'tag' 
 end 
 if @repository.supports_all_revisions? 
 l(:label_revision) 
 text_field_tag 'rev', @rev, :size => 8 
 end 
 end 

 link_to(@repository.identifier.present? ? @repository.identifier : 'root',
      :action => 'show', :id => @project,
      :repository_id => @repository.identifier_param,
      :path => nil, :rev => @rev) 

dirs = path.split('/')
if 'file' == kind
    filename = dirs.pop
end
link_path = ''
dirs.each do |dir|
    next if dir.blank?
    link_path << '/' unless link_path.empty?
    link_path << "#{dir}"
    
 link_to dir, :action => 'show', :id => @project, :repository_id => @repository.identifier_param,
                :path => to_path_param(link_path), :rev => @rev 
 end 
 if filename 
 link_to filename,
                   :action => 'changes', :id => @project, :repository_id => @repository.identifier_param,
                   :path => to_path_param("#{link_path}/#{filename}"), :rev => @rev 
 end 

  # @rev is revsion or Git and Mercurial branch or tag.
  # For Mercurial *tip*, @rev and @changeset are nil.
  rev_text = @changeset.nil? ? @rev : format_revision(@changeset)

 "@ #{rev_text}" unless rev_text.blank? 
 html_title(with_leading_slash(path)) 

 if @entry && @entry.kind == 'file' 
 link_to_if action_name != 'changes', l(:label_history), {:action => 'changes', :id => @project, :repository_id => @repository.identifier_param, :path => to_path_param(@path), :rev => @rev } 
 if @repository.supports_cat? 
 link_to_if action_name != 'entry', l(:button_view), {:action => 'entry', :id => @project, :repository_id => @repository.identifier_param, :path => to_path_param(@path), :rev => @rev } 
 end 
 if @repository.supports_annotate? 
 link_to_if action_name != 'annotate', l(:button_annotate), {:action => 'annotate', :id => @project, :repository_id => @repository.identifier_param, :path => to_path_param(@path), :rev => @rev } 
 end 
 link_to(l(:button_download),
            {:action => 'raw', :id => @project,
             :repository_id => @repository.identifier_param,
             :path => to_path_param(@path),
             :rev => @rev}) if @repository.supports_cat? 
 "(#{number_to_human_size(@entry.size)})" if @entry.size 
 end 

 show_revision_graph = ( @repository.supports_revision_graph? && path.blank? ) 
 if show_revision_graph && revisions && revisions.any?
    indexed_commits, graph_space = index_commits(revisions, @repository.branches) do |scmid|
                             url_for(
                               :controller => 'repositories',
                               :action => 'revision',
                               :id => project,
                               :repository_id => @repository.identifier_param,
                               :rev => scmid)
                         end
    render :partial => 'revision_graph',
         :locals => {
            :commits => indexed_commits,
            :space => graph_space
        }
end 
 form_tag(
      {:controller => 'repositories', :action => 'diff', :id => project,
       :repository_id => @repository.identifier_param, :path => to_path_param(path)},
      :method => :get
     ) do 
 l(:label_date) 
 l(:field_author) 
 l(:field_comments) 
 show_diff = revisions.size > 1 
 line_num = 1 
 revisions.each do |changeset| 
 cycle 'odd', 'even' 
 id_style = (show_revision_graph ? "padding-left:#{(graph_space + 1) * 20}px" : nil) 
 content_tag(:td, :class => 'id', :style => id_style) do 
 link_to_revision(changeset, @repository) 
 end 
 radio_button_tag('rev', changeset.identifier, (line_num==1), :id => "cb-#{line_num}", :onclick => "$('#cbto-#{line_num+1}').prop('checked',true);") if show_diff && (line_num < revisions.size) 
 radio_button_tag('rev_to', changeset.identifier, (line_num==2), :id => "cbto-#{line_num}", :onclick => "if ($('#cb-#{line_num}').prop('checked')) {$('#cb-#{line_num-1}').prop('checked',true);}") if show_diff && (line_num > 1) 
 format_time(changeset.committed_on) 
 changeset.author.to_s.truncate(30) 
 textilizable(truncate_at_line_break(changeset.comments)) 
 line_num += 1 
 end 
 submit_tag(l(:label_view_diff), :name => nil) if show_diff 
 end 

end

  def revisions
    @changeset_count = @repository.changesets.count
    @changeset_pages = Paginator.new @changeset_count,
                                     per_page_option,
                                     params['page']
    @changesets = @repository.changesets.
      limit(@changeset_pages.per_page).
      offset(@changeset_pages.offset).
      includes(:user, :repository, :parents).
      to_a

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.atom { render_feed(@changesets, :title => "#{@project.name}: #{l(:label_revision_plural)}") }
    end
  
 form_tag(
       {:controller => 'repositories', :action => 'revision', :id => @project,
        :repository_id => @repository.identifier_param},
       :method => :get
     ) do 
 l(:label_revision) 
 text_field_tag 'rev', nil, :size => 8 
 submit_tag 'OK' 
 end 
 l(:label_revision_plural) 
 render :partial => 'revisions',
           :locals => {:project   => @project,
                       :path      => '',
                       :revisions => @changesets,
                       :entry     => nil } 
 pagination_links_full @changeset_pages,@changeset_count 
 content_for :header_tags do 
 stylesheet_link_tag "scm" 
 auto_discovery_link_tag(
               :atom,
               :params => request.query_parameters.merge(:page => nil, :key => User.current.rss_key),
               :format => 'atom') 
 end 
 other_formats_links do |f| 
 f.link_to 'Atom', :url => {:key => User.current.rss_key} 
 end 
 html_title(l(:label_revision_plural)) 

 show_revision_graph = ( @repository.supports_revision_graph? && path.blank? ) 
 if show_revision_graph && revisions && revisions.any?
    indexed_commits, graph_space = index_commits(revisions, @repository.branches) do |scmid|
                             url_for(
                               :controller => 'repositories',
                               :action => 'revision',
                               :id => project,
                               :repository_id => @repository.identifier_param,
                               :rev => scmid)
                         end
    render :partial => 'revision_graph',
         :locals => {
            :commits => indexed_commits,
            :space => graph_space
        }
end 
 form_tag(
      {:controller => 'repositories', :action => 'diff', :id => project,
       :repository_id => @repository.identifier_param, :path => to_path_param(path)},
      :method => :get
     ) do 
 l(:label_date) 
 l(:field_author) 
 l(:field_comments) 
 show_diff = revisions.size > 1 
 line_num = 1 
 revisions.each do |changeset| 
 cycle 'odd', 'even' 
 id_style = (show_revision_graph ? "padding-left:#{(graph_space + 1) * 20}px" : nil) 
 content_tag(:td, :class => 'id', :style => id_style) do 
 link_to_revision(changeset, @repository) 
 end 
 radio_button_tag('rev', changeset.identifier, (line_num==1), :id => "cb-#{line_num}", :onclick => "$('#cbto-#{line_num+1}').prop('checked',true);") if show_diff && (line_num < revisions.size) 
 radio_button_tag('rev_to', changeset.identifier, (line_num==2), :id => "cbto-#{line_num}", :onclick => "if ($('#cb-#{line_num}').prop('checked')) {$('#cb-#{line_num-1}').prop('checked',true);}") if show_diff && (line_num > 1) 
 format_time(changeset.committed_on) 
 changeset.author.to_s.truncate(30) 
 textilizable(truncate_at_line_break(changeset.comments)) 
 line_num += 1 
 end 
 submit_tag(l(:label_view_diff), :name => nil) if show_diff 
 end 

end

  def raw
    entry_and_raw(true)
  end

  def entry
    entry_and_raw(false)
  end

  def entry_and_raw(is_raw)
    @entry = @repository.entry(@path, @rev)
    (show_error_not_found; return) unless @entry

    # If the entry is a dir, show the browser
    (show; return) if @entry.is_dir?

    if is_raw
      # Force the download
      send_opt = { :filename => filename_for_content_disposition(@path.split('/').last) }
      send_type = Redmine::MimeType.of(@path)
      send_opt[:type] = send_type.to_s if send_type
      send_opt[:disposition] = disposition(@path)
      send_data @repository.cat(@path, @rev), send_opt
    else
      if !@entry.size || @entry.size <= Setting.file_max_size_displayed.to_i.kilobyte
        content = @repository.cat(@path, @rev)
        (show_error_not_found; return) unless content

        if content.size <= Setting.file_max_size_displayed.to_i.kilobyte &&
           is_entry_text_data?(content, @path)
          # TODO: UTF-16
          # Prevent empty lines when displaying a file with Windows style eol
          # Is this needed? AttachmentsController simply reads file.
          @content = content.gsub("\r\n", "\n")
        end
      end
      @changeset = @repository.find_changeset_by_name(@rev)
    end
  end
  private :entry_and_raw

  def is_entry_text_data?(ent, path)
    # UTF-16 contains "\x00".
    # It is very strict that file contains less than 30% of ascii symbols
    # in non Western Europe.
    return true if Redmine::MimeType.is_type?('text', path)
    # Ruby 1.8.6 has a bug of integer divisions.
    # http://apidock.com/ruby/v1_8_6_287/String/is_binary_data%3F
    return false if ent.is_binary_data?
    true
  end
  private :is_entry_text_data?

  def annotate
    @entry = @repository.entry(@path, @rev)
    (show_error_not_found; return) unless @entry

    @annotate = @repository.scm.annotate(@path, @rev)
    if @annotate.nil? || @annotate.empty?
      @annotate = nil
      @error_message = l(:error_scm_annotate)
    else
      ann_buf_size = 0
      @annotate.lines.each do |buf|
        ann_buf_size += buf.size
      end
      if ann_buf_size > Setting.file_max_size_displayed.to_i.kilobyte
        @annotate = nil
        @error_message = l(:error_scm_annotate_big_text_file)
      end
    end
    @changeset = @repository.find_changeset_by_name(@rev)
  end

  def revision
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  
 unless @changeset.previous.nil? 
 link_to_revision(@changeset.previous, @repository,
      :text => l(:label_previous), :accesskey => accesskey(:previous)) 
 else 
 l(:label_previous) 
 end 
 unless @changeset.next.nil? 
 link_to_revision(@changeset.next, @repository,
      :text => l(:label_next), :accesskey => accesskey(:next)) 
 else 
 l(:label_next) 
 end 
 form_tag({:controller => 'repositories',
               :action     => 'revision',
               :id         => @project,
               :repository_id => @repository.identifier_param,
               :rev        => nil},
               :method     => :get) do 
 text_field_tag 'rev', @rev, :size => 8 
 submit_tag 'OK', :name => nil 
 end 
 render :partial => 'changeset' 
 if User.current.allowed_to?(:browse_repository, @project) 
 l(:label_attachment_plural) 
 l(:label_added)    
 l(:label_modified) 
 l(:label_copied)   
 l(:label_renamed)  
 l(:label_deleted)  
 link_to(l(:label_view_diff),
               :action => 'diff',
               :id     => @project,
               :repository_id => @repository.identifier_param,
               :path   => "",
               :rev    => @changeset.identifier) if @changeset.filechanges.any? 
 render_changeset_changes 
 end 
 content_for :header_tags do 
 stylesheet_link_tag "scm" 
 end 

  title = "#{l(:label_revision)} #{format_revision(@changeset)}"
  title << " - #{@changeset.comments.truncate(80)}"
  html_title(title)
 

 avatar(@changeset.user, :size => "24") 
 l(:label_revision) 
 format_revision(@changeset) 
 if @changeset.scmid.present? || @changeset.parents.present? || @changeset.children.present? 
 if @changeset.scmid.present? 
 @changeset.scmid 
 end 
 if @changeset.parents.present? 
 l(:label_parent_revision) 
 @changeset.parents.collect{
                |p| link_to_revision(p, @repository, :text => format_revision(p))
              }.join(", ").html_safe 
 end 
 if @changeset.children.present? 
 l(:label_child_revision) 
 @changeset.children.collect{
                |p| link_to_revision(p, @repository, :text => format_revision(p))
               }.join(", ").html_safe 
 end 
 end 
 authoring(@changeset.committed_on, @changeset.author) 
 textilizable @changeset.comments 
 if @changeset.issues.visible.any? || User.current.allowed_to?(:manage_related_issues, @repository.project) 
 render :partial => 'related_issues' 
 end 

end

  # Adds a related issue to a changeset
  # POST /projects/:project_id/repository/(:repository_id/)revisions/:rev/issues
  def add_related_issue
    issue_id = params[:issue_id].to_s.sub(/^#/,'')
    @issue = @changeset.find_referenced_issue_by_id(issue_id)
    if @issue && (!@issue.visible? || @changeset.issues.include?(@issue))
      @issue = nil
    end

    if @issue
      @changeset.issues << @issue
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  # Removes a related issue from a changeset
  # DELETE /projects/:project_id/repository/(:repository_id/)revisions/:rev/issues/:issue_id
  def remove_related_issue
    @issue = Issue.visible.find_by_id(params[:issue_id])
    if @issue
      @changeset.issues.delete(@issue)
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  def diff
    if params[:format] == 'diff'
      @diff = @repository.diff(@path, @rev, @rev_to)
      (show_error_not_found; return) unless @diff
      filename = "changeset_r#{@rev}"
      filename << "_r#{@rev_to}" if @rev_to
      send_data @diff.join, :filename => "#{filename}.diff",
                            :type => 'text/x-patch',
                            :disposition => 'attachment'
    else
      @diff_type = params[:type] || User.current.pref[:diff_type] || 'inline'
      @diff_type = 'inline' unless %w(inline sbs).include?(@diff_type)

      # Save diff type as user preference
      if User.current.logged? && @diff_type != User.current.pref[:diff_type]
        User.current.pref[:diff_type] = @diff_type
        User.current.preference.save
      end
      @cache_key = "repositories/diff/#{@repository.id}/" +
                      Digest::MD5.hexdigest("#{@path}-#{@rev}-#{@rev_to}-#{@diff_type}-#{current_language}")
      unless read_fragment(@cache_key)
        @diff = @repository.diff(@path, @rev, @rev_to)
        show_error_not_found unless @diff
      end

      @changeset = @repository.find_changeset_by_name(@rev)
      @changeset_to = @rev_to ? @repository.find_changeset_by_name(@rev_to) : nil
      @diff_format_revisions = @repository.diff_format_revisions(@changeset, @changeset_to)
    end
  end

  def stats
  end

  def graph
    data = nil
    case params[:graph]
    when "commits_per_month"
      data = graph_commits_per_month(@repository)
    when "commits_per_author"
      data = graph_commits_per_author(@repository)
    end
    if data
      headers["Content-Type"] = "image/svg+xml"
      send_data(data, :type => "image/svg+xml", :disposition => "inline")
    else
      render_404
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  private

  def find_repository
    @repository = Repository.find(params[:id])
    @project = @repository.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  REV_PARAM_RE = %r{\A[a-f0-9]*\Z}i

  def find_project_repository
    @project = Project.find(params[:id])
    if params[:repository_id].present?
      @repository = @project.repositories.find_by_identifier_param(params[:repository_id])
    else
      @repository = @project.repository
    end
    (render_404; return false) unless @repository
    @path = params[:path].is_a?(Array) ? params[:path].join('/') : params[:path].to_s
    @rev = params[:rev].blank? ? @repository.default_branch : params[:rev].to_s.strip
    @rev_to = params[:rev_to]

    unless @rev.to_s.match(REV_PARAM_RE) && @rev_to.to_s.match(REV_PARAM_RE)
      if @repository.branches.blank?
        raise InvalidRevisionParam
      end
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  rescue InvalidRevisionParam
    show_error_not_found
  end

  def find_changeset
    if @rev.present?
      @changeset = @repository.find_changeset_by_name(@rev)
    end
    show_error_not_found unless @changeset
  end

  def show_error_not_found
    render_error :message => l(:error_scm_not_found), :status => 404
  end

  # Handler for Redmine::Scm::Adapters::CommandFailed exception
  def show_error_command_failed(exception)
    render_error l(:error_scm_command_failed, exception.message)
  end

  def graph_commits_per_month(repository)
    @date_to = User.current.today
    @date_from = @date_to << 11
    @date_from = Date.civil(@date_from.year, @date_from.month, 1)
    commits_by_day = Changeset.
      where("repository_id = ? AND commit_date BETWEEN ? AND ?", repository.id, @date_from, @date_to).
      group(:commit_date).
      count
    commits_by_month = [0] * 12
    commits_by_day.each {|c| commits_by_month[(@date_to.month - c.first.to_date.month) % 12] += c.last }

    changes_by_day = Change.
      joins(:changeset).
      where("#{Changeset.table_name}.repository_id = ? AND #{Changeset.table_name}.commit_date BETWEEN ? AND ?", repository.id, @date_from, @date_to).
      group(:commit_date).
      count
    changes_by_month = [0] * 12
    changes_by_day.each {|c| changes_by_month[(@date_to.month - c.first.to_date.month) % 12] += c.last }

    fields = []
    today = User.current.today
    12.times {|m| fields << month_name(((today.month - 1 - m) % 12) + 1)}

    graph = SVG::Graph::Bar.new(
      :height => 300,
      :width => 800,
      :fields => fields.reverse,
      :stack => :side,
      :scale_integers => true,
      :step_x_labels => 2,
      :show_data_values => false,
      :graph_title => l(:label_commits_per_month),
      :show_graph_title => true
    )

    graph.add_data(
      :data => commits_by_month[0..11].reverse,
      :title => l(:label_revision_plural)
    )

    graph.add_data(
      :data => changes_by_month[0..11].reverse,
      :title => l(:label_change_plural)
    )

    graph.burn
  end

  def graph_commits_per_author(repository)
    #data
    stats = repository.stats_by_author
    fields, commits_data, changes_data = [], [], []
    stats.each do |name, hsh|
      fields << name
      commits_data << hsh[:commits_count]
      changes_data << hsh[:changes_count]
    end

    #expand to 10 values if needed
    fields = fields + [""]*(10 - fields.length) if fields.length<10
    commits_data = commits_data + [0]*(10 - commits_data.length) if commits_data.length<10
    changes_data = changes_data + [0]*(10 - changes_data.length) if changes_data.length<10

    # Remove email address in usernames
    fields = fields.collect {|c| c.gsub(%r{<.+@.+>}, '') }

    #prepare graph
    graph = SVG::Graph::BarHorizontal.new(
      :height => 30 * commits_data.length,
      :width => 800,
      :fields => fields,
      :stack => :side,
      :scale_integers => true,
      :show_data_values => false,
      :rotate_y_labels => false,
      :graph_title => l(:label_commits_per_author),
      :show_graph_title => true
    )
    graph.add_data(
      :data => commits_data,
      :title => l(:label_revision_plural)
    )
    graph.add_data(
      :data => changes_data,
      :title => l(:label_change_plural)
    )
    graph.burn
  end

  def disposition(path)
    if Redmine::MimeType.is_type?('image', @path) || Redmine::MimeType.of(@path) == "application/pdf"
      'inline'
    else
      'attachment'
    end
  end
end
