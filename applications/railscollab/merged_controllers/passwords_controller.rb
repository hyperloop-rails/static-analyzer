class PasswordsController < ApplicationController
  layout 'dialog'
  before_filter :find_user, :only => [:edit, :update]
  before_filter :validate_token, :only => [:edit, :update]

  def new
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
 form_tag password_path, :method => :post do 
 t('email_address') 
 text_field_tag 'your_email', '', :id => 'forgotPasswordEmail', :class => 'medium' 
 t('send_password') 
 link_to t('cancel'), login_path 
 end 

end

  end

  def create
    @your_email = params[:your_email]

    unless @your_email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      error_status(false, :invalid_email)
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
 form_tag password_path, :method => :post do 
 t('email_address') 
 text_field_tag 'your_email', '', :id => 'forgotPasswordEmail', :class => 'medium' 
 t('send_password') 
 link_to t('cancel'), login_path 
 end 

end

      return
    end

    user = User.where(:email => @your_email).first
    if user.nil?
      error_status(false, :invalid_email_not_in_use)
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
 form_tag password_path, :method => :post do 
 t('email_address') 
 text_field_tag 'your_email', '', :id => 'forgotPasswordEmail', :class => 'medium' 
 t('send_password') 
 link_to t('cancel'), login_path 
 end 

end

      return
    end

    # Send the reset!
    Notifier.deliver_password_reset user
    error_status(false, :forgot_password_sent_email)
    redirect_to login_path
  end

  def edit
    @initial_signup = params.has_key? :initial
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
 form_tag user_password_path(@user), :method => :put do 
 error_messages_for :user 
 h params[:confirm] 
 t('password') 
 t('repeat_password') 
 @initial_signup ? t('set_password') : t('reset_password') 
 end 

end

  end

  def update
    @initial_signup = params.has_key? :initial

    @password_data = params[:user]

    @user.password = @password_data[:password]
    if @user.save
      error_status(false, :password_changed)
      session['user_id'] = @user.id
      redirect_to root_path
    else
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
 form_tag user_password_path(@user), :method => :put do 
 error_messages_for :user 
 h params[:confirm] 
 t('password') 
 t('repeat_password') 
 @initial_signup ? t('set_password') : t('reset_password') 
 end 

end

    end
  end

  protected

  def find_user
    begin
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      error_status(false, :invalid_request)
      redirect_to login_path
    end
  end

  def validate_token
    unless @user.password_reset_key == params[:confirm]
      error_status(false, :invalid_request)
      redirect_to login_path
    end
  end

  def protect?(action)
    false
  end
end
