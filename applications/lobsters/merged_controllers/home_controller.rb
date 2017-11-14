class HomeController < ApplicationController
  # for rss feeds, load the user's tag filters if a token is passed
  before_filter :find_user_from_rss_token, :only => [ :index, :newest ]
  before_filter { @page = page }
  before_filter :require_logged_in_user, :only => [ :upvoted ]

  def about
#    begin
      render :action => "about"
#    rescue
#      render :text => "<div class=\"box wide\">" <<
#        "A mystery." <<
#        "</div>", :layout => "application"
#    end
  end

  def chat
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
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end
end

  def privacy
 #   begin
      render :action => "privacy"
#    rescue
 #     render :text => "<div class=\"box wide\">" <<
#        "You apparently have no privacy." <<
#        "</div>", :layout => "application"
#    end
  end

  def hidden
    @stories, @show_more = get_from_cache(hidden: true) {
      paginate stories.hidden
    }

    @heading = @title = "Hidden Stories"
    @cur_url = "/hidden"

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
 if @cur_url == "/recent" 
 end 
 @cur_url == "/hidden" ? "show_hidden" : "" 
  story.short_id 
 story.short_id 
 story.vote && story.vote[:vote] == 1 ? "upvoted" : "" 
 story.vote && story.vote[:vote] == -1 ? "downvoted" : "" 
 story.score <= -1 ? "negative_1" : "" 
 story.score <= -3 ? "negative_3" : "" 
 story.score <= -5 ? "negative_5" : "" 
 story.is_hidden_by_cur_user ? "hidden" : "" 
 story.is_expired? ? "expired" : "" 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 story.score 
 if story.can_be_seen_by_user?(@user) 
 story.url_or_comments_path 

          break_long_words(story.title) 
 end 
 if story.is_gone? 
 story.is_moderated? ? "moderator" :
          "original submitter" 
 end 
 if story.markeddown_description.present? 
 story.comments_path 
 end 
 if story.can_be_seen_by_user?(@user) 
 story.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if story.domain.present? 
 story.domain_search_url 

          break_long_words(story.domain) 
 end 
 if defined?(single_story) && single_story 
 story.merged_stories.each do |ms| 
 ms.url_or_comments_path 

              break_long_words(ms.title) 
 ms.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if ms.domain.present? 
 ms.domain_search_url 

              break_long_words(ms.domain) 
 end 
 if (@user && @user.show_avatars?) || !@user 
 ms.user.username 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(32) 
 end 
 if story.user_is_author? 
 else 
 end 
 ms.user.username 

              ms.html_class_for_user 
 ms.user.username 
 time_ago_in_words_label(ms.created_at, :strip_about => true) 
 end 
 end 
 end 
 if !(defined?(single_story) && single_story) && @user &&
    @user.show_story_previews? 
 if (sc = story.description_or_story_cache(500)).present? 
 break_long_words(sc) 
 end 
 end 
 if (@user && @user.show_avatars?) || !@user 
 story.user.username 
 story.user.avatar_url(16) 
 story.user.avatar_url(16) 
 story.user.avatar_url(32) 
 end 
 if story.previewing 
 if story.user_is_author? 
 else 
 end 
 story.html_class_for_user 

          story.user.username 
 else 
 if story.user_is_author? 
 else 
 end 
 story.user.username 

          story.html_class_for_user 
 story.user.username 
 time_ago_in_words_label(story.created_at, :strip_about => true) 
 if story.is_editable_by_user?(@user) 
 edit_story_path(story.short_id) 
 if story.is_gone? && story.is_undeletable_by_user?(@user) 
 link_to "undelete", story_undelete_path(story.short_id),
              :method => :post, :data => {
              :confirm => "Are you sure you want to undelete this story?" } 
 elsif !story.is_gone? 
 if story.user_id != @user.try(:id) &&
            @user.try(:is_moderator?) 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :class => "mod_story_link" 
 else 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :data => {
                :confirm => "Are you sure you want to delete this story?" } 
 end 
 end 
 end 
 if story.can_have_suggestions_from_user?(@user) 
 link_to "suggest", story_suggest_path(story.short_id),
            :class => "suggester" 
 end 
 if !story.is_gone? && @user 
 if @user && story.vote && story.vote[:vote] == -1 

              Vote::STORY_REASONS[story.vote[:reason]].to_s.downcase 
 elsif @user && @user.can_downvote?(story) 
 end 
 if story.is_hidden_by_cur_user 
 link_to "unhide", story_unhide_path(story.short_id),
              :class => "hider" 
 else 
 link_to "hide", story_hide_path(story.short_id),
              :class => "hider" 
 end 
 if defined?(single_story) && single_story && story.hider_count > 0 
 pluralize(story.hider_count, "user") 
 end 
 end 
 if story.url.present? 
 story.url 
 end 
 if !story.is_gone? 
 story.comments_path 
 if story.comments_count == 0 
 if @user 
 else 
 end 
 else 
 story.comments_count 
 story.comments_count == 1 ? "" : "s" 
 end 
 end 
 if defined?(single_story) && single_story &&
        ((story.downvotes > 0 && @user && @user.is_moderator?) ||
        (story.downvotes >= 3 || story.score <= 0)) 
 story.vote_summary_for(@user).downcase 
 end 
 end 
 story.comments_count == 0 ? "zero" : "" 
 story.comments_path 
 story.comments_count 
 
 if @page && @page > 1 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page == 2 ? "" : "page/#{@page - 1}" 
 @page - 1 
 end 
 if @show_more 
 if @page && @page > 1 
 end 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page + 1 
 @page + 1 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def index
    @stories, @show_more = get_from_cache(hottest: true) {
      paginate stories.hottest
    }

    @rss_link ||= { :title => "RSS 2.0",
      :href => "/rss#{@user ? "?token=#{@user.rss_token}" : ""}" }
    @comments_rss_link ||= { :title => "Comments - RSS 2.0",
      :href => "/comments.rss#{@user ? "?token=#{@user.rss_token}" : ""}" }

    @heading = @title = ""
    @cur_url = "/"

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
 if @cur_url == "/recent" 
 end 
 @cur_url == "/hidden" ? "show_hidden" : "" 
  story.short_id 
 story.short_id 
 story.vote && story.vote[:vote] == 1 ? "upvoted" : "" 
 story.vote && story.vote[:vote] == -1 ? "downvoted" : "" 
 story.score <= -1 ? "negative_1" : "" 
 story.score <= -3 ? "negative_3" : "" 
 story.score <= -5 ? "negative_5" : "" 
 story.is_hidden_by_cur_user ? "hidden" : "" 
 story.is_expired? ? "expired" : "" 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 story.score 
 if story.can_be_seen_by_user?(@user) 
 story.url_or_comments_path 

          break_long_words(story.title) 
 end 
 if story.is_gone? 
 story.is_moderated? ? "moderator" :
          "original submitter" 
 end 
 if story.markeddown_description.present? 
 story.comments_path 
 end 
 if story.can_be_seen_by_user?(@user) 
 story.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if story.domain.present? 
 story.domain_search_url 

          break_long_words(story.domain) 
 end 
 if defined?(single_story) && single_story 
 story.merged_stories.each do |ms| 
 ms.url_or_comments_path 

              break_long_words(ms.title) 
 ms.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if ms.domain.present? 
 ms.domain_search_url 

              break_long_words(ms.domain) 
 end 
 if (@user && @user.show_avatars?) || !@user 
 ms.user.username 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(32) 
 end 
 if story.user_is_author? 
 else 
 end 
 ms.user.username 

              ms.html_class_for_user 
 ms.user.username 
 time_ago_in_words_label(ms.created_at, :strip_about => true) 
 end 
 end 
 end 
 if !(defined?(single_story) && single_story) && @user &&
    @user.show_story_previews? 
 if (sc = story.description_or_story_cache(500)).present? 
 break_long_words(sc) 
 end 
 end 
 if (@user && @user.show_avatars?) || !@user 
 story.user.username 
 story.user.avatar_url(16) 
 story.user.avatar_url(16) 
 story.user.avatar_url(32) 
 end 
 if story.previewing 
 if story.user_is_author? 
 else 
 end 
 story.html_class_for_user 

          story.user.username 
 else 
 if story.user_is_author? 
 else 
 end 
 story.user.username 

          story.html_class_for_user 
 story.user.username 
 time_ago_in_words_label(story.created_at, :strip_about => true) 
 if story.is_editable_by_user?(@user) 
 edit_story_path(story.short_id) 
 if story.is_gone? && story.is_undeletable_by_user?(@user) 
 link_to "undelete", story_undelete_path(story.short_id),
              :method => :post, :data => {
              :confirm => "Are you sure you want to undelete this story?" } 
 elsif !story.is_gone? 
 if story.user_id != @user.try(:id) &&
            @user.try(:is_moderator?) 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :class => "mod_story_link" 
 else 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :data => {
                :confirm => "Are you sure you want to delete this story?" } 
 end 
 end 
 end 
 if story.can_have_suggestions_from_user?(@user) 
 link_to "suggest", story_suggest_path(story.short_id),
            :class => "suggester" 
 end 
 if !story.is_gone? && @user 
 if @user && story.vote && story.vote[:vote] == -1 

              Vote::STORY_REASONS[story.vote[:reason]].to_s.downcase 
 elsif @user && @user.can_downvote?(story) 
 end 
 if story.is_hidden_by_cur_user 
 link_to "unhide", story_unhide_path(story.short_id),
              :class => "hider" 
 else 
 link_to "hide", story_hide_path(story.short_id),
              :class => "hider" 
 end 
 if defined?(single_story) && single_story && story.hider_count > 0 
 pluralize(story.hider_count, "user") 
 end 
 end 
 if story.url.present? 
 story.url 
 end 
 if !story.is_gone? 
 story.comments_path 
 if story.comments_count == 0 
 if @user 
 else 
 end 
 else 
 story.comments_count 
 story.comments_count == 1 ? "" : "s" 
 end 
 end 
 if defined?(single_story) && single_story &&
        ((story.downvotes > 0 && @user && @user.is_moderator?) ||
        (story.downvotes >= 3 || story.score <= 0)) 
 story.vote_summary_for(@user).downcase 
 end 
 end 
 story.comments_count == 0 ? "zero" : "" 
 story.comments_path 
 story.comments_count 
 
 if @page && @page > 1 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page == 2 ? "" : "page/#{@page - 1}" 
 @page - 1 
 end 
 if @show_more 
 if @page && @page > 1 
 end 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page + 1 
 @page + 1 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end
 }
      format.rss {
        if @user && params[:token].present?
          @title = "Private feed for #{@user.username}"
        end

        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 coder = HTMLEntities.new 
 Rails.application.name 
 @title.present? ?
      ": " + h(@title) : "" 
 @title 
 Rails.application.root_url + (@newest ? "newest" : "") 
 @stories.each do |story| 
 raw coder.encode(story.title, :decimal) 
 story.url_or_comments_url 
 story.short_id_url 
 story.user.username 
 story.created_at.rfc2822 
 story.comments_url 
 raw coder.encode(story.markeddown_description, :decimal) 
 if story.url.present? 
 raw coder.encode("<p>" +
              link_to("Comments", story.comments_url) + "</p>", :decimal) 
 end 
 story.taggings.each do |tagging| 
 tagging.tag.tag 
 end 
 end 

end

      }
      format.json { render :json => @stories }
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
 if @cur_url == "/recent" 
 end 
 @cur_url == "/hidden" ? "show_hidden" : "" 
  story.short_id 
 story.short_id 
 story.vote && story.vote[:vote] == 1 ? "upvoted" : "" 
 story.vote && story.vote[:vote] == -1 ? "downvoted" : "" 
 story.score <= -1 ? "negative_1" : "" 
 story.score <= -3 ? "negative_3" : "" 
 story.score <= -5 ? "negative_5" : "" 
 story.is_hidden_by_cur_user ? "hidden" : "" 
 story.is_expired? ? "expired" : "" 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 story.score 
 if story.can_be_seen_by_user?(@user) 
 story.url_or_comments_path 

          break_long_words(story.title) 
 end 
 if story.is_gone? 
 story.is_moderated? ? "moderator" :
          "original submitter" 
 end 
 if story.markeddown_description.present? 
 story.comments_path 
 end 
 if story.can_be_seen_by_user?(@user) 
 story.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if story.domain.present? 
 story.domain_search_url 

          break_long_words(story.domain) 
 end 
 if defined?(single_story) && single_story 
 story.merged_stories.each do |ms| 
 ms.url_or_comments_path 

              break_long_words(ms.title) 
 ms.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if ms.domain.present? 
 ms.domain_search_url 

              break_long_words(ms.domain) 
 end 
 if (@user && @user.show_avatars?) || !@user 
 ms.user.username 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(32) 
 end 
 if story.user_is_author? 
 else 
 end 
 ms.user.username 

              ms.html_class_for_user 
 ms.user.username 
 time_ago_in_words_label(ms.created_at, :strip_about => true) 
 end 
 end 
 end 
 if !(defined?(single_story) && single_story) && @user &&
    @user.show_story_previews? 
 if (sc = story.description_or_story_cache(500)).present? 
 break_long_words(sc) 
 end 
 end 
 if (@user && @user.show_avatars?) || !@user 
 story.user.username 
 story.user.avatar_url(16) 
 story.user.avatar_url(16) 
 story.user.avatar_url(32) 
 end 
 if story.previewing 
 if story.user_is_author? 
 else 
 end 
 story.html_class_for_user 

          story.user.username 
 else 
 if story.user_is_author? 
 else 
 end 
 story.user.username 

          story.html_class_for_user 
 story.user.username 
 time_ago_in_words_label(story.created_at, :strip_about => true) 
 if story.is_editable_by_user?(@user) 
 edit_story_path(story.short_id) 
 if story.is_gone? && story.is_undeletable_by_user?(@user) 
 link_to "undelete", story_undelete_path(story.short_id),
              :method => :post, :data => {
              :confirm => "Are you sure you want to undelete this story?" } 
 elsif !story.is_gone? 
 if story.user_id != @user.try(:id) &&
            @user.try(:is_moderator?) 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :class => "mod_story_link" 
 else 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :data => {
                :confirm => "Are you sure you want to delete this story?" } 
 end 
 end 
 end 
 if story.can_have_suggestions_from_user?(@user) 
 link_to "suggest", story_suggest_path(story.short_id),
            :class => "suggester" 
 end 
 if !story.is_gone? && @user 
 if @user && story.vote && story.vote[:vote] == -1 

              Vote::STORY_REASONS[story.vote[:reason]].to_s.downcase 
 elsif @user && @user.can_downvote?(story) 
 end 
 if story.is_hidden_by_cur_user 
 link_to "unhide", story_unhide_path(story.short_id),
              :class => "hider" 
 else 
 link_to "hide", story_hide_path(story.short_id),
              :class => "hider" 
 end 
 if defined?(single_story) && single_story && story.hider_count > 0 
 pluralize(story.hider_count, "user") 
 end 
 end 
 if story.url.present? 
 story.url 
 end 
 if !story.is_gone? 
 story.comments_path 
 if story.comments_count == 0 
 if @user 
 else 
 end 
 else 
 story.comments_count 
 story.comments_count == 1 ? "" : "s" 
 end 
 end 
 if defined?(single_story) && single_story &&
        ((story.downvotes > 0 && @user && @user.is_moderator?) ||
        (story.downvotes >= 3 || story.score <= 0)) 
 story.vote_summary_for(@user).downcase 
 end 
 end 
 story.comments_count == 0 ? "zero" : "" 
 story.comments_path 
 story.comments_count 
 
 if @page && @page > 1 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page == 2 ? "" : "page/#{@page - 1}" 
 @page - 1 
 end 
 if @show_more 
 if @page && @page > 1 
 end 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page + 1 
 @page + 1 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def newest
    @stories, @show_more = get_from_cache(newest: true) {
      paginate stories.newest
    }

    @heading = @title = "Newest Stories"
    @cur_url = "/newest"

    @rss_link = { :title => "RSS 2.0 - Newest Items",
      :href => "/newest.rss#{@user ? "?token=#{@user.rss_token}" : ""}" }

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
 if @cur_url == "/recent" 
 end 
 @cur_url == "/hidden" ? "show_hidden" : "" 
  story.short_id 
 story.short_id 
 story.vote && story.vote[:vote] == 1 ? "upvoted" : "" 
 story.vote && story.vote[:vote] == -1 ? "downvoted" : "" 
 story.score <= -1 ? "negative_1" : "" 
 story.score <= -3 ? "negative_3" : "" 
 story.score <= -5 ? "negative_5" : "" 
 story.is_hidden_by_cur_user ? "hidden" : "" 
 story.is_expired? ? "expired" : "" 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 story.score 
 if story.can_be_seen_by_user?(@user) 
 story.url_or_comments_path 

          break_long_words(story.title) 
 end 
 if story.is_gone? 
 story.is_moderated? ? "moderator" :
          "original submitter" 
 end 
 if story.markeddown_description.present? 
 story.comments_path 
 end 
 if story.can_be_seen_by_user?(@user) 
 story.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if story.domain.present? 
 story.domain_search_url 

          break_long_words(story.domain) 
 end 
 if defined?(single_story) && single_story 
 story.merged_stories.each do |ms| 
 ms.url_or_comments_path 

              break_long_words(ms.title) 
 ms.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if ms.domain.present? 
 ms.domain_search_url 

              break_long_words(ms.domain) 
 end 
 if (@user && @user.show_avatars?) || !@user 
 ms.user.username 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(32) 
 end 
 if story.user_is_author? 
 else 
 end 
 ms.user.username 

              ms.html_class_for_user 
 ms.user.username 
 time_ago_in_words_label(ms.created_at, :strip_about => true) 
 end 
 end 
 end 
 if !(defined?(single_story) && single_story) && @user &&
    @user.show_story_previews? 
 if (sc = story.description_or_story_cache(500)).present? 
 break_long_words(sc) 
 end 
 end 
 if (@user && @user.show_avatars?) || !@user 
 story.user.username 
 story.user.avatar_url(16) 
 story.user.avatar_url(16) 
 story.user.avatar_url(32) 
 end 
 if story.previewing 
 if story.user_is_author? 
 else 
 end 
 story.html_class_for_user 

          story.user.username 
 else 
 if story.user_is_author? 
 else 
 end 
 story.user.username 

          story.html_class_for_user 
 story.user.username 
 time_ago_in_words_label(story.created_at, :strip_about => true) 
 if story.is_editable_by_user?(@user) 
 edit_story_path(story.short_id) 
 if story.is_gone? && story.is_undeletable_by_user?(@user) 
 link_to "undelete", story_undelete_path(story.short_id),
              :method => :post, :data => {
              :confirm => "Are you sure you want to undelete this story?" } 
 elsif !story.is_gone? 
 if story.user_id != @user.try(:id) &&
            @user.try(:is_moderator?) 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :class => "mod_story_link" 
 else 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :data => {
                :confirm => "Are you sure you want to delete this story?" } 
 end 
 end 
 end 
 if story.can_have_suggestions_from_user?(@user) 
 link_to "suggest", story_suggest_path(story.short_id),
            :class => "suggester" 
 end 
 if !story.is_gone? && @user 
 if @user && story.vote && story.vote[:vote] == -1 

              Vote::STORY_REASONS[story.vote[:reason]].to_s.downcase 
 elsif @user && @user.can_downvote?(story) 
 end 
 if story.is_hidden_by_cur_user 
 link_to "unhide", story_unhide_path(story.short_id),
              :class => "hider" 
 else 
 link_to "hide", story_hide_path(story.short_id),
              :class => "hider" 
 end 
 if defined?(single_story) && single_story && story.hider_count > 0 
 pluralize(story.hider_count, "user") 
 end 
 end 
 if story.url.present? 
 story.url 
 end 
 if !story.is_gone? 
 story.comments_path 
 if story.comments_count == 0 
 if @user 
 else 
 end 
 else 
 story.comments_count 
 story.comments_count == 1 ? "" : "s" 
 end 
 end 
 if defined?(single_story) && single_story &&
        ((story.downvotes > 0 && @user && @user.is_moderator?) ||
        (story.downvotes >= 3 || story.score <= 0)) 
 story.vote_summary_for(@user).downcase 
 end 
 end 
 story.comments_count == 0 ? "zero" : "" 
 story.comments_path 
 story.comments_count 
 
 if @page && @page > 1 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page == 2 ? "" : "page/#{@page - 1}" 
 @page - 1 
 end 
 if @show_more 
 if @page && @page > 1 
 end 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page + 1 
 @page + 1 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end
 }
      format.rss {
        if @user && params[:token].present?
          @title += " - Private feed for #{@user.username}"
        end

        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 coder = HTMLEntities.new 
 Rails.application.name 
 @title.present? ?
      ": " + h(@title) : "" 
 @title 
 Rails.application.root_url + (@newest ? "newest" : "") 
 @stories.each do |story| 
 raw coder.encode(story.title, :decimal) 
 story.url_or_comments_url 
 story.short_id_url 
 story.user.username 
 story.created_at.rfc2822 
 story.comments_url 
 raw coder.encode(story.markeddown_description, :decimal) 
 if story.url.present? 
 raw coder.encode("<p>" +
              link_to("Comments", story.comments_url) + "</p>", :decimal) 
 end 
 story.taggings.each do |tagging| 
 tagging.tag.tag 
 end 
 end 

end

      }
      format.json { render :json => @stories }
    end
  end

  def newest_by_user
    by_user = User.where(:username => params[:user]).first!

    @stories, @show_more = get_from_cache(by_user: by_user) {
      paginate stories.newest_by_user(by_user)
    }

    @heading = @title = "Newest Stories by #{by_user.username}"
    @cur_url = "/newest/#{by_user.username}"

    @newest = true
    @for_user = by_user.username

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
 if @cur_url == "/recent" 
 end 
 @cur_url == "/hidden" ? "show_hidden" : "" 
  story.short_id 
 story.short_id 
 story.vote && story.vote[:vote] == 1 ? "upvoted" : "" 
 story.vote && story.vote[:vote] == -1 ? "downvoted" : "" 
 story.score <= -1 ? "negative_1" : "" 
 story.score <= -3 ? "negative_3" : "" 
 story.score <= -5 ? "negative_5" : "" 
 story.is_hidden_by_cur_user ? "hidden" : "" 
 story.is_expired? ? "expired" : "" 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 story.score 
 if story.can_be_seen_by_user?(@user) 
 story.url_or_comments_path 

          break_long_words(story.title) 
 end 
 if story.is_gone? 
 story.is_moderated? ? "moderator" :
          "original submitter" 
 end 
 if story.markeddown_description.present? 
 story.comments_path 
 end 
 if story.can_be_seen_by_user?(@user) 
 story.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if story.domain.present? 
 story.domain_search_url 

          break_long_words(story.domain) 
 end 
 if defined?(single_story) && single_story 
 story.merged_stories.each do |ms| 
 ms.url_or_comments_path 

              break_long_words(ms.title) 
 ms.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if ms.domain.present? 
 ms.domain_search_url 

              break_long_words(ms.domain) 
 end 
 if (@user && @user.show_avatars?) || !@user 
 ms.user.username 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(32) 
 end 
 if story.user_is_author? 
 else 
 end 
 ms.user.username 

              ms.html_class_for_user 
 ms.user.username 
 time_ago_in_words_label(ms.created_at, :strip_about => true) 
 end 
 end 
 end 
 if !(defined?(single_story) && single_story) && @user &&
    @user.show_story_previews? 
 if (sc = story.description_or_story_cache(500)).present? 
 break_long_words(sc) 
 end 
 end 
 if (@user && @user.show_avatars?) || !@user 
 story.user.username 
 story.user.avatar_url(16) 
 story.user.avatar_url(16) 
 story.user.avatar_url(32) 
 end 
 if story.previewing 
 if story.user_is_author? 
 else 
 end 
 story.html_class_for_user 

          story.user.username 
 else 
 if story.user_is_author? 
 else 
 end 
 story.user.username 

          story.html_class_for_user 
 story.user.username 
 time_ago_in_words_label(story.created_at, :strip_about => true) 
 if story.is_editable_by_user?(@user) 
 edit_story_path(story.short_id) 
 if story.is_gone? && story.is_undeletable_by_user?(@user) 
 link_to "undelete", story_undelete_path(story.short_id),
              :method => :post, :data => {
              :confirm => "Are you sure you want to undelete this story?" } 
 elsif !story.is_gone? 
 if story.user_id != @user.try(:id) &&
            @user.try(:is_moderator?) 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :class => "mod_story_link" 
 else 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :data => {
                :confirm => "Are you sure you want to delete this story?" } 
 end 
 end 
 end 
 if story.can_have_suggestions_from_user?(@user) 
 link_to "suggest", story_suggest_path(story.short_id),
            :class => "suggester" 
 end 
 if !story.is_gone? && @user 
 if @user && story.vote && story.vote[:vote] == -1 

              Vote::STORY_REASONS[story.vote[:reason]].to_s.downcase 
 elsif @user && @user.can_downvote?(story) 
 end 
 if story.is_hidden_by_cur_user 
 link_to "unhide", story_unhide_path(story.short_id),
              :class => "hider" 
 else 
 link_to "hide", story_hide_path(story.short_id),
              :class => "hider" 
 end 
 if defined?(single_story) && single_story && story.hider_count > 0 
 pluralize(story.hider_count, "user") 
 end 
 end 
 if story.url.present? 
 story.url 
 end 
 if !story.is_gone? 
 story.comments_path 
 if story.comments_count == 0 
 if @user 
 else 
 end 
 else 
 story.comments_count 
 story.comments_count == 1 ? "" : "s" 
 end 
 end 
 if defined?(single_story) && single_story &&
        ((story.downvotes > 0 && @user && @user.is_moderator?) ||
        (story.downvotes >= 3 || story.score <= 0)) 
 story.vote_summary_for(@user).downcase 
 end 
 end 
 story.comments_count == 0 ? "zero" : "" 
 story.comments_path 
 story.comments_count 
 
 if @page && @page > 1 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page == 2 ? "" : "page/#{@page - 1}" 
 @page - 1 
 end 
 if @show_more 
 if @page && @page > 1 
 end 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page + 1 
 @page + 1 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def recent
    @stories, @show_more = get_from_cache(recent: true) {
      scope = if page == 1
        stories.recent
      else
        stories.newest
      end
      paginate scope
    }

    @heading = @title = "Recent Stories"
    @cur_url = "/recent"

    # our content changes every page load, so point at /newest.rss to be stable
    @rss_link = { :title => "RSS 2.0 - Newest Items",
      :href => "/newest.rss#{@user ? "?token=#{@user.rss_token}" : ""}" }

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
 if @cur_url == "/recent" 
 end 
 @cur_url == "/hidden" ? "show_hidden" : "" 
  story.short_id 
 story.short_id 
 story.vote && story.vote[:vote] == 1 ? "upvoted" : "" 
 story.vote && story.vote[:vote] == -1 ? "downvoted" : "" 
 story.score <= -1 ? "negative_1" : "" 
 story.score <= -3 ? "negative_3" : "" 
 story.score <= -5 ? "negative_5" : "" 
 story.is_hidden_by_cur_user ? "hidden" : "" 
 story.is_expired? ? "expired" : "" 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 story.score 
 if story.can_be_seen_by_user?(@user) 
 story.url_or_comments_path 

          break_long_words(story.title) 
 end 
 if story.is_gone? 
 story.is_moderated? ? "moderator" :
          "original submitter" 
 end 
 if story.markeddown_description.present? 
 story.comments_path 
 end 
 if story.can_be_seen_by_user?(@user) 
 story.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if story.domain.present? 
 story.domain_search_url 

          break_long_words(story.domain) 
 end 
 if defined?(single_story) && single_story 
 story.merged_stories.each do |ms| 
 ms.url_or_comments_path 

              break_long_words(ms.title) 
 ms.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if ms.domain.present? 
 ms.domain_search_url 

              break_long_words(ms.domain) 
 end 
 if (@user && @user.show_avatars?) || !@user 
 ms.user.username 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(32) 
 end 
 if story.user_is_author? 
 else 
 end 
 ms.user.username 

              ms.html_class_for_user 
 ms.user.username 
 time_ago_in_words_label(ms.created_at, :strip_about => true) 
 end 
 end 
 end 
 if !(defined?(single_story) && single_story) && @user &&
    @user.show_story_previews? 
 if (sc = story.description_or_story_cache(500)).present? 
 break_long_words(sc) 
 end 
 end 
 if (@user && @user.show_avatars?) || !@user 
 story.user.username 
 story.user.avatar_url(16) 
 story.user.avatar_url(16) 
 story.user.avatar_url(32) 
 end 
 if story.previewing 
 if story.user_is_author? 
 else 
 end 
 story.html_class_for_user 

          story.user.username 
 else 
 if story.user_is_author? 
 else 
 end 
 story.user.username 

          story.html_class_for_user 
 story.user.username 
 time_ago_in_words_label(story.created_at, :strip_about => true) 
 if story.is_editable_by_user?(@user) 
 edit_story_path(story.short_id) 
 if story.is_gone? && story.is_undeletable_by_user?(@user) 
 link_to "undelete", story_undelete_path(story.short_id),
              :method => :post, :data => {
              :confirm => "Are you sure you want to undelete this story?" } 
 elsif !story.is_gone? 
 if story.user_id != @user.try(:id) &&
            @user.try(:is_moderator?) 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :class => "mod_story_link" 
 else 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :data => {
                :confirm => "Are you sure you want to delete this story?" } 
 end 
 end 
 end 
 if story.can_have_suggestions_from_user?(@user) 
 link_to "suggest", story_suggest_path(story.short_id),
            :class => "suggester" 
 end 
 if !story.is_gone? && @user 
 if @user && story.vote && story.vote[:vote] == -1 

              Vote::STORY_REASONS[story.vote[:reason]].to_s.downcase 
 elsif @user && @user.can_downvote?(story) 
 end 
 if story.is_hidden_by_cur_user 
 link_to "unhide", story_unhide_path(story.short_id),
              :class => "hider" 
 else 
 link_to "hide", story_hide_path(story.short_id),
              :class => "hider" 
 end 
 if defined?(single_story) && single_story && story.hider_count > 0 
 pluralize(story.hider_count, "user") 
 end 
 end 
 if story.url.present? 
 story.url 
 end 
 if !story.is_gone? 
 story.comments_path 
 if story.comments_count == 0 
 if @user 
 else 
 end 
 else 
 story.comments_count 
 story.comments_count == 1 ? "" : "s" 
 end 
 end 
 if defined?(single_story) && single_story &&
        ((story.downvotes > 0 && @user && @user.is_moderator?) ||
        (story.downvotes >= 3 || story.score <= 0)) 
 story.vote_summary_for(@user).downcase 
 end 
 end 
 story.comments_count == 0 ? "zero" : "" 
 story.comments_path 
 story.comments_count 
 
 if @page && @page > 1 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page == 2 ? "" : "page/#{@page - 1}" 
 @page - 1 
 end 
 if @show_more 
 if @page && @page > 1 
 end 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page + 1 
 @page + 1 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def tagged
    @tag = Tag.where(:tag => params[:tag]).first!

    @stories, @show_more = get_from_cache(tag: @tag) {
      paginate stories.tagged(@tag)
    }

    @heading = @title = @tag.description.blank?? @tag.tag : @tag.description
    @cur_url = tag_url(@tag.tag)

    @rss_link = { :title => "RSS 2.0 - Tagged #{@tag.tag} (#{@tag.description})",
      :href => "/t/#{@tag.tag}.rss" }

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
 if @cur_url == "/recent" 
 end 
 @cur_url == "/hidden" ? "show_hidden" : "" 
  story.short_id 
 story.short_id 
 story.vote && story.vote[:vote] == 1 ? "upvoted" : "" 
 story.vote && story.vote[:vote] == -1 ? "downvoted" : "" 
 story.score <= -1 ? "negative_1" : "" 
 story.score <= -3 ? "negative_3" : "" 
 story.score <= -5 ? "negative_5" : "" 
 story.is_hidden_by_cur_user ? "hidden" : "" 
 story.is_expired? ? "expired" : "" 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 story.score 
 if story.can_be_seen_by_user?(@user) 
 story.url_or_comments_path 

          break_long_words(story.title) 
 end 
 if story.is_gone? 
 story.is_moderated? ? "moderator" :
          "original submitter" 
 end 
 if story.markeddown_description.present? 
 story.comments_path 
 end 
 if story.can_be_seen_by_user?(@user) 
 story.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if story.domain.present? 
 story.domain_search_url 

          break_long_words(story.domain) 
 end 
 if defined?(single_story) && single_story 
 story.merged_stories.each do |ms| 
 ms.url_or_comments_path 

              break_long_words(ms.title) 
 ms.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if ms.domain.present? 
 ms.domain_search_url 

              break_long_words(ms.domain) 
 end 
 if (@user && @user.show_avatars?) || !@user 
 ms.user.username 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(32) 
 end 
 if story.user_is_author? 
 else 
 end 
 ms.user.username 

              ms.html_class_for_user 
 ms.user.username 
 time_ago_in_words_label(ms.created_at, :strip_about => true) 
 end 
 end 
 end 
 if !(defined?(single_story) && single_story) && @user &&
    @user.show_story_previews? 
 if (sc = story.description_or_story_cache(500)).present? 
 break_long_words(sc) 
 end 
 end 
 if (@user && @user.show_avatars?) || !@user 
 story.user.username 
 story.user.avatar_url(16) 
 story.user.avatar_url(16) 
 story.user.avatar_url(32) 
 end 
 if story.previewing 
 if story.user_is_author? 
 else 
 end 
 story.html_class_for_user 

          story.user.username 
 else 
 if story.user_is_author? 
 else 
 end 
 story.user.username 

          story.html_class_for_user 
 story.user.username 
 time_ago_in_words_label(story.created_at, :strip_about => true) 
 if story.is_editable_by_user?(@user) 
 edit_story_path(story.short_id) 
 if story.is_gone? && story.is_undeletable_by_user?(@user) 
 link_to "undelete", story_undelete_path(story.short_id),
              :method => :post, :data => {
              :confirm => "Are you sure you want to undelete this story?" } 
 elsif !story.is_gone? 
 if story.user_id != @user.try(:id) &&
            @user.try(:is_moderator?) 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :class => "mod_story_link" 
 else 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :data => {
                :confirm => "Are you sure you want to delete this story?" } 
 end 
 end 
 end 
 if story.can_have_suggestions_from_user?(@user) 
 link_to "suggest", story_suggest_path(story.short_id),
            :class => "suggester" 
 end 
 if !story.is_gone? && @user 
 if @user && story.vote && story.vote[:vote] == -1 

              Vote::STORY_REASONS[story.vote[:reason]].to_s.downcase 
 elsif @user && @user.can_downvote?(story) 
 end 
 if story.is_hidden_by_cur_user 
 link_to "unhide", story_unhide_path(story.short_id),
              :class => "hider" 
 else 
 link_to "hide", story_hide_path(story.short_id),
              :class => "hider" 
 end 
 if defined?(single_story) && single_story && story.hider_count > 0 
 pluralize(story.hider_count, "user") 
 end 
 end 
 if story.url.present? 
 story.url 
 end 
 if !story.is_gone? 
 story.comments_path 
 if story.comments_count == 0 
 if @user 
 else 
 end 
 else 
 story.comments_count 
 story.comments_count == 1 ? "" : "s" 
 end 
 end 
 if defined?(single_story) && single_story &&
        ((story.downvotes > 0 && @user && @user.is_moderator?) ||
        (story.downvotes >= 3 || story.score <= 0)) 
 story.vote_summary_for(@user).downcase 
 end 
 end 
 story.comments_count == 0 ? "zero" : "" 
 story.comments_path 
 story.comments_count 
 
 if @page && @page > 1 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page == 2 ? "" : "page/#{@page - 1}" 
 @page - 1 
 end 
 if @show_more 
 if @page && @page > 1 
 end 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page + 1 
 @page + 1 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end
 }
      format.rss { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 coder = HTMLEntities.new 
 Rails.application.name 
 @title.present? ?
      ": " + h(@title) : "" 
 @title 
 Rails.application.root_url + (@newest ? "newest" : "") 
 @stories.each do |story| 
 raw coder.encode(story.title, :decimal) 
 story.url_or_comments_url 
 story.short_id_url 
 story.user.username 
 story.created_at.rfc2822 
 story.comments_url 
 raw coder.encode(story.markeddown_description, :decimal) 
 if story.url.present? 
 raw coder.encode("<p>" +
              link_to("Comments", story.comments_url) + "</p>", :decimal) 
 end 
 story.taggings.each do |tagging| 
 tagging.tag.tag 
 end 
 end 

end
 }
      format.json { render :json => @stories }
    end
  end

  TOP_INTVS = { "d" => "Day", "w" => "Week", "m" => "Month", "y" => "Year" }
  def top
    @cur_url = "/top"
    length = { :dur => 1, :intv => "Week" }

    if m = params[:length].to_s.match(/\A(\d+)([#{TOP_INTVS.keys.join}])\z/)
      length[:dur] = m[1].to_i
      length[:intv] = TOP_INTVS[m[2]]

      @cur_url << "/#{params[:length]}"
    end

    @stories, @show_more = get_from_cache(top: true, length: length) {
      paginate stories.top(length)
    }

    if length[:dur] > 1
      @heading = @title = "Top Stories of the Past #{length[:dur]} " <<
        length[:intv] << "s"
    else
      @heading = @title = "Top Stories of the Past " << length[:intv]
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
 if @cur_url == "/recent" 
 end 
 @cur_url == "/hidden" ? "show_hidden" : "" 
  story.short_id 
 story.short_id 
 story.vote && story.vote[:vote] == 1 ? "upvoted" : "" 
 story.vote && story.vote[:vote] == -1 ? "downvoted" : "" 
 story.score <= -1 ? "negative_1" : "" 
 story.score <= -3 ? "negative_3" : "" 
 story.score <= -5 ? "negative_5" : "" 
 story.is_hidden_by_cur_user ? "hidden" : "" 
 story.is_expired? ? "expired" : "" 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 story.score 
 if story.can_be_seen_by_user?(@user) 
 story.url_or_comments_path 

          break_long_words(story.title) 
 end 
 if story.is_gone? 
 story.is_moderated? ? "moderator" :
          "original submitter" 
 end 
 if story.markeddown_description.present? 
 story.comments_path 
 end 
 if story.can_be_seen_by_user?(@user) 
 story.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if story.domain.present? 
 story.domain_search_url 

          break_long_words(story.domain) 
 end 
 if defined?(single_story) && single_story 
 story.merged_stories.each do |ms| 
 ms.url_or_comments_path 

              break_long_words(ms.title) 
 ms.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if ms.domain.present? 
 ms.domain_search_url 

              break_long_words(ms.domain) 
 end 
 if (@user && @user.show_avatars?) || !@user 
 ms.user.username 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(32) 
 end 
 if story.user_is_author? 
 else 
 end 
 ms.user.username 

              ms.html_class_for_user 
 ms.user.username 
 time_ago_in_words_label(ms.created_at, :strip_about => true) 
 end 
 end 
 end 
 if !(defined?(single_story) && single_story) && @user &&
    @user.show_story_previews? 
 if (sc = story.description_or_story_cache(500)).present? 
 break_long_words(sc) 
 end 
 end 
 if (@user && @user.show_avatars?) || !@user 
 story.user.username 
 story.user.avatar_url(16) 
 story.user.avatar_url(16) 
 story.user.avatar_url(32) 
 end 
 if story.previewing 
 if story.user_is_author? 
 else 
 end 
 story.html_class_for_user 

          story.user.username 
 else 
 if story.user_is_author? 
 else 
 end 
 story.user.username 

          story.html_class_for_user 
 story.user.username 
 time_ago_in_words_label(story.created_at, :strip_about => true) 
 if story.is_editable_by_user?(@user) 
 edit_story_path(story.short_id) 
 if story.is_gone? && story.is_undeletable_by_user?(@user) 
 link_to "undelete", story_undelete_path(story.short_id),
              :method => :post, :data => {
              :confirm => "Are you sure you want to undelete this story?" } 
 elsif !story.is_gone? 
 if story.user_id != @user.try(:id) &&
            @user.try(:is_moderator?) 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :class => "mod_story_link" 
 else 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :data => {
                :confirm => "Are you sure you want to delete this story?" } 
 end 
 end 
 end 
 if story.can_have_suggestions_from_user?(@user) 
 link_to "suggest", story_suggest_path(story.short_id),
            :class => "suggester" 
 end 
 if !story.is_gone? && @user 
 if @user && story.vote && story.vote[:vote] == -1 

              Vote::STORY_REASONS[story.vote[:reason]].to_s.downcase 
 elsif @user && @user.can_downvote?(story) 
 end 
 if story.is_hidden_by_cur_user 
 link_to "unhide", story_unhide_path(story.short_id),
              :class => "hider" 
 else 
 link_to "hide", story_hide_path(story.short_id),
              :class => "hider" 
 end 
 if defined?(single_story) && single_story && story.hider_count > 0 
 pluralize(story.hider_count, "user") 
 end 
 end 
 if story.url.present? 
 story.url 
 end 
 if !story.is_gone? 
 story.comments_path 
 if story.comments_count == 0 
 if @user 
 else 
 end 
 else 
 story.comments_count 
 story.comments_count == 1 ? "" : "s" 
 end 
 end 
 if defined?(single_story) && single_story &&
        ((story.downvotes > 0 && @user && @user.is_moderator?) ||
        (story.downvotes >= 3 || story.score <= 0)) 
 story.vote_summary_for(@user).downcase 
 end 
 end 
 story.comments_count == 0 ? "zero" : "" 
 story.comments_path 
 story.comments_count 
 
 if @page && @page > 1 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page == 2 ? "" : "page/#{@page - 1}" 
 @page - 1 
 end 
 if @show_more 
 if @page && @page > 1 
 end 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page + 1 
 @page + 1 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def upvoted
    @stories, @show_more = get_from_cache(upvoted: true, user: @user) {
      paginate @user.upvoted_stories.order('votes.id DESC')
    }

    @heading = @title = "Your Upvoted Stories"
    @cur_url = "/upvoted"

    @rss_link = { :title => "RSS 2.0 - Your Upvoted Stories",
      :href => "/upvoted.rss#{(@user ? "?token=#{@user.rss_token}" : "")}" }

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
 if @cur_url == "/recent" 
 end 
 @cur_url == "/hidden" ? "show_hidden" : "" 
  story.short_id 
 story.short_id 
 story.vote && story.vote[:vote] == 1 ? "upvoted" : "" 
 story.vote && story.vote[:vote] == -1 ? "downvoted" : "" 
 story.score <= -1 ? "negative_1" : "" 
 story.score <= -3 ? "negative_3" : "" 
 story.score <= -5 ? "negative_5" : "" 
 story.is_hidden_by_cur_user ? "hidden" : "" 
 story.is_expired? ? "expired" : "" 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 story.score 
 if story.can_be_seen_by_user?(@user) 
 story.url_or_comments_path 

          break_long_words(story.title) 
 end 
 if story.is_gone? 
 story.is_moderated? ? "moderator" :
          "original submitter" 
 end 
 if story.markeddown_description.present? 
 story.comments_path 
 end 
 if story.can_be_seen_by_user?(@user) 
 story.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if story.domain.present? 
 story.domain_search_url 

          break_long_words(story.domain) 
 end 
 if defined?(single_story) && single_story 
 story.merged_stories.each do |ms| 
 ms.url_or_comments_path 

              break_long_words(ms.title) 
 ms.sorted_taggings.each do |tagging| 
 tag_path(tagging.tag.tag) 
 tagging.tag.css_class 
 tagging.tag.description 
 tagging.tag.tag 
 end 
 if ms.domain.present? 
 ms.domain_search_url 

              break_long_words(ms.domain) 
 end 
 if (@user && @user.show_avatars?) || !@user 
 ms.user.username 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(16) 
 ms.user.avatar_url(32) 
 end 
 if story.user_is_author? 
 else 
 end 
 ms.user.username 

              ms.html_class_for_user 
 ms.user.username 
 time_ago_in_words_label(ms.created_at, :strip_about => true) 
 end 
 end 
 end 
 if !(defined?(single_story) && single_story) && @user &&
    @user.show_story_previews? 
 if (sc = story.description_or_story_cache(500)).present? 
 break_long_words(sc) 
 end 
 end 
 if (@user && @user.show_avatars?) || !@user 
 story.user.username 
 story.user.avatar_url(16) 
 story.user.avatar_url(16) 
 story.user.avatar_url(32) 
 end 
 if story.previewing 
 if story.user_is_author? 
 else 
 end 
 story.html_class_for_user 

          story.user.username 
 else 
 if story.user_is_author? 
 else 
 end 
 story.user.username 

          story.html_class_for_user 
 story.user.username 
 time_ago_in_words_label(story.created_at, :strip_about => true) 
 if story.is_editable_by_user?(@user) 
 edit_story_path(story.short_id) 
 if story.is_gone? && story.is_undeletable_by_user?(@user) 
 link_to "undelete", story_undelete_path(story.short_id),
              :method => :post, :data => {
              :confirm => "Are you sure you want to undelete this story?" } 
 elsif !story.is_gone? 
 if story.user_id != @user.try(:id) &&
            @user.try(:is_moderator?) 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :class => "mod_story_link" 
 else 
 link_to "delete", story_path(story.short_id),
                :method => :delete, :data => {
                :confirm => "Are you sure you want to delete this story?" } 
 end 
 end 
 end 
 if story.can_have_suggestions_from_user?(@user) 
 link_to "suggest", story_suggest_path(story.short_id),
            :class => "suggester" 
 end 
 if !story.is_gone? && @user 
 if @user && story.vote && story.vote[:vote] == -1 

              Vote::STORY_REASONS[story.vote[:reason]].to_s.downcase 
 elsif @user && @user.can_downvote?(story) 
 end 
 if story.is_hidden_by_cur_user 
 link_to "unhide", story_unhide_path(story.short_id),
              :class => "hider" 
 else 
 link_to "hide", story_hide_path(story.short_id),
              :class => "hider" 
 end 
 if defined?(single_story) && single_story && story.hider_count > 0 
 pluralize(story.hider_count, "user") 
 end 
 end 
 if story.url.present? 
 story.url 
 end 
 if !story.is_gone? 
 story.comments_path 
 if story.comments_count == 0 
 if @user 
 else 
 end 
 else 
 story.comments_count 
 story.comments_count == 1 ? "" : "s" 
 end 
 end 
 if defined?(single_story) && single_story &&
        ((story.downvotes > 0 && @user && @user.is_moderator?) ||
        (story.downvotes >= 3 || story.score <= 0)) 
 story.vote_summary_for(@user).downcase 
 end 
 end 
 story.comments_count == 0 ? "zero" : "" 
 story.comments_path 
 story.comments_count 
 
 if @page && @page > 1 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page == 2 ? "" : "page/#{@page - 1}" 
 @page - 1 
 end 
 if @show_more 
 if @page && @page > 1 
 end 
 @cur_url 
 @cur_url == "/" ? "" : "/" 

      @page + 1 
 @page + 1 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end
 }
      format.rss {
        if @user && params[:token].present?
          @title += " - Private feed for #{@user.username}"
        end

        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 coder = HTMLEntities.new 
 Rails.application.name 
 @title.present? ?
      ": " + h(@title) : "" 
 @title 
 Rails.application.root_url + (@newest ? "newest" : "") 
 @stories.each do |story| 
 raw coder.encode(story.title, :decimal) 
 story.url_or_comments_url 
 story.short_id_url 
 story.user.username 
 story.created_at.rfc2822 
 story.comments_url 
 raw coder.encode(story.markeddown_description, :decimal) 
 if story.url.present? 
 raw coder.encode("<p>" +
              link_to("Comments", story.comments_url) + "</p>", :decimal) 
 end 
 story.taggings.each do |tagging| 
 tagging.tag.tag 
 end 
 end 

end

      }
      format.json { render :json => @stories }
    end
  end

private
  def filtered_tag_ids
    if @user
      @user.tag_filters.map{|tf| tf.tag_id }
    else
      tags_filtered_by_cookie.map{|t| t.id }
    end
  end

  def stories
    StoryRepository.new(@user, exclude_tags: filtered_tag_ids)
  end

  def page
    params[:page].to_i > 0 ? params[:page].to_i : 1
  end

  def paginate(scope)
    StoriesPaginator.new(scope, page, @user).get
  end

  def get_from_cache(opts={}, &block)
#    if Rails.env.development? || @user || tags_filtered_by_cookie.any?
#      yield
#    else
      key = opts.merge(page: page).sort.map{|k,v| "#{k}=#{v.to_param}"
        }.join(" ")
      Rails.cache.fetch("stories #{key}", :expires_in => 45, &block)
#    end
  end
end
