class SessionsController < ApplicationController
  layout 'dialog'

  def new
    @login_token = params[:token]
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h page_title 
 stylesheet_link_tag 'dialog' 
 javascript_include_tag 'application.js' 
 if !Company.owner.nil? and Company.owner.logo? 
 Company.owner.logo.url 
 end 
 h page_title 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 form_tag session_path, :method => :post do 
 t('username') 
 text_field_tag 'login', @login, :size => 30, :id => 'loginUsername', :class => 'medium' 
 t('password') 
 password_field_tag 'password', nil, :size => 30, :id => 'loginPassword', :class => 'medium' 
 check_box_tag 'remember_me', '1', @remember_me, :class => 'checkbox' 
 t('remember_me') 
 link_to t('forgot_password_q') , new_password_path 
 t('login') 
 end 

end

  end
  
  def show
    create
  end

  def create
    logout_keeping_session!
    
    if !params[:token].nil?
      user = User.find_by_email(params[:token_email])
      user = nil if user.nil? or !user.twisted_token_valid?(params[:token])
    else
      user = User.authenticate(params[:login], params[:password])
    end
    
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      error_status(false, :login_success)
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      @login_token = params[:token]
      @login_email = params[:token_email]
      render :action => (@login_token.nil? ? 'new' : 'new_token')
    end
  end

  def destroy
    logout_killing_session!
    error_status(false, :login_success)
    
    respond_to do |f|
      f.html {redirect_back_or_default('/')}
      f.js {}
    end
  end

protected
  # Track failed login attempts
  def note_failed_signin
    error_status(true, :login_failure)
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
  
  def authorized?(action = action_name, resource = nil)
    true
  end 
end
