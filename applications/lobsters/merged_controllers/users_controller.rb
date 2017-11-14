class UsersController < ApplicationController
  before_filter :require_logged_in_moderator, :only => [ :ban, :unban ]

  def show
    @showing_user = User.where(:username => params[:username]).first!
    @title = "User #{@showing_user.username}"

    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 if !@showing_user.is_active? 
 elsif @showing_user.is_new? 
 else 
 end 
 @showing_user.username 
 if @user && @showing_user.is_active? 
 @showing_user.username 
 end 
 if @showing_user.is_active? 
 @showing_user.avatar_url(100) 
 @showing_user.avatar_url(100) 
 @showing_user.avatar_url(200) 
 end 
 @showing_user.is_banned? ? raw("style=\"color: red;\"") : "" 
 if @showing_user.is_banned? 
 elsif !@showing_user.is_active? 
 else 
 end 
 @showing_user.is_admin? ? "administrator" :
      (@showing_user.is_moderator? ? "moderator" : "user") 
 time_ago_in_words_label(@showing_user.created_at) 
 if @showing_user.invited_by_user 
 link_to @showing_user.invited_by_user.try(:username),
        @showing_user.invited_by_user 
 end 
 if @showing_user.is_banned? 
 time_ago_in_words_label(@showing_user.banned_at) 
 if @showing_user.banned_by_user 
 link_to @showing_user.banned_by_user.try(:username),
          @showing_user.banned_by_user 
 @showing_user.banned_reason 
 end 
 end 
 if @showing_user.hats.any? 
 @showing_user.hats.each do |hat| 
 hat.to_html_label 
 end 
 end 
 if @showing_user.deleted_at? 
 time_ago_in_words_label(@showing_user.deleted_at) 
 end 
 if !@showing_user.is_admin? 
 @showing_user.karma 

        number_with_precision(@showing_user.average_karma, :precision => 2) 
 end 
 tag = @showing_user.most_common_story_tag 
 @showing_user.username 

      @showing_user.stories_submitted_count 
 tag ? ", " : "" 
 if tag 
 tag_path(tag.tag) 
 tag.css_class 
 tag.description 

        tag.tag 
 end 
 @showing_user.username 

      @showing_user.comments_posted_count 
 if @showing_user.is_active? 
 if @showing_user.about.present? 
 raw @showing_user.linkified_about 
 else 
 end 
 end 
 if @user && @user.is_admin? && !@showing_user.is_moderator? 
 @showing_user.email 
 @showing_user.votes_for_others.limit(10).each do |v| 
 if v.vote == 1 
 else 
 v.vote 
 if v.comment_id 
 Vote::COMMENT_REASONS[v.reason] 
 else 
 Vote::STORY_REASONS[v.reason] 
 end 
 end 
 if v.comment_id 
 v.comment.short_id_url 
 v.comment.user.try(:username) 
 
            v.comment.user.try(:username) 
 v.story.short_id_url 
 v.story.title 
 elsif v.story_id && !v.comment_id 
 v.story.short_id_url 
 v.story.title 
 v.story.user.try(:username) 

            v.story.user.try(:username) 
 end 
 end 
 if @user.is_banned? 
 form_tag user_unban_path, :method => :post do 
 submit_tag "Unban User" 
 end 
 else 
 form_tag user_ban_path, :method => :post do 
 label_tag :reason, "Reason:", :class => "required" 
 text_field_tag :reason, "", :size => 40 
 submit_tag "Ban User" 
 end 
 end 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end
 }
      format.json { render :json => @showing_user }
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
 if !@showing_user.is_active? 
 elsif @showing_user.is_new? 
 else 
 end 
 @showing_user.username 
 if @user && @showing_user.is_active? 
 @showing_user.username 
 end 
 if @showing_user.is_active? 
 @showing_user.avatar_url(100) 
 @showing_user.avatar_url(100) 
 @showing_user.avatar_url(200) 
 end 
 @showing_user.is_banned? ? raw("style=\"color: red;\"") : "" 
 if @showing_user.is_banned? 
 elsif !@showing_user.is_active? 
 else 
 end 
 @showing_user.is_admin? ? "administrator" :
      (@showing_user.is_moderator? ? "moderator" : "user") 
 time_ago_in_words_label(@showing_user.created_at) 
 if @showing_user.invited_by_user 
 link_to @showing_user.invited_by_user.try(:username),
        @showing_user.invited_by_user 
 end 
 if @showing_user.is_banned? 
 time_ago_in_words_label(@showing_user.banned_at) 
 if @showing_user.banned_by_user 
 link_to @showing_user.banned_by_user.try(:username),
          @showing_user.banned_by_user 
 @showing_user.banned_reason 
 end 
 end 
 if @showing_user.hats.any? 
 @showing_user.hats.each do |hat| 
 hat.to_html_label 
 end 
 end 
 if @showing_user.deleted_at? 
 time_ago_in_words_label(@showing_user.deleted_at) 
 end 
 if !@showing_user.is_admin? 
 @showing_user.karma 

        number_with_precision(@showing_user.average_karma, :precision => 2) 
 end 
 tag = @showing_user.most_common_story_tag 
 @showing_user.username 

      @showing_user.stories_submitted_count 
 tag ? ", " : "" 
 if tag 
 tag_path(tag.tag) 
 tag.css_class 
 tag.description 

        tag.tag 
 end 
 @showing_user.username 

      @showing_user.comments_posted_count 
 if @showing_user.is_active? 
 if @showing_user.about.present? 
 raw @showing_user.linkified_about 
 else 
 end 
 end 
 if @user && @user.is_admin? && !@showing_user.is_moderator? 
 @showing_user.email 
 @showing_user.votes_for_others.limit(10).each do |v| 
 if v.vote == 1 
 else 
 v.vote 
 if v.comment_id 
 Vote::COMMENT_REASONS[v.reason] 
 else 
 Vote::STORY_REASONS[v.reason] 
 end 
 end 
 if v.comment_id 
 v.comment.short_id_url 
 v.comment.user.try(:username) 
 
            v.comment.user.try(:username) 
 v.story.short_id_url 
 v.story.title 
 elsif v.story_id && !v.comment_id 
 v.story.short_id_url 
 v.story.title 
 v.story.user.try(:username) 

            v.story.user.try(:username) 
 end 
 end 
 if @user.is_banned? 
 form_tag user_unban_path, :method => :post do 
 submit_tag "Unban User" 
 end 
 else 
 form_tag user_ban_path, :method => :post do 
 label_tag :reason, "Reason:", :class => "required" 
 text_field_tag :reason, "", :size => 40 
 submit_tag "Ban User" 
 end 
 end 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def tree
    @title = "Users"

    if params[:by].to_s == "karma"
      @users = User.order("karma DESC, id ASC").to_a
      @user_count = @users.length
      @title << " By Karma"
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
 @title 
 @user_count 
 @users.each do |user| 
 user.username 
 if !user.is_active? 
 elsif user.is_new? 
 end 
 user.username 
 if user.is_admin? 
 else 
 user.karma 
 if user.is_moderator? 
 end 
 end 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

    elsif params[:moderators]
      @users = User.where("is_admin = 1 OR is_moderator = 1").
        order("id ASC").to_a
      @user_count = @users.length
      @title = "Moderators and Administrators"
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
 @title 
 @user_count 
 @users.each do |user| 
 user.username 
 if !user.is_active? 
 elsif user.is_new? 
 end 
 user.username 
 if user.is_admin? 
 else 
 user.karma 
 if user.is_moderator? 
 end 
 end 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

    else
      users = User.order("id DESC").to_a
      @user_count = users.length
      @users_by_parent = users.group_by(&:invited_by_user_id)
      @newest = User.order("id DESC").limit(10)
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
 @title 
 @user_count 
 raw @newest.map{|u| "<a href=\"/u/#{u.username}\" class=\"" <<
    (u.is_new?? "new_user" : "") << "\">#{u.username}</a> " <<
    "(#{u.karma})" }.join(", ") 
 subtree = @users_by_parent[nil] 
 ancestors = [] 
 while subtree 
 if (user = subtree.pop) 
 user.username 
 if !user.is_active? 
 elsif user.is_new? 
 end 
 user.username 
 if user.is_admin? 
 else 
 user.karma 
 if user.is_moderator? 
 end 
 end 
 if (children = @users_by_parent[user.id]) 
 # drill down deeper in the tree 
 ancestors << subtree 
 subtree = children 
 else 
 end 
 else 
 # climb back out 
 subtree = ancestors.pop 
 if subtree 
 end 
 end 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def invite
    @title = "Pass Along an Invitation"
  end

  def ban
    buser = User.where(:username => params[:username]).first
    if !buser
      flash[:error] = "Invalid user."
      return redirect_to "/"
    end

    if !params[:reason].present?
      flash[:error] = "You must give a reason for the ban."
      return redirect_to user_path(:user => buser.username)
    end

    buser.ban_by_user_for_reason!(@user, params[:reason])

    flash[:success] = "User has been banned."
    return redirect_to user_path(:user => buser.username)
  end

  def unban
    buser = User.where(:username => params[:username]).first
    if !buser
      flash[:error] = "Invalid user."
      return redirect_to "/"
    end

    buser.unban_by_user!(@user)

    flash[:success] = "User has been unbanned."
    return redirect_to user_path(:user => buser.username)
  end
end
