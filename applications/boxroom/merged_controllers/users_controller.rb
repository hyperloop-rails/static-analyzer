class UsersController < ApplicationController
  before_action :require_admin, :except => [:edit, :update]
  before_action :require_existing_user, :only => [:edit, :update, :destroy, :extend]
  before_action :require_deleted_user_isnt_admin, :only => :destroy

  def index
    @users = User.where.not(:name => nil).order('name')
    @new_users = User.where(:name => nil).order('email')
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
 
 content_for :title, t(:users) 
 content_for :title 
 image_tag('user_add.png', :alt => t(:create_a_new_user)) 
 link_to t(:create_a_new_user), new_user_path 
 t :active_users 
 t :name 
 t :email 
 @users.each do |user| 
 cycle('even','odd') 
 image_tag('user.png') 
 user.name 
 user.email 
 link_to image_tag('edit.png', :alt => t(:edit)), edit_user_path(user), :title => t(:edit) 
 unless user.is_admin 
 link_to image_tag('delete.png', :alt => t(:delete_item)), user_path(user), :method => :delete, :data => { :confirm => t(:are_you_sure) }, :title => t(:delete_item) 
 end 
 end 
 unless @new_users.blank? 
 t :invited_users 
 t :email 
 t :expiration_date 
 @new_users.each do |user| 
 cycle('even','odd') 
 image_tag('user.png') 
 user.email 
 if user.signup_token_expires_at > Time.now 
 l user.signup_token_expires_at, :format => :very_short 
 else 
 l user.signup_token_expires_at, :format => :very_short 
 end 
 link_to image_tag('extend.png', :alt => t(:extend_expiration_date)), extend_user_path(user), :method => :put, :title => t(:extend_expiration_date) 
 unless user.is_admin 
 link_to image_tag('delete.png', :alt => t(:delete_item)), user_path(user), :method => :delete, :data => { :confirm => t(:are_you_sure) }, :title => t(:delete_item) 
 end 
 end 
 end 
  

end

  end

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
 
 content_for :title, t(:new_user) 
 content_for :title 
  form_for @user do |f| 
 f.error_messages 
 unless @user.new_record? 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 end 
 f.label :email 
 f.text_field :email, { :class => 'text_input' } 
 unless @user.new_record? 
 f.label :password 
 f.password_field :password, { :class => 'text_input' } 
 label_tag t(:confirm_password) 
 f.password_field :password_confirmation, { :class => 'text_input' } 
 end 
 if signed_in? && current_user.member_of_admins? 
 t :member_of_these_groups 
 if @user.is_admin 
 hidden_field_tag 'user[group_ids][]', Group.admins_group.id 
 f.collection_check_boxes :group_ids, Group.all_except_admins, :id, :name 
 else 
 f.collection_check_boxes :group_ids, Group.all, :id, :name 
 end 
 end 
 f.submit t(:save) 
 if @user != current_user 
 link_to t(:back), users_url 
 end 
 end 
 
  

end

  end

  def create
    @user = User.new(permitted_params.user)

    if @user.save
      UserMailer.signup_email(@user).deliver_now
      redirect_to users_url
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
 
 content_for :title, t(:new_user) 
 content_for :title 
  form_for @user do |f| 
 f.error_messages 
 unless @user.new_record? 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 end 
 f.label :email 
 f.text_field :email, { :class => 'text_input' } 
 unless @user.new_record? 
 f.label :password 
 f.password_field :password, { :class => 'text_input' } 
 label_tag t(:confirm_password) 
 f.password_field :password_confirmation, { :class => 'text_input' } 
 end 
 if signed_in? && current_user.member_of_admins? 
 t :member_of_these_groups 
 if @user.is_admin 
 hidden_field_tag 'user[group_ids][]', Group.admins_group.id 
 f.collection_check_boxes :group_ids, Group.all_except_admins, :id, :name 
 else 
 f.collection_check_boxes :group_ids, Group.all, :id, :name 
 end 
 end 
 f.submit t(:save) 
 if @user != current_user 
 link_to t(:back), users_url 
 end 
 end 
 
  

end

    end
  end

  # Note: @user is set in require_existing_user
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
 
 content_for :title, @title 
 content_for :title 
  form_for @user do |f| 
 f.error_messages 
 unless @user.new_record? 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 end 
 f.label :email 
 f.text_field :email, { :class => 'text_input' } 
 unless @user.new_record? 
 f.label :password 
 f.password_field :password, { :class => 'text_input' } 
 label_tag t(:confirm_password) 
 f.password_field :password_confirmation, { :class => 'text_input' } 
 end 
 if signed_in? && current_user.member_of_admins? 
 t :member_of_these_groups 
 if @user.is_admin 
 hidden_field_tag 'user[group_ids][]', Group.admins_group.id 
 f.collection_check_boxes :group_ids, Group.all_except_admins, :id, :name 
 else 
 f.collection_check_boxes :group_ids, Group.all, :id, :name 
 end 
 end 
 f.submit t(:save) 
 if @user != current_user 
 link_to t(:back), users_url 
 end 
 end 
 
  

end

  end

  # Note: @user is set in require_existing_user
  def update
    if @user.update_attributes(permitted_params.user.merge({ :password_required => false }))
      redirect_to edit_user_url(@user), :notice => t(:your_changes_were_saved)
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
 
 content_for :title, @title 
 content_for :title 
  form_for @user do |f| 
 f.error_messages 
 unless @user.new_record? 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 end 
 f.label :email 
 f.text_field :email, { :class => 'text_input' } 
 unless @user.new_record? 
 f.label :password 
 f.password_field :password, { :class => 'text_input' } 
 label_tag t(:confirm_password) 
 f.password_field :password_confirmation, { :class => 'text_input' } 
 end 
 if signed_in? && current_user.member_of_admins? 
 t :member_of_these_groups 
 if @user.is_admin 
 hidden_field_tag 'user[group_ids][]', Group.admins_group.id 
 f.collection_check_boxes :group_ids, Group.all_except_admins, :id, :name 
 else 
 f.collection_check_boxes :group_ids, Group.all, :id, :name 
 end 
 end 
 f.submit t(:save) 
 if @user != current_user 
 link_to t(:back), users_url 
 end 
 end 
 
  

end

    end
  end

  # Note: @user is set in require_existing_user
  def extend
    @user.signup_token_expires_at = @user.signup_token_expires_at + 2.weeks
    @user.save(:validate => false)
    redirect_to users_url
  end

  # Note: @user is set in require_existing_user
  def destroy
    @user.destroy
    redirect_to users_url
  end

  private

  def require_existing_user
    if current_user.member_of_admins? && params[:id] != current_user.id.to_s
      @title = t(:edit_user)
      @user = User.find(params[:id])
    else
      @title = t(:account_settings)
      @user = current_user
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url, :alert => t(:user_already_deleted)
  end

  def require_deleted_user_isnt_admin
    if @user.is_admin
      redirect_to users_url, :alert => t(:admin_user_cannot_be_deleted)
    end
  end
end
