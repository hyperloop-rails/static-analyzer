class LoginController < ApplicationController

  layout 'login'
  skip_before_filter :set_session_expiration
  skip_before_filter :login_required
  before_filter :login_optional
  before_filter :get_current_user

  protect_from_forgery :except => [:check_expiry, :login]

  def login
    @page_title = "TRACKS::Login"
    cookies[:preferred_auth] = prefered_auth? unless cookies[:preferred_auth]
    case request.method
    when 'POST'
      if @user = User.authenticate(params['user_login'], params['user_password'])
        return handle_post_success
      else
        handle_post_failure
      end
    when 'GET'
      if User.no_users_yet?
        return redirect_to signup_path
      end
    end
    respond_to do |format|
      format.html
      format.m   { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t('login.account_login') 
 render_flash 
 t('login.please_login') 
 form_tag :action=> 'login' do 
 User.human_attribute_name('login') 
 User.human_attribute_name('password') 
 t('login.user_no_expiry') 
 t('login.sign_in') 
 end 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag "login" 
 favicon_link_tag 'favicon.ico' 
 favicon_link_tag 'apple-touch-icon.png', :rel => 'apple-touch-icon', :type => 'image/png' 
 @page_title 
  t('login.account_login') 
 render_flash 
 t('login.please_login') 
 form_tag :action=> 'login' do 
 User.human_attribute_name('login') 
 User.human_attribute_name('password') 
 t('login.user_no_expiry') 
 t('login.sign_in') 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def logout
    logout_user
  end

  def check_expiry
    # Gets called by periodically_call_remote to check whether
    # the session has timed out yet
    unless session == nil
      if session
        return unless should_expire_sessions?
        # Get expiry time (allow ten seconds window for the case where we have none)
        expiry_time = session['expiry_time'] || Time.now + 10
        time_left = expiry_time - Time.now
        @session_expired = ( time_left < (10*60) ) # Session will time out before the next check
      end
    end
    respond_to do |format|
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag "login" 
 favicon_link_tag 'favicon.ico' 
 favicon_link_tag 'apple-touch-icon.png', :rel => 'apple-touch-icon', :type => 'image/png' 
 @page_title 
   if @session_expired
  theLink = link_to(t('login.log_in_again'), :controller => "login", :action => "login")
  message = I18n.t('login.session_time_out', :link => theLink)
  theHtml = escape_javascript(content_tag(:div, message.html_safe, :"class" => "warning"))
  
theHtml
  end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  private

    def handle_post_success
      session['user_id'] = @user.id
      # If checkbox on login page checked, we don't expire the session after 1 hour
      # of inactivity and we remember this user for future browser sessions
      session['noexpiry'] = params['user_noexpiry']
      msg = (should_expire_sessions?) ? "will expire after 1 hour of inactivity." : "will not expire."
      notify :notice, "Login successful: session #{msg}"
      cookies[:tracks_login] = { :value => @user.login, :expires => Time.now + 1.year, :secure => SITE_CONFIG['secure_cookies'] }
      unless should_expire_sessions?
        @user.remember_me
        cookies[:auth_token] = { :value => @user.remember_token , :expires => @user.remember_token_expires_at, :secure => SITE_CONFIG['secure_cookies'] }
      end
      redirect_back_or_home
    end

    def handle_post_failure
      @login = params['user_login']
      notify :warning, t('login.unsuccessful')
    end

  def should_expire_sessions?
    session['noexpiry'] != "on"
  end

end
