class Admin::NotesController < Admin::BaseController
  layout 'administration'
  cache_sweeper :blog_sweeper

  before_action :load_existing_notes, only: [:index, :edit]
  before_action :find_note, only: [:edit, :update, :show, :destroy]

  def index
    @note = new_note
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
 t(".notes") 
 end 
   
 
 form_for @note, url: admin_notes_path do |n| 
  n.hidden_field :text_filter, value: current_user.text_filter_name 
 n.text_area :body, {class: 'form-control', rows: '7', placeholder: t(".compose_new_note")} 
 t(".publish_settings") 
 unless twitter_available?(this_blog, current_user) 
  t(".how_to_setup_twitter_html", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 
 else 
 check_box_tag 'push_to_twitter', true, true 
 t(".posse_to_twitter")
 t(".in_reply_to") 
 n.text_field :in_reply_to_status_id, class: 'form-control', placeholder: t(".tweet_id_like") 
 end 
 t(".permanent_link") 
 n.text_field :permalink, class: 'form-control' 
 t(".publish_at") 
 n.text_field :published_at, {class: 'form-control datepicker', placeholder: t('.now')} 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".publish"), class: 'btn btn-success') 
 
 end 
  if @notes.empty? 
 t("admin.notes.form.no_notes") 
 end 
  h(note.body.strip_html.slice(0..140)) 
 link_to(content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), {action: 'edit', id: note.id}, {class: 'btn btn-primary btn-xs btn-action'}) 
 link_to(content_tag(:span, '', class: 'glyphicon glyphicon-trash'), admin_note_path(note), {class: 'btn btn-danger btn-xs btn-action'}) 
 link_to(content_tag(:span, '', class: 'glyphicon glyphicon-link'), note.short_url, {class: 'btn btn-success btn-xs btn-action'}) 
 author_link(note)
 l(note.published_at) 
 
 display_pagination(@notes, 3, 'first', 'last')
 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def show
    unless @note.access_by?(current_user)
      flash[:error] = I18n.t('admin.base.not_allowed')
      redirect_to admin_notes_url
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
 t('.destroy_confirmation') 
 end 
  
 t(".are_you_sure", note: @note)
 form_for @note, url: admin_note_path(@note), method: :delete do 
 t(".action_or_other_html", first_action: link_to(t(".cancel"), {action: 'index'}), second_action: submit_tag(t(".delete"), class: "btn btn-danger")) 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def edit
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
 t(".notes") 
 end 
   
 
 form_for @note, url: admin_note_path(@note) do |n| 
  n.hidden_field :text_filter, value: current_user.text_filter_name 
 n.text_area :body, {class: 'form-control', rows: '7', placeholder: t(".compose_new_note")} 
 t(".publish_settings") 
 unless twitter_available?(this_blog, current_user) 
  t(".how_to_setup_twitter_html", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 
 else 
 check_box_tag 'push_to_twitter', true, true 
 t(".posse_to_twitter")
 t(".in_reply_to") 
 n.text_field :in_reply_to_status_id, class: 'form-control', placeholder: t(".tweet_id_like") 
 end 
 t(".permanent_link") 
 n.text_field :permalink, class: 'form-control' 
 t(".publish_at") 
 n.text_field :published_at, {class: 'form-control datepicker', placeholder: t('.now')} 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".publish"), class: 'btn btn-success') 
 
 end 
  if @notes.empty? 
 t("admin.notes.form.no_notes") 
 end 
  h(note.body.strip_html.slice(0..140)) 
 link_to(content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), {action: 'edit', id: note.id}, {class: 'btn btn-primary btn-xs btn-action'}) 
 link_to(content_tag(:span, '', class: 'glyphicon glyphicon-trash'), admin_note_path(note), {class: 'btn btn-danger btn-xs btn-action'}) 
 link_to(content_tag(:span, '', class: 'glyphicon glyphicon-link'), note.short_url, {class: 'btn btn-success btn-xs btn-action'}) 
 author_link(note)
 l(note.published_at) 
 
 display_pagination(@notes, 3, 'first', 'last')
 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def create
    note = new_note

    note.published = true
    note.published_at = parse_date_time params[:note][:published_at]
    note.attributes = params[:note].permit!
    note.text_filter ||= current_user.default_text_filter
    note.published_at ||= Time.now
    if note.save
      if params[:push_to_twitter] && note.twitter_id.blank?
        unless note.send_to_twitter
          flash[:error] = I18n.t('errors.problem_sending_to_twitter')
          flash[:error] += " : #{note.errors.full_messages.join(' ')}"
        end
      end
      flash[:notice] = I18n.t('notice.note_successfully_created')
    else
      flash[:error] = note.errors.full_messages
    end
    redirect_to admin_notes_url
  end

  def update
    @note.attributes = params[:note].permit!
    @note.save
    redirect_to admin_notes_url
  end

  def destroy
    @note.destroy
    flash[:notice] = I18n.t('admin.base.successfully_deleted', name: 'note')
    redirect_to admin_notes_url
  end

  private

  def load_existing_notes
    @notes = Note.page(params[:page]).per(this_blog.limit_article_display)
  end

  def find_note
    @note = Note.find(params[:id])
  end

  def new_note
    this_blog.notes.build(author: current_user,
                          text_filter: current_user.text_filter)
  end
end
