class ResetPasswordController < ApplicationController
  before_action :require_valid_token, :only => [:edit, :update]
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
 
 content_for :title, t(:reset_password) 
 content_for :title 
  
 form_tag(reset_password_index_path) do 
 label_tag :email, t(:email) 
 text_field_tag :email, nil, :class => 'text_input' 
 submit_tag t(:send_email) 
 link_to t(:back), new_session_path 
 end 
  

end

  end

  def create
    user = User.find_by_email(params[:email])

    unless user.nil?
      user.refresh_reset_password_token
      UserMailer.reset_password_email(user).deliver_now
    end

    redirect_to new_reset_password_url, :notice => t(:instruction_email_sent, :email => params[:email])
  end

  # Note: @user is set in require_valid_token
  def edit
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
 
 content_for :title, t(:reset_password) 
 content_for :title 
 form_for @user, :url => { :action => 'update' } do |f| 
 f.error_messages 
 label_tag :password, t(:password) 
 f.password_field :password, { :class => 'text_input' } 
 label_tag :confirm_password, t(:confirm_password) 
 f.password_field :password_confirmation, { :class => 'text_input' } 
 f.submit t(:reset_password) 
 link_to t(:back), new_session_path 
 end 
  

end

  end

  # Note: @user is set in require_valid_token
  def update
    if @user.update_attributes(permitted_params.user.merge({ :password_required => true }))
      redirect_to new_session_url, :notice => t(:password_reset_successfully)
    else
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
 
 content_for :title, t(:reset_password) 
 content_for :title 
 form_for @user, :url => { :action => 'update' } do |f| 
 f.error_messages 
 label_tag :password, t(:password) 
 f.password_field :password, { :class => 'text_input' } 
 label_tag :confirm_password, t(:confirm_password) 
 f.password_field :password_confirmation, { :class => 'text_input' } 
 f.submit t(:reset_password) 
 link_to t(:back), new_session_path 
 end 
  

end

    end
  end

  private

  def require_valid_token
    @user = User.find_by_reset_password_token(params[:id])

    if @user.nil? || @user.reset_password_token_expires_at < Time.now
      redirect_to new_reset_password_url, :alert => t(:reset_url_expired)
    end
  end
end
