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

class AccountController < ApplicationController
  helper :custom_fields
  include CustomFieldsHelper

  # prevents login action to be filtered by check_if_login_required application scope filter
  skip_before_action :check_if_login_required, :check_password_change

  # Overrides ApplicationController#verify_authenticity_token to disable
  # token verification on openid callbacks
  def verify_authenticity_token
    unless using_open_id?
      super
    end
  end

  # Login request and validation
  def login
    if request.get?
      if User.current.logged?
        redirect_back_or_default home_url, :referer => true
      end
    else
      authenticate_user
    end
  rescue AuthSourceException => e
    logger.error "An error occured when authenticating #{params[:username]}: #{e.message}"
    render_error :message => e.message
  
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

 call_hook :view_account_login_top 
 form_tag(signin_path, onsubmit: 'return keepAnchorOnSignIn(this);') do 
 back_url_hidden_field_tag 
l(:field_login)
 text_field_tag 'username', params[:username], :tabindex => '1' 
l(:field_password)
 link_to l(:label_password_lost), lost_password_path, :class => "lost_password" if Setting.lost_password? 
 password_field_tag 'password', nil, :tabindex => '2' 
 if Setting.openid? 
l(:field_identity_url)
 text_field_tag "openid_url", nil, :tabindex => '3' 
 end 
 if Setting.autologin? 
 check_box_tag 'autologin', 1, false, :tabindex => 4 
 l(:label_stay_logged_in) 
 end 
l(:button_login)
 end 
 call_hook :view_account_login_bottom 
 if params[:username].present? 
 javascript_tag "$('#password').focus();" 
 else 
 javascript_tag "$('#username').focus();" 
 end 

end

  # Log out current user and redirect to welcome page
  def logout
    if User.current.anonymous?
      redirect_to home_url
    elsif request.post?
      logout_user
      redirect_to home_url
    end
    # display the logout form
  
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

 form_tag(signout_path) do 
 submit_tag l(:label_logout) 
 end 

end

  # Lets user choose a new password
  def lost_password
    (redirect_to(home_url); return) unless Setting.lost_password?
    if params[:token]
      @token = Token.find_token("recovery", params[:token].to_s)
      if @token.nil? || @token.expired?
        redirect_to home_url
        return
      end
      @user = @token.user
      unless @user && @user.active?
        redirect_to home_url
        return
      end
      if request.post?
        @user.password, @user.password_confirmation = params[:new_password], params[:new_password_confirmation]
        if @user.save
          @token.destroy
          Mailer.password_updated(@user)
          flash[:notice] = l(:notice_account_password_updated)
          redirect_to signin_path
          return
        end
      end
      render :template => "account/password_recovery"
      return
    else
      if request.post?
        email = params[:mail].to_s
        user = User.find_by_mail(email)
        # user not found
        unless user
          flash.now[:error] = l(:notice_account_unknown_email)
          return
        end
        unless user.active?
          handle_inactive_user(user, lost_password_path)
          return
        end
        # user cannot change its password
        unless user.change_password_allowed?
          flash.now[:error] = l(:notice_can_t_change_password)
          return
        end
        # create a new token for password recovery
        token = Token.new(:user => user, :action => "recovery")
        if token.save
          # Don't use the param to send the email
          recipent = user.mails.detect {|e| email.casecmp(e) == 0} || user.mail
          Mailer.lost_password(token, recipent).deliver
          flash[:notice] = l(:notice_account_lost_email_sent)
          redirect_to signin_path
          return
        end
      end
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

l(:label_password_lost)
 form_tag(lost_password_path) do 
l(:field_mail)
 text_field_tag 'mail', nil, :size => 40 
 submit_tag l(:button_submit) 
 end 

l(:label_password_lost)
 error_messages_for 'user' 
 form_tag(lost_password_path) do 
 hidden_field_tag 'token', @token.value 
l(:field_new_password)
 password_field_tag 'new_password', nil, :size => 25 
 l(:text_caracters_minimum, :count => Setting.password_min_length) 
l(:field_password_confirmation)
 password_field_tag 'new_password_confirmation', nil, :size => 25 
 submit_tag l(:button_save) 
 end 

