class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if content_for? :title 
 content_for :title 
 else 
 end 
 stylesheet_link_tag 'application' 
 javascript_include_tag 'application' 
 csrf_meta_tag 
 if flash[:notice] 
 flash[:notice] 
 end 
 if flash[:alert] 
 flash[:alert] 
 end 
  if signed_in? 
 t :hello 
 current_user.name 
 link_to t(:settings), edit_user_path(current_user) 
 link_to t(:sign_out), signout_path, :method => :delete 
 end 
 link_to image_tag('logo.png', :alt => 'Boxroom'), root_path 
 
  if signed_in? 
 link_to t(:folders), folders_path 
 if current_user.member_of_admins? 
 link_to t(:users), users_path 
 link_to t(:groups), groups_path 
 link_to t(:shared_files), share_links_path 
 end 
 end 
 
 content_for :title, t(:sign_in) 
 content_for :title 
 form_tag(sessions_path) do 
 label_tag :username, t(:username) 
 text_field_tag :username, nil, :class => 'text_input' 
 label_tag :password, t(:password) 
 password_field_tag :password, nil, :class => 'text_input' 
 check_box_tag :remember_me, 'true' 
 label_tag :remember_me, t(:remember_me) 
 submit_tag t(:sign_in) 
 link_to t(:reset_password), new_reset_password_path 
 end 
  

end

  end

  def create
    user = User.authenticate(params[:username], params[:password])

    unless user.nil?
      if params[:remember_me] == 'true'
        user.refresh_remember_token
        cookies[:auth_token] = { :value => user.remember_token, :expires => 2.weeks.from_now }
      end

      session[:user_id] = user.id
      redirect_url = session.delete(:return_to) || folders_url
      redirect_to redirect_url, :only_path => true
    else
      log_failed_sign_in_attempt(Time.now, params[:username], request.remote_ip)
      redirect_to new_session_url, :alert => t(:credentials_incorrect)
    end
  end

  def destroy
    current_user.forget_me
    cookies.delete :auth_token
    reset_session
    session[:user_id] = nil
    redirect_to new_session_url
  end

  private

  def log_failed_sign_in_attempt(date, username, ip)
    Rails.logger.error(
      "\nFAILED SIGN IN ATTEMPT:\n" +
      "=======================\n" +
      " Date: #{date}\n" +
      " Username: #{username}\n" +
      " IP address: #{ip}\n\n"
    )
  end
end
