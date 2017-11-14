class TagsController < BaseController
  before_action :login_required, :only => [:manage, :edit, :update, :destroy]
  before_action :admin_required, :only => [:manage, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, :only => [:auto_complete_for_tag_name]

  caches_action :show, :cache_path => Proc.new { |controller| controller.send(:tag_url, controller.params[:id]) }, :if => Proc.new{|c| c.cache_action? }
  def cache_action?
    !logged_in? && params[:type].blank?
  end

  def auto_complete_for_tag_name
    @tag_names = ActsAsTaggableOn::Tag.pluck(:name)
    respond_to do |format|
      format.json {render :inline => @tag_names.to_json}
    end
  end

  def index
    @tags = popular_tags(100).to_a

    @user_tags = popular_tags(75, 'User').to_a

    @post_tags = popular_tags(75, 'Post').to_a

    @photo_tags = popular_tags(75, 'Photo').to_a

    @clipping_tags = popular_tags(75, 'Clipping').to_a
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
  
  @page_title= :browse_content_by_tags.l 
 widget do 
 :what_are_tags.l 
 :tags_are_one_word_descriptors_users_assign_to_blog_posts_pictures_and_clippings_on.l+" #{configatron.community_name}." 
 :bigger_font_size_more_popular_tag.l 
 end 
 widget do 
 :search.l 
 bootstrap_form_tag :url => search_tags_path, :method => 'get', :class => 'form' do 
 text_field_tag 'id', params[:id], :autocomplete => "off", :placeholder => 'search tags' 
  
 submit_tag :go.l, :class => 'btn btn-primary' 
 end 
 end 
 tag_cloud @tags, %w(css1 css2 css3 css4 css5) do |tag, css_class| 
 link_to tag.name, tag_url(tag.to_param), :class => css_class 
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
 
 tag_auto_complete_field 'id', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end

  end

  def manage
    @search = ActsAsTaggableOn::Tag.search(params[:q])
    @tags = @search.result
    @tags = @tags.order('name ASC').distinct.page(params[:page]).per(100)
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
  
  @page_title=:tags.l 
  widget do 
 :admin.l 
 link_to_unless_current :features.l, homepage_features_path 
 link_to_unless_current :categories.l, categories_path 
 link_to_unless_current :metro_areas.l, metro_areas_path 
 link_to_unless_current :events.l, admin_events_path 
 link_to_unless_current :statistics.l, statistics_path 
 link_to_unless_current :ads.l, ads_path 
 link_to_unless_current :comments.l, admin_comments_path 
 link_to_unless_current :tags.l, admin_tags_path 
 link_to_unless_current :admin_pages.l, admin_pages_path 
 link_to_unless_current :members.l, admin_users_path 
 if @admin_nav_links.any? 
 @admin_nav_links.each do |link| 
 link_to link[:name], link[:url] 
 end 
 end 
 link_to :cache_clear_link.l, admin_clear_cache_path, data: { confirm: :are_you_sure.l } 
 end 
 
 box do 
 :search.l 
 bootstrap_form_for @search, :url => admin_tags_path, :layout => :horizontal do |f| 
 f.text_field :name_start, :label => :name.l 
 f.form_group :submit_group do 
 f.primary :search.l 
 end 
 end 
 end 
 sort_link @search, :name, :name.l 
 sort_link @search, :taggings_count, :taggings.l 
 :actions.l 
 for tag in @tags 
 tag.name 
 tag.taggings.count 
 link_to :show.l, tag_path(tag), :class => 'btn btn-default' 
 link_to :edit.l, edit_tag_path(tag), :class => 'btn btn-warning' 
 link_to :destroy.l, tag_path(tag), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 paginate @tags, :theme => 'bootstrap' 
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


  def edit
    @tag = ActsAsTaggableOn::Tag.find_by_name(URI::decode(params[:id]))
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
  
  @page_title=:editing_tag.l 
  widget do 
 :admin.l 
 link_to_unless_current :features.l, homepage_features_path 
 link_to_unless_current :categories.l, categories_path 
 link_to_unless_current :metro_areas.l, metro_areas_path 
 link_to_unless_current :events.l, admin_events_path 
 link_to_unless_current :statistics.l, statistics_path 
 link_to_unless_current :ads.l, ads_path 
 link_to_unless_current :comments.l, admin_comments_path 
 link_to_unless_current :tags.l, admin_tags_path 
 link_to_unless_current :admin_pages.l, admin_pages_path 
 link_to_unless_current :members.l, admin_users_path 
 if @admin_nav_links.any? 
 @admin_nav_links.each do |link| 
 link_to link[:name], link[:url] 
 end 
 end 
 link_to :cache_clear_link.l, admin_clear_cache_path, data: { confirm: :are_you_sure.l } 
 end 
 
 link_to :back.l, admin_tags_path, :class => 'btn btn-default' 
 link_to :show.l, tag_path(@tag), :class => 'btn btn-primary' 
 link_to :delete.l, tag_path(@tag), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 bootstrap_form_for :tag, :url => tag_path(@tag), :layout => :horizontal, :html => {:method => 'put'} do |f| 
 f.text_field :name 
 f.form_group :submit_group do 
 f.primary :update.l 
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

  def update
    @tag = ActsAsTaggableOn::Tag.find_by_name(URI::decode(params[:id]))
    
    respond_to do |format|
      if @tag.update_attributes(params[:tag].permit(:name))
        flash[:notice] = :tag_was_successfully_updated.l
        format.html { redirect_to admin_tags_url }
        format.xml  { render :nothing => true }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  
  @page_title=:editing_tag.l 
  widget do 
 :admin.l 
 link_to_unless_current :features.l, homepage_features_path 
 link_to_unless_current :categories.l, categories_path 
 link_to_unless_current :metro_areas.l, metro_areas_path 
 link_to_unless_current :events.l, admin_events_path 
 link_to_unless_current :statistics.l, statistics_path 
 link_to_unless_current :ads.l, ads_path 
 link_to_unless_current :comments.l, admin_comments_path 
 link_to_unless_current :tags.l, admin_tags_path 
 link_to_unless_current :admin_pages.l, admin_pages_path 
 link_to_unless_current :members.l, admin_users_path 
 if @admin_nav_links.any? 
 @admin_nav_links.each do |link| 
 link_to link[:name], link[:url] 
 end 
 end 
 link_to :cache_clear_link.l, admin_clear_cache_path, data: { confirm: :are_you_sure.l } 
 end 
 
 link_to :back.l, admin_tags_path, :class => 'btn btn-default' 
 link_to :show.l, tag_path(@tag), :class => 'btn btn-primary' 
 link_to :delete.l, tag_path(@tag), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 bootstrap_form_for :tag, :url => tag_path(@tag), :layout => :horizontal, :html => {:method => 'put'} do |f| 
 f.text_field :name 
 f.form_group :submit_group do 
 f.primary :update.l 
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
 }
        format.xml  { render :xml => @tag.errors.to_xml }
      end
    end
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.find_by_name(URI::decode(params[:id]))
    @tag.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = :tag_was_successfully_deleted.l
        redirect_to admin_tags_url
      }
      format.xml  { render :nothing => true }
    end
  end

  def show
    tag_array = ActsAsTaggableOn::TagList.from( URI::decode(params[:id]) )

    @tags = ActsAsTaggableOn::Tag.where('name IN (?)', tag_array)
    if @tags.nil? || @tags.empty?
      flash[:notice] = :tag_does_not_exists.l_with_args(:tag => tag_array)
      redirect_to :action => :index and return
    end
    @related_tags = @tags.first.related_tags
    @tags_raw = @tags.collect { |t| t.name } .join(',')

    if params[:type]
      case params[:type]
        when 'Post', 'posts'
          @pages = @posts = Post.recent.tagged_with(tag_array).page(params[:page]).per(20)
          @photos, @users, @clippings = [], [], []
        when 'Photo', 'photos'
          @pages = @photos = Photo.recent.tagged_with(tag_array).page(params[:page]).per(30)
          @posts, @users, @clippings = [], [], []
        when 'User', 'users'
          @pages = @users = User.recent.tagged_with(tag_array).page(params[:page]).per(30)
          @posts, @photos, @clippings = [], [], []
        when 'Clipping', 'clippings'
          @pages = @clippings = Clipping.recent.tagged_with(tag_array).page(params[:page]).per(10)
          @posts, @photos, @users = [], [], []
      else
        @clippings, @posts, @photos, @users = [], [], [], []
      end
    else
      @posts      = Post.recent.limit(5).tagged_with(tag_array)
      @photos     = Photo.recent.limit(10).tagged_with(tag_array)
      @users      = User.recent.limit(10).tagged_with(tag_array)
      @clippings  = Clipping.recent.limit(10).tagged_with(tag_array)
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
  
  widget do 
 if params[:type] 
 (params[:type].downcase.pluralize + '_tagged').l 
 else 
 :items_tagged.l 
 end 
 @tags.each do |tag| 
 link_to h(tag.name), tag_path(tag) 
 end 
 end 
 if @related_tags.to_a.size > 0 
 widget do 
 :related_tags.l 
 tag_cloud @related_tags, %w(css1 css2 css3 css4 css5) do |tag, css_class| 
 link_to h(tag.name), tag_path(tag), :class => css_class 
 end 
 link_to fa_icon('plus-circle', :text => :all_tags.l), tags_path 
 end 
 end 
 if @posts.any? 
 unless params[:type] 
 :posts.l 
 @posts.each do |post| 
 link_to( truncate(post.display_title, :length => 75), user_post_path(post.user, post), :title => :by.l(:login => post.user.login) ) 
 truncate_words(post.post, 35, '...' ) 
 end 
 link_to fa_icon('plus-circle', :text => :all_posts_tagged.l(:tag_name => @tags_raw)), show_tag_type_path(:id => @tags_raw, :type => 'Post') unless params[:type] 
 else 
  
 end 
 end 
 if @photos.any? 
 :photos.l(:count => @photos.size) 
 @photos.each do |photo| 
 link_to image_tag(photo.photo.url(:medium), :title => "#{photo.description} ("+:uploaded_by.l+" #{photo.user.login})"), user_photo_path(photo.user, photo), :class => "thumbnail" 
 end 
 link_to fa_icon('plus-circle', :text => :all_photos_tagged.l(:tag_name => @tags_raw)), show_tag_type_path(:id => @tags_raw, :type => 'Photo') unless params[:type] 
 end 
 if @users.any? 
 t('tags.show.users') 
 @users.each do |user| 
 link_to image_tag(user.avatar_photo_url(:medium)), user_path(user), :title => user.login, :class => "thumbnail" 
 end 
 link_to fa_icon('plus-circle', :text => :all_users_tagged.l(:tag_name => @tags_raw)), show_tag_type_path(:id => @tags_raw, :type => 'User') unless params[:type] 
 end 
 unless @clippings.empty? 
 :clippings.l 
 @clippings.each do |clipping| 
  
 end 
 link_to fa_icon('plus-circle', :text => :all_clippings_tagged.l(:tag_name => @tags_raw)), show_tag_type_path(:id => @tags_raw, :type => 'Clipping') unless params[:type] 
 end 
 if @pages && !params[:type].eql?('Post') 
 paginate @pages, :theme => 'bootstrap' 
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

end
