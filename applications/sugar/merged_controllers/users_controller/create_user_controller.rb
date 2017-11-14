class UsersController < ApplicationController
  module CreateUserController
    extend ActiveSupport::Concern

    included do
      before_action :find_invite,               only: [:new, :create]
      before_action :check_for_expired_invite,  only: [:new, :create]
      before_action :check_for_signups_allowed, only: [:new, :create]
    end

    def new
      if @invite
        session[:invite_token] = @invite.token
        @user = @invite.user.invitees.new(facebook_user_params)
        @user.email = @invite.email
      else
        @user = User.new(facebook_user_params)
      end
    end

    def create
      @user = User.new(new_user_params)
      @user.invite = @invite # This can be nil

      if @user.save
        finalize_successful_signup
        redirect_to user_profile_url(id: @user.username)
      else
        flash.now[:notice] = "Could not create your account, " \
                             "please fill in all required fields."
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title, Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.stylesheet_url? 
 stylesheet_link_tag current_user.stylesheet_url 
 else 
 stylesheet_link_tag @theme.stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 javascript_include_tag "swfobject" 
 body_classes 
 if Sugar.config.custom_header 
 raw Sugar.config.custom_header 
 end 
 Sugar.config.forum_title.html_safe 
 if current_user? || Sugar.public_browsing? 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Search", name: nil 
 end 
 end 
 if current_user? 
 profile_link(current_user) 
 link_to "Sign out", logout_users_path, data: { confirm: "Do you really want to sign out?"} 
 else 
 if Sugar.config.signups_allowed 
 link_to("Sign up", new_user_path) 
 end 
 link_to "Log in", login_users_path 
 end 
 if current_user? || Sugar.public_browsing? 
 header_tab 'Discussions', discussions_path 
 if current_user? 
 header_tab 'Following', following_discussions_path 
 header_tab 'Favorites', favorites_discussions_path 
 if current_user.unread_conversations? 
 header_tab(
                "Conversations (#{current_user.unread_conversations_count})",
                conversations_path,
                section: :conversations,
                class:   'new'
              )
            
 else 
 header_tab 'Conversations', conversations_path 
 end 
 end 
 header_tab 'Users', online_users_path 
 if current_user? && (current_user.invites? || current_user.available_invites?) 
 if !current_user.user_admin? && current_user.available_invites? 
 header_tab(
                "Invites (#{current_user.available_invites})",
                invites_path,
                section: :invites
              )
            
 else 
 header_tab 'Invites', invites_path 
 end 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
 if content_for?(:sidebar) 
 yield :sidebar 
 end 

  add_body_class "signup"
  @page_title = t('user.sign_up')

 if current_user? || Sugar.public_browsing? 
 link_to "Users", users_path 
 end 
 link_to @page_title, new_user_path 
 if @user.facebook? 
 form_for @user, builder: Sugar::FormBuilder do |f| 
 if @invite 
 hidden_field_tag 'token', @invite.token 
 end 
 unless @user.errors[:email].blank? 
 f.labelled_text_field :email, size: 50 
 else 
 f.hidden_field :email 
 end 
 f.hidden_field :realname 
 f.hidden_field :facebook_uid 
 f.labelled_text_field :username 
 t('user.sign_up') 
 end 
 else 
 if Sugar.config.facebook_app_id 
 end 
 form_for @user, builder: Sugar::FormBuilder do |f| 
 
  mode ||= false

 if @invite 
 hidden_field_tag 'token', @invite.token 
 end 
 f.labelled_text_field :username 
 f.labelled_text_field :email, size: 50 
 f.labelled_password_field :password 
 f.labelled_password_field :confirm_password 
 t('user.new.optional_fields') 
 f.labelled_text_field :realname, size: 50 
 f.labelled_text_field :location, size: 50 
 
 end 
 if Sugar.config.facebook_app_id 
 link_to t('user.sign_up_with_facebook'), facebook_oauth_url(signup_facebook_url), class: 'fb_button' 
 end 
 end 
 if mobile_user_agent? 
 link_to "mobile version", mobile_format: 'mobile' 
 end 
 if Sugar.config.custom_footer 
 raw Sugar.config.custom_footer 
 end 
 javascript_include_tag "application" 
 frontend_configuration.to_json.html_safe 
 unless Sugar.config.custom_javascript.blank? 
 raw Sugar.config.custom_javascript 
 end 
 if @posts && @posts.any? 
 end 
 if @google_maps_api 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

      end
    end

    private

    def new_user_params
      params.require(:user).permit(:username, *allowed_params)
    end

    def find_invite
      @invite = Invite.find_by_token(invite_token) if invite_token?
    end

    def invite_token
      params[:token] || session[:invite_token]
    end

    def invite_token?
      invite_token ? true : false
    end

    def finalize_successful_signup
      Mailer.new_user(@user, login_users_url).deliver_now if @user.email?
      session.delete(:facebook_user_params)
      session.delete(:invite_token)
      @current_user = @user
    end

    def check_for_expired_invite
      if @invite && @invite.expired?
        session.delete(:invite_token)
        flash[:notice] = "Your invite has expired"
        redirect_to login_users_url
      end
    end

    def check_for_signups_allowed
      if !Sugar.config.signups_allowed && User.any? && !@invite
        flash[:notice] = "Signups are not allowed"
        redirect_to login_users_url
      end
    end

    def facebook_user_params
      session[:facebook_user_params] || {}
    end
  end
end
