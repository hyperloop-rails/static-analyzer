require 'hpricot'
require 'open-uri'
require 'pp'

class BaseController < ApplicationController

  include MethodLogging
  include AuthenticatedSystem
  include LocalizedApplication
  include BaseHelper

  before_action :track_all!
  around_action :set_locale
  skip_before_action :verify_authenticity_token, :only => :footer_content
  before_action :initialize_header_tabs
  before_action :initialize_admin_tabs
  before_action :store_location, :except => :footer_content

  caches_action :site_index, :footer_content, :if => Proc.new{|c| c.cache_action? }

  def cache_action?
    !logged_in? && controller_name.eql?('base') && params[:format].blank?
  end

  def rss_site_index
    redirect_to :controller => 'base', :action => 'site_index', :format => 'rss'
  end

  def plaxo
    render :layout => false
  end

  def site_index
    @posts = Post.find_recent

    @rss_title = "#{configatron.community_name} "+:recent_posts.l
    @rss_url = rss_url
    respond_to do |format|
      format.html { get_additional_homepage_data }
      format.rss do
        render_rss_feed_for(@posts, { :feed => {:title => "#{configatron.community_name} "+:recent_posts.l, :link => recent_url},
                              :item => {:title => :title,
                                        :link =>  Proc.new {|post| user_post_url(post.user, post)},
                                         :description => :post,
                                         :pub_date => :published_at}
          })
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @page_title = configatron.community_name + ' ' + :home.l 
 @meta = { :description => configatron.meta_description, :keywords => configatron.meta_keywords, :robots => configatron.robots_meta_list_content } 
 unless logged_in? 
  jumbotron do 
 :get_started_banner.l :site=>configatron.community_name 
 link_to :sign_up.l, signup_path 
 end 
 
 end 
 box :class => "hfeed" do 
 :recent_posts.l 
  
 link_to fa_icon('plus-circle', :text => :see_all_recent_posts.l), recent_path 
 end 
  widget do 
 Category.all.each do |c| 
 link_to c.name, category_path(c) 
 end 
 link_to :whats_popular.l, popular_url, {:class => 'popular'} 
 Page.all.each do |page| 
 if (logged_in? || page.page_public) 
 link_to page.title, pages_path(page) 
 end 
 end 
 end 
 
 widget do 
 :whats_hot.l 
 @popular_posts.each do |post| 
  link_to truncate(post.title, :length => 75), user_post_path(post.user, post) 
 
 end 
 link_to fa_icon('plus-circle', :text => :see_all.l), popular_url 
 end 
 widget do 
 :featured_writer.l 
 @featured_writers.each do |user| 
  link_to image_tag(user.avatar_photo_url(:thumb), :alt => "#{user.login}"), user_path(user) 
 link_to user.login, user_path(user), :class => 'url' 
 if user.description 
 truncate_words( user.description, 10, '...') 
 end 
 
 end 
 end 
 widget do 
 :active_users.l 
 @active_users.each do |user| 
  link_to image_tag(user.avatar_photo_url(:thumb), :alt => "#{user.login}"), user_path(user) 
 link_to user.login, user_path(user), :class => 'url' 
 if user.description 
 truncate_words( user.description, 10, '...') 
 end 
 
 end 
 end 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

  end

  def footer_content
    get_recent_footer_content
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  :whats_fresh.l 
 @recent_activity.each do |activity| 
  
 end 
 link_to fa_icon('plus-circle', :text => :see_all_activity.l), activities_path 
 :tags.l 
 tag_cloud @popular_tags, %w(css1 css2 css3 css4 css5) do |tag, css_class| 
 link_to tag.name, tag_path(tag.to_param), :class => css_class 
 end 
 link_to fa_icon('plus-circle', :text => :all_tags.l), tags_path 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

  end

  def homepage_features
    @homepage_features = HomepageFeature.find_features
    @homepage_features.shift
    render :partial => 'homepage_feature', :collection => @homepage_features and return
  end

  def advertise
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @page_title = :advertise_on.l + " #{configatron.community_name}" 
 mail_to "#{configatron.support_email}" 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

  end

  protected
  def self.uses_tiny_mce(options = {}, &block)
    if block_given?
      options = block.call
    end

    new_configuration = TinyMCE::Rails.configuration.merge(options.delete(:options)).options
    new_configuration.stringify_keys!

    # Set instance vars in the current class
    p = Proc.new do |c|
      configuration = c.instance_variable_get(:@tiny_mce_configuration) || {}

      c.instance_variable_set(:@tiny_mce_configuration, configuration.merge(new_configuration))
      c.instance_variable_set(:@uses_tiny_mce, true)
    end

    before_action p, options
  end


  private
    def admin_required
      current_user && current_user.admin? ? true : access_denied
    end

    def admin_or_moderator_required
      current_user && (current_user.admin? || current_user.moderator?) ? true : access_denied
    end

    def find_user
      if @user = User.active.find(params[:user_id] || params[:id])
        @is_current_user = (@user && @user.eql?(current_user))
        unless logged_in? || @user.profile_public?
          flash[:error] = :private_user_profile_message.l
          access_denied
        else
          return @user
        end
      else
        flash[:error] = :please_log_in.l
        access_denied
      end
    end

    def require_current_user
      @user ||= User.find(params[:user_id] || params[:id] )
      unless admin? || (@user && (@user.eql?(current_user)))
        redirect_to :controller => 'sessions', :action => 'new' and return false
      end
      return @user
    end

    def popular_tags(limit = 20, type = nil)
      ActsAsTaggableOn::Tag.popular(limit, type)
    end


    def get_recent_footer_content
      @recent_clippings = Clipping.find_recent(:limit => 10)
      @recent_photos = Photo.find_recent(:limit => 10)
      @recent_comments = Comment.find_recent(:limit => 13)
      @popular_tags = popular_tags(30).to_a
      @recent_activity = User.recent_activity(:size => 15, :current => 1)

    end

    def get_additional_homepage_data
      @homepage_features = HomepageFeature.find_features
      @homepage_features_data = @homepage_features.collect {|f| [f.id, f.image.url(:large) ]  }

      @active_users = User.find_by_activity(:limit => 5, :require_avatar => false)
      @featured_writers = User.find_featured

      @featured_posts = Post.find_featured

      @topics = Topic.order("replied_at DESC").limit(5)

      @popular_posts = Post.find_popular(:limit => 10)
      @popular_polls = Poll.find_popular(:limit => 8)
    end

    def initialize_header_tabs
      puts "HERE I AM INITIALIZING HEADER TABS!"
      # This hook allows plugins or host apps to easily add tabs to the header by adding to the @header_tabs array
      # Usage: @header_tabs << {:name => "My tab", :url => my_tab_path, :section => 'my_tab_section' }
      @header_tabs = []
    end
    def initialize_admin_tabs
      puts "$$$$ $$$$ HERE I AM INITIALIZING ADMIN TABLS!"
      # This hook allows plugins or host apps to easily add tabs to the admin nav by adding to the @admin_nav_links array
      # Usage: @admin_nav_links << {:name => "My link", :url => my_link_path,  }
      @admin_nav_links = []
    end

end