end

  # User self-registration
  def register
    (redirect_to(home_url); return) unless Setting.self_registration? || session[:auth_source_registration]
    if request.get?
      session[:auth_source_registration] = nil
      @user = User.new(:language => current_language.to_s)
    else
      user_params = params[:user] || {}
      @user = User.new
      @user.safe_attributes = user_params
      @user.pref.safe_attributes = params[:pref]
      @user.admin = false
      @user.register
      if session[:auth_source_registration]
        @user.activate
        @user.login = session[:auth_source_registration][:login]
        @user.auth_source_id = session[:auth_source_registration][:auth_source_id]
        if @user.save
          session[:auth_source_registration] = nil
          self.logged_user = @user
          flash[:notice] = l(:notice_account_activated)
          redirect_to my_account_path
        end
      else
        unless user_params[:identity_url].present? && user_params[:password].blank? && user_params[:password_confirmation].blank?
          @user.password, @user.password_confirmation = user_params[:password], user_params[:password_confirmation]
        end

        case Setting.self_registration
        when '1'
          register_by_email_activation(@user)
        when '3'
          register_automatically(@user)
        else
          register_manually_by_administrator(@user)
        end
      end
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

l(:label_register)
link_to l(:label_login_with_open_id_option), signin_url if Setting.openid? 
 labelled_form_for @user, :url => register_path do |f| 
 error_messages_for 'user' 
 if @user.auth_source_id.nil? 
 f.text_field :login, :size => 25, :required => true 
 f.password_field :password, :size => 25, :required => true 
 l(:text_caracters_minimum, :count => Setting.password_min_length) 
 f.password_field :password_confirmation, :size => 25, :required => true 
 end 
 f.text_field :firstname, :required => true 
 f.text_field :lastname, :required => true 
 f.text_field :mail, :required => true 
 labelled_fields_for :pref, @user.pref do |pref_fields| 
 pref_fields.check_box :hide_mail 
 end 
 unless @user.force_default_language? 
 f.select :language, lang_options_for_select 
 end 
 if Setting.openid? 
 f.text_field :identity_url  
 end 
 @user.custom_field_values.select {|v| v.editable? || v.required?}.each do |value| 
 custom_field_tag_with_label :user, value 
 end 
 submit_tag l(:button_submit) 
 end 

end

  # Token based account activation
  def activate
    (redirect_to(home_url); return) unless Setting.self_registration? && params[:token].present?
    token = Token.find_token('register', params[:token].to_s)
    (redirect_to(home_url); return) unless token and !token.expired?
    user = token.user
    (redirect_to(home_url); return) unless user.registered?
    user.activate
    if user.save
      token.destroy
      flash[:notice] = l(:notice_account_activated)
    end
    redirect_to signin_path
  
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

  # Sends a new account activation email
  def activation_email
    if session[:registered_user_id] && Setting.self_registration == '1'
      user_id = session.delete(:registered_user_id).to_i
      user = User.find_by_id(user_id)
      if user && user.registered?
        register_by_email_activation(user)
        return
      end
    end
    redirect_to(home_url)
  
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

  def authenticate_user
    if Setting.openid? && using_open_id?
      open_id_authenticate(params[:openid_url])
    else
      password_authentication
    end
  end

  def password_authentication
    user = User.try_to_login(params[:username], params[:password], false)

    if user.nil?
      invalid_credentials
    elsif user.new_record?
      onthefly_creation_failed(user, {:login => user.login, :auth_source_id => user.auth_source_id })
    else
      # Valid user
      if user.active?
        successful_authentication(user)
        update_sudo_timestamp! # activate Sudo Mode
      else
        handle_inactive_user(user)
      end
    end
  end

  def open_id_authenticate(openid_url)
    back_url = signin_url(:autologin => params[:autologin])
    authenticate_with_open_id(
          openid_url, :required => [:nickname, :fullname, :email],
          :return_to => back_url, :method => :post
    ) do |result, identity_url, registration|
      if result.successful?
        user = User.find_or_initialize_by_identity_url(identity_url)
        if user.new_record?
          # Self-registration off
          (redirect_to(home_url); return) unless Setting.self_registration?
          # Create on the fly
          user.login = registration['nickname'] unless registration['nickname'].nil?
          user.mail = registration['email'] unless registration['email'].nil?
          user.firstname, user.lastname = registration['fullname'].split(' ') unless registration['fullname'].nil?
          user.random_password
          user.register
          case Setting.self_registration
          when '1'
            register_by_email_activation(user) do
              onthefly_creation_failed(user)
            end
          when '3'
            register_automatically(user) do
              onthefly_creation_failed(user)
            end
          else
            register_manually_by_administrator(user) do
              onthefly_creation_failed(user)
            end
          end
        else
          # Existing record
          if user.active?
            successful_authentication(user)
          else
            handle_inactive_user(user)
          end
        end
      end
    end
  end

  def successful_authentication(user)
    logger.info "Successful authentication for '#{user.login}' from #{request.remote_ip} at #{Time.now.utc}"
    # Valid user
    self.logged_user = user
    # generate a key and set cookie if autologin
    if params[:autologin] && Setting.autologin?
      set_autologin_cookie(user)
    end
    call_hook(:controller_account_success_authentication_after, {:user => user })
    redirect_back_or_default my_page_path
  end

  def set_autologin_cookie(user)
    token = Token.create(:user => user, :action => 'autologin')
    secure = Redmine::Configuration['autologin_cookie_secure']
    if secure.nil?
      secure = request.ssl?
    end
    cookie_options = {
      :value => token.value,
      :expires => 1.year.from_now,
      :path => (Redmine::Configuration['autologin_cookie_path'] || RedmineApp::Application.config.relative_url_root || '/'),
      :secure => secure,
      :httponly => true
    }
    cookies[autologin_cookie_name] = cookie_options
  end

  # Onthefly creation failed, display the registration form to fill/fix attributes
  def onthefly_creation_failed(user, auth_source_options = { })
    @user = user
    session[:auth_source_registration] = auth_source_options unless auth_source_options.empty?
    render :action => 'register'
  
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

