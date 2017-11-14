class AdminsController < ApplicationController
  skip_before_action :require_admin_in_system, :require_login
  before_action :require_no_admin

  def new
    @user = User.new
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
 
 content_for :title, t(:create_admin) 
 content_for :title 
 t :no_administrator_yet 
 form_for @user, :url => { :action => 'create' } do |f| 
 f.error_messages 
 f.label :name, t(:username) 
 f.text_field :name, { :class => 'text_input' } 
 f.label :email 
 f.text_field :email, { :class => 'text_input' } 
 label_tag :password 
 f.password_field :password, { :class => 'text_input' } 
 label_tag :confirm_password 
 f.password_field :password_confirmation, { :class => 'text_input' } 
 f.submit t(:create_admin_account) 
 end 
  

end

  end

  def create
    @user = User.new(permitted_params.user)
    @user.password_required = true
    @user.is_admin = true

    if @user.save
      redirect_to new_session_url, :notice => t(:admin_user_created_successfully)
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
 
 content_for :title, t(:create_admin) 
 content_for :title 
 t :no_administrator_yet 
 form_for @user, :url => { :action => 'create' } do |f| 
 f.error_messages 
 f.label :name, t(:username) 
 f.text_field :name, { :class => 'text_input' } 
 f.label :email 
 f.text_field :email, { :class => 'text_input' } 
 label_tag :password 
 f.password_field :password, { :class => 'text_input' } 
 label_tag :confirm_password 
 f.password_field :password_confirmation, { :class => 'text_input' } 
 f.submit t(:create_admin_account) 
 end 
  

end

    end
  end

  private

  def require_no_admin
    redirect_to new_session_url unless User.no_admin_yet?
  end
end
