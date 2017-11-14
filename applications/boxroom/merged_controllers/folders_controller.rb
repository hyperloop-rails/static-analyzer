class FoldersController < ApplicationController
  before_action :require_existing_folder, :only => [:show, :edit, :update, :destroy]
  before_action :require_existing_target_folder, :only => [:new, :create]
  before_action :require_folder_isnt_root_folder, :only => [:edit, :update, :destroy]

  before_action :require_create_permission, :only => [:new, :create]
  before_action :require_read_permission, :only => :show
  before_action :require_update_permission, :only => [:edit, :update]
  before_action :require_delete_permission, :only => :destroy

  def index
    redirect_to Folder.root
  end

  # Note: @folder is set in require_existing_folder
  def show
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
 
 content_for :title, @folder.name 
 content_for :title 
 unless @folder.is_root? 
 breadcrumbs(@folder) 
 @folder.name 
 end 
 if current_user.can_create(@folder) 
 image_tag('folder_add.png', :alt => t(:create_a_new_folder)) 
 link_to t(:create_a_new_folder), new_folder_folder_path(@folder) 
 image_tag('file_add.png', :alt => t(:upload_a_file)) 
 link_to t(:upload_a_file), new_folder_file_path(@folder) 
 end 
 if current_user.member_of_admins? 
 image_tag('permissions.png', :alt => t(:permissions)) 
 link_to t(:permissions), '#', :class => 'permissions_link' 
 end 
 image_tag('clipboard.png', :alt => t(:clipboard)) 
 link_to t(:clipboard), '#', :class => 'clipboard_link' 
 t :name 
 t :size 
 t :date_modified 
 unless @folder.is_root? 
 cycle('even','odd') 
 image_tag('folder.png') 
 link_to t(:up), @folder.parent, :title => @folder.parent.name 
 end 
 @folder.children.each do |folder| 
 if current_user.can_read(folder) 
 cycle('even','odd') 
 image_tag('folder.png') 
 link_to folder.name, folder 
 l folder.updated_at, :format => :short 
 if current_user.can_update(folder) 
 link_to image_tag('edit.png', :alt => t(:edit)), edit_folder_path(folder), :title => t(:edit) 
 end 
 if current_user.can_delete(folder) 
 link_to image_tag('delete.png', :alt => t(:delete_item)), folder, :method => :delete, :data => { :confirm => t(:are_you_sure) }, :title => t(:delete_item) 
 end 
 link_to image_tag('clipboard_add.png', :alt => t(:add_to_clipboard)),
          { :controller => :clipboard, :action => :create, :id => folder.id, :type => 'folder', :folder_id => @folder, :authenticity_token => form_authenticity_token },
          :method => :post, :title => t(:add_to_clipboard)
        
 end 
 end 
 @folder.user_files.each do |file| 
 if current_user.can_read(@folder) 
 cycle('even','odd') 
 image_tag(file_icon(file.extension)) 
 link_to file.attachment_file_name, file_path(file), :title => "#{t(:download)} #{file.attachment_file_name}" 
 number_to_human_size(file.attachment_file_size, :locale => I18n.locale) 
 l file.updated_at, :format => :short 
 if current_user.can_update(file.folder) 
 link_to image_tag('edit.png', :alt => t(:edit)), edit_file_path(file), :title => t(:edit) 
 end 
 if current_user.can_delete(file.folder) 
 link_to image_tag('delete.png', :alt => t(:delete_item)), file_path(file), :method => :delete, :data => { :confirm => t(:are_you_sure) }, :title => t(:delete_item) 
 end 
 link_to image_tag('clipboard_add.png', :alt => t(:add_to_clipboard)),
          { :controller => :clipboard, :action => :create, :id => file.id, :type => 'file', :folder_id => @folder, :authenticity_token => form_authenticity_token },
          :method => :post, :title => t(:add_to_clipboard)
        
 link_to image_tag('share.png', :alt => t(:share)), new_file_share_link_path(file), :title => t(:share) 
 end 
 end 
 if current_user.member_of_admins? 
  form_tag update_multiple_permissions_path do 
 hidden_field_tag '_method', 'put' 
 t :create_permission 
 t :read_permission 
 t :update_permission 
 t :delete_permission 
 reset_cycle 
 @folder.permissions.each do |permission| 
 fields_for "permissions[]", permission do |f| 
 cycle('even','odd') 
 if permission.group.admins_group? 
 image_tag('group_grey.png') 
 permission.group.name 
 else 
 image_tag('group.png') 
 permission.group.name 
 f.check_box :can_create 
 f.check_box :can_read 
 f.check_box :can_update 
 f.check_box :can_delete 
 end 
 end 
 end 
 submit_tag t(:save) 
 check_box_tag :recursive, true 
 t :apply_changes_to_subfolders 
 link_to t(:back), '#', :class => 'back_link' 
 end 
 
 end 
  if clipboard.empty? 
 image_tag('information.png', :alt => 'Notice', :class => 'clipboard_info_image') 
  link_to 'indietro', '#', :class => 'back_link' 
 
 else 
 t :name 
 reset_cycle 
 clipboard.folders.each do |item| 
 cycle('even','odd') 
 image_tag('folder.png') 
 item.name 
 if current_user.can_create(@folder) 
 link_to image_tag('copy.png', :alt => t(:copy)),
          { :controller => :clipboard, :action => :copy, :id => item.id, :type => 'folder', :folder_id => @folder, :authenticity_token => form_authenticity_token },
          :method => :post, :title => t(:copy_folder)
        
 end 
 if current_user.can_create(@folder) && current_user.can_delete(item) 
 link_to image_tag('move.png', :alt => t(:move)),
          { :controller => :clipboard, :action => :move, :id => item.id, :type => 'folder', :folder_id => @folder, :authenticity_token => form_authenticity_token },
          :method => :post, :title => t(:move_folder), :data => { :confirm => t(:are_you_sure) }
        
 end 
 link_to image_tag('delete.png', :alt => t(:delete_item)),
          { :controller => :clipboard, :action => :destroy, :id => item.id, :type => 'folder', :folder_id => @folder, :authenticity_token => form_authenticity_token },
          :method => :delete, :title => t(:remove_from_clipboard)
        
 end 
 clipboard.files.each do |item| 
 cycle('even', 'odd') 
 image_tag(file_icon(item.extension)) 
 item.attachment_file_name 
 if current_user.can_create(@folder) 
 link_to image_tag('copy.png', :alt => t(:copy)),
          { :controller => :clipboard, :action => :copy, :id => item.id, :type => 'file', :folder_id => @folder, :authenticity_token => form_authenticity_token },
          :method => :post, :title => t(:copy_file)
        
 end 
 if current_user.can_create(@folder) && current_user.can_delete(item.folder) 
 link_to image_tag('move.png', :alt => t(:move)),
          { :controller => :clipboard, :action => :move, :id => item.id, :type => 'file', :folder_id => @folder, :authenticity_token => form_authenticity_token },
          :method => :post, :title => t(:move_file), :data => { :confirm => t(:are_you_sure) }
        
 end 
 link_to image_tag('delete.png', :alt => t(:delete_item)),
          { :controller => :clipboard, :action => :destroy, :id => item.id, :type => 'file', :folder_id => @folder, :authenticity_token => form_authenticity_token },
          :method => :delete, :title => t(:remove_from_clipboard)
        
 end 
 button_to t(:clear_clipboard),
      { :controller => :clipboard, :action => :reset, :folder_id => @folder, :authenticity_token => form_authenticity_token }, :method => :put
    
 link_to t(:back), '#', :class => 'back_link' 
 end 
 
  

