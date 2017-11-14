class Admin::MigrationsController < Admin::BaseController
  cache_sweeper :blog_sweeper
  skip_before_action :look_for_needed_db_updates

  def show
    @current_version = migrator.current_schema_version
    @needed_migrations = migrator.pending_migrations
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
 t(".database_migration") 
 end 
  
 t(".information") 
 t(".current_database_version") 
 @current_version 
 unless @needed_migrations.blank? 
 t(".migrations")
 t(".migration_pending", count: @needed_migrations.count) 
 t(".needed_migrations")
 for migration in @needed_migrations 
 migration.name 
 end 
 end 
 form_tag admin_migrations_path do 
 if @needed_migrations.blank? 
 t(".you_are_up_to_date")
 else 
 submit_tag(t(".update_database_now"), class: 'btn btn-success') 
 t(".may_take_a_moment")
 end 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def update
    migrator.migrate
    redirect_to admin_migrations_url
  end

  private

  def migrator
    @migrator ||= Migrator.new
  end
end
