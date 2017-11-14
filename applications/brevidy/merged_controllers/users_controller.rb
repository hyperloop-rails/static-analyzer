class UsersController < ApplicationController
  require 'securerandom'

  # needed for truncate method
  include ActionView::Helpers::TextHelper
  
  before_filter :site_authenticate, :only => [:block, :edit, :edit_banner, :latest_activity, :new_image, 
                                              :new_image_status, :subscriptions_stream, :unblock, :update, 
                                              :update_background_image, :update_banner_from_gallery, :update_notifications, 
                                              :update_password]
  before_filter :redirect_to_stream_if_logged_in, :only => [:create, :forgotten_password, :new, :reset_password, :signup, 
                                                            :validate_forgotten_password, :validate_reset_password] 
  before_filter :set_user, :except => [:create, :forgotten_password, :index, :new, :signup, :username_availability, :validate_forgotten_password]
  before_filter :verify_current_user_is_not_blocked, :only => [:show]
  before_filter :verify_user_owns_page, :only => [:edit, :edit_banner, :new_image, :new_image_status, :subscriptions_stream, 
                                                  :update, :update_background_image, :update_banner_from_gallery, :update_notifications, 
                                                  :update_password]
  before_filter :set_featured_videos, :only => [:show, :subscriptions_stream]
  before_filter :verify_tokens_match_and_token_is_fresh, :only => [:reset_password, :validate_reset_password]
  
  # Caching
  caches_action :new
  
  # POST /:username/block
  def block
    blocking = Blocking.where(:requesting_user => current_user.id, :blocked_user => @user.id).first
    if blocking
      render :json => { :error => "You are already blocking that user." }, 
             :status => :unprocessable_entity
    else
      current_user.block!(@user)
      render :nothing => true, :status => :created
    end
  end
  
  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in @user
      
      # associate them w/ a social login account if necessary
      unless params[:social_signup].blank?
        @user.associate_with_social_account(params, cookies[:social_image_url], cookies[:social_bio])
      end
      
      respond_to do |format|
        format.html { redirect_to user_stream_path(current_user) }
        format.json { render :json => { :success => true, 
                                        :message => nil,
                                        :user_id => @user.id }, :status => :created }
      end
      
      UserMailer.delay.celebrate_new_user(@user) if Rails.env.production?
    else
      # return errors via AJAX
      respond_to do |format|
        format.js
        format.json { render :json => { :success => false, 
                                        :message => get_errors_for_class(@user).to_sentence,
                                        :user_id => false }, :status => :unprocessable_entity }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 image_path('meta_tag_logo.png') 
 end 
 browser_title 
 # Logged In CSS 
 cache_buster_path('/stylesheets/i_love_lamp-1.0.3.min.css') 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 cache_buster_path('/javascripts/functions.min.js') 
 cache_buster_path('/javascripts/i_love_lamp-1.0.3.min.js') 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("#{current_user.image.blank? ? 'default_user_35px.jpg' : current_user.image_url(:small_profile) }", :alt => "#{current_user.name}", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  if @user.errors.any? 
 end 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # GET /:username/account
  def edit
    @browser_title ||= "Edit Account"
    @facebook_connected = SocialNetwork.find_by_user_id_and_provider(current_user.id, "facebook") 
    @twitter_connected = SocialNetwork.find_by_user_id_and_provider(current_user.id, "twitter") 
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 image_path('meta_tag_logo.png') 
 end 
 browser_title 
 # Logged In CSS 
 cache_buster_path('/stylesheets/i_love_lamp-1.0.3.min.css') 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 cache_buster_path('/javascripts/functions.min.js') 
 cache_buster_path('/javascripts/i_love_lamp-1.0.3.min.js') 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("#{current_user.image.blank? ? 'default_user_35px.jpg' : current_user.image_url(:small_profile) }", :alt => "#{current_user.name}", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  # User Banner Image 
  if @user.banner_image_id == 0 
 # The user has uploaded a banner or they are using the default 
 image_tag("#{ @user.banner_image.blank? ? @user.get_banner_image_url(nil) : @user.banner_image_url(:resized) }", :alt => "", :size => "850x315") 
 else 
 # The user has chosen a banner from the gallery 
 image_tag("#{@user.get_banner_image_url(@user.banner_image_id)}", :alt => "", :size => "850x315") 
 end 
 if current_user?(@user) 
 link_to("Change Banner Image", user_edit_banner_path(current_user), :class => "small primary btn") 
 end 
 
 # Middle User Info Section 
  
 # Dark Content Wrapper 
 # Main (White) Content Wrapper 
 # Set up the tabs 
 # Set up the content areas for the tabs 
 link_to(user_update_background_image_path(current_user, :background_image_id => 0), :class => "set-new-background-image thumbnail light-bg", :remote => true, :method => :put) do 
 image_tag("backgrounds/small/light.jpg", :size => "200x200") 
 end 
 link_to(user_update_background_image_path(current_user, :background_image_id => 1), :class => "set-new-background-image thumbnail dark-bg", :remote => true, :method => :put) do 
 image_tag("backgrounds/small/dark.jpg", :size => "200x200") 
 end 
 form_tag(user_account_update_path(@user), :id => "update-user-info", :class => "prl", :remote => true, :method => :put) do |f| 
 text_field(:user, :username, :maxlength => "30", 'data-path' => username_availability_path) 
 text_field(:user, :name, :maxlength => "30") 
 text_field(:user, :location, :maxlength => "50") 
 image_tag("private_small.png", :alt => "Private Information", :title => "Private Information", :size => "14x14", :class => "semi-transparent") 
 text_field(:user, :email, :maxlength => "200") 
 image_tag("private_small.png", :alt => "Private Information", :title => "Private Information", :size => "14x14", :class => "semi-transparent") 
  options_for_select((1..12).map {|m| [Date::MONTHNAMES[m], m]}) 
 options_for_select((1..31)) 
 options_for_select((1901..Date.today.year).to_a.reverse) 
 # Set the select values if they were passed in 
 if defined?(the_month) 
 end 
 
 image_tag("private_small.png", :alt => "Private Information", :title => "Private Information", :size => "14x14", :class => "semi-transparent") 
 # Set the gender if it's defined 
 unless @user.gender.blank? 
 end 
 image_tag("ajax.gif", :class=>"ajax-animation", :size => "16x16") 
 image_tag("green_checkmark.png", :class=>"green-checkmark", :size => "16x16") 
 end 
 succeed "," do 
 end 
 link_to("Latest Activity", user_latest_activity_path(current_user)) 
 form_tag(user_account_notifications_path(@user), :method => :put, :remote => true, :id => "update-notifications") do 
 check_box("user", "send_email_for_private_channel_request", { }, "true", "false") 
 check_box("user", "send_email_for_new_subscriber", { }, "true", "false") 
 check_box("user", "send_email_for_new_badges", { }, "true", "false") 
 check_box("user", "send_email_for_new_comments", { }, "true", "false") 
 check_box("user", "send_email_for_replies_to_a_prior_comment", { }, "true", "false") 
 check_box("user", "send_email_for_encoding_completion", { }, "true", "false") 
 image_tag("ajax.gif", :class=>"ajax-animation", :size => "16x16") 
 image_tag("green_checkmark.png", :class=>"green-checkmark", :size => "16x16") 
 end 
 if @facebook_connected 
 image_tag("green_checkmark.png", :size => "16x16") 
 else 
 link_to(image_tag("social_connect_facebook.png", :size => "200x38"), "#{root_url}auth/facebook") 
 end 
 if @twitter_connected 
 image_tag("green_checkmark.png", :size => "16x16") 
 else 
 link_to(image_tag("social_connect_twitter.png", :size => "200x38"), "#{root_url}auth/twitter") 
 end 
 form_tag(user_account_password_path(@user), :method => "PUT", :remote => true, :id => "update-password") do 
 password_field_tag :old_password, nil, :placeholder => "old password" 
 password_field_tag :new_password, nil, :placeholder => "new password" 
 password_field_tag :confirm_new_password, nil, :placeholder => "confirm new password" 
 image_tag("ajax.gif", :class=>"ajax-animation", :size => "16x16") 
 image_tag("green_checkmark.png", :class=>"green-checkmark", :size => "16x16") 
 end 
 ze_blocked_users ||= @user.people_they_are_blocking 
 if ze_blocked_users.empty? 
 else 
 ze_blocked_users.each do |u| 
 link_to("(unblock)", user_unblock_path(u), :class => "unblock-user", :remote => true, :method => :delete) 
 end 
 end 
 # Tell the page to scroll down to the content wrapper upon page load 
  
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # GET /:username/edit_banner
  def edit_banner
    @banner_images = BannerImage.where(:active => true)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 image_path('meta_tag_logo.png') 
 end 
 browser_title 
 # Logged In CSS 
 cache_buster_path('/stylesheets/i_love_lamp-1.0.3.min.css') 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 cache_buster_path('/javascripts/functions.min.js') 
 cache_buster_path('/javascripts/i_love_lamp-1.0.3.min.js') 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("#{current_user.image.blank? ? 'default_user_35px.jpg' : current_user.image_url(:small_profile) }", :alt => "#{current_user.name}", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  # User Banner Image 
  if @user.banner_image_id == 0 
 # The user has uploaded a banner or they are using the default 
 image_tag("#{ @user.banner_image.blank? ? @user.get_banner_image_url(nil) : @user.banner_image_url(:resized) }", :alt => "", :size => "850x315") 
 else 
 # The user has chosen a banner from the gallery 
 image_tag("#{@user.get_banner_image_url(@user.banner_image_id)}", :alt => "", :size => "850x315") 
 end 
 if current_user?(@user) 
 link_to("Change Banner Image", user_edit_banner_path(current_user), :class => "small primary btn") 
 end 
 
 # Middle User Info Section 
  
 # Dark Content Wrapper 
 # Main (White) Content Wrapper 
 # Set up the tabs 
 # Set up the content areas for the tabs 
 succeed "." do 
 link_to "Court Whelan", "http://cwhelanphotography.com", :target => "_blank" 
 end 
 @banner_images.each do |b| 
 link_to(image_tag("banners/small/#{b.filename}", :size => "250x93"), user_update_banner_from_gallery_path(current_user, :banner_image_id => b.id), :class => "set-new-banner-image thumbnail", :remote => true, :method => :put) 
 end 
 # Tell the page to scroll down to the content wrapper upon page load 
  
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # GET /account/forgotten_password
  def forgotten_password
    @browser_title ||= "Forgotten Password"
    @show_password_reset = false
 
    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 compact_flash_messages 
 unless flash.empty? 
 @flash_key 
 @flash_msg 
 end 
 if @show_password_reset 
 else 
 end 
 if @show_password_reset 
 # Show the reset password form 
 user_reset_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 @token 
 password_field_tag :password, nil, :placeholder => "password", :class => "ras" 
 password_field_tag :password_confirmation, nil, :placeholder => "confirm password", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 else 
 # Show the forgotten password form 
 validate_forgotten_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 text_field_tag :email, nil, :placeholder => "e-mail address", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 end 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 image_path('meta_tag_logo.png') 
 end 
 browser_title 
 # Logged In CSS 
 cache_buster_path('/stylesheets/i_love_lamp-1.0.3.min.css') 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 cache_buster_path('/javascripts/functions.min.js') 
 cache_buster_path('/javascripts/i_love_lamp-1.0.3.min.js') 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("#{current_user.image.blank? ? 'default_user_35px.jpg' : current_user.image_url(:small_profile) }", :alt => "#{current_user.name}", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  compact_flash_messages 
 unless flash.empty? 
 @flash_key 
 @flash_msg 
 end 
 if @show_password_reset 
 else 
 end 
 if @show_password_reset 
 # Show the reset password form 
 user_reset_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 @token 
 password_field_tag :password, nil, :placeholder => "password", :class => "ras" 
 password_field_tag :password_confirmation, nil, :placeholder => "confirm password", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 else 
 # Show the forgotten password form 
 validate_forgotten_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 text_field_tag :email, nil, :placeholder => "e-mail address", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 end 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # GET /users
  def index
    @browser_title ||= "Find People"
    
    # show the 4 latest featured videos for the Explore page
    #@latest_featured_videos = User.find_by_username("brevidy").featured_videos.limit(4)
    
    @latest_featured_videos = []
    
    respond_to do |format|
      format.html
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 image_path('meta_tag_logo.png') 
 end 
 browser_title 
 # Logged In CSS 
 cache_buster_path('/stylesheets/i_love_lamp-1.0.3.min.css') 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 cache_buster_path('/javascripts/functions.min.js') 
 cache_buster_path('/javascripts/i_love_lamp-1.0.3.min.js') 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("#{current_user.image.blank? ? 'default_user_35px.jpg' : current_user.image_url(:small_profile) }", :alt => "#{current_user.name}", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  # Dark Content Wrapper 
  
 # Main (White) Content Wrapper 
  link_to("Recent Videos", explore_path, :class => "lighten-to-blue") 
 link_to("Find People", find_people_path, :class => "lighten-to-blue") 
 
 if signed_in? 
 # Invitation sell 
 if more_people_can_be_invited? 
 link_to("Invite your friends and family", user_invitations_path(current_user)) 
 end 
 end 
 cache("find_people_page", :expires_in => 15.minutes) do 
 # Search form 
 form_tag user_search_path, :method => :get, :class => "user-search" do 
 text_field_tag :q, @term, :placeholder => "Search for a name or email" 
 end 
 render User.show_random_people 
 end 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # Main landing page w/ social sign up buttons
  # GET brevidy.com
  def new
    @invitation ||= InvitationLink.handle_invite_token(params[:invitation_token])
    cookies[:invitation_token] = params[:invitation_token] if params[:invitation_token]
    
    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 image_tag("fleeting_moments.png", :size => "175x88") 
 image_tag("connect_people.png", :size => "96x125", :class => "connect_people") 
 image_tag("social_sharing.png", :size => "129x115", :class => "social_sharing") 
 link_to(image_tag("social_signup_facebook.png", :size => "225x43", :class => "left"), "#{root_url}auth/facebook") 
 link_to(image_tag("social_signup_twitter.png", :size => "225x43", :class => "right"), "#{root_url}auth/twitter") 
 link_to("...or sign up the old fashioned way", signup_path) 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 image_path('meta_tag_logo.png') 
 end 
 browser_title 
 # Logged In CSS 
 cache_buster_path('/stylesheets/i_love_lamp-1.0.3.min.css') 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 cache_buster_path('/javascripts/functions.min.js') 
 cache_buster_path('/javascripts/i_love_lamp-1.0.3.min.js') 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("#{current_user.image.blank? ? 'default_user_35px.jpg' : current_user.image_url(:small_profile) }", :alt => "#{current_user.name}", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  image_tag("fleeting_moments.png", :size => "175x88") 
 image_tag("connect_people.png", :size => "96x125", :class => "connect_people") 
 image_tag("social_sharing.png", :size => "129x115", :class => "social_sharing") 
 link_to(image_tag("social_signup_facebook.png", :size => "225x43", :class => "left"), "#{root_url}auth/facebook") 
 link_to(image_tag("social_signup_twitter.png", :size => "225x43", :class => "right"), "#{root_url}auth/twitter") 
 link_to("...or sign up the old fashioned way", signup_path) 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # GET /:username/account/image_status
  def new_image_status
    if current_user.image_status == 'processing'
      render :json => { :job_status => 'processing' },
             :status => :ok
    elsif current_user.image_status == 'success'
      # refresh page to show new image
      if params[:media_type] == 'banner'
        redirect_to user_edit_banner_path(current_user)
      else
        redirect_to user_account_path(current_user)
      end
    elsif current_user.image_status == 'error'
      # we had an issue updating the image
      render :json => { :job_status => 'error' },
             :status => :ok
    else
      # we had an unknown state
      render :json => { :job_status => 'error' },
             :status => :ok
    end
  end
  
  # PUT /:username/account/image
  def new_image
    if params[:filename].blank? || params[:media_type].blank?
      Airbrake.notify(:error_class => "Logged Error", :error_message => "USER IMAGE: Error SAVING image for #{current_user.email}.  REASON: Filename or media_type (image or banner) was blank.") if Rails.env.production?
      render :json => { :error => "There was an error saving your new image.  We have been notified of this issue." }, 
             :status => :unprocessable_entity
    else  
      current_user.update_attribute(:image_status, 'processing')
      new_temp_image = params[:filename]

      if params[:media_type] == 'banner'
        # It's a banner image
        old_banner_image = current_user.read_attribute(:banner_image)

        # Kick off resizing and setting the new image
        # Also pass in the old image and new temp file so we can clean up after ourselves on S3
        current_user.set_new_user_image(old_banner_image, new_temp_image, true)
      elsif params[:media_type] == 'image'
        # It's a profile image
        old_image = current_user.read_attribute(:image)

        # Kick off resizing and setting the new image
        # Also pass in the old image and new temp file so we can clean up after ourselves on S3
        current_user.set_new_user_image(old_image, new_temp_image, false)
      else
        Airbrake.notify(:error_class => "Logged Error", :error_message => "There was a bad media_type passed in (#{params[:media_type]}) when saving a new image for #{current_user.email}.") if Rails.env.production?
        return
      end
      
      # return :ok back to the browser so it can start polling
      # the image status to check when processing is complete
      #
      # we use :start_polling to tell the uploader to only do this
      # for images and not for videos
      render :json => { :start_polling => 'true' }, 
             :status => :ok
    end
  end
  
  # POST /:username/reset_password
  def reset_password
    if params[:password] == params[:password_confirmation]
      # New passwords match so reset it
      @user.update_attributes(:password => params[:password])
      User.should_encrypt_password = true
      if @user.save
        User.should_encrypt_password = false
        sign_in @user
        
        # Clear out the reset token so it can't be reused
        @user.reset_token = ""
        @user.save
        
        redirect_to current_user and return
        
      else
        flash.now[:error] = get_errors_for_class(@user)
        @show_password_reset = true
      end
      User.should_encrypt_password = false
  
    else
      flash.now[:error] = "Passwords do not match.  Please re-enter and confirm your new password."
      @show_password_reset = true
    end
  
    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 compact_flash_messages 
 unless flash.empty? 
 @flash_key 
 @flash_msg 
 end 
 if @show_password_reset 
 else 
 end 
 if @show_password_reset 
 # Show the reset password form 
 user_reset_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 @token 
 password_field_tag :password, nil, :placeholder => "password", :class => "ras" 
 password_field_tag :password_confirmation, nil, :placeholder => "confirm password", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 else 
 # Show the forgotten password form 
 validate_forgotten_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 text_field_tag :email, nil, :placeholder => "e-mail address", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 end 

end
 }
    end
  end
  
  # GET /:username
  # GET /:username.js
  def show
    @browser_title ||= @user.name

    if current_user.blank? || !current_user?(@user)
      # Only show public videos that are complete
      @videos ||= @user.public_videos.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
    else
      # Show all videos (public and private) except ones that are uploading
      @videos ||= @user.all_videos.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
    end

    respond_to do |format|
      params[:page].to_i > 1 ? format.js : format.html
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 image_path('meta_tag_logo.png') 
 end 
 browser_title 
 # Logged In CSS 
 cache_buster_path('/stylesheets/i_love_lamp-1.0.3.min.css') 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 cache_buster_path('/javascripts/functions.min.js') 
 cache_buster_path('/javascripts/i_love_lamp-1.0.3.min.js') 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("#{current_user.image.blank? ? 'default_user_35px.jpg' : current_user.image_url(:small_profile) }", :alt => "#{current_user.name}", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  # User Banner Image 
  if @user.banner_image_id == 0 
 # The user has uploaded a banner or they are using the default 
 image_tag("#{ @user.banner_image.blank? ? @user.get_banner_image_url(nil) : @user.banner_image_url(:resized) }", :alt => "", :size => "850x315") 
 else 
 # The user has chosen a banner from the gallery 
 image_tag("#{@user.get_banner_image_url(@user.banner_image_id)}", :alt => "", :size => "850x315") 
 end 
 if current_user?(@user) 
 link_to("Change Banner Image", user_edit_banner_path(current_user), :class => "small primary btn") 
 end 
 
 # Middle User Info Section 
  
 # Dark Content Wrapper 
  
 # Main (White) Content Wrapper 
  
 if @videos.blank? 
 else 
 render @videos 
 end 
 will_paginate @videos 
  @page_has_infinite_scrolling = true 
 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # Secondary sign up page for handling errors and showing old fashioned signup form
  # GET /users/signup
  def signup
    @user = User.new
    @invitation ||= InvitationLink.handle_invite_token(params[:invitation_token])
    
    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 compact_flash_messages 
 unless flash.empty? 
 @flash_key 
 @flash_msg 
 end 
 # validation error field placeholder 
 # do not remove 
 if defined?(social_signup) 
 # these instance vars get passed into the form 
 @user = user 
 @provider = provider 
 @uid = uid 
 @oauth_token = oauth_token 
 @oauth_token_secret = oauth_token_secret 
 @social_signup = social_signup 
  form_for(@user, :html => { :class => "ptxs"}, :remote => true) do |f| 
 @uid 
 @provider 
 @oauth_token 
 @oauth_token_secret 
 @social_signup 
 @user.location 
 unless @invitation.blank? 
 @invitation.token 
 end 
 f.label(:username, "Username", :class => "login_label") 
 f.text_field(:username, :autocomplete => :off, :id => "signupUsername", :placeholder => "username", :class => "mls ras toolTipSignup", :title => "", :tabindex => 1, "data-path" => username_availability_path) 
 f.label(:name, "Your Name (First & Last)", :class => "login_label") 
 f.text_field(:name, :autocomplete => :off, :id => "signupName", :placeholder => "your name", :class => "mls ras toolTipSignup", :title => "We recommend using your real name so people you know can find you.", :tabindex => 2) 
 f.label(:email, "E-mail", :class => "login_label") 
 f.text_field(:email, :autocomplete => :off, :id => "signupEmail", :placeholder => "email address", :class => "mls ras toolTipSignup", :title => "We will not share your e-mail address with ANYONE. Period.", :tabindex => 3) 
 f.label(:password, "Password", :class => "login_label") 
 f.password_field(:password, :autocomplete => :off, :id => "signupPassword", :placeholder => "password", :class => "mls ras toolTipSignup", :title => "Passwords should be longer than 6 characters.", :tabindex => 4) 
 f.label(:birthday, "Date of Birth (age verification only)", :class => "ml30 login_label") 
 options_for_select((1..12).map {|m| [Date::MONTHNAMES[m], m]}) 
 options_for_select((1..31)) 
 options_for_select((1901..Date.today.year).to_a.reverse) 
 image_tag("ajax_white.gif", :size => "16x16", :class => "soft_hidden signup_ajax_animation") 
 end 
 unless @user.birthday.blank? 
 begin 
 parsed_bday = Date.parse @user.birthday.to_s 
 rescue 
 end 
 end 
 
 else 
 link_to(image_tag("social_signup_facebook.png", :size => "225x43", :class => "left mtl"), "#{root_url}auth/facebook") 
 link_to(image_tag("social_signup_twitter.png", :size => "225x43", :class => "left mtl"), "#{root_url}auth/twitter") 
  form_for(@user, :html => { :class => "ptxs"}, :remote => true) do |f| 
 @uid 
 @provider 
 @oauth_token 
 @oauth_token_secret 
 @social_signup 
 @user.location 
 unless @invitation.blank? 
 @invitation.token 
 end 
 f.label(:username, "Username", :class => "login_label") 
 f.text_field(:username, :autocomplete => :off, :id => "signupUsername", :placeholder => "username", :class => "mls ras toolTipSignup", :title => "", :tabindex => 1, "data-path" => username_availability_path) 
 f.label(:name, "Your Name (First & Last)", :class => "login_label") 
 f.text_field(:name, :autocomplete => :off, :id => "signupName", :placeholder => "your name", :class => "mls ras toolTipSignup", :title => "We recommend using your real name so people you know can find you.", :tabindex => 2) 
 f.label(:email, "E-mail", :class => "login_label") 
 f.text_field(:email, :autocomplete => :off, :id => "signupEmail", :placeholder => "email address", :class => "mls ras toolTipSignup", :title => "We will not share your e-mail address with ANYONE. Period.", :tabindex => 3) 
 f.label(:password, "Password", :class => "login_label") 
 f.password_field(:password, :autocomplete => :off, :id => "signupPassword", :placeholder => "password", :class => "mls ras toolTipSignup", :title => "Passwords should be longer than 6 characters.", :tabindex => 4) 
 f.label(:birthday, "Date of Birth (age verification only)", :class => "ml30 login_label") 
 options_for_select((1..12).map {|m| [Date::MONTHNAMES[m], m]}) 
 options_for_select((1..31)) 
 options_for_select((1901..Date.today.year).to_a.reverse) 
 image_tag("ajax_white.gif", :size => "16x16", :class => "soft_hidden signup_ajax_animation") 
 end 
 unless @user.birthday.blank? 
 begin 
 parsed_bday = Date.parse @user.birthday.to_s 
 rescue 
 end 
 end 
 
 end 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 image_path('meta_tag_logo.png') 
 end 
 browser_title 
 # Logged In CSS 
 cache_buster_path('/stylesheets/i_love_lamp-1.0.3.min.css') 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 cache_buster_path('/javascripts/functions.min.js') 
 cache_buster_path('/javascripts/i_love_lamp-1.0.3.min.js') 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("#{current_user.image.blank? ? 'default_user_35px.jpg' : current_user.image_url(:small_profile) }", :alt => "#{current_user.name}", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  compact_flash_messages 
 unless flash.empty? 
 @flash_key 
 @flash_msg 
 end 
 # validation error field placeholder 
 # do not remove 
 if defined?(social_signup) 
 # these instance vars get passed into the form 
 @user = user 
 @provider = provider 
 @uid = uid 
 @oauth_token = oauth_token 
 @oauth_token_secret = oauth_token_secret 
 @social_signup = social_signup 
  form_for(@user, :html => { :class => "ptxs"}, :remote => true) do |f| 
 @uid 
 @provider 
 @oauth_token 
 @oauth_token_secret 
 @social_signup 
 @user.location 
 unless @invitation.blank? 
 @invitation.token 
 end 
 f.label(:username, "Username", :class => "login_label") 
 f.text_field(:username, :autocomplete => :off, :id => "signupUsername", :placeholder => "username", :class => "mls ras toolTipSignup", :title => "", :tabindex => 1, "data-path" => username_availability_path) 
 f.label(:name, "Your Name (First & Last)", :class => "login_label") 
 f.text_field(:name, :autocomplete => :off, :id => "signupName", :placeholder => "your name", :class => "mls ras toolTipSignup", :title => "We recommend using your real name so people you know can find you.", :tabindex => 2) 
 f.label(:email, "E-mail", :class => "login_label") 
 f.text_field(:email, :autocomplete => :off, :id => "signupEmail", :placeholder => "email address", :class => "mls ras toolTipSignup", :title => "We will not share your e-mail address with ANYONE. Period.", :tabindex => 3) 
 f.label(:password, "Password", :class => "login_label") 
 f.password_field(:password, :autocomplete => :off, :id => "signupPassword", :placeholder => "password", :class => "mls ras toolTipSignup", :title => "Passwords should be longer than 6 characters.", :tabindex => 4) 
 f.label(:birthday, "Date of Birth (age verification only)", :class => "ml30 login_label") 
 options_for_select((1..12).map {|m| [Date::MONTHNAMES[m], m]}) 
 options_for_select((1..31)) 
 options_for_select((1901..Date.today.year).to_a.reverse) 
 image_tag("ajax_white.gif", :size => "16x16", :class => "soft_hidden signup_ajax_animation") 
 end 
 unless @user.birthday.blank? 
 begin 
 parsed_bday = Date.parse @user.birthday.to_s 
 rescue 
 end 
 end 
 
 else 
 link_to(image_tag("social_signup_facebook.png", :size => "225x43", :class => "left mtl"), "#{root_url}auth/facebook") 
 link_to(image_tag("social_signup_twitter.png", :size => "225x43", :class => "left mtl"), "#{root_url}auth/twitter") 
  form_for(@user, :html => { :class => "ptxs"}, :remote => true) do |f| 
 @uid 
 @provider 
 @oauth_token 
 @oauth_token_secret 
 @social_signup 
 @user.location 
 unless @invitation.blank? 
 @invitation.token 
 end 
 f.label(:username, "Username", :class => "login_label") 
 f.text_field(:username, :autocomplete => :off, :id => "signupUsername", :placeholder => "username", :class => "mls ras toolTipSignup", :title => "", :tabindex => 1, "data-path" => username_availability_path) 
 f.label(:name, "Your Name (First & Last)", :class => "login_label") 
 f.text_field(:name, :autocomplete => :off, :id => "signupName", :placeholder => "your name", :class => "mls ras toolTipSignup", :title => "We recommend using your real name so people you know can find you.", :tabindex => 2) 
 f.label(:email, "E-mail", :class => "login_label") 
 f.text_field(:email, :autocomplete => :off, :id => "signupEmail", :placeholder => "email address", :class => "mls ras toolTipSignup", :title => "We will not share your e-mail address with ANYONE. Period.", :tabindex => 3) 
 f.label(:password, "Password", :class => "login_label") 
 f.password_field(:password, :autocomplete => :off, :id => "signupPassword", :placeholder => "password", :class => "mls ras toolTipSignup", :title => "Passwords should be longer than 6 characters.", :tabindex => 4) 
 f.label(:birthday, "Date of Birth (age verification only)", :class => "ml30 login_label") 
 options_for_select((1..12).map {|m| [Date::MONTHNAMES[m], m]}) 
 options_for_select((1..31)) 
 options_for_select((1901..Date.today.year).to_a.reverse) 
 image_tag("ajax_white.gif", :size => "16x16", :class => "soft_hidden signup_ajax_animation") 
 end 
 unless @user.birthday.blank? 
 begin 
 parsed_bday = Date.parse @user.birthday.to_s 
 rescue 
 end 
 end 
 
 end 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # GET /:username/stream
  # GET /:username/stream.js
  def subscriptions_stream
    @browser_title ||= @user.name
    @videos ||= current_user.all_videos_for_subscriptions.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')

    respond_to do |format|
      params[:page].to_i > 1 ? format.js : format.html
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 image_path('meta_tag_logo.png') 
 end 
 browser_title 
 # Logged In CSS 
 cache_buster_path('/stylesheets/i_love_lamp-1.0.3.min.css') 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 cache_buster_path('/javascripts/functions.min.js') 
 cache_buster_path('/javascripts/i_love_lamp-1.0.3.min.js') 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("#{current_user.image.blank? ? 'default_user_35px.jpg' : current_user.image_url(:small_profile) }", :alt => "#{current_user.name}", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  # User Banner Image 
  if @user.banner_image_id == 0 
 # The user has uploaded a banner or they are using the default 
 image_tag("#{ @user.banner_image.blank? ? @user.get_banner_image_url(nil) : @user.banner_image_url(:resized) }", :alt => "", :size => "850x315") 
 else 
 # The user has chosen a banner from the gallery 
 image_tag("#{@user.get_banner_image_url(@user.banner_image_id)}", :alt => "", :size => "850x315") 
 end 
 if current_user?(@user) 
 link_to("Change Banner Image", user_edit_banner_path(current_user), :class => "small primary btn") 
 end 
 
 # Middle User Info Section 
  
 # Dark Content Wrapper 
  
 # Main (White) Content Wrapper 
  
 if @videos.blank? 
 else 
 render @videos 
 end 
 will_paginate @videos 
  @page_has_infinite_scrolling = true 
 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # POST /:username/unblock
  def unblock
    blocking = Blocking.where(:requesting_user => current_user.id, :blocked_user => @user.id).first
    if blocking
      if blocking.destroy
        render :nothing => true, :status => :ok
      else
        render :json => { :error => "There was an issue unblocking that person.  We have been notified of this issue." }, 
               :status => :not_found
        Airbrake.notify(:error_class => "Logged Error", :error_message => "UNBLOCK: User (#{current_user.email}) was unable to unblock another user (#{@user.email})") if Rails.env.production?
      end
    else
      render :json => { :error => "You are not currently blocking that user." }, 
             :status => :unprocessable_entity
    end
  end
  
  # PUT /:username/account/update
  def update
    # format the new birthday
    new_birthday = "#{params[:birthday_year]}-#{params[:birthday_month]}-#{params[:birthday_day]}"
    # cache the old username
    old_username = current_user.username
    
    # update the other attributes
    if current_user.update_attributes(params[:user]) && current_user.update_attributes(:birthday => new_birthday)
      if current_user.username != old_username
        current_user.update_attribute(:username_changed_at, DateTime.now)
        redirect_to user_account_path(current_user) 
      else  
        render :nothing => true, :status => :accepted
      end
    else
      render :json => { :error => get_errors_for_class(current_user).to_sentence }, 
             :status => :unprocessable_entity
    end
  end
  
  # PUT /:username/update_background_image
  def update_background_image
    background_image_id = params[:background_image_id]
    if background_image_id.blank?
      render :json => { :error => "Sorry, but we could not set your background image for you." }, 
             :status => :unprocessable_entity
      Airbrake.notify(:error_class => "Logged Error", :error_message => "USER BACKGROUND: Could not set a background image since the background_image_id passed in was blank.") if Rails.env.production?
    else
      # Make sure a valid ID was passed in
      if current_user.update_attributes(:background_image_id => background_image_id.to_i)
        render :json => { :background_image_id => background_image_id }, 
               :status => :accepted
      else
        render :json => { :error => "Sorry, but we could not set your background image for you." }, 
               :status => :unprocessable_entity
        Airbrake.notify(:error_class => "Logged Error", :error_message => "USER BACKGROUND: Could not set a background image since the background_image_id passed in was invalid.") if Rails.env.production?
      end
    end
  end
  
  # PUT /:username/update_banner_from_gallery
  def update_banner_from_gallery
    banner_id = params[:banner_image_id]
    if banner_id.blank?
      render :json => { :error => "Sorry, but we could not set your banner image for you." }, 
             :status => :unprocessable_entity
      Airbrake.notify(:error_class => "Logged Error", :error_message => "USER BANNER: Could not set a user banner from the gallery since the banner ID passed in was blank.") if Rails.env.production?
    else
      # Make sure a valid ID was passed in
      if BannerImage.where(:id => banner_id, :active => true).exists?
        current_user.update_attributes(:banner_image_id => banner_id)
        render :json => { :image_path => current_user.get_banner_image_url(banner_id) }, 
               :status => :accepted
      else
        render :json => { :error => "Sorry, but we could not set your banner image for you." }, 
               :status => :unprocessable_entity
        Airbrake.notify(:error_class => "Logged Error", :error_message => "USER BANNER: Could not set a user banner from the gallery since the banner ID passed in was invalid or for a banner that is no longer active.") if Rails.env.production?
      end
    end
  end
  
  # PUT /:username/account/notifications
  def update_notifications
    the_settings = current_user.setting
    if the_settings.update_attributes(params[:user])  
      render :nothing => true, 
             :status => :accepted
    else
      render :json => { :error => get_errors_for_class(the_settings).to_sentence }, 
             :status => :unprocessable_entity
    end
  end
  
  # PUT /:username/account/password
  def update_password      
    puts params[:old_password].strip
    if current_user.has_password?(params[:old_password].strip)
      new_password ||= params[:new_password].strip
      confirm_new_password ||= params[:confirm_new_password].strip
      if new_password == confirm_new_password
        User.should_encrypt_password = true
        if current_user.update_attributes(:password => new_password)
          render :nothing => true, :status => :accepted
        else
          render :json => { :error => get_errors_for_class(current_user).to_sentence }, 
                 :status => :unprocessable_entity
        end
        User.should_encrypt_password = false 
      else
        render :json => { :error => "Your new password does not match the confirmation password.  Please re-type them." }, 
               :status => :unprocessable_entity
      end
    else
      render :json => { :error => "Your old password does not match the password we have on record." }, 
             :status => :unprocessable_entity
    end
  end
  
  # GET /username_availability
  def username_availability
    if params[:username].blank?
      render :json => { :error => "No username was passed in." }, 
             :status => :unprocessable_entity
    else
      username = params[:username].downcase.strip
      if (username.length > User::USERNAME_LENGTH) || !User::USERNAME_REGEX.match(username) || !User.verify_username_is_acceptable(username) || User.where(:username => username).exists?
        render :json => { :availability_text => "not available" }, 
               :status => :ok
      else
        render :json => { :availability_text => "available" }, 
               :status => :ok
      end
    end
  end
  
  # POST /account/validate_forgotten_password
  def validate_forgotten_password
    @show_password_reset = false
    
    if params[:email].blank?
      flash.now[:error] = "Please enter an email address." and return
    elsif is_not_a_valid_email(params[:email])
      flash.now[:error] = "Email address is invalid.  Please enter a valid email address." and return
    else            
      forgetful_user = User.find_by_email(params[:email])
      if forgetful_user
        # Generate reset token for the forgetful user
        forgetful_user.reset_token = generate_reset_token
        # Record when pw reset was requested for token expiration
        forgetful_user.pw_reset_timestamp = Date.today
        
        if forgetful_user.save 
          # Send email
          UserMailer.delay(:priority => 0).reset_password_instructions(forgetful_user)
          
          # Show flash message
          flash.now[:success] = "We have sent password reset instructions to that email address."
        else
          flash.now[:error] = "There was an error processing your password reset request.  We have been notified of this issue."
          Airbrake.notify(:error_class => "Logged Error", :error_message => "Could not save reset_token (#{forgetful_user.reset_token}) for User (#{forgetful_user.email}).") if Rails.env.production?
        end 
      else
        flash.now[:error] = "We could not find a user with that email address."
      end
    end
    
    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 compact_flash_messages 
 unless flash.empty? 
 @flash_key 
 @flash_msg 
 end 
 if @show_password_reset 
 else 
 end 
 if @show_password_reset 
 # Show the reset password form 
 user_reset_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 @token 
 password_field_tag :password, nil, :placeholder => "password", :class => "ras" 
 password_field_tag :password_confirmation, nil, :placeholder => "confirm password", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 else 
 # Show the forgotten password form 
 validate_forgotten_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 text_field_tag :email, nil, :placeholder => "e-mail address", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 end 

end
 }
    end
  end
  
  # GET /:username/validate_reset_password?token=[token]
  def validate_reset_password
    @browser_title ||= "Reset Password"
    @show_password_reset = true
    
    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 compact_flash_messages 
 unless flash.empty? 
 @flash_key 
 @flash_msg 
 end 
 if @show_password_reset 
 else 
 end 
 if @show_password_reset 
 # Show the reset password form 
 user_reset_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 @token 
 password_field_tag :password, nil, :placeholder => "password", :class => "ras" 
 password_field_tag :password_confirmation, nil, :placeholder => "confirm password", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 else 
 # Show the forgotten password form 
 validate_forgotten_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 text_field_tag :email, nil, :placeholder => "e-mail address", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 end 

end
 }
    end
  end
  
  
  private 
    # Verifies the user's reset password token matches and is less than 2 days old
    def verify_tokens_match_and_token_is_fresh
      @token = params[:token]
      invalid_token_msg = "The reset password link you are attempting to use is invalid or has expired.  Please enter your email below to generate a new link."
      
      # Make sure the token isn't blank
      if @token.blank?
        @show_password_reset = false
        flash.now[:error] = invalid_token_msg
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 compact_flash_messages 
 unless flash.empty? 
 @flash_key 
 @flash_msg 
 end 
 if @show_password_reset 
 else 
 end 
 if @show_password_reset 
 # Show the reset password form 
 user_reset_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 @token 
 password_field_tag :password, nil, :placeholder => "password", :class => "ras" 
 password_field_tag :password_confirmation, nil, :placeholder => "confirm password", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 else 
 # Show the forgotten password form 
 validate_forgotten_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 text_field_tag :email, nil, :placeholder => "e-mail address", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 end 

end
      end
      
      # See if the token is older than 2 days (it's expired if so)
      unless @user.pw_reset_timestamp.blank?
        date_then = Date.new(@user.pw_reset_timestamp.year, @user.pw_reset_timestamp.month, @user.pw_reset_timestamp.day)
        @freshToken = (Date.today - date_then).to_i <= 2
      end
      
      # Make sure the tokens match up and the token is less than 2 days old
      unless @token == @user.reset_token && @freshToken
        # Clear the reset token since it's expired or someone is trying to guess it            
        @user.reset_token = ""
        @user.save  
        
        # Show a flash message and render the page
        @show_password_reset = false
        flash.now[:error] = invalid_token_msg
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 compact_flash_messages 
 unless flash.empty? 
 @flash_key 
 @flash_msg 
 end 
 if @show_password_reset 
 else 
 end 
 if @show_password_reset 
 # Show the reset password form 
 user_reset_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 @token 
 password_field_tag :password, nil, :placeholder => "password", :class => "ras" 
 password_field_tag :password_confirmation, nil, :placeholder => "confirm password", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 else 
 # Show the forgotten password form 
 validate_forgotten_password_path 
 request_forgery_protection_token 
 form_authenticity_token 
 text_field_tag :email, nil, :placeholder => "e-mail address", :class => "ras" 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
 end 

end

      end
    end
    
    # Checks if email is valid
    def is_not_a_valid_email(email)
      reg = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      return (reg.match(email))? false : true
    end
    
    # Generates a 32 character random string for resetting the user's password
    def generate_reset_token
      loop do
        token = SecureRandom.base64(32).tr('+/=', 'xyz')
        break token unless User.where(:reset_token => token).exists?
      end
    end
    
end
