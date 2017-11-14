require 'riddle'
class SearchController < ApplicationController
  skip_before_filter :site_authenticate
  
  # GET /search/users?q=[term]
  def users
    @browser_title ||= "Find People"
    
    @search_type = "user"
    @term = params[:q]
    searching_for_an_email = !@term.blank? && @term.match(User::EMAIL_REGEX)
    @results_count = 0
    
    # Only perform the search on Heroku
    if Rails.env.production? || Rails.env.staging?
      if @term.blank?
        @users = User.search :order => "@random DESC", :page => params[:page], :per_page => 50
      else
        # Build up search field conditions hash
        @conditions = {}
        @conditions = searching_for_an_email ? {:email => Riddle.escape(@term)} : {:name => Riddle.escape(@term)}
        @users = User.search :conditions => @conditions, :order => :name, :page => params[:page], :per_page => 50
      end
      @results_count = @users.total_entries
    else
      @users = []
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
  # Dark Content Wrapper 
 # Main (White) Content Wrapper 
 if @term.blank? 
 else 
 end 
 # Search form 
 form_tag user_search_path, :method => :get, :class => "user-search" do 
 text_field_tag :q, @term, :placeholder => "Search for a name or email" 
 end 
 if @users.blank? 
 image_tag("okayguy.png", :alt => "Okay", :size => "256x275") 
 else 
 render @users 
 will_paginate @users 
  @page_has_infinite_scrolling = true 
 
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
  
  # GET /search/videos?q=[term]  or GET /search/videos?tag=[tag]
  def videos
    @browser_title ||= "Search Public Videos"
    
    @search_type = "video"
    searching_for_a_tag = params[:q].blank?
    @term = searching_for_a_tag ? params[:tag] : params[:q]
    @results_count = 0
    
    # Only perform the search on Heroku
    if Rails.env.production? || Rails.env.staging?
      if @term.blank?
        # use the default extended mode matching to return random results
        @results = Video.search :conditions => {:status => VideoGraph.get_status_number(:ready), :channel_is_private => 'f'},
                                :order => "@random DESC",
                                :page => params[:page], 
                                :per_page => 10
      else
        if searching_for_a_tag
          # only match video tags using the default extended mode matching
          @results = Video.search :conditions => {:tags => Riddle.escape(@term), :status => VideoGraph.get_status_number(:ready), :channel_is_private => 'f'},
                                  :page => params[:page], 
                                  :per_page => 10,
                                  :order => 'created_at DESC'
        else
          # use the default extended mode matching to search the video meta
          @results = Video.search Riddle.escape(@term), :conditions => {:status => VideoGraph.get_status_number(:ready), :channel_is_private => 'f'},
                                  :page => params[:page], 
                                  :per_page => 10,
                                  :order => 'created_at DESC'
        end
      end
      @results_count = @results.total_entries
    else
      @results = []
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
  # Dark Content Wrapper 
 # Main (White) Content Wrapper 
 if @term.blank? 
 else 
 end 
 if @results.blank? 
 image_tag("okayguy.png", :alt => "Okay", :size => "256x275") 
 else 
 render @results 
 will_paginate @results 
  @page_has_infinite_scrolling = true 
 
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
   
end