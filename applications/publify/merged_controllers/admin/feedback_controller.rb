class Admin::FeedbackController < Admin::BaseController
  cache_sweeper :blog_sweeper
  ONLY_DOMAIN = %w(unapproved presumed_ham presumed_spam ham spam).freeze

  def index
    scoped_feedback = this_blog.feedback

    if params[:only].present?
      @only_param = ONLY_DOMAIN.dup.delete(params[:only])
      scoped_feedback = scoped_feedback.send(@only_param) if @only_param
    end

    params.delete(:page) if params[:page].blank? || params[:page] == '0'

    @feedback = scoped_feedback.paginated(params[:page], this_blog.admin_display_elements)
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
 t(".feedback") 
 end 
  
  if flash 
 flash.each do |alert_level, message| 
 flash[:error] ? 'danger' : 'success'
 alert_level.to_s.downcase 
 message 
 end 
 end 
 
 form_tag({action: 'index'}, method: :get, class: 'form-inline') do 
 link_to(t(".all"), {controller: 'admin/feedback', action: :index}, {class: 'label label-default'}) 
 link_to(t(".unapproved_comments"), {controller: 'admin/feedback', action: :index, only: 'unapproved'}, {class: 'label label-info'}) 
 link_to(t(".presumed_ham"), {controller: 'admin/feedback', action: :index, only: 'presumed_ham'}, {class: 'label label-primary'}) 
 link_to(t(".ham"), {controller: 'admin/feedback', action: :index, only: 'ham'}, {class: 'label label-success'}) 
 link_to(t(".presumed_spam"), {controller: 'admin/feedback', action: :index, only: 'presumed_spam'}, {class: 'label label-warning'}) 
 link_to(t(".spam"), {controller: 'admin/feedback', action: :index, only: 'spam'}, {class: 'label label-danger'}) 
 end 
 form_tag({:action => 'bulkops'}, {class: 'form-inline'}) do 
 hidden_field_tag "page", params[:page]
  hidden_field_tag "confirmed", params[:confirmed] 
 hidden_field_tag "published", params[:published] 
 "bulkop_#{position}" 
 t(".mark_checked_items_as_ham") 
 "bulkop_#{position}" 
 t(".mark_checked_items_as_spam") 
 "bulkop_#{position}" 
 t(".delete_checked_items") 
 "bulkop_#{position}" 
 t(".delete_all_spam") 
 
 t(".select_all") 
 if @feedback.empty? 
 t(".no_feedback") 
 end 
 @feedback.each do |comment| 
  comment.id 
 comment.state.to_s.downcase 
 if comment.state.to_s.downcase == 'spam'
  avatar_tag(:email => comment.email, :url => comment.url, :size => 48, :class => 'img-circle') 
 t("admin.feedback.state.#{comment.state}") 
 link_to comment.article.title, :controller => 'feedback', :action => 'article', :id => comment.article_id 
 t('.by')
 mail_to h(comment.email), h(comment.author) 
 link_to "(#{h(comment.url)})".html_safe, comment.url unless comment.url.blank? 
 t('.created_on') 
 l(comment.created_at) 
 t(".this_comment_by_was_flagged_as_spam_html",
            author: comment.author,
            cancel_link: link_to(t('.cancel'), url: {action: 'change_state', id: comment.id, remote: true})) 
 toggle_element "feedback_#{comment.id}" 
 
 else 
  comment.id 
 avatar_tag(:email => comment.email, :url => comment.url, :size => 80, :class => 'img-circle') 
 comment_class comment.state.to_s.downcase 
 t("admin.feedback.state.#{comment.state}") 
 link_to comment.article.title, :controller => 'feedback', :action => 'article', :id => comment.article_id 
 t('.by')
 mail_to h(comment.email), h(comment.author) 
 link_to "(#{h(comment.url)})".html_safe, comment.url unless comment.url.blank? 
 t('.created_on') 
 l(comment.created_at) 
 comment.html(:all) 
 show_feedback_actions comment 
 
 end 
 
 end 
 display_pagination(@feedback, 5) 
 t(".select_all") 
  hidden_field_tag "confirmed", params[:confirmed] 
 hidden_field_tag "published", params[:published] 
 "bulkop_#{position}" 
 t(".mark_checked_items_as_ham") 
 "bulkop_#{position}" 
 t(".mark_checked_items_as_spam") 
 "bulkop_#{position}" 
 t(".delete_checked_items") 
 "bulkop_#{position}" 
 t(".delete_all_spam") 
 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def destroy
    @record = Feedback.find params[:id]

    unless @record.article.user_id == current_user.id
      return redirect_to admin_feedback_index_url unless current_user.admin?
    end

    begin
      @record.destroy
      flash[:success] = I18n.t('admin.feedback.destroy.success')
    rescue ActiveRecord::RecordNotFound
      flash[:error] = I18n.t('admin.feedback.destroy.error')
    end
    redirect_to action: 'article', id: @record.article.id
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user_id = current_user.id

    if request.post? && @comment.save
      # We should probably wave a spam filter over this, but for now, just mark it as published.
      @comment.mark_as_ham
      @comment.save!
      flash[:success] = I18n.t('admin.feedback.create.success')
    end
    redirect_to action: 'article', id: @article.id
  end

  def edit
    @comment = Comment.find(params[:id])
    @article = @comment.article
    unless @article.access_by? current_user
      redirect_to admin_feedback_index_url
      return
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
 t(".comments_for_html", article_link: link_to(h(@comment.article.title), controller: '/admin/content', action: 'edit', id: @comment.article.id).html_safe) 
 end 
  
 form_tag :action => "update", :id => @comment.id do 
 error_messages_for 'comment' 
 hidden_field_tag 'article_id', @article.id 
 t(".edit_a_comment") 
 t(".author") 
 text_field 'comment', 'author', :class => 'form-control' 
 t(".email") 
 text_field 'comment', 'email', :class => 'form-control' 
 t(".url") 
 text_field 'comment', 'url', :class => 'form-control' 
 t(".your_comment") 
 current_user.default_text_filter.name 
 text_area 'comment', 'body', { :rows => '10', :class => 'form-control'} 
 t(".action_or_other_html", first_action: link_to(t(".cancel"), {action: 'index'}), second_action: submit_tag(t(".save"), class: 'btn btn-primary')) 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def update
    comment = Comment.find(params[:id])
    unless comment.article.access_by? current_user
      redirect_to admin_feedback_index_url
      return
    end
    comment.attributes = comment_params
    if request.post? && comment.save
      flash[:success] = I18n.t('admin.feedback.update.success')
      redirect_to action: 'article', id: comment.article.id
    else
      redirect_to action: 'edit', id: comment.id
    end
  end

  def article
    @article = this_blog.articles.find(params[:id])
    @feedback = @article.comments.ham if params[:ham] && params[:spam].blank?
    @feedback = @article.comments.spam if params[:spam] && params[:ham].blank?
    @feedback ||= @article.comments
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
 t(".comments_for_html", title: @article.title) 
 end 
  
 form_tag({action: 'bulkops'}, {class: 'form-inline'}) do 
 hidden_field 'article_id', @article.id 
  hidden_field_tag "confirmed", params[:confirmed] 
 hidden_field_tag "published", params[:published] 
 "bulkop_#{position}" 
 t(".mark_checked_items_as_ham") 
 "bulkop_#{position}" 
 t(".mark_checked_items_as_spam") 
 "bulkop_#{position}" 
 t(".delete_checked_items") 
 "bulkop_#{position}" 
 t(".delete_all_spam") 
 
 t(".select_all") 
 if @feedback.empty? 
 t(".no_feedback") 
 end 
 @feedback.each do |comment| 
  comment.id 
 comment.state.to_s.downcase 
 if comment.state.to_s.downcase == 'spam'
  avatar_tag(:email => comment.email, :url => comment.url, :size => 48, :class => 'img-circle') 
 t("admin.feedback.state.#{comment.state}") 
 link_to comment.article.title, :controller => 'feedback', :action => 'article', :id => comment.article_id 
 t('.by')
 mail_to h(comment.email), h(comment.author) 
 link_to "(#{h(comment.url)})".html_safe, comment.url unless comment.url.blank? 
 t('.created_on') 
 l(comment.created_at) 
 t(".this_comment_by_was_flagged_as_spam_html",
            author: comment.author,
            cancel_link: link_to(t('.cancel'), url: {action: 'change_state', id: comment.id, remote: true})) 
 toggle_element "feedback_#{comment.id}" 
 
 else 
  comment.id 
 avatar_tag(:email => comment.email, :url => comment.url, :size => 80, :class => 'img-circle') 
 comment_class comment.state.to_s.downcase 
 t("admin.feedback.state.#{comment.state}") 
 link_to comment.article.title, :controller => 'feedback', :action => 'article', :id => comment.article_id 
 t('.by')
 mail_to h(comment.email), h(comment.author) 
 link_to "(#{h(comment.url)})".html_safe, comment.url unless comment.url.blank? 
 t('.created_on') 
 l(comment.created_at) 
 comment.html(:all) 
 show_feedback_actions comment 
 
 end 
 
 end 
 end 
 form_tag :action => "create" do 
 hidden_field_tag('article_id', @article.id) 
 t(".add_a_comment")
 t(".author")
 text_field 'comment', 'author', :class => 'form-control' 
 t(".email")
 text_field 'comment', 'email', :class => 'form-control' 
 t(".url") 
 text_field 'comment', 'url', :class => 'form-control' 
 t(".your_comment") 
 text_area 'comment', 'body', { :rows => '10', :class => 'form-control'} 
 t(".action_or_other_html", first_action: link_to(t(".cancel"), {action: 'index'}), second_action: submit_tag(t(".save"), class: 'btn btn-primary')) 
 end 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def change_state
    return unless request.xhr?

    @feedback = Feedback.find(params[:id])
    template = @feedback.change_state!

    respond_to do |format|
      if params[:context] != 'listing'
        @comments = Comment.last_published
        page.replace_html('commentList', partial: 'admin/dashboard/comment')
      elsif template == 'ham'
        format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 comment.id 
 avatar_tag(:email => comment.email, :url => comment.url, :size => 80, :class => 'img-circle') 
 comment_class comment.state.to_s.downcase 
 t("admin.feedback.state.#{comment.state}") 
 link_to comment.article.title, :controller => 'feedback', :action => 'article', :id => comment.article_id 
 t('.by')
 mail_to h(comment.email), h(comment.author) 
 link_to "(#{h(comment.url)})".html_safe, comment.url unless comment.url.blank? 
 t('.created_on') 
 l(comment.created_at) 
 comment.html(:all) 
 show_feedback_actions comment 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end
 }
      else
        format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 avatar_tag(:email => comment.email, :url => comment.url, :size => 48, :class => 'img-circle') 
 t("admin.feedback.state.#{comment.state}") 
 link_to comment.article.title, :controller => 'feedback', :action => 'article', :id => comment.article_id 
 t('.by')
 mail_to h(comment.email), h(comment.author) 
 link_to "(#{h(comment.url)})".html_safe, comment.url unless comment.url.blank? 
 t('.created_on') 
 l(comment.created_at) 
 t(".this_comment_by_was_flagged_as_spam_html",
            author: comment.author,
            cancel_link: link_to(t('.cancel'), url: {action: 'change_state', id: comment.id, remote: true})) 
 toggle_element "feedback_#{comment.id}" 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end
 }
      end
    end
  end

  def bulkops
    ids = (params[:feedback_check] || {}).keys.map(&:to_i)
    items = Feedback.find(ids)
    @unexpired = true

    bulkop = (params[:bulkop_top] || {}).empty? ? params[:bulkop_bottom] : params[:bulkop_top]

    case bulkop
    when 'Delete Checked Items'
      count = 0
      ids.each do |id|
        count += Feedback.delete(id)
      end
      flash[:success] = I18n.t('admin.feedback.bulkops.success_deleted', count: count)

      items.each do |i|
        i.invalidates_cache? or next
        flush_cache
        return
      end
    when 'Mark Checked Items as Ham'
      update_feedback(items, :mark_as_ham!)
      flash[:success] = I18n.t('admin.feedback.bulkops.success_mark_as_ham', count: ids.size)
    when 'Mark Checked Items as Spam'
      update_feedback(items, :mark_as_spam!)
      flash[:success] = I18n.t('admin.feedback.bulkops.success_mark_as_spam', count: ids.size)
    when 'Confirm Classification of Checked Items'
      update_feedback(items, :confirm_classification!)
      flash[:success] = I18n.t('admin.feedback.bulkops.success_classification', count: ids.size)
    when 'Delete all spam'
      if request.post?
        Feedback.delete_all(['state = ?', 'spam'])
        flash[:success] = I18n.t('admin.feedback.bulkops.success_deleted_spam')
      end
    else
      flash[:error] = I18n.t('admin.feedback.bulkops.error')
    end

    if params[:article_id]
      redirect_to action: 'article', id: params[:article_id], confirmed: params[:confirmed], published: params[:published]
    else
      redirect_to action: 'index', page: params[:page], search: params[:search], confirmed: params[:confirmed], published: params[:published]
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:author, :email, :url, :body)
  end

  def update_feedback(items, method)
    items.each do |value|
      value.send(method)
      @unexpired && value.invalidates_cache? or next
      flush_cache
    end
  end

  def flush_cache
    @unexpired = false
    PageCache.sweep_all
  end
end