end

  end

  # Note: @target_folder is set in require_existing_target_folder
  def new
    @folder = @target_folder.children.build
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
 
 content_for :title, t(:new_folder) 
 content_for :title 
 form_for [@target_folder, @folder] do |f| 
  f.error_messages 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 f.submit t(:save) 
 link_to t(:back), @folder.parent 
 
 end 
  

end

  end

  # Note: @target_folder is set in require_existing_target_folder
  def create
    @folder = @target_folder.children.build(permitted_params.folder)

    if @folder.save
      redirect_to @target_folder
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
 
 content_for :title, t(:new_folder) 
 content_for :title 
 form_for [@target_folder, @folder] do |f| 
  f.error_messages 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 f.submit t(:save) 
 link_to t(:back), @folder.parent 
 
 end 
  

end

    end
  end

  # Note: @folder is set in require_existing_folder
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
 
 content_for :title, t(:rename_folder) 
 content_for :title 
 form_for @folder do |f| 
  f.error_messages 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 f.submit t(:save) 
 link_to t(:back), @folder.parent 
 
 end 
  

end

  end

  # Note: @folder is set in require_existing_folder
  def update
    if @folder.update_attributes(permitted_params.folder)
      redirect_to edit_folder_url(@folder), :notice => t(:your_changes_were_saved)
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
 
 content_for :title, t(:rename_folder) 
 content_for :title 
 form_for @folder do |f| 
  f.error_messages 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 f.submit t(:save) 
 link_to t(:back), @folder.parent 
 
 end 
  

end

    end
  end

  # Note: @folder is set in require_existing_folder
  def destroy
    target_folder = @folder.parent
    @folder.destroy
    redirect_to target_folder
  end

  private

  # get_folder_or_redirect is defined in ApplicationController
  def require_existing_folder
    @folder = get_folder_or_redirect(params[:id])
  end

  def require_folder_isnt_root_folder
    if @folder.is_root?
      redirect_to Folder.root, :alert => t(:cannot_delete_root_folder)
    end
  end

  # Overrides require_delete_permission in ApplicationController
  def require_delete_permission
    unless @folder.is_root? || current_user.can_delete(@folder)
      redirect_to @folder.parent, :alert => t(:no_permissions_for_this_type, :method => t(:delete), :type =>t(:this_folder))
    else
      require_delete_permissions_for(@folder.children)
    end
  end

  def require_delete_permissions_for(folders)
    folders.each do |folder|
      unless current_user.can_delete(folder)
        redirect_to @folder.parent, :alert => t(:no_delete_permissions_for_subfolder)
      else
        # Recursive...
        require_delete_permissions_for(folder.children)
      end
    end
  end
end
