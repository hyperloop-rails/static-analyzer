class SettingsController < ApplicationController
  before_filter :require_logged_in_user

  def index
    @title = "Account Settings"

    @edit_user = @user.dup
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @meta_tags 
 @meta_tags.each do |k,v| 
 k 
 v 
 end 
 end 
 if @short_url 
 @short_url 
 end 
 @title.present? ? "#{@title} | " : "" 

    Rails.application.name 
 stylesheet_link_tag "application", :media => "all" 
 if @user 
 javascript_include_tag "application" 
 @user.id 
 end 
 csrf_meta_tags 
 if @rss_link 
 @rss_link[:title] 
 @rss_link[:href] 
 end 
 if @comments_rss_link 
 @comments_rss_link[:title] 
 @comments_rss_link[:href] 
 end 
 sprintf("%02x%02x%02x",
        [ 255, (@traffic * 7).floor + 50.0 ].min, 0, 0) 
 Rails.application.name 
 @traffic.to_i 
 links = {
          "/" => @cur_url == "/" ? Rails.application.name : "Home",
          "/recent" => "Recent",
          "/comments" => "Comments"
        } 
 if @user 
 links.merge!({ "/threads" => "Your Threads",
            "/stories/new" => "Submit Story" }) 
 end 
 links.merge!({ "/search" => "Search" }) 
 if @cur_url.present? && !links.keys.include?(@cur_url) &&
        @heading.present? 
 @cur_url 
 @heading 
 end 
 links.each do |u,v| 
 u 
 u == @cur_url ? raw("class=\"cur_url\"") :
              "" 
 v 
 end 
 @cur_url == "/filters" ?
          raw("class=\"cur_url\"") : "" 
 if @user 
 if (count = @user.unread_message_count) > 0 
 @cur_url == "/messages" ?
              "cur_url" : "" 
 count 
 count == 1 ? "" :
              "s" 
 else 
 @cur_url == "/messages" ?
              raw("class=\"cur_url\"") : "" 
 end 
 @cur_url == "/settings" ?
            raw("class=\"cur_url\"") : "" 
 @user.username 
 @user.karma 
 link_to "Logout", { :controller => "login", :action => "logout" },
            :data => { :confirm => "Are you sure you want to logout?" },
            :method => "post" 
 else 
 end 
 [ :error, :success, :notice ].each do |f| 
 if flash[f].present? 
 f 
 flash[f] 
 end 
 end 
 @user.username 
 form_for @edit_user, :url => settings_path, :method => :post,
  :html => { :id => "edit_user" } do |f| 
 error_messages_for f.object 
 f.label :username, "Username:", :class => "required" 
 f.text_field :username, :size => 15 
 User.username_regex 
 f.label :password, "New Password:", :class => "required" 
 f.password_field :password, :size => 40, :autocomplete => "off" 
 f.label :password_confirmation, "Confirm Password:",
        :class => "required" 
 f.password_field :password_confirmation, :size => 40,
        :autocomplete => "off" 
 f.label :email, "E-mail Address:", :class => "required" 
 f.text_field :email, :size => 40 
 f.label :about, "About:", :class => "required" 
 f.text_area :about, :size => "100x5", :style => "width: 600px;" 
  if defined?(allow_images) && allow_images 
 end 
 
 f.submit "Save Account Settings" 
 f.label :pushover_user_key,
        raw("<a href=\"https://pushover.net/\">Pushover</a>:"),
        :class => "required" 
 link_to((f.object.pushover_user_key.present??
        "Manage Pushover Subscription" : "Subscribe With Pushover"),
        "/settings/pushover", :class => "pushover_button", :method => :post) 
 f.label :email_replies, "Receive E-mail:", :class => "required" 
 f.check_box :email_replies 
 f.label :pushover_replies, "Receive Pushover Alert:",
        :class => "required" 
 f.check_box :pushover_replies 
 f.label :email_mentions, "Receive E-mail:", :class => "required" 
 f.check_box :email_mentions 
 f.label :pushover_mentions, "Receive Pushover Alert:",
        :class => "required" 
 f.check_box :pushover_mentions 
 f.label :email_messages, "Receive E-mail:", :class => "required" 
 f.check_box :email_messages 
 f.label :pushover_messages, "Receive Pushover Alert:",
        :class => "required" 
 f.check_box :pushover_messages 
 f.label :show_submitted_story_threads,
        "Show in Your Threads:", :class => "required" 
 f.check_box :show_submitted_story_threads 
 f.label :mailing_list_mode, "Receive List E-mails:",
        :class => "required" 
 f.select :mailing_list_mode, [ [ "No e-mails", 0 ],
        [ "All stories and comments", 1 ], [ "Only stories", 2 ] ] 
 Rails.application.shortname 

        @edit_user.mailing_list_token 
 Rails.application.domain 
 f.label :show_story_previews, "Show Story Previews:",
        :class => "required" 
 f.check_box :show_story_previews 
 f.label :show_avatars, "Show User Avatars:", :class => "required" 
 f.check_box :show_avatars 
 f.submit "Save All Settings" 
 end 
 form_for @edit_user, :url => delete_account_path, :method => :post,
  :html => { :id => "delete_user" } do |f| 
 f.label :password, "Verify Password:", :class => "required" 
 f.password_field :password, :size => 40, :autocomplete => "off" 
 f.submit "Yes, Delete My Account" 
 end 
  form_tag "/invitations", :method => :post do |f| 
 if defined?(return_home) && return_home 
 hidden_field_tag :return_home, 1 
 end 
 label_tag :email, "E-mail Address:", :class => "required" 
 text_field_tag :email, "", :size => 30, :autocomplete => "off" 
 label_tag :memo, "Memo to User:", :class => "required" 
 text_field_tag :memo, "", :size => 60 
 submit_tag "Send Invitation" 
 end 
 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def delete_account
    if @user.try(:authenticate, params[:user][:password].to_s)
      @user.delete!
      reset_session
      flash[:success] = "Your account has been deleted."
      return redirect_to "/"
    end

    flash[:error] = "Your password could not be verified."
    return redirect_to settings_path
  end

  def pushover
    if !Pushover.SUBSCRIPTION_CODE
      flash[:error] = "This site is not configured for Pushover"
      return redirect_to "/settings"
    end

    session[:pushover_rand] = SecureRandom.hex

    return redirect_to Pushover.subscription_url({
      :success => "#{Rails.application.root_url}settings/pushover_callback?" <<
        "rand=#{session[:pushover_rand]}",
      :failure => "#{Rails.application.root_url}settings/",
    })
  end

  def pushover_callback
    if !session[:pushover_rand].to_s.present?
      flash[:error] = "No random token present in session"
      return redirect_to "/settings"
    end

    if !params[:rand].to_s.present?
      flash[:error] = "No random token present in URL"
      return redirect_to "/settings"
    end

    if params[:rand].to_s != session[:pushover_rand].to_s
      raise "rand param #{params[:rand].inspect} != " <<
        session[:pushover_rand].inspect
    end

    @user.pushover_user_key = params[:pushover_user_key].to_s
    @user.save!

    if @user.pushover_user_key.present?
      flash[:success] = "Your account is now setup for Pushover notifications."
    else
      flash[:success] = "Your account is no longer setup for Pushover " <<
        "notifications."
    end

    return redirect_to "/settings"
  end

  def update
    @edit_user = @user.clone

    if @edit_user.update_attributes(user_params)
      flash.now[:success] = "Successfully updated settings."
      @user = @edit_user
    end

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @meta_tags 
 @meta_tags.each do |k,v| 
 k 
 v 
 end 
 end 
 if @short_url 
 @short_url 
 end 
 @title.present? ? "#{@title} | " : "" 

    Rails.application.name 
 stylesheet_link_tag "application", :media => "all" 
 if @user 
 javascript_include_tag "application" 
 @user.id 
 end 
 csrf_meta_tags 
 if @rss_link 
 @rss_link[:title] 
 @rss_link[:href] 
 end 
 if @comments_rss_link 
 @comments_rss_link[:title] 
 @comments_rss_link[:href] 
 end 
 sprintf("%02x%02x%02x",
        [ 255, (@traffic * 7).floor + 50.0 ].min, 0, 0) 
 Rails.application.name 
 @traffic.to_i 
 links = {
          "/" => @cur_url == "/" ? Rails.application.name : "Home",
          "/recent" => "Recent",
          "/comments" => "Comments"
        } 
 if @user 
 links.merge!({ "/threads" => "Your Threads",
            "/stories/new" => "Submit Story" }) 
 end 
 links.merge!({ "/search" => "Search" }) 
 if @cur_url.present? && !links.keys.include?(@cur_url) &&
        @heading.present? 
 @cur_url 
 @heading 
 end 
 links.each do |u,v| 
 u 
 u == @cur_url ? raw("class=\"cur_url\"") :
              "" 
 v 
 end 
 @cur_url == "/filters" ?
          raw("class=\"cur_url\"") : "" 
 if @user 
 if (count = @user.unread_message_count) > 0 
 @cur_url == "/messages" ?
              "cur_url" : "" 
 count 
 count == 1 ? "" :
              "s" 
 else 
 @cur_url == "/messages" ?
              raw("class=\"cur_url\"") : "" 
 end 
 @cur_url == "/settings" ?
            raw("class=\"cur_url\"") : "" 
 @user.username 
 @user.karma 
 link_to "Logout", { :controller => "login", :action => "logout" },
            :data => { :confirm => "Are you sure you want to logout?" },
            :method => "post" 
 else 
 end 
 [ :error, :success, :notice ].each do |f| 
 if flash[f].present? 
 f 
 flash[f] 
 end 
 end 
 @user.username 
 form_for @edit_user, :url => settings_path, :method => :post,
  :html => { :id => "edit_user" } do |f| 
 error_messages_for f.object 
 f.label :username, "Username:", :class => "required" 
 f.text_field :username, :size => 15 
 User.username_regex 
 f.label :password, "New Password:", :class => "required" 
 f.password_field :password, :size => 40, :autocomplete => "off" 
 f.label :password_confirmation, "Confirm Password:",
        :class => "required" 
 f.password_field :password_confirmation, :size => 40,
        :autocomplete => "off" 
 f.label :email, "E-mail Address:", :class => "required" 
 f.text_field :email, :size => 40 
 f.label :about, "About:", :class => "required" 
 f.text_area :about, :size => "100x5", :style => "width: 600px;" 
  if defined?(allow_images) && allow_images 
 end 
 
 f.submit "Save Account Settings" 
 f.label :pushover_user_key,
        raw("<a href=\"https://pushover.net/\">Pushover</a>:"),
        :class => "required" 
 link_to((f.object.pushover_user_key.present??
        "Manage Pushover Subscription" : "Subscribe With Pushover"),
        "/settings/pushover", :class => "pushover_button", :method => :post) 
 f.label :email_replies, "Receive E-mail:", :class => "required" 
 f.check_box :email_replies 
 f.label :pushover_replies, "Receive Pushover Alert:",
        :class => "required" 
 f.check_box :pushover_replies 
 f.label :email_mentions, "Receive E-mail:", :class => "required" 
 f.check_box :email_mentions 
 f.label :pushover_mentions, "Receive Pushover Alert:",
        :class => "required" 
 f.check_box :pushover_mentions 
 f.label :email_messages, "Receive E-mail:", :class => "required" 
 f.check_box :email_messages 
 f.label :pushover_messages, "Receive Pushover Alert:",
        :class => "required" 
 f.check_box :pushover_messages 
 f.label :show_submitted_story_threads,
        "Show in Your Threads:", :class => "required" 
 f.check_box :show_submitted_story_threads 
 f.label :mailing_list_mode, "Receive List E-mails:",
        :class => "required" 
 f.select :mailing_list_mode, [ [ "No e-mails", 0 ],
        [ "All stories and comments", 1 ], [ "Only stories", 2 ] ] 
 Rails.application.shortname 

        @edit_user.mailing_list_token 
 Rails.application.domain 
 f.label :show_story_previews, "Show Story Previews:",
        :class => "required" 
 f.check_box :show_story_previews 
 f.label :show_avatars, "Show User Avatars:", :class => "required" 
 f.check_box :show_avatars 
 f.submit "Save All Settings" 
 end 
 form_for @edit_user, :url => delete_account_path, :method => :post,
  :html => { :id => "delete_user" } do |f| 
 f.label :password, "Verify Password:", :class => "required" 
 f.password_field :password, :size => 40, :autocomplete => "off" 
 f.submit "Yes, Delete My Account" 
 end 
  form_tag "/invitations", :method => :post do |f| 
 if defined?(return_home) && return_home 
 hidden_field_tag :return_home, 1 
 end 
 label_tag :email, "E-mail Address:", :class => "required" 
 text_field_tag :email, "", :size => 30, :autocomplete => "off" 
 label_tag :memo, "Memo to User:", :class => "required" 
 text_field_tag :memo, "", :size => 60 
 submit_tag "Send Invitation" 
 end 
 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

private

  def user_params
    params.require(:user).permit(
      :username, :email, :password, :password_confirmation, :about,
      :email_replies, :email_messages, :email_mentions,
      :pushover_replies, :pushover_messages, :pushover_mentions,
      :mailing_list_mode, :show_avatars, :show_story_previews,
      :show_submitted_story_threads
    )
  end
end
