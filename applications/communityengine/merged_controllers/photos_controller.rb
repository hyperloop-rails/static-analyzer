require 'pp'

class PhotosController < BaseController
  include Viewable
  before_action :login_required, :only => [:new, :edit, :update, :destroy, :create, :swfupload]
  before_action :find_user, :only => [:new, :edit, :index, :show]
  before_action :require_current_user, :only => [:new, :edit, :update, :destroy]

  skip_before_action :verify_authenticity_token, :only => [:create] #because the TinyMCE image uploader can't provide the auth token

  uses_tiny_mce do
    {:only => [:show], :options => configatron.simple_mce_options}
  end

  cache_sweeper :taggable_sweeper, :only => [:create, :update, :destroy]

  def recent
    @photos = Photo.recent.page(params[:page])
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
  
  @page_title=:recent_photos.l 
 @photos.each do |photo| 
 link_to image_tag(photo.photo.url(:medium)), user_photo_path(photo.user, photo), :class => 'thumbnail' 
 end 
 paginate @photos, :theme => 'bootstrap' 
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

  def index
    @user = User.find(params[:user_id])

    @photos = Photo.where(:user_id => @user.id).includes(:tags)
    if params[:tag_name]
      @photos = @photos.where('tags.name = ?', params[:tag_name])
    end

    @photos = @photos.recent.page(params[:page]).per(20)

    @tags = Photo.includes(:taggings).where(:user_id => @user.id).tag_counts(:limit => 20)

    @rss_title = "#{configatron.community_name}: #{@user.login}'s photos"
    @rss_url = user_photos_path(@user,:format => :rss)

    respond_to do |format|
      format.html
      format.rss {
        render_rss_feed_for(@photos,
           { :feed => {:title => @rss_title, :link => url_for(:controller => 'photos', :action => 'index', :user_id => @user) },
             :item => {:title => :name,
                       :description => Proc.new {|photo| description_for_rss(photo)},
                       :link => Proc.new {|photo| user_photo_url(photo.user, photo)},
                       :pub_date => :created_at} })

      }
      format.xml { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title=:users_photos.l(:user=>@user.login) 
  widget do 
 :author.l 
 link_to tag(:img, :src => user.avatar_photo_url(:medium), "alt"=>"#{user.login}", :class => "img-responsive"), user_path(user), :title => "#{user.login}'s"+ :profile.l 
 link_to user.login, user_path(user), :class => 'url' 
 if user.featured_writer? 
 :featured_writer.l 
 end 
 if user.description 
 truncate_words( user.description, 12, '...') 
 end 
 :member_since.l+" #{I18n.l(user.created_at, :format => :short_published_date)}" 
 if user.posts.count == 1 
 link_to :singular_posts.l(:count => user.posts.count), user_posts_path(user) 
 else 
 link_to :plural_posts.l(:count => user.posts.count), user_posts_path(user) 
 end 
 link_to fa_icon('rss', :text => :rss_feed.l), user_posts_path(user, :format => :rss) 
 end 
 
 if @tags.any? 
 widget do 
 :tags.l 
 @tags.each do |tag| 
 if (tag.name.eql?(params[:tag_name]) ) 
 user_photos_path(@user) 
 fa_icon "tag inverse", :text => tag.name 
 else 
 user_photos_path(:user_id => @user, :tag_name => tag.name) 
 fa_icon "tag inverse", :text => tag.name 
 end 
 end 
 end 
 end 
 @photos.each do |photo| 
 link_to image_tag(photo.photo.url(:medium)), user_photo_path(@user, photo), :class => 'thumbnail' 
 if @is_current_user 
 link_to :show.l, user_photo_path(@user, photo), :class => 'btn btn-xs btn-default' 
 link_to :edit.l, edit_user_photo_path(@user, photo), :class => 'btn btn-xs btn-warning' 
 link_to :delete.l, user_photo_path(@user, photo), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-xs btn-danger' 
 end 
 end 
 paginate @photos, :theme => 'bootstrap' 
 if @is_current_user 
 link_to :new_photo.l, new_user_photo_path(@user), :class => 'btn btn-success' 
 end 

end
}
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
  
  @page_title=:users_photos.l(:user=>@user.login) 
  widget do 
 :author.l 
 link_to tag(:img, :src => user.avatar_photo_url(:medium), "alt"=>"#{user.login}", :class => "img-responsive"), user_path(user), :title => "#{user.login}'s"+ :profile.l 
 link_to user.login, user_path(user), :class => 'url' 
 if user.featured_writer? 
 :featured_writer.l 
 end 
 if user.description 
 truncate_words( user.description, 12, '...') 
 end 
 :member_since.l+" #{I18n.l(user.created_at, :format => :short_published_date)}" 
 if user.posts.count == 1 
 link_to :singular_posts.l(:count => user.posts.count), user_posts_path(user) 
 else 
 link_to :plural_posts.l(:count => user.posts.count), user_posts_path(user) 
 end 
 link_to fa_icon('rss', :text => :rss_feed.l), user_posts_path(user, :format => :rss) 
 end 
 
 if @tags.any? 
 widget do 
 :tags.l 
 @tags.each do |tag| 
 if (tag.name.eql?(params[:tag_name]) ) 
 user_photos_path(@user) 
 fa_icon "tag inverse", :text => tag.name 
 else 
 user_photos_path(:user_id => @user, :tag_name => tag.name) 
 fa_icon "tag inverse", :text => tag.name 
 end 
 end 
 end 
 end 
 @photos.each do |photo| 
 link_to image_tag(photo.photo.url(:medium)), user_photo_path(@user, photo), :class => 'thumbnail' 
 if @is_current_user 
 link_to :show.l, user_photo_path(@user, photo), :class => 'btn btn-xs btn-default' 
 link_to :edit.l, edit_user_photo_path(@user, photo), :class => 'btn btn-xs btn-warning' 
 link_to :delete.l, user_photo_path(@user, photo), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-xs btn-danger' 
 end 
 end 
 paginate @photos, :theme => 'bootstrap' 
 if @is_current_user 
 link_to :new_photo.l, new_user_photo_path(@user), :class => 'btn btn-success' 
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

  def manage_photos
    if logged_in?
      @user = current_user
      @photos = current_user.photos.recent.includes(:tags)
      if params[:tag_name]
        @photos = @photos.where('tags.name = ?', params[:tag_name])
      end
      @selected = params[:photo_id]
      @photos = @photos.page(params[:page]).per(10)
    end
    respond_to do |format|
      format.js
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
  
   
 paginate @photos, :per_page => 20 
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

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = @user.photos.find(params[:id])
    update_view_count(@photo) if current_user && current_user.id != @photo.user_id

    @is_current_user = @user.eql?(current_user)
    @comment = Comment.new

    @previous = @photo.previous_photo
    @next = @photo.next_photo
    @related = Photo.find_related_to(@photo)

    respond_to do |format|
      format.html # show.rhtml
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
  
  @page_title = @photo.display_name 
 if @related.any? 
 widget do 
 :related_photos_all_members.l 
 @related.each do |photo| 
 link_to image_tag( photo.photo.url(:thumb), :class => "thumbnail"), user_photo_path(photo.user, photo), {:title => :photo_from_user.l_with_args(:photo_description => h(photo.description), :user => photo.user.login)} 
 end 
 end 
 end 
 if @is_current_user 
 widget do 
 link_to :make_this_my_profile_photo.l, change_profile_photo_user_path(@user, :photo_id => @photo), :method => :patch 
 end 
 link_to :back.l, user_photos_path(@user), :class => 'btn btn-default' 
 link_to :edit.l, edit_user_photo_path(@user, @photo), :class => 'btn btn-warning' 
 link_to :delete.l, user_photo_path(@user, @photo), :method => :delete, data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 end 
  widget do 
 :author.l 
 link_to tag(:img, :src => user.avatar_photo_url(:medium), "alt"=>"#{user.login}", :class => "img-responsive"), user_path(user), :title => "#{user.login}'s"+ :profile.l 
 link_to user.login, user_path(user), :class => 'url' 
 if user.featured_writer? 
 :featured_writer.l 
 end 
 if user.description 
 truncate_words( user.description, 12, '...') 
 end 
 :member_since.l+" #{I18n.l(user.created_at, :format => :short_published_date)}" 
 if user.posts.count == 1 
 link_to :singular_posts.l(:count => user.posts.count), user_posts_path(user) 
 else 
 link_to :plural_posts.l(:count => user.posts.count), user_posts_path(user) 
 end 
 link_to fa_icon('rss', :text => :rss_feed.l), user_posts_path(user, :format => :rss) 
 end 
 
 if @photo.album 
 "#{:album.l}: #{link_to @photo.album.title, user_album_path(@user, @photo.album)}".html_safe 
 link_to "<img src='#{@photo.previous_in_album.photo.url(:thumb)}' class='thumbnail' /><br />&laquo; ".html_safe + :previous.l, user_photo_path(@user, @photo.previous_in_album) if @photo.previous_in_album 
 link_to "<img src='#{@photo.next_in_album.photo.url(:thumb)}' class='thumbnail' /><br />".html_safe + :next.l + "&raquo;".html_safe, user_photo_path(@user, @photo.next_in_album) if @photo.next_in_album 
 elsif @previous || @next 
 link_to "<img src='#{@previous.photo.url(:thumb)}' class='thumbnail' /><br />&laquo; ".html_safe + :previous.l, user_photo_path(@user, @previous) if @previous 
 link_to "<img src='#{@next.photo.url(:thumb)}' class='thumbnail' /><br />".html_safe + :next.l + "&raquo;".html_safe, user_photo_path(@user, @next) if @next 
 end 
 image_tag @photo.photo(:large), :class => "thumbnail" 
 h @photo.description 
 for tag in @photo.tags 
 user_photos_path(@photo.user, :tag_name => tag.name) 
 fa_icon "tag inverse", :text => tag.name 
 end 
 box :id => 'comments' do 
 :photo_comments.l 
 :add_your_comment.l 
  if logged_in? || configatron.allow_anonymous_commenting 
 bootstrap_form_for(:comment, :url => commentable_comments_path(commentable.class.to_s.tableize, commentable), :remote => true, :layout => :horizontal, :html => {:id => 'comment'}) do |f| 
 f.text_area :comment, :rows => 5, :style => 'width: 99%', :class => "rich_text_editor", :help => :comment_character_limit.l 
 if !logged_in? && configatron.recaptcha_pub_key && configatron.recaptcha_priv_key 
 f.text_field :author_name 
 f.text_field :author_email, :required => true 
 f.form_group do 
 f.check_box :notify_by_email, :label => :notify_me_of_follow_ups_via_email.l 
 if commentable.respond_to?(:send_comment_notifications?) && !commentable.send_comment_notifications? 
 :comment_notifications_off.l 
 end 
 end 
 f.text_field :author_url, :label => :comment_web_site_label.l 
 f.form_group do 
 recaptcha_tags :ajax => true 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :add_comment.l, data: { disable_with: "Please wait..." } 
 end 
 end 
 else 
 link_to :log_in_to_leave_a_comment.l, new_commentable_comment_path(commentable.class, commentable.id), :class => 'btn btn-primary' 
 link_to :create_an_account.l, signup_path, :class => 'btn btn-primary' 
 end 
 
  comment.id 
 if comment.pending? 
 end 
 if comment.user 
 link_to image_tag(comment.user.avatar_photo_url(:medium), :alt => comment.user.login, :class => "img-responsive"), user_path(comment.user), :rel => 'bookmark', :title => :users_profile.l(:user => comment.user.login), :class => 'list-group-item' 
 user_path(comment.user) 
 fa_icon "hand-o-right fw", :text => comment.user.login 
 commentable_url(comment) 
 fa_icon "calendar" 
 comment.created_at 
 I18n.l(comment.created_at, :format => :short_literal_date) 
 if logged_in? && (current_user.admin? || current_user.moderator?) 
 link_to fa_icon("pencil-square-o fw", :text => :edit.l), edit_commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :class => 'edit-via-ajax list-group-item' 
 end 
 if ( comment.can_be_deleted_by(current_user) ) 
 link_to fa_icon("trash-o fw", :text => :delete.l), commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, 'data-confirm' => :are_you_sure_you_want_to_permanently_delete_this_comment.l, :remote => true, :class => "list-group-item" 
 end 
 comment.comment.html_safe 
 else 
 image_tag(configatron.photo.missing_thumb, :height => '50', :width => '50', :class => "img-responsive") 
 if comment.author_url.blank? 
 h comment.username 
 else 
 link_to fa_icon('hand-o-right', :text => h(comment.username)), h(comment.author_url) 
 end 
 commentable_url(comment) 
 fa_icon "calendar fw" 
 comment.created_at 
 I18n.l(comment.created_at, :format => :short_literal_date) 
 if logged_in? && (current_user.admin? || current_user.moderator?) 
 link_to fa_icon("pencil-square-o fw", :text => :edit.l), edit_commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :class => 'edit-via-ajax list-group-item' 
 end 
 if ( comment.can_be_deleted_by(current_user) ) 
 link_to fa_icon("trash-o fw", :text => :delete.l), commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, 'data-confirm' => :are_you_sure_you_want_to_permanently_delete_this_comment.l, :remote => true, :class => "list-group-item" 
 end 
 comment.comment.html_safe 
 end 
 
 more_comments_links(@photo) 
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

  # GET /photos/new
  def new
    @user = User.find(params[:user_id])
    @photo = Photo.new
    if params[:inline]
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title=:new_photo.l 
 widget do 
 :tips.l 
 :photo_tip_1.l 
 :photo_tip_2.l 
 end 
 link_to :back.l, user_photos_path(@user), :class => 'btn btn-default' 
  if @photo.new_record? 
 object = @photo 
 url = user_photos_path 
 else 
 object = [@user, @photo] 
 url = user_photo_path(@user, @photo) 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal  do |f| 
 if @photo.photo_file_name.blank? 
 f.file_field :photo 
 :megabyte_upload_limit.l(:count => configatron.photo.validation_options.max_size) 
 else 
 image_tag( @photo.photo.url(:large), :id => 'photo', :class => 'thumbnail' ) 
 end 
 f.text_field :tag_list, :autocomplete => "off", :label => :tags.l, :help => :optional_keywords_describing_this_photo_separated_by_commas.l 
 content_for :end_javascript do 
 tag_auto_complete_field 'photo_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 
 end 
 f.text_field :name 
 f.text_area :description, :rows => 5 
 unless params[:album_id] || current_user.albums.empty? 
 f.select(:album_id, current_user.albums.collect {|album| [album.title, album.id ] }, { :include_blank => true }) 
 end 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 

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
  
  @page_title=:new_photo.l 
 widget do 
 :tips.l 
 :photo_tip_1.l 
 :photo_tip_2.l 
 end 
 link_to :back.l, user_photos_path(@user), :class => 'btn btn-default' 
  if @photo.new_record? 
 object = @photo 
 url = user_photos_path 
 else 
 object = [@user, @photo] 
 url = user_photo_path(@user, @photo) 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal  do |f| 
 if @photo.photo_file_name.blank? 
 f.file_field :photo 
 :megabyte_upload_limit.l(:count => configatron.photo.validation_options.max_size) 
 else 
 image_tag( @photo.photo.url(:large), :id => 'photo', :class => 'thumbnail' ) 
 end 
 f.text_field :tag_list, :autocomplete => "off", :label => :tags.l, :help => :optional_keywords_describing_this_photo_separated_by_commas.l 
  
 f.text_field :name 
 f.text_area :description, :rows => 5 
 unless params[:album_id] || current_user.albums.empty? 
 f.select(:album_id, current_user.albums.collect {|album| [album.title, album.id ] }, { :include_blank => true }) 
 end 
 f.form_group :submit_group do 
 f.primary :save.l 
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
 
 tag_auto_complete_field 'photo_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end

  end

  # GET /photos/1;edit
  def edit
    @photo = Photo.find(params[:id])
    @user = @photo.user
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
  
  @page_title= :editing_photo.l 
 widget do 
 :help.l 
 :tags_are_keywords_you_use_to_organize_your_photos.l 
 end 
 link_to :back.l, user_photos_path(@user), :class => 'btn btn-default' 
 link_to :show.l, user_photo_path(@user, @photo), :class => 'btn btn-primary' 
 link_to :delete.l, user_photo_path(@user, @photo), :method => :delete, data: { confirm: :are_you_sure_you_want_to_delete_this_photo.l }, :class => 'btn btn-danger' 
  if @photo.new_record? 
 object = @photo 
 url = user_photos_path 
 else 
 object = [@user, @photo] 
 url = user_photo_path(@user, @photo) 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal  do |f| 
 if @photo.photo_file_name.blank? 
 f.file_field :photo 
 :megabyte_upload_limit.l(:count => configatron.photo.validation_options.max_size) 
 else 
 image_tag( @photo.photo.url(:large), :id => 'photo', :class => 'thumbnail' ) 
 end 
 f.text_field :tag_list, :autocomplete => "off", :label => :tags.l, :help => :optional_keywords_describing_this_photo_separated_by_commas.l 
  
 f.text_field :name 
 f.text_area :description, :rows => 5 
 unless params[:album_id] || current_user.albums.empty? 
 f.select(:album_id, current_user.albums.collect {|album| [album.title, album.id ] }, { :include_blank => true }) 
 end 
 f.form_group :submit_group do 
 f.primary :save.l 
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
 
 tag_auto_complete_field 'photo_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end

  end

  # POST /photos
  # POST /photos.xml
  def create
    @user = current_user
    @photo = Photo.new(photo_params)
    @photo.user = @user
    @photo.tag_list = params[:tag_list] || ''

    @photo.album_id = params[:album_id] || ''
    @photo.album_id = params[:album_selected] unless params[:album_selected].blank?


    respond_to do |format|
      if @photo.save
        flash[:notice] = :photo_was_successfully_created.l

        format.html {
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @photo.photo.url() 
 @photo.display_name 
 @photo.id 

end

        }
        format.js {
          # render create.js.erb
        }
      else
        format.html {
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @photo.photo.url() 
 @photo.display_name 
 @photo.id 

end

        }
        format.js {
          # render create.js.erb
          @alert = :sorry_there_was_an_error_uploading_the_photo.l
        }
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
  
  @photo.photo.url() 
 @photo.display_name 
 @photo.id 
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


  # patch /photos/1
  # patch /photos/1.xml
  def update
    @photo = Photo.find(params[:id])
    @user = @photo.user
    @photo.tag_list = params[:tag_list] || ''
    @photo.album_id = photo_params[:album_id]

    respond_to do |format|
      if @photo.update_attributes(photo_params)
        format.html { redirect_to user_photo_url(@photo.user, @photo) }
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
  
  @page_title= :editing_photo.l 
 widget do 
 :help.l 
 :tags_are_keywords_you_use_to_organize_your_photos.l 
 end 
 link_to :back.l, user_photos_path(@user), :class => 'btn btn-default' 
 link_to :show.l, user_photo_path(@user, @photo), :class => 'btn btn-primary' 
 link_to :delete.l, user_photo_path(@user, @photo), :method => :delete, data: { confirm: :are_you_sure_you_want_to_delete_this_photo.l }, :class => 'btn btn-danger' 
  if @photo.new_record? 
 object = @photo 
 url = user_photos_path 
 else 
 object = [@user, @photo] 
 url = user_photo_path(@user, @photo) 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal  do |f| 
 if @photo.photo_file_name.blank? 
 f.file_field :photo 
 :megabyte_upload_limit.l(:count => configatron.photo.validation_options.max_size) 
 else 
 image_tag( @photo.photo.url(:large), :id => 'photo', :class => 'thumbnail' ) 
 end 
 f.text_field :tag_list, :autocomplete => "off", :label => :tags.l, :help => :optional_keywords_describing_this_photo_separated_by_commas.l 
  
 f.text_field :name 
 f.text_area :description, :rows => 5 
 unless params[:album_id] || current_user.albums.empty? 
 f.select(:album_id, current_user.albums.collect {|album| [album.title, album.id ] }, { :include_blank => true }) 
 end 
 f.form_group :submit_group do 
 f.primary :save.l 
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
 
 tag_auto_complete_field 'photo_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end
 }
      end
    end
  end


  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @user = User.find(params[:user_id])
    @photo = Photo.find(params[:id])
    if @user.avatar.eql?(@photo)
      @user.avatar = nil
      @user.save!
    end
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to user_photos_url(@photo.user)   }
    end
  end


  protected

  def description_for_rss(photo)
    "<a href='#{user_photo_url(photo.user, photo)}' title='#{photo.name}'><img src='#{photo.photo.url(:large)}' alt='#{photo.name}' /><br />#{photo.description}</a>"
  end

  private

  def photo_params
    params[:photo].permit(:name, :description, :album_id, :photo)
  end

  def comment_params
    params[:comment].permit(:author_name, :author_email, :notify_by_email, :author_url, :comment)
  end
end
