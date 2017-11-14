require 'base64'

module Admin; end

class Admin::ContentController < Admin::BaseController
  layout :get_layout

  cache_sweeper :blog_sweeper

  def index
    @search = params[:search] ? params[:search] : {}
    @articles = this_blog.articles.search_with(@search).page(params[:page]).per(this_blog.admin_display_elements)

    if request.xhr?
      respond_to do |format|
        format.js {}
      end
    else
      @article = Article.new(params[:article])
    end
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
  if @articles.empty? 
 t('.no_articles') 
 end 
 for article in @articles 
 if article.published 
 link_to_permalink(article, article.title, nil, 'published')
 else 
 link_to(article.title, {controller: '/articles', action: "preview", id: article.id}, {class: 'unpublished', target: '_new'}) 
 end 
 show_actions article 
 author_link(article)
 l(article.published_at) 
 (article.allow_comments?) ? link_to("#{article.comments.ham.size.to_s} <i class='glyphicon glyphicon-comment'></i>".html_safe, controller: '/admin/feedback', id: article.id, action: 'article') : '-' 
 end 
 display_pagination(@articles, 5, 'first', 'last')
 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def new
    @article = Article::Factory.new(this_blog, current_user).default
    load_resources
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
 form_tag({action: 'create'}, id: 'article_form', multipart: true, class: 'autosave') do 
  hidden_field_tag 'user_textfilter', current_user.text_filter_name 
 hidden_field_tag('article[id]', @article.id) if @article.present? 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 link_to(t('.preview'), {controller: '/articles', action: 'preview', id: @article.id}, {target: 'new', class: 'btn btn-default'}) if @article.id 
 t('.save_as_draft') 
 controller.action_name == 'new' ? t('.publish') : t('.save') 
  if flash 
 flash.each do |alert_level, message| 
 flash[:error] ? 'danger' : 'success'
 alert_level.to_s.downcase 
 message 
 end 
 end 
 
 error_messages_for 'article' 
 @article.text_filter 
 text_field 'article', 'title', class: 'form-control', placeholder: t('.title') 
 text_area('article', 'body_and_extended', {class: 'form-control ', style: 'height: 360px', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag(t('.publish'), class: 'btn btn-success pull-right') 
 t('.tags') 
 text_field 'article', 'keywords', {autocomplete: 'off', class: 'form-control tm-input'} 
t('.tags_explaination') 
 post_types = @post_types || [] 
 if post_types.size.zero? 
 hidden_field_tag 'article[post_type]', 'read' 
 else 
 t('.article_type') 
 select :article, :post_type, post_types.map{|pt| [pt.name, pt.permalink]}, {include_blank: t('.default')} 
 end 
 t('.publish_settings') 
 t('.permalink') 
 toggle_element('permalink') 
 text_field 'article', 'permalink', {autocomplete: 'off', class: 'form-control'} 
 toggle_element('permalink', t('.ok')) 
 t('.status') 
 @article.state.to_s.downcase 
 toggle_element('status') 
 check_box 'article', 'published'  
 t('.published') 
 toggle_element('status', t('.ok')) 
 t('.allowed_comments_and_trackbacks_html', allow_comment: content_tag(:strong, t('.allow_comments_status', count: @article.allow_comments ? 1 : 0)), allow_trackback: content_tag(:strong, t('.allow_pings_status', count: @article.allow_pings ? 1 : 0))) 
 toggle_element('conversation') 
 check_box 'article', 'allow_pings' 
 t('.allow_trackbacks') 
 check_box 'article', 'allow_comments' 
 t('.allow_comments') 
 toggle_element('conversation', t('.ok')) 
 t('.published') 
 if @article.published 
 display_date_and_time(@article.published_at) 
 else 
 t('.now') 
 end 
 toggle_element('publish') 
 text_field 'article', 'published_at' 
 toggle_element('publish', t('.ok')) 
 t('.visibility') 
 @article.password.blank? ? t('.public') : t('.protected') 
 toggle_element('visibility') 
 t('.password') 
 text_field 'article', 'password', class: 'form-control' 
 toggle_element('visibility', t('.ok')) 
 t('.cancel') 
 submit_tag(t('.publish'), class: 'btn btn-success') 
 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def edit
    return unless access_granted?(params[:id])
    @article = Article.find(params[:id])
    @article.text_filter ||= current_user.default_text_filter
    @article.keywords = Tag.collection_to_string @article.tags
    load_resources
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
 form_tag({action: 'update', id: @article.id}, method: :put, multipart: true, id: "article_form", class: 'autosave') do 
  hidden_field_tag 'user_textfilter', current_user.text_filter_name 
 hidden_field_tag('article[id]', @article.id) if @article.present? 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 link_to(t('.preview'), {controller: '/articles', action: 'preview', id: @article.id}, {target: 'new', class: 'btn btn-default'}) if @article.id 
 t('.save_as_draft') 
 controller.action_name == 'new' ? t('.publish') : t('.save') 
  if flash 
 flash.each do |alert_level, message| 
 flash[:error] ? 'danger' : 'success'
 alert_level.to_s.downcase 
 message 
 end 
 end 
 
 error_messages_for 'article' 
 @article.text_filter 
 text_field 'article', 'title', class: 'form-control', placeholder: t('.title') 
 text_area('article', 'body_and_extended', {class: 'form-control ', style: 'height: 360px', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag(t('.publish'), class: 'btn btn-success pull-right') 
 t('.tags') 
 text_field 'article', 'keywords', {autocomplete: 'off', class: 'form-control tm-input'} 
t('.tags_explaination') 
 post_types = @post_types || [] 
 if post_types.size.zero? 
 hidden_field_tag 'article[post_type]', 'read' 
 else 
 t('.article_type') 
 select :article, :post_type, post_types.map{|pt| [pt.name, pt.permalink]}, {include_blank: t('.default')} 
 end 
 t('.publish_settings') 
 t('.permalink') 
 toggle_element('permalink') 
 text_field 'article', 'permalink', {autocomplete: 'off', class: 'form-control'} 
 toggle_element('permalink', t('.ok')) 
 t('.status') 
 @article.state.to_s.downcase 
 toggle_element('status') 
 check_box 'article', 'published'  
 t('.published') 
 toggle_element('status', t('.ok')) 
 t('.allowed_comments_and_trackbacks_html', allow_comment: content_tag(:strong, t('.allow_comments_status', count: @article.allow_comments ? 1 : 0)), allow_trackback: content_tag(:strong, t('.allow_pings_status', count: @article.allow_pings ? 1 : 0))) 
 toggle_element('conversation') 
 check_box 'article', 'allow_pings' 
 t('.allow_trackbacks') 
 check_box 'article', 'allow_comments' 
 t('.allow_comments') 
 toggle_element('conversation', t('.ok')) 
 t('.published') 
 if @article.published 
 display_date_and_time(@article.published_at) 
 else 
 t('.now') 
 end 
 toggle_element('publish') 
 text_field 'article', 'published_at' 
 toggle_element('publish', t('.ok')) 
 t('.visibility') 
 @article.password.blank? ? t('.public') : t('.protected') 
 toggle_element('visibility') 
 t('.password') 
 text_field 'article', 'password', class: 'form-control' 
 toggle_element('visibility', t('.ok')) 
 t('.cancel') 
 submit_tag(t('.publish'), class: 'btn btn-success') 
 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def create
    article_factory = Article::Factory.new(this_blog, current_user)
    @article = article_factory.get_or_build_from(params[:article][:id])

    update_article_attributes

    if @article.save
      flash[:success] = I18n.t('admin.content.create.success')
      redirect_to action: 'index'
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
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
 form_tag({action: 'create'}, id: 'article_form', multipart: true, class: 'autosave') do 
  hidden_field_tag 'user_textfilter', current_user.text_filter_name 
 hidden_field_tag('article[id]', @article.id) if @article.present? 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 link_to(t('.preview'), {controller: '/articles', action: 'preview', id: @article.id}, {target: 'new', class: 'btn btn-default'}) if @article.id 
 t('.save_as_draft') 
 controller.action_name == 'new' ? t('.publish') : t('.save') 
  if flash 
 flash.each do |alert_level, message| 
 flash[:error] ? 'danger' : 'success'
 alert_level.to_s.downcase 
 message 
 end 
 end 
 
 error_messages_for 'article' 
 @article.text_filter 
 text_field 'article', 'title', class: 'form-control', placeholder: t('.title') 
 text_area('article', 'body_and_extended', {class: 'form-control ', style: 'height: 360px', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag(t('.publish'), class: 'btn btn-success pull-right') 
 t('.tags') 
 text_field 'article', 'keywords', {autocomplete: 'off', class: 'form-control tm-input'} 
t('.tags_explaination') 
 post_types = @post_types || [] 
 if post_types.size.zero? 
 hidden_field_tag 'article[post_type]', 'read' 
 else 
 t('.article_type') 
 select :article, :post_type, post_types.map{|pt| [pt.name, pt.permalink]}, {include_blank: t('.default')} 
 end 
 t('.publish_settings') 
 t('.permalink') 
 toggle_element('permalink') 
 text_field 'article', 'permalink', {autocomplete: 'off', class: 'form-control'} 
 toggle_element('permalink', t('.ok')) 
 t('.status') 
 @article.state.to_s.downcase 
 toggle_element('status') 
 check_box 'article', 'published'  
 t('.published') 
 toggle_element('status', t('.ok')) 
 t('.allowed_comments_and_trackbacks_html', allow_comment: content_tag(:strong, t('.allow_comments_status', count: @article.allow_comments ? 1 : 0)), allow_trackback: content_tag(:strong, t('.allow_pings_status', count: @article.allow_pings ? 1 : 0))) 
 toggle_element('conversation') 
 check_box 'article', 'allow_pings' 
 t('.allow_trackbacks') 
 check_box 'article', 'allow_comments' 
 t('.allow_comments') 
 toggle_element('conversation', t('.ok')) 
 t('.published') 
 if @article.published 
 display_date_and_time(@article.published_at) 
 else 
 t('.now') 
 end 
 toggle_element('publish') 
 text_field 'article', 'published_at' 
 toggle_element('publish', t('.ok')) 
 t('.visibility') 
 @article.password.blank? ? t('.public') : t('.protected') 
 toggle_element('visibility') 
 t('.password') 
 text_field 'article', 'password', class: 'form-control' 
 toggle_element('visibility', t('.ok')) 
 t('.cancel') 
 submit_tag(t('.publish'), class: 'btn btn-success') 
 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

    end
  end

  def update
    return unless access_granted?(params[:id])
    id = params[:article][:id] || params[:id]
    @article = Article.find(id)

    if params[:article][:draft]
      get_fresh_or_existing_draft_for_article
    else
      @article = Article.find(@article.parent_id) unless @article.parent_id.nil?
    end

    update_article_attributes

    if @article.save
      Article.where(parent_id: @article.id).map(&:destroy) unless @article.draft
      flash[:success] = I18n.t('admin.content.update.success')
      redirect_to action: 'index'
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
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
 form_tag({action: 'update', id: @article.id}, method: :put, multipart: true, id: "article_form", class: 'autosave') do 
  hidden_field_tag 'user_textfilter', current_user.text_filter_name 
 hidden_field_tag('article[id]', @article.id) if @article.present? 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 link_to(t('.preview'), {controller: '/articles', action: 'preview', id: @article.id}, {target: 'new', class: 'btn btn-default'}) if @article.id 
 t('.save_as_draft') 
 controller.action_name == 'new' ? t('.publish') : t('.save') 
  if flash 
 flash.each do |alert_level, message| 
 flash[:error] ? 'danger' : 'success'
 alert_level.to_s.downcase 
 message 
 end 
 end 
 
 error_messages_for 'article' 
 @article.text_filter 
 text_field 'article', 'title', class: 'form-control', placeholder: t('.title') 
 text_area('article', 'body_and_extended', {class: 'form-control ', style: 'height: 360px', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag(t('.publish'), class: 'btn btn-success pull-right') 
 t('.tags') 
 text_field 'article', 'keywords', {autocomplete: 'off', class: 'form-control tm-input'} 
t('.tags_explaination') 
 post_types = @post_types || [] 
 if post_types.size.zero? 
 hidden_field_tag 'article[post_type]', 'read' 
 else 
 t('.article_type') 
 select :article, :post_type, post_types.map{|pt| [pt.name, pt.permalink]}, {include_blank: t('.default')} 
 end 
 t('.publish_settings') 
 t('.permalink') 
 toggle_element('permalink') 
 text_field 'article', 'permalink', {autocomplete: 'off', class: 'form-control'} 
 toggle_element('permalink', t('.ok')) 
 t('.status') 
 @article.state.to_s.downcase 
 toggle_element('status') 
 check_box 'article', 'published'  
 t('.published') 
 toggle_element('status', t('.ok')) 
 t('.allowed_comments_and_trackbacks_html', allow_comment: content_tag(:strong, t('.allow_comments_status', count: @article.allow_comments ? 1 : 0)), allow_trackback: content_tag(:strong, t('.allow_pings_status', count: @article.allow_pings ? 1 : 0))) 
 toggle_element('conversation') 
 check_box 'article', 'allow_pings' 
 t('.allow_trackbacks') 
 check_box 'article', 'allow_comments' 
 t('.allow_comments') 
 toggle_element('conversation', t('.ok')) 
 t('.published') 
 if @article.published 
 display_date_and_time(@article.published_at) 
 else 
 t('.now') 
 end 
 toggle_element('publish') 
 text_field 'article', 'published_at' 
 toggle_element('publish', t('.ok')) 
 t('.visibility') 
 @article.password.blank? ? t('.public') : t('.protected') 
 toggle_element('visibility') 
 t('.password') 
 text_field 'article', 'password', class: 'form-control' 
 toggle_element('visibility', t('.ok')) 
 t('.cancel') 
 submit_tag(t('.publish'), class: 'btn btn-success') 
 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

    end
  end

  def destroy
    destroy_a(Article)
  end

  def auto_complete_for_article_keywords
    @items = Tag.select(:display_name).order(:display_name).map(&:display_name)
    render json: @items
  end

  def autosave
    return false unless request.xhr?

    id = params[:article][:id] || params[:id]

    article_factory = Article::Factory.new(this_blog, current_user)
    @article = article_factory.get_or_build_from(id)

    get_fresh_or_existing_draft_for_article

    @article.attributes = params[:article].permit!

    @article.published = false
    @article.author = current_user
    @article.save_attachments!(params[:attachments])
    @article.state = 'draft' unless @article.state == 'withdrawn'
    @article.text_filter ||= current_user.default_text_filter

    if @article.title.blank?
      lastid = Article.order('id desc').first.id
      @article.title = 'Draft article ' + lastid.to_s
    end

    if @article.save
      flash[:success] = I18n.t('admin.content.autosave.success')
      @must_update_calendar = (params[:article][:published_at] and params[:article][:published_at].to_time.to_i < Time.now.to_time.to_i and @article.parent_id.nil?)
      respond_to do |format|
        format.js
      end
    end
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
 hidden_field_tag('article[id]', @article.id) 
 link_to('Preview', {:controller => '/articles', :action => 'preview', :id => @article.id}, {:target => 'new', :class => 'btn btn-default'}); 
 if @article.state.to_s.downcase == "draft" 
 Time.now() 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  protected

  def get_fresh_or_existing_draft_for_article
    if @article.published && @article.id
      parent_id = @article.id
      @article =
        this_blog.articles.drafts.child_of(parent_id).first || this_blog.articles.build
      @article.allow_comments = this_blog.default_allow_comments
      @article.allow_pings = this_blog.default_allow_pings
      @article.parent_id = parent_id
    end
  end

  attr_accessor :resources, :resource

  private

  def load_resources
    @post_types = PostType.all
    @images = Resource.images_by_created_at.page(params[:page]).per(10)
    @resources = Resource.without_images_by_filename
    @macros = TextFilter.macro_filters
  end

  def access_granted?(article_id)
    article = Article.find(article_id)
    if article.access_by? current_user
      return true
    else
      flash[:error] = I18n.t('admin.content.access_granted.error')
      redirect_to action: 'index'
      return false
    end
  end

  def update_article_attributes
    @article.attributes = update_params
    @article.published_at = parse_date_time params[:article][:published_at]
    @article.author = current_user
    @article.save_attachments!(params[:attachments])
    @article.state = 'draft' if @article.draft
    @article.text_filter ||= current_user.default_text_filter
  end

  def update_params
    params.require(:article).except(:id).permit!
  end

  def get_layout
    case action_name
    when 'new', 'edit', 'create'
      'editor'
    when 'show', 'autosave'
      nil
    else
      'administration'
    end
  end
end
