class FilesController < ApplicationController
  before_action :require_existing_file, :only => [:show, :edit, :update, :destroy]
  before_action :require_existing_target_folder, :only => [:new, :create]

  before_action :require_create_permission, :only => [:new, :create]
  before_action :require_read_permission, :only => :show
  before_action :require_update_permission, :only => [:edit, :update]
  before_action :require_delete_permission, :only => :destroy

  # @file and @folder are set in require_existing_file
  def show
    send_file @file.attachment.path, :filename => @file.attachment_file_name
  end

  # @target_folder is set in require_existing_target_folder
  def new
    @file = @target_folder.user_files.build
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
 
 content_for :title, t(:upload_file) 
 content_for :title 
 form_for [@target_folder, @file], :url => { :action => 'create' } do |f| 
 hidden_field_tag :target_folder_id, @target_folder.id 
 file_field_tag :attachment, :multiple => true, :name => 'user_file[attachment]' 
 link_to t(:back), @target_folder 
 end 
 image_tag 'spinner.gif', :class => 'spinner' 
 image_tag 'failed.png', :class => 'failed', :style => 'display:none;' 
 image_tag 'tick.png', :class => 'tick', :style => 'display:none;' 
 t(:exists_already) 
  

end

  end

  # @target_folder is set in require_existing_target_folder
  def create
    @file = @target_folder.user_files.create(permitted_params.user_file)
    render :nothing => true
  end

  # @file and @folder are set in require_existing_file
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
 
 content_for :title, t(:rename_file) 
 content_for :title 
 form_for @file, :url => { :action => 'update' } do |f| 
 f.error_messages 
 f.label :name 
 f.text_field :attachment_file_name 
 f.submit t(:save) 
 link_to t(:back), @folder 
 end 
  

end

  end

  # @file and @folder are set in require_existing_file
  def update
    if @file.update_attributes(permitted_params.user_file)
      redirect_to edit_file_url(@file), :notice => t(:your_changes_were_saved)
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
 
 content_for :title, t(:rename_file) 
 content_for :title 
 form_for @file, :url => { :action => 'update' } do |f| 
 f.error_messages 
 f.label :name 
 f.text_field :attachment_file_name 
 f.submit t(:save) 
 link_to t(:back), @folder 
 end 
  

end

    end
  end

  # @file and @folder are set in require_existing_file
  def destroy
    @file.destroy
    redirect_to @folder
  end

  def exists
    @file = UserFile.new(:attachment_file_name => params[:name].gsub(RESTRICTED_CHARACTERS, '_'))
    @file.folder_id = params[:folder]
    render :json => !@file.valid?
  end

  private

  def require_existing_file
    @file = UserFile.find(params[:id])
    @folder = @file.folder
  rescue ActiveRecord::RecordNotFound
    redirect_to Folder.root, :alert => t(:already_deleted, :type => t(:this_file))
  end
end
