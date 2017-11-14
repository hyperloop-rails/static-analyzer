# coding: utf-8
require 'base64'

class Admin::PagesController < Admin::BaseController
  before_action :set_images, only: [:new, :edit]
  before_action :set_macro, only: [:new, :edit]
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  layout :get_layout
  cache_sweeper :blog_sweeper

  def index
    @search = params[:search] ? params[:search] : {}
    @pages = Page.search_with(@search).page(params[:page]).per(this_blog.admin_display_elements)
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
 t(".manage_pages") 
 link_to(t(".new_page"), {controller: 'pages', action: 'new'}, id: 'dialog-link', class: 'btn btn-info pull-right') 
 end 
  
 t(".title") 
 t(".author")
  if @pages.empty? 
 t(".no_pages") 
 end 
 for page in @pages 
 link_to_permalink(page, page.title) 
 show_actions page 
 author_link(page) 
 l(page.created_at) 
 end 
 display_pagination(@pages, 5) 
 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def new
    @page = Page.new
    @page.text_filter ||= default_textfilter
    @page.published = true
    @page.user_id = current_user.id
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
 yield :page_heading 
 end 
  form_for([:admin, @page]) do |f| 
 if @page.errors.any? 
 pluralize(@page.errors.count, "error") 
 @page.errors.full_messages.each do |message| 
 message 
 end 
 end 
 current_user.text_filter_name 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 controller.action_name == "new" ? t(".publish") : t(".save") 
 error_messages_for 'page' 
 @page.text_filter 
 text_field 'page', 'title', :class => 'form-control', :placeholder => t('.title')  
 text_area('page', 'body', {:class => 'form-control ', style: 'height: 360px', :rows => '20', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag( t(".publish"), class: 'btn btn-success pull-right') 
 t(".permanent_link")
 text_field 'page', 'name', :class => 'form-control' 
 t(".publish_settings") 
 t(".status") 
 (@page.published) ? t(".published") : t(".offline") 
 toggle_element('status') 
 check_box 'page', 'published'  
 t(".online")
 toggle_element 'status', "OK" 
 t(".article_filter") 
 @page.text_filter.description 
 toggle_element 'text_filter' 
 options_for_select text_filter_options, @page.text_filter 
 toggle_element 'text_filter', "OK" 
 submit_tag( t(".publish"), class: 'btn btn-success') 
 end 
 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def edit
    @page.text_filter ||= default_textfilter
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
 yield :page_heading 
 end 
  form_for([:admin, @page]) do |f| 
 if @page.errors.any? 
 pluralize(@page.errors.count, "error") 
 @page.errors.full_messages.each do |message| 
 message 
 end 
 end 
 current_user.text_filter_name 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 controller.action_name == "new" ? t(".publish") : t(".save") 
 error_messages_for 'page' 
 @page.text_filter 
 text_field 'page', 'title', :class => 'form-control', :placeholder => t('.title')  
 text_area('page', 'body', {:class => 'form-control ', style: 'height: 360px', :rows => '20', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag( t(".publish"), class: 'btn btn-success pull-right') 
 t(".permanent_link")
 text_field 'page', 'name', :class => 'form-control' 
 t(".publish_settings") 
 t(".status") 
 (@page.published) ? t(".published") : t(".offline") 
 toggle_element('status') 
 check_box 'page', 'published'  
 t(".online")
 toggle_element 'status', "OK" 
 t(".article_filter") 
 @page.text_filter.description 
 toggle_element 'text_filter' 
 options_for_select text_filter_options, @page.text_filter 
 toggle_element 'text_filter', "OK" 
 submit_tag( t(".publish"), class: 'btn btn-success') 
 end 
 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def create
    @page = Page.new(page_params)
    @page.published_at = Time.now
    @page.blog = this_blog
    @page.user_id = current_user.id

    if @page.save
      redirect_to admin_pages_url, notice: I18n.t('admin.pages.new.success')
    else
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
 yield :page_heading 
 end 
  form_for([:admin, @page]) do |f| 
 if @page.errors.any? 
 pluralize(@page.errors.count, "error") 
 @page.errors.full_messages.each do |message| 
 message 
 end 
 end 
 current_user.text_filter_name 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 controller.action_name == "new" ? t(".publish") : t(".save") 
 error_messages_for 'page' 
 @page.text_filter 
 text_field 'page', 'title', :class => 'form-control', :placeholder => t('.title')  
 text_area('page', 'body', {:class => 'form-control ', style: 'height: 360px', :rows => '20', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag( t(".publish"), class: 'btn btn-success pull-right') 
 t(".permanent_link")
 text_field 'page', 'name', :class => 'form-control' 
 t(".publish_settings") 
 t(".status") 
 (@page.published) ? t(".published") : t(".offline") 
 toggle_element('status') 
 check_box 'page', 'published'  
 t(".online")
 toggle_element 'status', "OK" 
 t(".article_filter") 
 @page.text_filter.description 
 toggle_element 'text_filter' 
 options_for_select text_filter_options, @page.text_filter 
 toggle_element 'text_filter', "OK" 
 submit_tag( t(".publish"), class: 'btn btn-success') 
 end 
 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

    end
  end

  def update
    @page.text_filter ||= default_textfilter
    if @page.update(page_params)
      redirect_to admin_pages_url, notice: I18n.t('admin.pages.edit.success')
    else
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
 yield :page_heading 
 end 
  form_for([:admin, @page]) do |f| 
 if @page.errors.any? 
 pluralize(@page.errors.count, "error") 
 @page.errors.full_messages.each do |message| 
 message 
 end 
 end 
 current_user.text_filter_name 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 controller.action_name == "new" ? t(".publish") : t(".save") 
 error_messages_for 'page' 
 @page.text_filter 
 text_field 'page', 'title', :class => 'form-control', :placeholder => t('.title')  
 text_area('page', 'body', {:class => 'form-control ', style: 'height: 360px', :rows => '20', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag( t(".publish"), class: 'btn btn-success pull-right') 
 t(".permanent_link")
 text_field 'page', 'name', :class => 'form-control' 
 t(".publish_settings") 
 t(".status") 
 (@page.published) ? t(".published") : t(".offline") 
 toggle_element('status') 
 check_box 'page', 'published'  
 t(".online")
 toggle_element 'status', "OK" 
 t(".article_filter") 
 @page.text_filter.description 
 toggle_element 'text_filter' 
 options_for_select text_filter_options, @page.text_filter 
 toggle_element 'text_filter', "OK" 
 submit_tag( t(".publish"), class: 'btn btn-success') 
 end 
 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

    end
  end

  def destroy
    destroy_a(Page)
  end

  private

  def default_textfilter
    current_user.text_filter || blog.text_filter
  end

  def set_macro
    @macros = TextFilter.macro_filters
  end

  def set_images
    @images = Resource.images.by_created_at.page(1).per(10)
  end

  def get_layout
    case action_name
    when 'new', 'edit', 'create'
      'editor'
    when 'show'
      nil
    else
      'administration'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_params
    params.require(:page).permit(:title, :body, :name, :published, :text_filter)
  end
end
