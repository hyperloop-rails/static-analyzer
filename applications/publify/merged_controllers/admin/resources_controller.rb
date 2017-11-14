require 'fog'

class Admin::ResourcesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def upload
    if !params[:upload].blank?
      file = params[:upload][:filename]

      mime = if file.content_type
               file.content_type.chomp
             else
               'text/plain'
             end

      @up = Resource.create(upload: file, mime: mime, created_at: Time.now)
      flash[:success] = I18n.t('admin.resources.upload.success')
    else
      flash[:warning] = I18n.t('admin.resources.upload.warning')
    end

    redirect_to admin_resources_url
  end

  def index
    @r = Resource.new
    @resources = Resource.order('created_at DESC').page(params[:page]).per(this_blog.admin_display_elements)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 this_blog.blog_name 
 controller.controller_name 
 javascript_include_tag 'publify_admin', async: true 
 stylesheet_link_tag 'publify_admin' 
 csrf_meta_tags 
  link_to content_tag(:span, '', class: 'glyphicon glyphicon-home'), {controller: 'admin/dashboard'}, {class: "navbar-brand"} 
 if can? :index, 'admin/content' 
 t('.articles') 
 menu_item(t('.all_articles'), admin_content_index_path) 
 menu_item(t('.new_article'),  new_admin_content_path) 
 menu_item(t('.feedback'),     admin_feedback_index_path) 
 menu_item(t('.tags'),         admin_tags_path) 
 menu_item(t('.article_types'),admin_post_types_path) 
 menu_item(t('.redirects'),    admin_redirects_path) 
 end 
 if can? :index, 'admin/notes' 
 menu_item(t('.notes'), admin_notes_path) 
 end 
 if can? :index, 'admin/pages' 
 t('.pages') 
 menu_item(t('.all_pages'), admin_pages_path) 
 menu_item(t('.new_page'),  new_admin_page_path) 
 end 
 if can? :index, 'admin/resources' 
 menu_item(t('.media_library'), admin_resources_path) 
 end 
 if can? :index, 'admin/themes' 
 t('.design') 
 menu_item(t('.choose_theme'),      admin_themes_path) 
 menu_item(t('.customize_sidebar'), admin_sidebar_index_path) 
 end 
 if can? :index, 'admin/settings' 
 t('.settings') 
 menu_item(t('.general_settings'), admin_settings_path) 
 menu_item(t('.write'),            write_admin_settings_path) 
 menu_item(t('.display'),          display_admin_settings_path) 
 menu_item(t('.feedback'),         feedback_admin_settings_path) 
 menu_item(t('.cache'),            admin_cache_path) 
 menu_item(t('.manage_users'),     admin_users_path) 
 end 
 if can? :index, 'admin/seo' 
 t('.seo') 
 menu_item(t('.global_seo_settings'), admin_seo_path(section: 'general')) 
 menu_item(t('.permalinks'),          admin_seo_path(section: 'permalinks')) 
 menu_item(t('.titles'),              admin_seo_path(section: 'titles')) 
 end 
 t(".logged_in_as", login: current_user.display_name) 
 link_to t(".profile"), { :controller => 'admin/profiles', :action => 'index'}  
 link_to t(".documentation"), "https://github.com/fdv/publify/wiki" 
 link_to t(".report_a_bug"), "https://github.com/fdv/publify/issues" 
 link_to t(".in_page_plugins"), "https://github.com/fdv/publify/wiki/In-Page-Plugins" 
 link_to t(".sidebar_plugins"), "https://github.com/fdv/publify/wiki/Sidebar-plugins" 
 link_to t(".logout_html"), destroy_user_session_path, method: :delete 
 t(".new")
 link_to(t(".new_article"), {controller: 'content', action: 'new'}) 
 link_to(t(".new_page"), {controller: 'pages', actions: 'new'}) 
 link_to(t(".new_media"), {controller: 'resources', action: 'index'}) 
 link_to(t(".new_note"), {controller: 'notes'}) 
 
  if flash 
 flash.each do |alert_level, message| 
 flash[:error] ? 'danger' : 'success'
 alert_level.to_s.downcase 
 message 
 end 
 end 
 
 if content_for?(:page_heading) 
 t(".media_library") 
 end 
  
 form_tag({action: 'upload'}, {enctype: "multipart/form-data", class: 'form-inline'}) do 
 t('.upload_a_file_to_your_site') 
 file_field('upload', 'filename', {class: 'input-file'}) 
 submit_tag(t('.upload'), {class: 'btn btn-success'}) 
 end 
 t(".filename")
 t('.right_click_for_link') 
 t(".content_type")
 t(".file_size")
 t(".date")
 if @resources.empty? 
 t(".no_resources") 
 end 
 for upload in @resources 
 if upload.mime =~ /image/ 
 upload.upload.medium.url 
 image_tag(upload.upload.thumb.url) 
 else 
 link_to(upload.upload_url, upload.upload_url) 
 end 
 if upload.mime =~ /image/ 
 link_to(t(".thumbnail"), upload.upload.thumb.url) 
 link_to(t(".medium_size"), upload.upload.medium.url) 
 link_to(t(".original_size"), upload.upload.url) 
 end 
 link_to(t(".delete"),
                      { action: 'destroy', id: upload.id, search: params[:search], page: params[:page] },
                      confirm: t(".are_you_sure"), method: :delete) 
 upload.mime 
h upload.size rescue 0 
 l(upload.created_at, format: :short) 
 end 
 display_pagination(@resources, 6)
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def destroy
    @record = Resource.find(params[:id])
    @record.destroy
    flash[:notice] = I18n.t('admin.resources.destroy.notice')
    redirect_to admin_resources_url
  end
end
