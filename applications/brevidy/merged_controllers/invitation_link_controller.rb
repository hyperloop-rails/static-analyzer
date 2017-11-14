class InvitationLinkController < ApplicationController
  before_filter :set_user, :verify_user_owns_page, :set_featured_videos
  
  # GET /:username/invitations
  def index
    @browser_title ||= "Invite People"

    respond_to do |format|
      if User::USERS_CAN_INVITE_MORE_PEOPLE
        format.html # index.html.haml
      else
        # don't show the page unless site-wide invites are enabled
        format.html { redirect_to(current_user) }
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
 invitation_link = current_user.invitation_link 
 invitation_url = signup_via_invitation_url(:invitation_token => invitation_link.token) 
 true 
 invitation_url 
 invitation_url 
 form_tag(user_invite_people_path(current_user, @invitation), :class => "send-invites", :remote => true, :method => "POST") do 
 text_area_tag(:recipient_email, nil, :autocomplete => :off,          :placeholder => '"Smith, John" <john.smith@brevidy.com>, averagejoe@brevidy.com, <new.user@brevidy.com>') 
 text_area_tag(:personal_message, nil, :autocomplete => :off, :maxlength => "250",          :placeholder => "(Optional) Personalize your invitation by including a short message" ) 
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

  # POST /:username/invitations
  def create
    recipient_emails = params[:recipient_email]
    if recipient_emails.blank?
      render :json => { :error => "You have not specified any email addresses to invite." }, 
             :status => :unprocessable_entity
    else
      personal_message = params[:personal_message]
      invitation_validation_errors = InvitationLink.invite_new_users!(recipient_emails, current_user, personal_message)
      if invitation_validation_errors.blank?
        render :json => { :message => "Thank you!  We have sent an email inviting each person!" }, 
               :status => :ok
      else
        # return the errors
        render :json => { :error => invitation_validation_errors }, 
               :status => :unprocessable_entity
      end
    end
  end

end
