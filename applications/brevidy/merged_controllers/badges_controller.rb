class BadgesController < ApplicationController
  include ApplicationHelper

  before_filter :site_authenticate, :except => [:badges_dialog, :index]
  before_filter :set_user, :set_browser_title
  before_filter :verify_current_user_is_not_blocked, :only => [:index]
  before_filter :set_video, :except => [:index]
  before_filter :verify_user_can_access_channel_or_video, :only => [:badges_dialog, :create, :destroy]
  before_filter :set_featured_videos, :only => [:index]

  # GET /:username/videos/:video_id/badges
  def badges_dialog
    @badges ||= @video.badges.all
    
    respond_to do |format|
      format.js # badges_dialog.js.haml
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

  # GET /:username/badges 
  def index
    @badges ||= sort_badges_by_count_for_user(get_all_active_badges, @user)
    
    respond_to do |format|
      format.html # index.html.haml
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

  # POST /:username/videos/:video_id/badges
  def create
    new_badge ||= @video.badge_it(current_user, params[:badge_type])
    if new_badge.errors.any?
      render :json => { :error => get_errors_for_class(new_badge).to_sentence }, 
             :status => :unprocessable_entity
    else
      video_owner ||= get_object_owner(@video)
      total_video_badges ||= @video.badges.count
      @viewing_via_token_access = (params[:channel_token] == @video.channel.public_token)
      render :json => { :html => 
                          render_to_string( :partial => 'badges/badge.html',
                                            :locals => { :icon => new_badge,
                                                         :count => @video.badges_count_for_type(params[:badge_type]) } ),
                        :unbadge =>
                          render_to_string( :partial => 'badges/unbadge.html',
                                            :locals => { :badge => new_badge,
                                                         :video => @video,
                                                         :video_owner => video_owner,
                                                         :icon => Icon.find_by_id(params[:badge_type]) } ),
                        :view_all_badges_link =>
                          render_to_string( :partial => 'badges/view_all_badges.html',
                                            :locals => { :badges_count => total_video_badges, 
                                                         :video_owner => video_owner, 
                                                         :video => @video } ),
                        :total_video_badges => total_video_badges,
                        :video_id => @video.id },
             :status => :created
    end
  end
  
  # DELETE /:username/videos/:video_id/badges/:id
  def destroy
    badge ||= @video.badges.find_by_id(params[:id])
    if badge
      # badge exists, so destroy it if user owns it
      if badge.badge_from == current_user.id
        video_owner ||= get_object_owner(@video)
        # cache old badge
        old_badge = badge
        
        if badge.destroy
          badges_count ||= @video.badges.count
          icon ||= Icon.find_by_id(badge.badge_type)
          
          render :json => { :badges_path => user_video_badges_dialog_path(video_owner, @video),
                            :this_badge_count => @video.badges_count_for_type(old_badge.badge_type),
                            :total_video_badges => badges_count,
                            :video_id => @video.id,
                            :badge_name => icon.name,
                            :give_a_badge => 
                              render_to_string( :partial => 'badges/give_a_badge.html', 
                                                :locals => { :video => @video,
                                                             :video_owner => video_owner,
                                                             :icon => icon } ),
                            :view_all_badges_link =>
                              render_to_string( :partial => 'badges/view_all_badges.html',
                                                :locals => { :badges_count => badges_count, 
                                                             :video_owner => video_owner, 
                                                             :video => @video } ) },
                 :status => :ok
        else
          render :json => { :error => "There was an error removing your badge." }, 
                 :status => :unprocessable_entity
        end
      else
        render :json => { :error => "You do not own that badge so you cannot remove it." }, 
               :status => :unauthorized
      end
    else
      render :nothing => true, :status => :not_found
    end
  end
  
  private
    # Sets a browser title for all actions
    def set_browser_title
      @browser_title ||= @user.name unless @user.blank?
    end
end
