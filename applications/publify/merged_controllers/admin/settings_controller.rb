class Admin::SettingsController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index
    this_blog.base_url = blog_base_url if this_blog.base_url.blank?
    load_settings
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
 t(".general_settings") 
 end 
  
 form_tag :action => 'update' do 
 t(".your_blog")
 t(".blog_name") 
 text_field(:setting, :blog_name, {:class => 'form-control', :size => this_blog.blog_name.length }) 
 t(".blog_subtitle") 
 text_field(:setting, :blog_subtitle, {:class => 'form-control', :size => this_blog.blog_subtitle.length}) 
 t(".blog_url") 
 text_field(:setting, :base_url, {:size => this_blog.base_url.length, :class => 'form-control'}) 
 t(".language") 
 langs = Hash[Publify::Lang::LIST.map{|l| [t("langs.#{l}"), l]}]
 options_for_select(langs, this_blog.lang) 
 t(".users") 
 check_box(:setting, :allow_signup) 
 t(".allow_users_to_register")
 t(".explain_allow_users_to_register_html") 
 t(".source_email") 
 text_field(:setting, :email_from, { :class => 'form-control'}) 
 t(".email_address_used_to_notify") 
 t(".items_to_display_in_admin_lists") 
 text_field(:setting, :admin_display_elements, {:size => 4, :class => 'form-control'}) 
 hidden_field_tag 'from', 'index' 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".update_settings"), class: 'btn btn-success') 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def write
    load_settings
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
 t(".write") 
 end 
  
 form_tag action: 'update' do 
 t(".publish") 
 t(".trackbacks") 
 check_box(:setting, :send_outbound_pings) 
 t(".send_trackbacks") 
 t(".explain") 
 t(".urls_to_ping") 
 text_area(:setting, :ping_urls, :rows => 4, :class => 'form-control') 
 t(".latitude_longitude") 
 text_field(:setting, :geourl_location, { :class => 'form-control'}) 
 t(".display")
 t(".your_geoloc") 
 t(".example") 
 t(".media") 
 t(".image_thumbnail_size") 
 text_field(:setting, :image_thumb_size, { :class => 'form-control'}) 
 t(".image_medium_size") 
 text_field(:setting, :image_medium_size, { :class => 'form-control'}) 
 t(".avatar_size") 
 text_field(:setting, :image_avatar_size, { :class => 'form-control'}) 
 t(".publish_on_twitter") 
 unless twitter_available?(this_blog, current_user) 
  t(".how_to_setup_twitter_html", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 
 end 
 t(".twitter_consumer_key") 
 text_field(:setting, :twitter_consumer_key, { :class => 'form-control'}) 
 t(".twitter_consumer_secret") 
 text_field(:setting, :twitter_consumer_secret, { :class => 'form-control'}) 
 hidden_field_tag 'from', 'write' 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".update_settings"), class: 'btn btn-success') 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def feedback
    load_settings
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
 t(".feedback_settings") 
 end 
  
 form_tag action: 'update' do 
 t(".feedback")
 t(".comments") 
 check_box(:setting, :default_allow_comments) 
 t(".enable_comments_by_default") 
 t(".enable_feedback_moderation") 
 check_box(:setting, :default_moderate_comments) 
 t(".explain_feedback_moderation") 
 t(".trackbacks") 
 check_box(:setting, :default_allow_pings) 
 t(".enable_trackbacks_by_default") 
 check_box(:setting, :global_pings_disable) 
 t(".disable_trackbacks_sitewide") 
 t(".explain_disable_trackbacks") 
 t(".comments_filter") 
 options_for_select text_filter_options, TextFilter.find_by_name(this_blog.comment_text_filter) 
 t(".avatars_provider") 
 options_for_select plugin_options(:avatar).push([t(".none"),'']), this_blog.plugin_avatar 
 t(".spam") 
 t(".spam_protection") 
 t(".enable_spam_protection")
 check_box(:setting, :sp_global) 
 t(".explain_spam_protection") 
 t(".askimet_key") 
 text_field(:setting, :sp_akismet_key, {:class => 'form-control'}) 
 t(".explain_spamfiltering_html") 
 t(".disable_comments_after") 
 text_field(:setting, :sp_article_auto_close, {:size => 4, :class => 'form-control'}) 
 t(".days") 
 t(".set_to_0_to_never_disable_comments") 
 t(".max_links") 
 text_field(:setting, :sp_url_limit, {:size => 4, :class => 'form-control'}) 
 t(".explain_reject_comments")
 t(".set_to_0_to_never_reject_comments") 
 t(".captcha") 
 t(".enable_recaptcha") 
 check_box(:setting, :use_recaptcha) 
 t(".remember_to_set_your_recaptcha") 
 hidden_field_tag 'from', 'feedback' 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".update_settings"), class: 'btn btn-success') 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def display
    load_settings
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
 t('.display_settings') 
 end 
  
 form_tag :action => 'update' do 
 t('.publishing_options')
 t('.display') 
 text_field(:setting, :limit_article_display, {:size => 4, :class => 'form-control'}) 
 t('.default_article_show') 
 t('.display') 
 text_field(:setting, :limit_archives_display, {:size => 4, :class => 'form-control'}) 
 t('.default_archives_show') 
 t('.statuses') 
 check_box(:setting, :statuses_in_timeline) 
 t('.status_main_feed') 
 t('.date_format') 
 select(:setting, :date_format, {
          Time.now.strftime('%d/%m/%Y') => '%d/%m/%Y',
          Time.now.strftime('%m/%d/%Y') => '%m/%d/%Y',
          Time.now.strftime('%d %b %Y') => '%d %b %Y',
          Time.now.strftime('%d %B %Y') => '%d %B %Y',
          Time.now.strftime('%Y/%m/%d') => '%Y/%m/%d',
          distance_of_time_in_words(Time.now, Time.now - 2.days) => 'setting_date_format_distance_of_time_in_words'})
        
 t('.time_format') 
 select(:setting, :time_format, {
          Time.now.strftime('%Hh%M') => '%Hh%M',
          Time.now.strftime('%H:%M') => '%H:%M',
          Time.now.strftime('%I:%M%p') => '%I:%M%p'})
        
 t('.custom_url') 
 text_field(:setting, :custom_url_shortener, { :class => 'form-control'}) 
 t('.custom_url_help') 
 t('.feed_settings') 
 t('.display') 
 text_field(:setting, :limit_rss_display, {:size => 4, :class => 'form-control'}) 
 t('.default_feed_show') 
 t('.feed_articles') 
 check_box(:setting, :hide_extended_on_rss) 
 t('.feed_excerpts_only')
 t('.feedburner_id') 
 text_field(:setting, :feedburner_url, :class => 'form-control') 
 t('.feedburner_help') 
 hidden_field_tag 'from', 'display' 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".update_settings"), class: 'btn btn-success') 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def update
    load_settings
    if @setting.update_attributes(settings_params)
      flash[:success] = I18n.t('admin.settings.update.success')
      redirect_to action: action_param
    else
      flash[:error] = I18n.t('admin.settings.update.error',
                             messages: this_blog.errors.full_messages.join(', '))
      render action_param
    end
  end

  private

  VALID_ACTIONS = %w(index write feedback display).freeze

  def settings_params
    @settings_params ||= params.require(:setting).permit!
  end

  def action_param
    @action_param ||=
      begin
        value = params[:from]
        VALID_ACTIONS.include?(value) ? value : 'index'
      end
  end

  def load_settings
    @setting = this_blog
  end
end