l(:label_register)
link_to l(:label_login_with_open_id_option), signin_url if Setting.openid? 
 labelled_form_for @user, :url => register_path do |f| 
 error_messages_for 'user' 
 if @user.auth_source_id.nil? 
 f.text_field :login, :size => 25, :required => true 
 f.password_field :password, :size => 25, :required => true 
 l(:text_caracters_minimum, :count => Setting.password_min_length) 
 f.password_field :password_confirmation, :size => 25, :required => true 
 end 
 f.text_field :firstname, :required => true 
 f.text_field :lastname, :required => true 
 f.text_field :mail, :required => true 
 labelled_fields_for :pref, @user.pref do |pref_fields| 
 pref_fields.check_box :hide_mail 
 end 
 unless @user.force_default_language? 
 f.select :language, lang_options_for_select 
 end 
 if Setting.openid? 
 f.text_field :identity_url  
 end 
 @user.custom_field_values.select {|v| v.editable? || v.required?}.each do |value| 
 custom_field_tag_with_label :user, value 
 end 
 submit_tag l(:button_submit) 
 end 

end

  def invalid_credentials
    logger.warn "Failed login for '#{params[:username]}' from #{request.remote_ip} at #{Time.now.utc}"
    flash.now[:error] = l(:notice_account_invalid_credentials)
  end

  # Register a user for email activation.
  #
  # Pass a block for behavior when a user fails to save
  def register_by_email_activation(user, &block)
    token = Token.new(:user => user, :action => "register")
    if user.save and token.save
      Mailer.register(token).deliver
      flash[:notice] = l(:notice_account_register_done, :email => ERB::Util.h(user.mail))
      redirect_to signin_path
    else
      yield if block_given?
    end
  end

  # Automatically register a user
  #
  # Pass a block for behavior when a user fails to save
  def register_automatically(user, &block)
    # Automatic activation
    user.activate
    user.last_login_on = Time.now
    if user.save
      self.logged_user = user
      flash[:notice] = l(:notice_account_activated)
      redirect_to my_account_path
    else
      yield if block_given?
    end
  end

  # Manual activation by the administrator
  #
  # Pass a block for behavior when a user fails to save
  def register_manually_by_administrator(user, &block)
    if user.save
      # Sends an email to the administrators
      Mailer.account_activation_request(user).deliver
      account_pending(user)
    else
      yield if block_given?
    end
  end

  def handle_inactive_user(user, redirect_path=signin_path)
    if user.registered?
      account_pending(user, redirect_path)
    else
      account_locked(user, redirect_path)
    end
  end

  def account_pending(user, redirect_path=signin_path)
    if Setting.self_registration == '1'
      flash[:error] = l(:notice_account_not_activated_yet, :url => activation_email_path)
      session[:registered_user_id] = user.id
    else
      flash[:error] = l(:notice_account_pending)
    end
    redirect_to redirect_path
  end

  def account_locked(user, redirect_path=signin_path)
    flash[:error] = l(:notice_account_locked)
    redirect_to redirect_path
  end
end
