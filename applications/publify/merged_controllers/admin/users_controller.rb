class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]
  cache_sweeper :blog_sweeper

  def index
    @users = User.order('login asc').page(params[:page]).per(this_blog.admin_display_elements)
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
 t(".users") 
 link_to(t(".new_user"), new_admin_user_path, id: 'dialog-link', class: 'btn btn-info pull-right') 
 end 
  
 t(".login") 
 t(".name") 
 t(".email") 
 t(".profile") 
 t(".articles") 
 t(".comments") 
 t(".state") 
 for user in @users 
 link_to user.login, author_path(id: user.login) 
 link_to(content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), edit_admin_user_path(user), class: 'btn btn-primary btn-xs btn-action' ) 
 link_to(content_tag(:span, '', class: 'glyphicon glyphicon-link'), author_path(id:user.login), class: 'btn btn-success btn-xs btn-action' ) 
 user.nickname 
 mail_to user.email, user.email 
 t("profile.#{user.profile.label}") 
 Article.where("user_id = #{user.id}").count 
 Comment.where("user_id = #{user.id}").count 
 t("user.status.#{user.state}") 
 end 
 display_pagination(@users, 7) 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def new
    @user = User.new
    @user.text_filter = TextFilter.find_by_name(this_blog.text_filter)
    setup_profiles
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
 t(".add_user") 
 end 
  
 form_for([:admin, @user]) do |f| 
  if user.errors.any? 
 pluralize(user.errors.count, "error") 
 user.errors.full_messages.each do |message| 
 message 
 end 
 end 
 t('.account_settings')
 t('.login')
 f.text_field :login, class: 'form-control' 
 t('.password')
 f.password_field :password, class: 'form-control' 
 t('.password_confirmation')
 f.password_field :password_confirmation, :class => 'form-control' 
 t('.email')
 f.text_field :email, class: 'form-control' 
 if controller.controller_name == 'users' 
 t('.profile')
 f.collection_select :profile_id, Profile.order('id').all, :id, :label, { include_blank: false }, class: 'form-control' 
 t('.user_status')
 User::STATUS.each do |state| 
 state 
 'selected' if user.state == state 
 t("user.status.#{state}") 
 end 
 end 
 t('.profile_settings')
 t('.firstname') 
 f.text_field :firstname, class: 'form-control' 
 t('.lastname') 
 f.text_field :lastname, class: 'form-control' 
 t('.nickname') 
 f.text_field :nickname, class: 'form-control' 
 unless user.login.nil? 
 t('.display_name') 
 options_for_select(user.display_names, user.name) 
 end 
 t('.article_filter') 
 options_for_select text_filter_options_with_id, user.text_filter.id 
 unless controller.controller_name == 'users'
 t('.avatar') 
 display_user_avatar(current_user, 'thumb') 
 t('.avatar_current') 
 t('.upload') 
 f.file_field :filename, class: 'input-file' 
 t('.upload_file') 
 end 
 t('.notification_settings') 
 t('.notifications') 
 f.check_box :notify_via_email 
 t('.notification_email') 
 f.check_box :notify_on_new_articles 
 t('.notification_article') 
 f.check_box :notify_on_comments 
 t('.notification_comment') 
 unless controller.controller_name == 'users' 
 t('.twitter') 
 unless twitter_available?(this_blog, current_user) 
  t(".how_to_setup_twitter_html", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 
 end 
 t('.twitter_account')
 f.text_field :twitter_account, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth')
 f.text_field :twitter_oauth_token, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth_secret')
 f.text_field :twitter_oauth_token_secret, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.contact_settings')
 t('.contact_explain_html', link: link_to(t('.author_page'), author_path(id: current_user.login))) 
 t('.about')
 f.text_area :description, {class: 'form-control', rows: 5} 
 t('.website')
 f.text_field :url, class: 'form-control' 
 t('.msn')
 f.text_field :msn, class: 'form-control' 
 t('.yahoo')
 f.text_field :yahoo, class: 'form-control' 
 t('.jabber')
 f.text_field :jabber, class: 'form-control' 
 t('.aim')
 f.text_field :aim, class: 'form-control' 
 t('.twitter')
 f.text_field :twitter, class: 'form-control' 
 end 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".save"), class: 'btn btn-success') 
 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def edit
    @user = params[:id] ? User.find_by_id(params[:id]) : current_user
    setup_profiles
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
 t(".edit_user") 
 end 
  
 form_for([:admin, @user]) do |f| 
  if user.errors.any? 
 pluralize(user.errors.count, "error") 
 user.errors.full_messages.each do |message| 
 message 
 end 
 end 
 t('.account_settings')
 t('.login')
 f.text_field :login, class: 'form-control' 
 t('.password')
 f.password_field :password, class: 'form-control' 
 t('.password_confirmation')
 f.password_field :password_confirmation, :class => 'form-control' 
 t('.email')
 f.text_field :email, class: 'form-control' 
 if controller.controller_name == 'users' 
 t('.profile')
 f.collection_select :profile_id, Profile.order('id').all, :id, :label, { include_blank: false }, class: 'form-control' 
 t('.user_status')
 User::STATUS.each do |state| 
 state 
 'selected' if user.state == state 
 t("user.status.#{state}") 
 end 
 end 
 t('.profile_settings')
 t('.firstname') 
 f.text_field :firstname, class: 'form-control' 
 t('.lastname') 
 f.text_field :lastname, class: 'form-control' 
 t('.nickname') 
 f.text_field :nickname, class: 'form-control' 
 unless user.login.nil? 
 t('.display_name') 
 options_for_select(user.display_names, user.name) 
 end 
 t('.article_filter') 
 options_for_select text_filter_options_with_id, user.text_filter.id 
 unless controller.controller_name == 'users'
 t('.avatar') 
 display_user_avatar(current_user, 'thumb') 
 t('.avatar_current') 
 t('.upload') 
 f.file_field :filename, class: 'input-file' 
 t('.upload_file') 
 end 
 t('.notification_settings') 
 t('.notifications') 
 f.check_box :notify_via_email 
 t('.notification_email') 
 f.check_box :notify_on_new_articles 
 t('.notification_article') 
 f.check_box :notify_on_comments 
 t('.notification_comment') 
 unless controller.controller_name == 'users' 
 t('.twitter') 
 unless twitter_available?(this_blog, current_user) 
  t(".how_to_setup_twitter_html", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 
 end 
 t('.twitter_account')
 f.text_field :twitter_account, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth')
 f.text_field :twitter_oauth_token, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth_secret')
 f.text_field :twitter_oauth_token_secret, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.contact_settings')
 t('.contact_explain_html', link: link_to(t('.author_page'), author_path(id: current_user.login))) 
 t('.about')
 f.text_area :description, {class: 'form-control', rows: 5} 
 t('.website')
 f.text_field :url, class: 'form-control' 
 t('.msn')
 f.text_field :msn, class: 'form-control' 
 t('.yahoo')
 f.text_field :yahoo, class: 'form-control' 
 t('.jabber')
 f.text_field :jabber, class: 'form-control' 
 t('.aim')
 f.text_field :aim, class: 'form-control' 
 t('.twitter')
 f.text_field :twitter, class: 'form-control' 
 end 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".save"), class: 'btn btn-success') 
 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def create
    @user = User.new(user_params)
    @user.name = @user.login
    if @user.save
      redirect_to admin_users_url, notice: I18n.t('admin.users.new.success')
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
 t(".add_user") 
 end 
  
 form_for([:admin, @user]) do |f| 
  if user.errors.any? 
 pluralize(user.errors.count, "error") 
 user.errors.full_messages.each do |message| 
 message 
 end 
 end 
 t('.account_settings')
 t('.login')
 f.text_field :login, class: 'form-control' 
 t('.password')
 f.password_field :password, class: 'form-control' 
 t('.password_confirmation')
 f.password_field :password_confirmation, :class => 'form-control' 
 t('.email')
 f.text_field :email, class: 'form-control' 
 if controller.controller_name == 'users' 
 t('.profile')
 f.collection_select :profile_id, Profile.order('id').all, :id, :label, { include_blank: false }, class: 'form-control' 
 t('.user_status')
 User::STATUS.each do |state| 
 state 
 'selected' if user.state == state 
 t("user.status.#{state}") 
 end 
 end 
 t('.profile_settings')
 t('.firstname') 
 f.text_field :firstname, class: 'form-control' 
 t('.lastname') 
 f.text_field :lastname, class: 'form-control' 
 t('.nickname') 
 f.text_field :nickname, class: 'form-control' 
 unless user.login.nil? 
 t('.display_name') 
 options_for_select(user.display_names, user.name) 
 end 
 t('.article_filter') 
 options_for_select text_filter_options_with_id, user.text_filter.id 
 unless controller.controller_name == 'users'
 t('.avatar') 
 display_user_avatar(current_user, 'thumb') 
 t('.avatar_current') 
 t('.upload') 
 f.file_field :filename, class: 'input-file' 
 t('.upload_file') 
 end 
 t('.notification_settings') 
 t('.notifications') 
 f.check_box :notify_via_email 
 t('.notification_email') 
 f.check_box :notify_on_new_articles 
 t('.notification_article') 
 f.check_box :notify_on_comments 
 t('.notification_comment') 
 unless controller.controller_name == 'users' 
 t('.twitter') 
 unless twitter_available?(this_blog, current_user) 
  t(".how_to_setup_twitter_html", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 
 end 
 t('.twitter_account')
 f.text_field :twitter_account, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth')
 f.text_field :twitter_oauth_token, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth_secret')
 f.text_field :twitter_oauth_token_secret, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.contact_settings')
 t('.contact_explain_html', link: link_to(t('.author_page'), author_path(id: current_user.login))) 
 t('.about')
 f.text_area :description, {class: 'form-control', rows: 5} 
 t('.website')
 f.text_field :url, class: 'form-control' 
 t('.msn')
 f.text_field :msn, class: 'form-control' 
 t('.yahoo')
 f.text_field :yahoo, class: 'form-control' 
 t('.jabber')
 f.text_field :jabber, class: 'form-control' 
 t('.aim')
 f.text_field :aim, class: 'form-control' 
 t('.twitter')
 f.text_field :twitter, class: 'form-control' 
 end 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".save"), class: 'btn btn-success') 
 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_url, notice: 'User was successfully updated.'
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
 t(".edit_user") 
 end 
  
 form_for([:admin, @user]) do |f| 
  if user.errors.any? 
 pluralize(user.errors.count, "error") 
 user.errors.full_messages.each do |message| 
 message 
 end 
 end 
 t('.account_settings')
 t('.login')
 f.text_field :login, class: 'form-control' 
 t('.password')
 f.password_field :password, class: 'form-control' 
 t('.password_confirmation')
 f.password_field :password_confirmation, :class => 'form-control' 
 t('.email')
 f.text_field :email, class: 'form-control' 
 if controller.controller_name == 'users' 
 t('.profile')
 f.collection_select :profile_id, Profile.order('id').all, :id, :label, { include_blank: false }, class: 'form-control' 
 t('.user_status')
 User::STATUS.each do |state| 
 state 
 'selected' if user.state == state 
 t("user.status.#{state}") 
 end 
 end 
 t('.profile_settings')
 t('.firstname') 
 f.text_field :firstname, class: 'form-control' 
 t('.lastname') 
 f.text_field :lastname, class: 'form-control' 
 t('.nickname') 
 f.text_field :nickname, class: 'form-control' 
 unless user.login.nil? 
 t('.display_name') 
 options_for_select(user.display_names, user.name) 
 end 
 t('.article_filter') 
 options_for_select text_filter_options_with_id, user.text_filter.id 
 unless controller.controller_name == 'users'
 t('.avatar') 
 display_user_avatar(current_user, 'thumb') 
 t('.avatar_current') 
 t('.upload') 
 f.file_field :filename, class: 'input-file' 
 t('.upload_file') 
 end 
 t('.notification_settings') 
 t('.notifications') 
 f.check_box :notify_via_email 
 t('.notification_email') 
 f.check_box :notify_on_new_articles 
 t('.notification_article') 
 f.check_box :notify_on_comments 
 t('.notification_comment') 
 unless controller.controller_name == 'users' 
 t('.twitter') 
 unless twitter_available?(this_blog, current_user) 
  t(".how_to_setup_twitter_html", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 
 end 
 t('.twitter_account')
 f.text_field :twitter_account, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth')
 f.text_field :twitter_oauth_token, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth_secret')
 f.text_field :twitter_oauth_token_secret, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.contact_settings')
 t('.contact_explain_html', link: link_to(t('.author_page'), author_path(id: current_user.login))) 
 t('.about')
 f.text_area :description, {class: 'form-control', rows: 5} 
 t('.website')
 f.text_field :url, class: 'form-control' 
 t('.msn')
 f.text_field :msn, class: 'form-control' 
 t('.yahoo')
 f.text_field :yahoo, class: 'form-control' 
 t('.jabber')
 f.text_field :jabber, class: 'form-control' 
 t('.aim')
 f.text_field :aim, class: 'form-control' 
 t('.twitter')
 f.text_field :twitter, class: 'form-control' 
 end 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".save"), class: 'btn btn-success') 
 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

    end
  end

  def destroy
    @user.destroy if User.where('profile_id = ? and id != ?', Profile.find_by_label('admin'), @user.id).count > 1
    redirect_to admin_users_url
  end

  private

  def setup_profiles
    @profiles = Profile.order('id')
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation, :email, :firstname, :lastname, :nickname, :display_name, :notify_via_email, :notify_on_new_articles, :notify_on_comments, :profile_id, :text_filter_id, :state, :twitter_account, :twitter_oauth_token, :twitter_oauth_token_secret, :description, :url, :msn, :yahoo, :jabber, :aim, :twitter)
  end
end
