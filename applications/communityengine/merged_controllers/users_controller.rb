class UsersController < BaseController
  include Viewable
  cache_sweeper :taggable_sweeper, :only => [:activate, :update, :destroy]

  uses_tiny_mce do
    {:only => [:new, :create, :update, :edit, :welcome_about], :options => configatron.default_mce_options}
  end

  uses_tiny_mce do
    {:only => [:show], :options => configatron.simple_mce_options}
  end

  before_action :login_required, :only => [:edit, :edit_account, :update, :welcome_photo, :welcome_about,
                                          :welcome_invite, :return_admin, :assume, :featured,
                                          :toggle_featured, :edit_pro_details, :update_pro_details, :dashboard, :deactivate,
                                          :crop_profile_photo, :upload_profile_photo]
  before_action :find_user, :only => [:edit, :edit_pro_details, :show, :update, :statistics, :deactivate,
                                      :crop_profile_photo, :upload_profile_photo ]
  before_action :require_current_user, :only => [:edit, :update, :update_account,
                                                :edit_pro_details, :update_pro_details,
                                                :welcome_photo, :welcome_about, :welcome_invite, :deactivate,
                                                :crop_profile_photo, :upload_profile_photo]
  before_action :admin_required, :only => [:assume, :destroy, :featured, :toggle_featured, :toggle_moderator]
  before_action :admin_or_current_user_required, :only => [:statistics]

  def activate
    redirect_to signup_path and return if params[:id].blank?
    @user = User.find_by_activation_code(params[:id])
    if @user and @user.activate
      self.current_user = @user
      @user.track_activity(:joined_the_site)
      flash[:notice] = :thanks_for_activating_your_account.l
      redirect_to welcome_photo_user_path(@user) and return
    end

    flash[:error] = :account_activation_error.l_with_args(:email => configatron.support_email)
    redirect_to signup_path
  end

  def deactivate
    @user.deactivate
    current_user_session.destroy if current_user_session
    flash[:notice] = :deactivate_completed.l
    redirect_to login_path
  end

  def index
    @users, @search, @metro_areas, @states = User.search_conditions_with_metros_and_states(params)

    @users = @users.active.recent.includes(:tags).page(params[:page]).per(20)

    @metro_areas, @states = User.find_country_and_state_from_search_params(params)

    @tags = User.tag_counts :limit => 10

    setup_metro_areas_for_cloud
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
  
  @page_title=:site_members.l :site => configatron.community_name 
 @section = (params[:metro_area_id] ? 'metro_area' : 'users') 
  
  link_to image_tag( user.avatar_photo_url(:medium), :class => "img-responsive" ), user_path(user) 
 link_to user.login, user_path(user) 
 if @search && @search['description'] 
 truncate_words_with_highlight user.description, @search['description'] 
 else 
 truncate_words user.description, 18, '...' 
 end 
 if user.metro_area 
 :from2.l 
 user.location 
 end 
 user.created_at 
 :joined.l + " #{time_ago_in_words_or_date user.created_at}" 
 if current_user and current_user.can_request_friendship_with(user) 
 user.id 
 add_friend_link(user) 
 end 
 unless user.tags.empty? 
 raw user.tags[0...6].compact.collect{|t| link_to( t.name, tag_url(t), :class => "tag") }.join(" ") 
 end 
 if current_user && current_user.admin? 
 button_to :assume_id.l, assume_user_path(user), :class => 'btn' 
 end 
 
 paginate @users, :theme => 'bootstrap' 
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

  def dashboard
    @user = current_user
    @network_activity = @user.network_activity
    @recommended_posts = @user.recommended_posts
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

  def show
    @friend_count               = @user.accepted_friendships.count
    @accepted_friendships       = @user.accepted_friendships.limit(5).to_a.collect{|f| f.friend }
    @pending_friendships_count  = @user.pending_friendships.count()

    @comments       = @user.comments.limit(10).order('created_at DESC')
    @photo_comments = Comment.find_photo_comments_for(@user)
    @users_comments = Comment.find_comments_by_user(@user).limit(5)

    @recent_posts   = @user.posts.recent.limit(2)
    @clippings      = @user.clippings.limit(5)
    @photos         = @user.photos.limit(5)
    @comment        = Comment.new

    @my_activity = Activity.recent.by_users([@user.id]).limit(10)

    update_view_count(@user) unless current_user && current_user.eql?(@user)
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
  
  @meta = { :description => "#{@user.login}'s profile on #{configatron.community_name}.", :keywords => "#{@user.login}, #{@user.tags.join(", ") unless @user.tags.nil?}", :robots => configatron.robots_meta_show_content } 
 @section = @user.eql?(current_user) ? 'my_profile' : 'users' 
 @sidebar_left = true 
 widget :id => 'friends' do 
 :my_friends.l 
 link_to "(#{@friend_count})", accepted_user_friendships_path(@user) if @friend_count > 5 
 link_to "#{:invite_a_friend.l :site => configatron.community_name}", invite_user_path(@user) if @is_current_user 
 link_to "#{:view_all_my_friend_requests.l} (#{@pending_friendships_count})", pending_user_friendships_path(@user) if @is_current_user 
 @accepted_friendships.each do |user| 
  link_to image_tag(user.avatar_photo_url(:thumb), :alt => "#{user.login}"), user_path(user) 
 link_to user.login, user_path(user), :class => 'url' 
 if user.description 
 truncate_words( user.description, 10, '...') 
 end 
 
 end 
 if @accepted_friendships.size > 4 
 link_to fa_icon('plus-circle', :text => :see_all.l), accepted_user_friendships_path(@user) 
 end 
 end 
 if @photos.empty? and @recent_posts.empty? 
 widget do 
 :small_profile.l :user => @user.login 
 end 
 end 
 if @is_current_user and @user.vendor? and @user.description.nil? 
 configatron.community_name 
 link_to :update_your_profile.l, edit_user_path(@user) 
 end 
  
 unless @user.description.blank? 
 box :id => "about_me" do 
 :about_me.l 
 @user.description.html_safe 
 end 
 end 
 unless @users_comments.empty? 
 :my_recent_comments.l 
 @users_comments.each do |comment| 
 if comment.recipient 
 link_to image_tag(comment.recipient.avatar_photo_url(:thumb), :alt => "#{comment.recipient.login}"), commentable_url(comment), :class => 'thumbnail' 
 end 
 if comment.commentable.eql?(comment.recipient) 
 :to.l + ": #{link_to comment.recipient.login, commentable_url(comment)}".html_safe 
 else 
 :on_commentable.l + ": #{link_to comment.commentable_name, commentable_url(comment)} (#{comment.commentable_type.l})".html_safe 
 end 
 truncate_words( comment.comment, 10, '...').html_safe 
 end 
 end 
 unless @photo_comments.empty? 
 :photo_comments.l 
 @photo_comments.each do |comment| 
 link_to(image_tag((comment.user && comment.user.avatar_photo_url(:thumb) || configatron.photo.missing_thumb), :width => '50', :height => '50'), user_photo_path(@user, comment.commentable)) 
 "#{comment.username}" + " " + :says.l + ":" 
 truncate_words(comment.comment, 10).html_safe 
 link_to "&raquo; ".html_safe + :view_comment.l, user_photo_path(@user, comment.commentable) + "#comment-#{comment.id}" 
 end 
 end 
 unless @photos.empty? 
 :my_photos.l 
 @photos.each do |photo| 
 link_to image_tag( photo.photo.url(:medium)), user_photo_path(@user, photo), :class => "thumbnail" 
 end 
 link_to fa_icon('plus-circle', :text => :view_all_my_photos.l), user_photos_path(@user) 
 link_to(:add_a_photo.l, new_user_photo_path(@user)) if @is_current_user 
 end 
 unless @recent_posts.empty? 
 :recent_blog_posts.l 
  
 link_to :view_my_blog.l, user_posts_path(@user) 
 end 
 unless @clippings.empty? 
 :my_clippings.l 
 @clippings.each do |clipping| 
  
 end 
 link_to fa_icon('plus-circle', :text => :view_all_my_clippings.l), user_clippings_path(@user) 
 end 
 :profile_comments.l 
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
 
 more_comments_links(@user) 
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

  def new
    @user         = User.new(:birthday => Date.parse((Time.now - 25.years).to_s))
    @inviter_id   = params[:id]
    @inviter_code = params[:code]
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
  
  @page_title=:sign_up.l 
 widget do 
 :why_sign_up.l 
 :sign_up_reason_1.l 
 :sign_up_reason_2.l 
 end 
 widget do 
 :tips.l 
 :after_signing_up_youll_receive_an_e_mail_confirmation_message.l 
 :click_the_activation_link_in_the_e_mail_to_log_in.l 
 link_to :already_have_an_account.l,  login_path 
 end 
 bootstrap_form_for @user, :layout => :horizontal do |f| 
 f.text_field :login, :label => :username.l, :help => :required_your_username_must_not_contain_numerals_spaces_or_special_characters.l 
 f.text_field :email, :label => :e_mail_address.l, :help => :required_we_will_send_a_confirmation_e_mail_to_the_address_you_enter.l 
 f.date_select :birthday, {:start_year => (Time.now.year - configatron.max_age), :end_year => (Time.now.year - configatron.min_age)}, :help => :required_you_must_be_at_least_years_old_to_sign_up.l_with_args(:min_age => configatron.min_age) 
 f.password_field :password 
 f.password_field :password_confirmation, :help => :re_type_your_password_to_confirm.l 
 hidden_field_tag :inviter_id, params[:inviter_id] 
 hidden_field_tag :inviter_code, params[:inviter_code] 
 if configatron.require_captcha_on_signup 
 f.form_group do 
 recaptcha_tags 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :sign_up.l 
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

  def create
    @user       = User.new(user_params)
    @user.role  = Role[:member]

    if (!configatron.require_captcha_on_signup || verify_recaptcha(@user)) && @user.save
      create_friendship_with_inviter(@user, params)
      flash[:notice] = :email_signup_thanks.l_with_args(:email => @user.email)
      redirect_to signup_completed_user_path(@user)
    else
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
  
  @page_title=:sign_up.l 
 widget do 
 :why_sign_up.l 
 :sign_up_reason_1.l 
 :sign_up_reason_2.l 
 end 
 widget do 
 :tips.l 
 :after_signing_up_youll_receive_an_e_mail_confirmation_message.l 
 :click_the_activation_link_in_the_e_mail_to_log_in.l 
 link_to :already_have_an_account.l,  login_path 
 end 
 bootstrap_form_for @user, :layout => :horizontal do |f| 
 f.text_field :login, :label => :username.l, :help => :required_your_username_must_not_contain_numerals_spaces_or_special_characters.l 
 f.text_field :email, :label => :e_mail_address.l, :help => :required_we_will_send_a_confirmation_e_mail_to_the_address_you_enter.l 
 f.date_select :birthday, {:start_year => (Time.now.year - configatron.max_age), :end_year => (Time.now.year - configatron.min_age)}, :help => :required_you_must_be_at_least_years_old_to_sign_up.l_with_args(:min_age => configatron.min_age) 
 f.password_field :password 
 f.password_field :password_confirmation, :help => :re_type_your_password_to_confirm.l 
 hidden_field_tag :inviter_id, params[:inviter_id] 
 hidden_field_tag :inviter_code, params[:inviter_code] 
 if configatron.require_captcha_on_signup 
 f.form_group do 
 recaptcha_tags 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :sign_up.l 
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
  end

  def edit
    @metro_areas, @states = setup_locations_for(@user)
    @avatar     = (@user.avatar || @user.build_avatar)
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
 :you_are_editing_your_profile.l 
 link_to :edit_your_account_settings_instead.l, edit_account_user_path(@user) 
 end 
 widget do 
 :tips.l 
  if @user.vendor? 
 :user_vendor_offer.l 
 else 
 :user_bio_help.l 
 end 
 
 :feel_free_to_embed_images_or_videos.l 
 end 
 bootstrap_form_for @user, :layout => :horizontal, :html => {:multipart =>true} do |f| 
 :profile_photo.l 
 @user.vendor ? "<div class='right_corner'><div class='community_pro'></div></div>" : '' 
 image_tag( @user.avatar_photo_url(:medium), :class => "thumbnail" ) 
 f.fields_for :avatar, @avatar do |avatar_form| 
 :choose_a_photo_for_your_profile.l 
 avatar_form.file_field :photo, :size => '15' 
 end 
 :location.l 
 f.form_group :location, label: { :text => :location.l } do 
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
 end 
 
 end 
 :zippostal_code.l 
 f.text_field :zip, :hide_label => true 
 :birthday_gender.l 
 f.form_group :birthday_gender, label: { :text => :gender.l } do 
 f.radio_button :gender, User::MALE, :label => :male.l, :inline => true 
 f.radio_button :gender, User::FEMALE, :label => :female.l, :inline => true 
 end 
 f.date_select :birthday, {:start_year => 1926, :end_year => Time.now.year - 1} 
 :about_me.l 
 f.text_area :description, :class => "rich_text_editor" 
 :tags.l 
 f.text_field :tag_list, {:autocomplete => "off"} 
 f.form_group :tag_list_group do 
 :you_could_tag_yourself.l 
 if @user.vendor? 
 :custom_friendly_local.l 
 else 
 configatron.meta_keywords.split(",")[0..3].join(", ") 
 end 
 :tags_are_comma_separated_keywords_that_describe_you.l 
 :you_can_browse_all_content_and_users_on.l 
 configatron.community_name 
 :by_looking_at_the.l 
 link_to :tags_page.l, tags_path 
 end 
  
 f.form_group :save_group do 
 f.primary :save_changes.l 
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
 
 tag_auto_complete_field 'user_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end

  end

  def update
    @metro_areas, @states = setup_locations_for(@user)

    unless params[:metro_area_id].blank?
      @user.metro_area  = MetroArea.find(params[:metro_area_id])
      @user.state       = (@user.metro_area && @user.metro_area.state) ? @user.metro_area.state : nil
      @user.country     = @user.metro_area.country if (@user.metro_area && @user.metro_area.country)
    else
      @user.metro_area = @user.state = @user.country = nil
    end

    @user.tag_list = params[:tag_list] || ''

    if user_params
      attributes = user_params.permit!
      attributes[:avatar_attributes][:user_id] = @user.id if attributes[:avatar_attributes]
      if @user.update_attributes(attributes)
        @user.track_activity(:updated_profile)

        flash[:notice] = :your_changes_were_saved.l
        unless params[:welcome]
          redirect_to user_path(@user)
        else
          redirect_to :action => "welcome_#{params[:welcome]}", :id => @user
        end
      else
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
 :you_are_editing_your_profile.l 
 link_to :edit_your_account_settings_instead.l, edit_account_user_path(@user) 
 end 
 widget do 
 :tips.l 
  if @user.vendor? 
 :user_vendor_offer.l 
 else 
 :user_bio_help.l 
 end 
 
 :feel_free_to_embed_images_or_videos.l 
 end 
 bootstrap_form_for @user, :layout => :horizontal, :html => {:multipart =>true} do |f| 
 :profile_photo.l 
 @user.vendor ? "<div class='right_corner'><div class='community_pro'></div></div>" : '' 
 image_tag( @user.avatar_photo_url(:medium), :class => "thumbnail" ) 
 f.fields_for :avatar, @avatar do |avatar_form| 
 :choose_a_photo_for_your_profile.l 
 avatar_form.file_field :photo, :size => '15' 
 end 
 :location.l 
 f.form_group :location, label: { :text => :location.l } do 
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
 end 
 
 end 
 :zippostal_code.l 
 f.text_field :zip, :hide_label => true 
 :birthday_gender.l 
 f.form_group :birthday_gender, label: { :text => :gender.l } do 
 f.radio_button :gender, User::MALE, :label => :male.l, :inline => true 
 f.radio_button :gender, User::FEMALE, :label => :female.l, :inline => true 
 end 
 f.date_select :birthday, {:start_year => 1926, :end_year => Time.now.year - 1} 
 :about_me.l 
 f.text_area :description, :class => "rich_text_editor" 
 :tags.l 
 f.text_field :tag_list, {:autocomplete => "off"} 
 f.form_group :tag_list_group do 
 :you_could_tag_yourself.l 
 if @user.vendor? 
 :custom_friendly_local.l 
 else 
 configatron.meta_keywords.split(",")[0..3].join(", ") 
 end 
 :tags_are_comma_separated_keywords_that_describe_you.l 
 :you_can_browse_all_content_and_users_on.l 
 configatron.community_name 
 :by_looking_at_the.l 
 link_to :tags_page.l, tags_path 
 end 
  
 f.form_group :save_group do 
 f.primary :save_changes.l 
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
 
 tag_auto_complete_field 'user_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end

      end
    else
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
 :you_are_editing_your_profile.l 
 link_to :edit_your_account_settings_instead.l, edit_account_user_path(@user) 
 end 
 widget do 
 :tips.l 
  if @user.vendor? 
 :user_vendor_offer.l 
 else 
 :user_bio_help.l 
 end 
 
 :feel_free_to_embed_images_or_videos.l 
 end 
 bootstrap_form_for @user, :layout => :horizontal, :html => {:multipart =>true} do |f| 
 :profile_photo.l 
 @user.vendor ? "<div class='right_corner'><div class='community_pro'></div></div>" : '' 
 image_tag( @user.avatar_photo_url(:medium), :class => "thumbnail" ) 
 f.fields_for :avatar, @avatar do |avatar_form| 
 :choose_a_photo_for_your_profile.l 
 avatar_form.file_field :photo, :size => '15' 
 end 
 :location.l 
 f.form_group :location, label: { :text => :location.l } do 
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
 end 
 
 end 
 :zippostal_code.l 
 f.text_field :zip, :hide_label => true 
 :birthday_gender.l 
 f.form_group :birthday_gender, label: { :text => :gender.l } do 
 f.radio_button :gender, User::MALE, :label => :male.l, :inline => true 
 f.radio_button :gender, User::FEMALE, :label => :female.l, :inline => true 
 end 
 f.date_select :birthday, {:start_year => 1926, :end_year => Time.now.year - 1} 
 :about_me.l 
 f.text_area :description, :class => "rich_text_editor" 
 :tags.l 
 f.text_field :tag_list, {:autocomplete => "off"} 
 f.form_group :tag_list_group do 
 :you_could_tag_yourself.l 
 if @user.vendor? 
 :custom_friendly_local.l 
 else 
 configatron.meta_keywords.split(",")[0..3].join(", ") 
 end 
 :tags_are_comma_separated_keywords_that_describe_you.l 
 :you_can_browse_all_content_and_users_on.l 
 configatron.community_name 
 :by_looking_at_the.l 
 link_to :tags_page.l, tags_path 
 end 
  
 f.form_group :save_group do 
 f.primary :save_changes.l 
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
 
 tag_auto_complete_field 'user_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end

    end
  end

  def destroy
    @user = User.find(params[:id])
    unless @user.admin? || @user.featured_writer?
      @user.spam! if params[:spam] && configatron.has_key?(:akismet_key)
      @user.destroy
      flash[:notice] = :the_user_was_deleted.l
    else
      flash[:error] = :you_cant_delete_that_user.l
    end
    respond_to do |format|
      format.html { redirect_to users_url }
      format.js   {
        render :inline => flash[:error], :status => 500 if flash[:error]
        render if flash[:notice]
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
  
  @user.id.to_s 
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

  def change_profile_photo
    @user   = User.find(params[:id])
    @photo  = Photo.find(params[:photo_id])
    @user.avatar = @photo

    if @user.save!
      flash[:notice] = :your_changes_were_saved.l
      redirect_to user_photo_path(@user, @photo)
    end
  rescue ActiveRecord::RecordInvalid
    @metro_areas, @states = setup_locations_for(@user)
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
 :you_are_editing_your_profile.l 
 link_to :edit_your_account_settings_instead.l, edit_account_user_path(@user) 
 end 
 widget do 
 :tips.l 
  if @user.vendor? 
 :user_vendor_offer.l 
 else 
 :user_bio_help.l 
 end 
 
 :feel_free_to_embed_images_or_videos.l 
 end 
 bootstrap_form_for @user, :layout => :horizontal, :html => {:multipart =>true} do |f| 
 :profile_photo.l 
 @user.vendor ? "<div class='right_corner'><div class='community_pro'></div></div>" : '' 
 image_tag( @user.avatar_photo_url(:medium), :class => "thumbnail" ) 
 f.fields_for :avatar, @avatar do |avatar_form| 
 :choose_a_photo_for_your_profile.l 
 avatar_form.file_field :photo, :size => '15' 
 end 
 :location.l 
 f.form_group :location, label: { :text => :location.l } do 
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
 end 
 
 end 
 :zippostal_code.l 
 f.text_field :zip, :hide_label => true 
 :birthday_gender.l 
 f.form_group :birthday_gender, label: { :text => :gender.l } do 
 f.radio_button :gender, User::MALE, :label => :male.l, :inline => true 
 f.radio_button :gender, User::FEMALE, :label => :female.l, :inline => true 
 end 
 f.date_select :birthday, {:start_year => 1926, :end_year => Time.now.year - 1} 
 :about_me.l 
 f.text_area :description, :class => "rich_text_editor" 
 :tags.l 
 f.text_field :tag_list, {:autocomplete => "off"} 
 f.form_group :tag_list_group do 
 :you_could_tag_yourself.l 
 if @user.vendor? 
 :custom_friendly_local.l 
 else 
 configatron.meta_keywords.split(",")[0..3].join(", ") 
 end 
 :tags_are_comma_separated_keywords_that_describe_you.l 
 :you_can_browse_all_content_and_users_on.l 
 configatron.community_name 
 :by_looking_at_the.l 
 link_to :tags_page.l, tags_path 
 end 
  
 f.form_group :save_group do 
 f.primary :save_changes.l 
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
 
 tag_auto_complete_field 'user_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end

  end

  def crop_profile_photo
    unless @photo = @user.avatar
      flash[:notice] = :no_profile_photo.l
      redirect_to upload_profile_photo_user_path(@user) and return
    end
    return unless request.put? || request.patch?

    @photo.update_attributes(:crop_x => params[:crop_x], :crop_y => params[:crop_y], :crop_w => params[:crop_w], :crop_h => params[:crop_h])
    redirect_to user_path(@user)
  end

  def upload_profile_photo
    @avatar       = Photo.new(avatar_params)
    return unless request.put? || request.patch?

    @avatar.user  = @user
    if @avatar.save
      @user.avatar  = @avatar
      @user.save
      redirect_to crop_profile_photo_user_path(@user)
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
  
  @page_title=:profile_photo.l 
 bootstrap_form_for :avatar, :url => upload_profile_photo_user_url(@user), :method => 'put', :multipart => true, :layout => :horiztonal do |f| 
 @user.vendor ? "<div class='right_corner'><div class='community_pro'></div></div>" : '' 
 image_tag( @user.avatar_photo_url(:medium), :class => "thumbnail" ) 
 f.file_field :photo, :label => :choose_a_photo_for_your_profile.l 
 f.primary :save_changes.l 
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

  def edit_account
    @user             = current_user
    @authorizations   = current_user.authorizations
    @is_current_user  = true
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
 :you_are_editing_your_account.l 
 link_to :edit_your_user_profile.l, edit_user_path(@user) 
 end 
 widget do 
  if configatron.has_key?(:auth_providers) 
 remaining_providers = configatron.auth_providers.to_hash.keys.map(&:to_s) - @authorizations.map(&:provider) 
 if @authorizations.any? 
 @authorizations.each do |authorization| 
 image_tag "auth/#{authorization.provider}_32.png" 
 if @authorizations.size > 1 
 link_to image_tag("auth/remove.png"), authorization, :data => {:confirm => t('users.edit_account.omniauth.confirm_remove', :provider => authorization.provider.capitalize)}, :method => :delete, :class => "omniauth_remove", :title => t('users.edit_account.omniauth.title_remove', :provider => authorization.provider.capitalize) 
 end 
 end 
 end 
 if remaining_providers.any? 
 remaining_providers.each do |provider| 
 alt = t('sessions.new.omniauth.button_alt', :provider => provider.capitalize) 
 link_to(image_tag("auth/#{provider}_32.png", :alt => alt), "/auth/#{provider}", :title => alt) 
 end 
 end 
 end 
 
 end 
 bootstrap_form_for @user, :method => 'put', :layout => :horizontal, :label_col => "col-sm-2", :control_col => "col-sm-4", :html => {:multipart => true} do |f| 
 f.text_field :login, :label => :username.l 
 f.text_field :email, :label => :e_mail_address.l 
 f.password_field :password 
 f.password_field :password_confirmation, :label => :confirm_password.l 
 :e_mail_notification.l 
 f.form_group :notifications_group do 
 f.check_box :notify_friend_requests, :label => :notify_of_friend_requests.l(:site => configatron.community_name) 
 f.check_box :notify_comments, :label => :notify_of_comments.l(:site => configatron.community_name) 
 f.check_box :notify_community_news, :label => :notify_email_updates.l(:site => configatron.community_name) 
 end 
 :profile_privacy.l 
 f.form_group :location do 
 f.check_box :profile_public, :label => :make_my_profile_public.l 
 :when_checked_your_profile_will_be_visible_to_anyone.l 
 :when_unchecked_your_profile_will_only_be_visible_to_people_who_are_logged_in_to.l(configatron.community_name) 
 end 
 f.primary :save_changes.l 
 link_to :deactivate_link.l, deactivate_user_path(@user), :method => :patch, data: { confirm: :deactivate_confirmation.l }, :class => 'btn btn-danger' 
 :deactivate_tip.l 
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

  def update_account
    @user             = current_user

    if @user.update_attributes(user_params)
      flash[:notice] = :your_changes_were_saved.l
      respond_to do |format|
        format.html {redirect_to user_path(@user)}
        format.js
      end
    else
      respond_to do |format|
        format.html {ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 :you_are_editing_your_account.l 
 link_to :edit_your_user_profile.l, edit_user_path(@user) 
 end 
 widget do 
  if configatron.has_key?(:auth_providers) 
 remaining_providers = configatron.auth_providers.to_hash.keys.map(&:to_s) - @authorizations.map(&:provider) 
 if @authorizations.any? 
 @authorizations.each do |authorization| 
 image_tag "auth/#{authorization.provider}_32.png" 
 if @authorizations.size > 1 
 link_to image_tag("auth/remove.png"), authorization, :data => {:confirm => t('users.edit_account.omniauth.confirm_remove', :provider => authorization.provider.capitalize)}, :method => :delete, :class => "omniauth_remove", :title => t('users.edit_account.omniauth.title_remove', :provider => authorization.provider.capitalize) 
 end 
 end 
 end 
 if remaining_providers.any? 
 remaining_providers.each do |provider| 
 alt = t('sessions.new.omniauth.button_alt', :provider => provider.capitalize) 
 link_to(image_tag("auth/#{provider}_32.png", :alt => alt), "/auth/#{provider}", :title => alt) 
 end 
 end 
 end 
 
 end 
 bootstrap_form_for @user, :method => 'put', :layout => :horizontal, :label_col => "col-sm-2", :control_col => "col-sm-4", :html => {:multipart => true} do |f| 
 f.text_field :login, :label => :username.l 
 f.text_field :email, :label => :e_mail_address.l 
 f.password_field :password 
 f.password_field :password_confirmation, :label => :confirm_password.l 
 :e_mail_notification.l 
 f.form_group :notifications_group do 
 f.check_box :notify_friend_requests, :label => :notify_of_friend_requests.l(:site => configatron.community_name) 
 f.check_box :notify_comments, :label => :notify_of_comments.l(:site => configatron.community_name) 
 f.check_box :notify_community_news, :label => :notify_email_updates.l(:site => configatron.community_name) 
 end 
 :profile_privacy.l 
 f.form_group :location do 
 f.check_box :profile_public, :label => :make_my_profile_public.l 
 :when_checked_your_profile_will_be_visible_to_anyone.l 
 :when_unchecked_your_profile_will_only_be_visible_to_people_who_are_logged_in_to.l(configatron.community_name) 
 end 
 f.primary :save_changes.l 
 link_to :deactivate_link.l, deactivate_user_path(@user), :method => :patch, data: { confirm: :deactivate_confirmation.l }, :class => 'btn btn-danger' 
 :deactivate_tip.l 
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
        format.js
      end
    end
  end

  def edit_pro_details
    @user = User.find(params[:id])
  end

  def update_pro_details
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      respond_to do |format|
        format.html {
          flash[:notice] = :your_changes_were_saved.l
          redirect_to edit_pro_details_user_path(@user)
        }
        format.js {
          render :text => 'success'
        }
      end

    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit_pro_details'
  end

  def create_friendship_with_inviter(user, options = {})
    unless options[:inviter_code].blank? or options[:inviter_id].blank?
      friend = User.find(options[:inviter_id])

      if friend && friend.valid_invite_code?(options[:inviter_code])
        accepted    = FriendshipStatus[:accepted]
        @friendship = Friendship.new(:user_id => friend.id,
          :friend_id => user.id,
          :friendship_status => accepted,
          :initiator => true)

        reverse_friendship = Friendship.new(:user_id => user.id,
          :friend_id => friend.id,
          :friendship_status => accepted )

        @friendship.save!
        reverse_friendship.save!
      end
    end
  end

  def signup_completed
    @user = User.find(params[:id])
    redirect_to home_path and return unless @user
  end

  def welcome_photo
    @user = User.find(params[:id])
    @avatar = (@user.avatar || @user.build_avatar)
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
  
  @page_title=:profile_photo.l 
 widget do 
 :get_started.l + ' ' + :upload_a_profile_photo.l 
 :photo_message.l :site => configatron.community_name 
 link_to :skip_this_step.l, welcome_about_user_path(@user) 
 link_to :go_to_your_profile.l, user_path(@user) 
 end 
 bootstrap_form_for @user, :url => user_path(:welcome => 'about'), :method => :put, :multipart => true, :layout => :horizontal do |f| 
 if @user.avatar_photo_url 
 image_tag @user.avatar_photo_url(:medium), :class => "pull-right" 
 end 
 f.fields_for :avatar, @avatar do |avatar_form| 
 if @user.vendor? 
 :vendor_avatar_hint.l 
 end 
 avatar_form.file_field :photo, :label => :choose_a_photo_to_upload.l, :help => :photos_should_be_x_pixels.l 
 end 
 f.primary :upload_and_continue_to_step_two.l 
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

  def welcome_about
    @user = User.find(params[:id])
    @metro_areas, @states = setup_locations_for(@user)
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
  
  @page_title=:about_you.l 
 widget do 
 :get_started.l + ' ' + :tell_us_about_yourself.l 
  if @user.vendor? 
 :user_vendor_offer.l 
 else 
 :user_bio_help.l 
 end 
 
 :remember_you_can_always_change_this_later.l 
 link_to :skip_this_step.l, welcome_invite_user_path(@user) 
 link_to :go_to_your_profile.l, user_path(@user) 
 end 
 if @user.avatar_photo_url 
 widget do 
 :your_profile_photo.l 
 @user.vendor ? "<div class='right_corner'><div class='community_pro'></div></div>" : '' 
 image_tag @user.avatar_photo_url(:medium), :class => "img-responsive" 
 link_to :profile_photo_crop.l, crop_profile_photo_user_path(@user) 
 end 
 end 
 bootstrap_form_tag :url => user_path(:welcome => 'invite'), :method => 'put', :multipart => true do 
 :description.l 
 text_area :user, :description, :rows => 30, :style => 'width:100%', :class => "rich_text_editor" 
 :gender.l 
 radio_button :user, :gender, User::MALE 
 :male.l 
 radio_button :user, :gender, User::FEMALE 
 :female.l 
 :choose_your_location.l 
 :postal_code.l 
 text_field :user, :zip, :size => 10, :class => "form-control" 
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
 end 
 
 :tag_yourself.l 
 :tags.l 
 text_field_tag 'tag_list', @user.tag_list, {:autocomplete => "off"} 
 :comma_separated_keywords_that_describe_you.l 
 :you_could_tag_yourself.l 
 if @user.vendor? 
 :custom_friendly_local.l 
 else 
 configatron.meta_keywords.split(",")[0..3].join(', ') 
 end 
  
 submit_tag :save_and_continue_to_step_three.l, :class => 'btn btn-primary' 
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
 
 tag_auto_complete_field 'tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end

  end

  def welcome_invite
    @user = User.find(params[:id])
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
  
  @page_title= :get_started.l + ' ' + :invite_some_friends.l 
 @page_title= :invite_some_customers.l if @user.vendor? 
 :invite_message.l(:site=> configatron.community_name) 
 :people_who_sign_up_using_your_invitation_will_automatically_be_added_as_your_friends.l 
 bootstrap_form_for :invitation, :url => user_invitations_path(:user_id => @user.id), :layout => :horizontal do |f| 
 :add_from_my_address_book.l 
 f.text_area :email_addresses, :rows => 5, :label => :enter_e_mail_addresses.l, :help => :comma_separated.l 
 f.text_area :message, :rows => 5, :label => :write_a_message.l, :value => "#{configatron.community_name} "+:is_great_check_it_out_youll_love_it.l+" #{}" 
 f.form_group :submit_buttons_group do 
 submit_tag :send_invitations.l, :class => 'btn btn-primary' 
 link_to :skip_this_and_go_to_your_profile.l, user_path(@user), :class => 'btn btn-primary' 
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

  def invite
    @user = User.find(params[:id])
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
  
  @page_title=:invite_your_friends_to_join.l 
 widget do 
 :spread_the_word.l 
 :invite_message.l(:site => configatron.community_name) 
 :people_who_sign_up_using_your_invitation_will_automatically_be_added_as_your_friends.l 
 end 
 bootstrap_form_for :invitation, :url => user_invitations_path(:user_id => @user.id ), :layout => :horizontal do |f| 
 :add_from_my_address_book.l 
 f.text_area :email_addresses , :rows => "5", :label => :enter_e_mail_addresses.l 
 f.text_area :message, :rows => "5", :label => :write_a_message.l 
 f.primary :send_invitations.l 
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

  def welcome_complete
    flash[:notice] = :walkthrough_complete.l_with_args(:site => configatron.community_name)
    redirect_to user_path
  end

  def forgot_username
    return unless request.post?

    if @user = User.active.find_by_email(params[:email])
      UserNotifier.forgot_username(@user).deliver
      redirect_to login_url
      flash[:info] = :your_username_was_emailed_to_you.l
    else
      flash[:error] = :sorry_we_dont_recognize_that_email_address.l
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
  
  @page_title=:forgot_your_username.l 
  widget do 
 :help.l 
 :dont_have_an_account.l 
 link_to :click_here_to_sign_up.l, signup_path 
 :forgot_your_password.l 
 link_to :click_here_to_retrieve_it.l, forgot_password_url 
 :forgot_your_username.l 
 link_to :click_here_to_retrieve_it.l, forgot_username_url 
 end 
 
 bootstrap_form_tag :url => forgot_username_path, :layout => :horizontal do |f| 
 f.email_field :email, :label => :enter_your_email_address.l 
 f.form_group :submit_group do 
 f.primary :send_me_my_username.l 
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

  def resend_activation

    if params[:email]
      @user = User.find_by_email(params[:email])
    else
      @user = User.find(params[:id])
    end

    if @user && !@user.active?
      flash[:notice] = :activation_email_resent_message.l
      UserNotifier.signup_notification(@user).deliver
      redirect_to login_path and return
    else
      flash[:notice] = :activation_email_not_sent_message.l
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
  
  @page_title=:resend_your_activation_e_mail.l 
  widget do 
 :help.l 
 :dont_have_an_account.l 
 link_to :click_here_to_sign_up.l, signup_path 
 :forgot_your_password.l 
 link_to :click_here_to_retrieve_it.l, forgot_password_url 
 :forgot_your_username.l 
 link_to :click_here_to_retrieve_it.l, forgot_username_url 
 end 
 
 bootstrap_form_tag :url => resend_activation_url, :layout => :horizontal do 
 :enter_your_email_address.l 
 text_field_tag 'email', nil 
 submit_tag :resend_my_activation_e_mail.l, :class => 'btn btn-primary' 
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

  def assume
    user = User.find(params[:id])

    if assumed_user_session = self.assume_user(user)
      redirect_to user_path(assumed_user_session.record)
    else
      redirect_to users_path
    end
  end

  def return_admin
    return_to_admin
  end

  def metro_area_update

    country = Country.find(params[:country_id]) unless params[:country_id].blank?
    state   = State.find(params[:state_id]) unless params[:state_id].blank?
    states  = country ? country.states : []

    if states.any?
      metro_areas = state ? state.metro_areas.order("name ASC") : []
    else
      metro_areas = country ? country.metro_areas.order("name ASC") : []
    end

    respond_to do |format|
      format.js {
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
  
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
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
 
  

end

      }
    end
  end

  def toggle_featured
    @user = User.find(params[:id])
    @user.toggle!(:featured_writer)
    redirect_to user_path(@user)
  end

  def toggle_moderator
    @user = User.find(params[:id])
    if not @user.admin?
      @user.role = @user.moderator? ? Role[:member] : Role[:moderator]
      @user.save!
    else
      flash[:error] = :you_cannot_make_an_administrator_a_moderator.l
    end
    redirect_to user_path(@user)
  end

  def statistics
    if params[:date]
      date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i)
      @month = Time.parse(date.to_s)
    else
      @month = Date.today
    end

    start_date  = @month.beginning_of_month
    end_date    = @month.end_of_month.end_of_day

    @posts = @user.posts.where('? <= published_at AND published_at <= ?', start_date, end_date)

    @estimated_payment = @posts.to_a.sum do |p|
      7
    end

    respond_to do |format|
      format.html
      format.xml {
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
  
  box do 
 bootstrap_form_tag :url => statistics_user_path(@user), :layout => :horiztonal do 
 :month.l 
 select_month(@month) 
 select_year(@month, :start_year => 1.years.ago.year, :end_year => 1.years.from_now.year) 
 submit_tag :go.l, :class => 'btn btn-primary' 
 if current_user.admin? 
 link_to :back_to_all_statistics.l, statistics_path 
 :estimated_total_for_this_month.l+":" 
 "$#{@estimated_payment}" 
 end 
 @posts.group_by(&:category).each do |category, posts| 
 "#{category.name}:" if category 
 "#{posts.size} "+:posts.l 
 :comments.l 
 :view.l.pluralize 
 posts.each do |post| 
 post.title 
 post.comments.count 
 post.view_count 
 end 
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
  
  box do 
 bootstrap_form_tag :url => statistics_user_path(@user), :layout => :horiztonal do 
 :month.l 
 select_month(@month) 
 select_year(@month, :start_year => 1.years.ago.year, :end_year => 1.years.from_now.year) 
 submit_tag :go.l, :class => 'btn btn-primary' 
 if current_user.admin? 
 link_to :back_to_all_statistics.l, statistics_path 
 :estimated_total_for_this_month.l+":" 
 "$#{@estimated_payment}" 
 end 
 @posts.group_by(&:category).each do |category, posts| 
 "#{category.name}:" if category 
 "#{posts.size} "+:posts.l 
 :comments.l 
 :view.l.pluralize 
 posts.each do |post| 
 post.title 
 post.comments.count 
 post.view_count 
 end 
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

  def delete_selected
    if params[:delete]
      params[:delete].each { |id|
        user = User.find(id)
        unless user.admin? || user.featured_writer?
          user.spam! if params[:spam] && configatron.has_key?(:akismet_key)
          user.destroy
        end
      }
    end
    flash[:notice] = :the_selected_users_were_deleted.l
    redirect_to admin_users_path
  end

  protected
    def setup_metro_areas_for_cloud
      @metro_areas_for_cloud = MetroArea.where("users_count > 0", :order => "users_count DESC").limit(100)
      @metro_areas_for_cloud = @metro_areas_for_cloud.sort_by{|m| m.name}
    end

    def setup_locations_for(user)
      metro_areas = states = []

      states = user.country.states if user.country

      metro_areas = user.state.metro_areas.order("name") if user.state

      return metro_areas, states
    end

    def admin_or_current_user_required
      current_user && (current_user.admin? || @is_current_user) ? true : access_denied
    end


  def avatar_params
    params[:avatar] && params[:avatar].permit(:name, :description, :album_id, :photo)
  end

  def user_params
    params[:user].permit(:avatar_id, :company_name, :country_id, :description, :email,
                                 :firstname, :fullname, :gender, :lastname, :login, :metro_area_id,
                                 :middlename, :notify_comments, :notify_community_news,
                                 :notify_friend_requests, :password, :password_confirmation,
                                 :profile_public, :state_id, :stylesheet, :time_zone, :vendor, :zip,
                                 :tag_list,
                                 {:avatar_attributes => [:id, :name, :description, :album_id, :user, :user_id, :photo, :photo_remote_url]}, :birthday) if params[:user]
  end

  def comment_params
    params[:comment].permit(:author_name, :author_email, :notify_by_email, :author_url, :comment)
  end
end
