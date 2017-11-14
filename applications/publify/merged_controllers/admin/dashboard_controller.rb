# coding: utf-8
class Admin::DashboardController < Admin::BaseController
  require 'open-uri'
  require 'time'
  require 'rexml/document'

  def index
    t = Time.new
    today = t.strftime('%Y-%m-%d 00:00')

    # Since last venue
    @newposts_count = Article.published_since(current_user.last_sign_in_at).count
    @newcomments_count = Feedback.published_since(current_user.last_sign_in_at).count

    # Today
    @statposts = Article.published.where('published_at > ?', today).count
    @statsdrafts = Article.drafts.where('created_at > ?', today).count
    @statspages = Page.where('published_at > ?', today).count
    @statuses = Note.where('published_at > ?', today).count
    @statuserposts = Article.published.where('published_at > ?', today).count(conditions: { user_id: current_user.id })
    @statcomments = Comment.where('created_at > ?', today).count
    @presumedspam = Comment.presumed_spam.where('created_at > ?', today).count
    @confirmed = Comment.ham.where('created_at > ?', today).count
    @unconfirmed = Comment.unconfirmed.where('created_at > ?', today).count

    @comments = Comment.last_published
    @drafts = Article.drafts.where('user_id = ?', current_user.id).limit(5)

    @statspam = Comment.spam.count
    @inbound_links = inbound_links
    @publify_links = publify_dev
    publify_version
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
 t(".welcome_back", user_name: current_user.name) 
 end 
  
 
    links = []
    links << link_to(t('.write_a_post'), controller: 'content', action: 'new') if can? :new, 'admin/content'
    links << link_to(t('.write_a_page'), controller: 'pages', action: 'new') if can? :new, 'admin/pages'
    links << link_to(t('.update_your_profile_or_change_your_password'), controller: 'profiles', action: 'index')
  
 t(".dashboard_explain_html", available_actions: safe_join(links, ', ')) 
 if can? :index, 'admin/themes' 
 t(".customization_explain_html", theme_link: link_to(t(".change_your_blog_presentation"), controller: 'themes'), sidebar_link: link_to(t(".enable_plugins"), controller: 'sidebar')) 
 end 
 t(".help_explain_html", doc_link: link_to(t('.read_our_documentation'), 'http://publify.co')) 
 
  t(".today") 
 t(".articles_and_comments_count_since", articles_count: @newposts_count, comments_count: @newcomments_count) 
 t(".running_publify", version: PUBLIFY_VERSION) 
 @version_message 
 if can? :index, 'admin/content' 
 t(".content") 
 link_to(t(".articles_count", count: @statposts), controller: 'admin/content') 
 link_to(t(".your_articles_count", count: @statuserposts), controller: 'admin/content', "search[user_id]" => current_user.id) 
 link_to(t(".drafts_count", count: @statsdrafts), controller: 'admin/content', "search[state]" => "drafts") 
 link_to(t(".pages_count", count: @statspages), controller: 'admin/pages') 
 link_to(t(".notes_count", count: @statuses), controller: 'admin/notes') 
 end 
 if can? :index, 'admin/feedback' 
 t(".feedback") 
 link_to(t('.comments_count', count: @statcomments), controller: 'admin/feedback') 
 link_to(t('.approved_count', count: @confirmed), controller: 'admin/feedback', only: 'ham') 
 link_to(t('.unconfirmed_count', count: @unconfirmed), controller: 'admin/feedback', only: 'unapproved') 
 link_to(t(".spam_count", count: @statspam), controller: 'admin/feedback', only: 'spam') 
 end 
 
  t(".latest_comments") 
  if @comments.size == 0 
 t(".no_comments_yet") 
 else 
 for comment in @comments 
 comment.id 
 avatar_tag(:email => comment.email, :url => comment.url, class: 'pull-left img-circle gravatar') 
 t(".by") 
 comment.url.blank? ? h(comment.author) : nofollowify_links(link_to(h(comment.author), comment.url)) 
 display_date_and_time comment.created_at 
 comment.html.strip_html.slice(0..300) 
 show_feedback_actions(comment, 'dashboard') 
 end 
 end 
 
 
  t(".your_drafts") 
 if @drafts.empty? 
 link_to t(".no_drafts_yet"), controller: 'content', action: 'new' 
 else 
 for post in @drafts 
 link_to(post.title, controller: "admin/content", action: "edit", id: post.id) 
 display_date_and_time(post.created_at) 
 post.body.strip_html.slice(0,300) if post.body 
 end 
 end 
 
  t(".inbound_links") 
 if @inbound_links.nil? 
 t('.you_have_no_internet_connection') 
 else 
 if @inbound_links.empty? 
 t(".no_one_made_link_to_you_yet") 
 else 
 for link in @inbound_links 
 link_date = link.date 
 sprintf("%s %s %s %s %s", link_to(link.author, link.link), t(".made_a_link_to_you_on"), link_date && link_date.strftime(this_blog.date_format) || t('.at_an_unknown_date'), link_date && t(".at") || '', link_date && link_date.strftime(this_blog.time_format)) || '' 
 link.description.strip_html.slice(0, 300) 
 end 
 end 
 end 
 
 link_to(this_blog.blog_name, this_blog.base_url) 
 t(".powered_by")
h PUBLIFY_VERSION 

end

  end

  def publify_version
    version = nil
    begin
      open(PUBLIFY_VERSION_URL) do |http|
        publify_version = http.read[0..5]
        version = publify_version.split('.')
      end
    rescue
      return
    end
    if version[0].to_i > TYPO_MAJOR.to_i
      flash[:error] = I18n.t('admin.dashboard.publify_version.error')
    elsif version[1].to_i > TYPO_SUB.to_i
      flash[:warning] = I18n.t('admin.dashboard.publify_version.warning')
    elsif version[2].to_i > TYPO_MINOR.to_i
      flash[:notice] = I18n.t('admin.dashboard.publify_version.notice')
    end
  end

  private

  def inbound_links
    host = URI.parse(this_blog.base_url).host
    return [] if Rails.env.development?
    url = "http://www.google.com/search?q=link:#{host}&tbm=blg&output=rss"
    parse(url).reverse.compact
  end

  def publify_dev
    url = 'http://blog.publify.co/articles.rss'
    parse(url)[0..2]
  end

  def parse(url)
    open(url) do |http|
      return parse_rss(http.read)
    end
  rescue
    []
  end

  RssItem = Struct.new(:link, :title, :description, :description_link, :date, :author) do
    def to_s
      title
    end
  end

  def parse_rss(body)
    xml = REXML::Document.new(body.force_encoding('ISO-8859-1').encode('UTF-8'))

    items = []

    REXML::XPath.each(xml, '//item/') do |elem|
      item = RssItem.new
      item.title = REXML::XPath.match(elem, 'title/text()').first.value rescue ''
      item.link = REXML::XPath.match(elem, 'link/text()').first.value rescue ''
      item.description = REXML::XPath.match(elem, 'description/text()').first.value rescue ''
      item.author = REXML::XPath.match(elem, 'dc:publisher/text()').first.value rescue ''
      item.date = Time.mktime(*ParseDate.parsedate(REXML::XPath.match(elem, 'dc:date/text()').first.value)) rescue Date.parse(REXML::XPath.match(elem, 'pubDate/text()').first.value) rescue Time.now

      item.description_link = item.description
      item.description.gsub!(/<\/?a\b.*?>/, '') # remove all <a> tags
      items << item
    end

    items
  end
end
