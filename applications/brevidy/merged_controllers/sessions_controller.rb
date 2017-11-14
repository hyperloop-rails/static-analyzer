class SessionsController < ApplicationController
  skip_before_filter :site_authenticate
  skip_before_filter :ensure_the_user_is_not_deactivated, :only => [:destroy]
  
  def new
    if signed_in?
      redirect_to user_stream_path(current_user)
    else
      @browser_title = "Login"
      respond_to do |format|
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [:notice, :error, :message].each do |key| 
 unless flash[key].blank? 
 key 
 flash[key] 
 end 
 end 
 link_to(image_tag("social_login_facebook.png", :size => "225x43", :class => "left mtl"), "#{root_url}auth/facebook") 
 link_to(image_tag("social_login_twitter.png", :size => "225x43", :class => "left mtl"), "#{root_url}auth/twitter") 
 sessions_path 
 request_forgery_protection_token 
 form_authenticity_token 
 text_field_tag :email, nil, :placeholder => "e-mail address", :class => "mls ras" 
 password_field_tag :password, nil, :placeholder => "password", :class => "mls ras" 
 link_to :forgotten_password do 
 end 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 

end
 }
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
  [:notice, :error, :message].each do |key| 
 unless flash[key].blank? 
 key 
 flash[key] 
 end 
 end 
 link_to(image_tag("social_login_facebook.png", :size => "225x43", :class => "left mtl"), "#{root_url}auth/facebook") 
 link_to(image_tag("social_login_twitter.png", :size => "225x43", :class => "left mtl"), "#{root_url}auth/twitter") 
 sessions_path 
 request_forgery_protection_token 
 form_authenticity_token 
 text_field_tag :email, nil, :placeholder => "e-mail address", :class => "mls ras" 
 password_field_tag :password, nil, :placeholder => "password", :class => "mls ras" 
 link_to :forgotten_password do 
 end 
  link_to "Sign Up", signup_path, :class => "mls ram medium green button" 
 
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
  
  # handles social signups / logins / associations
  def create_social_session
    social_params ||= request.env["omniauth.auth"]
    if social_params
      if signed_in?
        # user is associating their FB / Twitter account with their Brevidy account        
        new_network ||= current_user.social_networks.new(:provider => social_params["provider"], :uid => social_params["uid"], :token => social_params["credentials"]["token"], :token_secret => social_params["credentials"]["secret"])
        
        respond_to do |format|
          if new_network.save
            format.html { redirect_to user_account_path(current_user) }
            format.json { render :json => { :success => true,
                                            :message => nil,
                                            :user_id => current_user.id }, 
                                 :status => :created }
          else
            error_message ||= get_errors_for_class(new_network).to_sentence
            format.html { flash[:error] = error_message; redirect_to user_account_path(current_user) }
            format.json { render :json => { :success => false,
                                            :message => error_message,
                                            :user_id => current_user.id }, 
                                 :status => :unprocessable_entity }
          end
        end
      else
        # user is either logging in or signing up via FB / Twitter
        # check if a user with that UID already exists
        social_credentials = SocialNetwork.find_by_provider_and_uid(social_params["provider"], social_params["uid"])
        
        if social_credentials.blank?
          # delete any old social image cookies so we don't set an incorrect image from a prior session
          cookies.delete(:social_image_url)
          cookies.delete(:social_bio)
          
          # create a new user and redirect to step 2 of the signup process
          @user = User.create_via_fb_or_twitter(social_params)
          # set cookies to remember the user's image and bio so we can set it after they are created
          case social_params["provider"]
            when "facebook"
              cookies[:social_image_url] = social_params["user_info"]["image"].gsub("type=square", "type=large") rescue nil
              cookies[:social_bio] = social_params["extra"]["user_hash"]["bio"] rescue nil
            when "twitter"
              cookies[:social_image_url] = social_params["extra"]["user_hash"]["profile_image_url_https"].gsub("_normal", "") rescue nil
              cookies[:social_bio] = social_params["extra"]["user_hash"]["description"] rescue nil
          end
          
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
        else
          # user already exists with that UID/provider combo, so they just want to login
          sign_in User.find_by_id(social_credentials.user_id)
          respond_to do |format|
            format.html { redirect_back_or user_stream_path(current_user) }
          end
        end # end blank?
      end # end signed_in?
    else
      respond_to do |format|
        error_message = "There was an error communicating with Facebook or Twitter. Please try again in a few minutes!"
        format.html { flash[:error] = error_message; redirect_to :login }
        format.json { render :json => { :success => false,
                                        :message => error_message,
                                        :user_id => false }, 
                             :status => :unauthorized }
      end
    end # end check for social params
  end
  
  # handles regular logins (i.e. w/ email / password)
  def create
    # strip fields and downcase email
    prepare_params_for_login
  
    user = User.authenticate(params[:email],
                             params[:password])
  
    if user.nil?
      respond_to do |format|
        error_message = "Invalid login credentials."
        format.html { flash[:error] = error_message; redirect_to :login }
        format.json { render :json => { :success => false,
                                        :message => error_message,
                                        :user_id => false }, 
                             :status => :unauthorized }
      end
    else
      sign_in user
      respond_to do |format|
        format.html { redirect_back_or user_stream_path(current_user) }
        format.json { render :json => { :success => true,
                                        :message => nil,
                                        :user_id => user.id }, 
                             :status => :created }
      end
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
