class StoriesController < ApplicationController
  before_filter :require_logged_in_user_or_400,
    :only => [ :upvote, :downvote, :unvote, :hide, :unhide, :preview ]
  before_filter :require_logged_in_user, :only => [ :destroy, :create, :edit,
    :fetch_url_attributes, :new, :suggest ]
  before_filter :find_user_story, :only => [ :destroy, :edit, :undelete,
    :update ]
  before_filter :find_story!, :only => [ :suggest, :submit_suggestions ]

  def create
    @title = "Submit Story"
    @cur_url = "/stories/new"

    @story = Story.new(story_params)
    @story.user_id = @user.id

    if @story.valid? && !(@story.already_posted_story && !@story.seen_previous)
      if @story.save
        Countinual.count!("#{Rails.application.shortname}.stories.submitted",
          "+1")

        return redirect_to @story.comments_path
      end
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
 form_for @story do |f| 
  if f.object.errors.count == 1 && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 elsif f.object.errors.any? 
 error_messages_for f.object 
 elsif !f.object.errors.any? && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 f.hidden_field :seen_previous 
 end 
 unless defined?(suggesting) 
 if f.object.url_is_editable_by_user?(@user) 
 f.label :url, "URL:", :class => "required" 
 f.text_field :url, :autocomplete => "off" 
 button_tag "Fetch Title", :id => "story_fetch_title",
        :type => "button" 
 elsif !f.object.new_record? && !f.object.url.blank? 
 f.label :url, "URL:", :class => "required" 
 f.object.url 
 f.object.url 
 end 
 end 
 f.label :title, "Title:", :class => "required" 
 f.text_field :title, :maxlength => 100, :autocomplete => "off"  
 if f.object.id && !defined?(suggesting) 
 title_votes = {} 
 f.object.suggested_titles.each do |st| 
 title_votes[st.title] ||= 0 
 title_votes[st.title] += 1 
 end 
 title_votes.delete(f.object.title) 
 if title_votes.any? 
 title_votes.each do |ti,c| 
 h(ti) 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 f.label :tags_a, "Tags:", :class => "required",
    :style => "line-height: 2.3em;" 
 f.select "tags_a", options_for_select(
    Tag.all_with_filtered_counts_for(@user).map{|t|
      html = "<strong>#{h(t.tag)}</strong> - #{h(t.description.to_s)}"

      if t.hotness_mod != 0
        html << " (hotness mod #{t.hotness_mod > 0 ? "+" : ""}#{t.hotness_mod})"
      end
      if t.filtered_count > 0
        html << " <em>#{t.filtered_count} user" <<
          (t.filtered_count == 1 ? "" : "s") << " filtering</em>"
      end

      [ "#{t.tag} - #{t.description}", t.tag, { "data-html" => raw(html) } ]},
    f.object.tags_a), {}, { :multiple => true } 
 if f.object.id && !defined?(suggesting) 
 tag_votes = {} 
 f.object.suggested_taggings.group_by(&:user_id).each do |u,stg| 
 tl = stg.map{|st| st.tag.tag }.sort.join(", ") 
 tag_votes[tl] ||= 0 
 tag_votes[tl] += 1 
 end 
 tag_votes.delete(f.object.tags_a.sort.join(", ")) 
 if tag_votes.any? 
 tag_votes.each do |ts,c| 
 ts 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 unless defined?(suggesting) 
 f.label :description, "Text:", :class => "required" 
 f.text_area :description, :rows => 15,
        :placeholder => "Optional when submitting a URL; please see guidelines",
        :autocomplete => "off" 
 show_guidelines?? "" :
      "display: none;" 
 Rails.application.root_url
        

        
 Rails.application.name 
 Rails.application.name 
 end 
 unless defined?(suggesting) 
 f.label :user_is_author, "Author:", :class => "required" 
 f.check_box :user_is_author 
 f.label :user_is_author,
        (f.object.id && f.object.user_id != @user.id ? "Submitter is" : "I am") +
        " the author of the story at this URL (or this text)",
        :class => "normal" 
 end 
 
 end 
 if @story.previewing && @story.valid? 
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
 
 if @story.markeddown_description.present? 
 raw @story.markeddown_description 
 end 
 if @story.is_unavailable && @story.story_cache.present? 

    time_ago_in_words_label(@story.unavailable_at) 
 simple_format(@story.story_cache) 
 end 
 if !@story.previewing 
 if !@story.is_gone? && !@story.previewing 
  comment.short_id if comment.persisted? 
 form_for comment,
:html => { :id => "edit_comment_#{comment.short_id}" } do |f| 
 if comment.errors.any? 
 errors_for comment 
 end 
 hidden_field_tag "story_id", comment.story.short_id 
 if comment.parent_comment 
 hidden_field_tag "parent_comment_short_id",
      comment.parent_comment.short_id 
 end 
 text_area_tag "comment", comment.comment, :rows => 5,
      :style => "width: 100%;", :autocomplete => "off", :disabled => !@user,
      :placeholder => (@user ? "" : "You must be logged in to leave a comment.")
      
 if @user 
 end 
 button_tag "#{comment.new_record?? "Post" : "Update"}",
        :class => "comment-post", :type => "button",
        :disabled => !@user 
 button_tag "Preview", :class => "comment-preview",
        :type => "button", :disabled => !@user 
 if comment.persisted? || comment.parent_comment_id 
 button_tag "Cancel", :class => "comment-cancel",
          :type => "button" 
 end 
 if @user && @user.hats.any? 
 select_tag "hat_id",
          options_from_collection_for_select(@user.hats, "id", "hat",
          comment.hat_id), :include_blank => true 
 end 
 if @user 
  if defined?(allow_images) && allow_images 
 end 
 
 end 
 end 
 if defined?(show_comment) && show_comment.valid? 
  comment.short_id 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 comment.short_id 
 if defined?(was_merged) && was_merged 
 end 
 if (@user && @user.show_avatars?) || !@user 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 comment.user.username 
 comment.html_class_for_user 

        comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 if @user && @user.is_moderator? && @user.id != comment.user_id 
 else 
 end 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary_for_user(@user).downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 
 
 end 
 
 end 
 comments_by_parent = @comments.group_by(&:parent_comment_id) 
 subtree = comments_by_parent[nil] 
 ancestors = [] 
 while subtree 
 if (comment = subtree.shift) 
  comment.short_id 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 comment.short_id 
 if defined?(was_merged) && was_merged 
 end 
 if (@user && @user.show_avatars?) || !@user 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 comment.user.username 
 comment.html_class_for_user 

        comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 if @user && @user.is_moderator? && @user.id != comment.user_id 
 else 
 end 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary_for_user(@user).downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 
 
 elsif (subtree = ancestors.pop) 
 end 
 end 
 end 
 
 end 
 if !@story.previewing 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def destroy
    if !@story.is_editable_by_user?(@user)
      flash[:error] = "You cannot edit that story."
      return redirect_to "/"
    end

    @story.is_expired = true
    @story.editor = @user

    if params[:reason].present? && @story.user_id != @user.id
      @story.moderation_reason = params[:reason]
    end

    @story.save(:validate => false)

    redirect_to @story.comments_path
  end

  def edit
    if !@story.is_editable_by_user?(@user)
      flash[:error] = "You cannot edit that story."
      return redirect_to "/"
    end

    @title = "Edit Story"

    if @story.merged_into_story
      @story.merge_story_short_id = @story.merged_into_story.short_id
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
 form_for @story, :url => story_path(@story.short_id),
  :method => :put, :html => { :id => "edit_story" } do |f| 
  if f.object.errors.count == 1 && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 elsif f.object.errors.any? 
 error_messages_for f.object 
 elsif !f.object.errors.any? && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 f.hidden_field :seen_previous 
 end 
 unless defined?(suggesting) 
 if f.object.url_is_editable_by_user?(@user) 
 f.label :url, "URL:", :class => "required" 
 f.text_field :url, :autocomplete => "off" 
 button_tag "Fetch Title", :id => "story_fetch_title",
        :type => "button" 
 elsif !f.object.new_record? && !f.object.url.blank? 
 f.label :url, "URL:", :class => "required" 
 f.object.url 
 f.object.url 
 end 
 end 
 f.label :title, "Title:", :class => "required" 
 f.text_field :title, :maxlength => 100, :autocomplete => "off"  
 if f.object.id && !defined?(suggesting) 
 title_votes = {} 
 f.object.suggested_titles.each do |st| 
 title_votes[st.title] ||= 0 
 title_votes[st.title] += 1 
 end 
 title_votes.delete(f.object.title) 
 if title_votes.any? 
 title_votes.each do |ti,c| 
 h(ti) 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 f.label :tags_a, "Tags:", :class => "required",
    :style => "line-height: 2.3em;" 
 f.select "tags_a", options_for_select(
    Tag.all_with_filtered_counts_for(@user).map{|t|
      html = "<strong>#{h(t.tag)}</strong> - #{h(t.description.to_s)}"

      if t.hotness_mod != 0
        html << " (hotness mod #{t.hotness_mod > 0 ? "+" : ""}#{t.hotness_mod})"
      end
      if t.filtered_count > 0
        html << " <em>#{t.filtered_count} user" <<
          (t.filtered_count == 1 ? "" : "s") << " filtering</em>"
      end

      [ "#{t.tag} - #{t.description}", t.tag, { "data-html" => raw(html) } ]},
    f.object.tags_a), {}, { :multiple => true } 
 if f.object.id && !defined?(suggesting) 
 tag_votes = {} 
 f.object.suggested_taggings.group_by(&:user_id).each do |u,stg| 
 tl = stg.map{|st| st.tag.tag }.sort.join(", ") 
 tag_votes[tl] ||= 0 
 tag_votes[tl] += 1 
 end 
 tag_votes.delete(f.object.tags_a.sort.join(", ")) 
 if tag_votes.any? 
 tag_votes.each do |ts,c| 
 ts 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 unless defined?(suggesting) 
 f.label :description, "Text:", :class => "required" 
 f.text_area :description, :rows => 15,
        :placeholder => "Optional when submitting a URL; please see guidelines",
        :autocomplete => "off" 
 show_guidelines?? "" :
      "display: none;" 
 Rails.application.root_url
        

        
 Rails.application.name 
 Rails.application.name 
 end 
 unless defined?(suggesting) 
 f.label :user_is_author, "Author:", :class => "required" 
 f.check_box :user_is_author 
 f.label :user_is_author,
        (f.object.id && f.object.user_id != @user.id ? "Submitter is" : "I am") +
        " the author of the story at this URL (or this text)",
        :class => "normal" 
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

  def fetch_url_attributes
    s = Story.new
    s.fetching_ip = request.remote_ip
    s.url = params[:fetch_url]

    return render :json => s.fetched_attributes
  end

  def new
    @title = "Submit Story"
    @cur_url = "/stories/new"

    @story = Story.new
    @story.fetching_ip = request.remote_ip

    if params[:url].present?
      @story.url = params[:url]

      sattrs = @story.fetched_attributes

      if sattrs[:url].present? && @story.url != sattrs[:url]
        flash.now[:notice] = "Note: URL has been changed to fetched " <<
          "canonicalized version"
        @story.url = sattrs[:url]
      end

      if s = Story.find_similar_by_url(@story.url)
        if s.is_recent?
          # user won't be able to submit this story as new, so just redirect
          # them to the previous story
          flash[:success] = "This URL has already been submitted recently."
          return redirect_to s.comments_path
        else
          # user will see a warning like with preview screen
          @story.already_posted_story = s
        end
      end

      # ignore what the user brought unless we need it as a fallback
      @story.title = sattrs[:title]
      if !@story.title.present? && params[:title].present?
        @story.title = params[:title]
      end
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
 form_for @story do |f| 
  if f.object.errors.count == 1 && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 elsif f.object.errors.any? 
 error_messages_for f.object 
 elsif !f.object.errors.any? && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 f.hidden_field :seen_previous 
 end 
 unless defined?(suggesting) 
 if f.object.url_is_editable_by_user?(@user) 
 f.label :url, "URL:", :class => "required" 
 f.text_field :url, :autocomplete => "off" 
 button_tag "Fetch Title", :id => "story_fetch_title",
        :type => "button" 
 elsif !f.object.new_record? && !f.object.url.blank? 
 f.label :url, "URL:", :class => "required" 
 f.object.url 
 f.object.url 
 end 
 end 
 f.label :title, "Title:", :class => "required" 
 f.text_field :title, :maxlength => 100, :autocomplete => "off"  
 if f.object.id && !defined?(suggesting) 
 title_votes = {} 
 f.object.suggested_titles.each do |st| 
 title_votes[st.title] ||= 0 
 title_votes[st.title] += 1 
 end 
 title_votes.delete(f.object.title) 
 if title_votes.any? 
 title_votes.each do |ti,c| 
 h(ti) 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 f.label :tags_a, "Tags:", :class => "required",
    :style => "line-height: 2.3em;" 
 f.select "tags_a", options_for_select(
    Tag.all_with_filtered_counts_for(@user).map{|t|
      html = "<strong>#{h(t.tag)}</strong> - #{h(t.description.to_s)}"

      if t.hotness_mod != 0
        html << " (hotness mod #{t.hotness_mod > 0 ? "+" : ""}#{t.hotness_mod})"
      end
      if t.filtered_count > 0
        html << " <em>#{t.filtered_count} user" <<
          (t.filtered_count == 1 ? "" : "s") << " filtering</em>"
      end

      [ "#{t.tag} - #{t.description}", t.tag, { "data-html" => raw(html) } ]},
    f.object.tags_a), {}, { :multiple => true } 
 if f.object.id && !defined?(suggesting) 
 tag_votes = {} 
 f.object.suggested_taggings.group_by(&:user_id).each do |u,stg| 
 tl = stg.map{|st| st.tag.tag }.sort.join(", ") 
 tag_votes[tl] ||= 0 
 tag_votes[tl] += 1 
 end 
 tag_votes.delete(f.object.tags_a.sort.join(", ")) 
 if tag_votes.any? 
 tag_votes.each do |ts,c| 
 ts 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 unless defined?(suggesting) 
 f.label :description, "Text:", :class => "required" 
 f.text_area :description, :rows => 15,
        :placeholder => "Optional when submitting a URL; please see guidelines",
        :autocomplete => "off" 
 show_guidelines?? "" :
      "display: none;" 
 Rails.application.root_url
        

        
 Rails.application.name 
 Rails.application.name 
 end 
 unless defined?(suggesting) 
 f.label :user_is_author, "Author:", :class => "required" 
 f.check_box :user_is_author 
 f.label :user_is_author,
        (f.object.id && f.object.user_id != @user.id ? "Submitter is" : "I am") +
        " the author of the story at this URL (or this text)",
        :class => "normal" 
 end 
 
 end 
 if @story.previewing && @story.valid? 
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
 
 if @story.markeddown_description.present? 
 raw @story.markeddown_description 
 end 
 if @story.is_unavailable && @story.story_cache.present? 

    time_ago_in_words_label(@story.unavailable_at) 
 simple_format(@story.story_cache) 
 end 
 if !@story.previewing 
 if !@story.is_gone? && !@story.previewing 
  comment.short_id if comment.persisted? 
 form_for comment,
:html => { :id => "edit_comment_#{comment.short_id}" } do |f| 
 if comment.errors.any? 
 errors_for comment 
 end 
 hidden_field_tag "story_id", comment.story.short_id 
 if comment.parent_comment 
 hidden_field_tag "parent_comment_short_id",
      comment.parent_comment.short_id 
 end 
 text_area_tag "comment", comment.comment, :rows => 5,
      :style => "width: 100%;", :autocomplete => "off", :disabled => !@user,
      :placeholder => (@user ? "" : "You must be logged in to leave a comment.")
      
 if @user 
 end 
 button_tag "#{comment.new_record?? "Post" : "Update"}",
        :class => "comment-post", :type => "button",
        :disabled => !@user 
 button_tag "Preview", :class => "comment-preview",
        :type => "button", :disabled => !@user 
 if comment.persisted? || comment.parent_comment_id 
 button_tag "Cancel", :class => "comment-cancel",
          :type => "button" 
 end 
 if @user && @user.hats.any? 
 select_tag "hat_id",
          options_from_collection_for_select(@user.hats, "id", "hat",
          comment.hat_id), :include_blank => true 
 end 
 if @user 
  if defined?(allow_images) && allow_images 
 end 
 
 end 
 end 
 if defined?(show_comment) && show_comment.valid? 
  comment.short_id 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 comment.short_id 
 if defined?(was_merged) && was_merged 
 end 
 if (@user && @user.show_avatars?) || !@user 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 comment.user.username 
 comment.html_class_for_user 

        comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 if @user && @user.is_moderator? && @user.id != comment.user_id 
 else 
 end 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary_for_user(@user).downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 
 
 end 
 
 end 
 comments_by_parent = @comments.group_by(&:parent_comment_id) 
 subtree = comments_by_parent[nil] 
 ancestors = [] 
 while subtree 
 if (comment = subtree.shift) 
  comment.short_id 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 comment.short_id 
 if defined?(was_merged) && was_merged 
 end 
 if (@user && @user.show_avatars?) || !@user 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 comment.user.username 
 comment.html_class_for_user 

        comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 if @user && @user.is_moderator? && @user.id != comment.user_id 
 else 
 end 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary_for_user(@user).downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 
 
 elsif (subtree = ancestors.pop) 
 end 
 end 
 end 
 
 end 
 if !@story.previewing 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def preview
    @story = Story.new(story_params)
    @story.user_id = @user.id
    @story.previewing = true

    @story.vote = Vote.new(:vote => 1)
    @story.upvotes = 1

    @story.valid?

    @story.seen_previous = true

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_for @story do |f| 
  if f.object.errors.count == 1 && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 elsif f.object.errors.any? 
 error_messages_for f.object 
 elsif !f.object.errors.any? && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 f.hidden_field :seen_previous 
 end 
 unless defined?(suggesting) 
 if f.object.url_is_editable_by_user?(@user) 
 f.label :url, "URL:", :class => "required" 
 f.text_field :url, :autocomplete => "off" 
 button_tag "Fetch Title", :id => "story_fetch_title",
        :type => "button" 
 elsif !f.object.new_record? && !f.object.url.blank? 
 f.label :url, "URL:", :class => "required" 
 f.object.url 
 f.object.url 
 end 
 end 
 f.label :title, "Title:", :class => "required" 
 f.text_field :title, :maxlength => 100, :autocomplete => "off"  
 if f.object.id && !defined?(suggesting) 
 title_votes = {} 
 f.object.suggested_titles.each do |st| 
 title_votes[st.title] ||= 0 
 title_votes[st.title] += 1 
 end 
 title_votes.delete(f.object.title) 
 if title_votes.any? 
 title_votes.each do |ti,c| 
 h(ti) 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 f.label :tags_a, "Tags:", :class => "required",
    :style => "line-height: 2.3em;" 
 f.select "tags_a", options_for_select(
    Tag.all_with_filtered_counts_for(@user).map{|t|
      html = "<strong>#{h(t.tag)}</strong> - #{h(t.description.to_s)}"

      if t.hotness_mod != 0
        html << " (hotness mod #{t.hotness_mod > 0 ? "+" : ""}#{t.hotness_mod})"
      end
      if t.filtered_count > 0
        html << " <em>#{t.filtered_count} user" <<
          (t.filtered_count == 1 ? "" : "s") << " filtering</em>"
      end

      [ "#{t.tag} - #{t.description}", t.tag, { "data-html" => raw(html) } ]},
    f.object.tags_a), {}, { :multiple => true } 
 if f.object.id && !defined?(suggesting) 
 tag_votes = {} 
 f.object.suggested_taggings.group_by(&:user_id).each do |u,stg| 
 tl = stg.map{|st| st.tag.tag }.sort.join(", ") 
 tag_votes[tl] ||= 0 
 tag_votes[tl] += 1 
 end 
 tag_votes.delete(f.object.tags_a.sort.join(", ")) 
 if tag_votes.any? 
 tag_votes.each do |ts,c| 
 ts 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 unless defined?(suggesting) 
 f.label :description, "Text:", :class => "required" 
 f.text_area :description, :rows => 15,
        :placeholder => "Optional when submitting a URL; please see guidelines",
        :autocomplete => "off" 
 show_guidelines?? "" :
      "display: none;" 
 Rails.application.root_url
        

        
 Rails.application.name 
 Rails.application.name 
 end 
 unless defined?(suggesting) 
 f.label :user_is_author, "Author:", :class => "required" 
 f.check_box :user_is_author 
 f.label :user_is_author,
        (f.object.id && f.object.user_id != @user.id ? "Submitter is" : "I am") +
        " the author of the story at this URL (or this text)",
        :class => "normal" 
 end 
 
 end 
 if @story.previewing && @story.valid? 
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
 
 if @story.markeddown_description.present? 
 raw @story.markeddown_description 
 end 
 if @story.is_unavailable && @story.story_cache.present? 

    time_ago_in_words_label(@story.unavailable_at) 
 simple_format(@story.story_cache) 
 end 
 if !@story.previewing 
 if !@story.is_gone? && !@story.previewing 
  comment.short_id if comment.persisted? 
 form_for comment,
:html => { :id => "edit_comment_#{comment.short_id}" } do |f| 
 if comment.errors.any? 
 errors_for comment 
 end 
 hidden_field_tag "story_id", comment.story.short_id 
 if comment.parent_comment 
 hidden_field_tag "parent_comment_short_id",
      comment.parent_comment.short_id 
 end 
 text_area_tag "comment", comment.comment, :rows => 5,
      :style => "width: 100%;", :autocomplete => "off", :disabled => !@user,
      :placeholder => (@user ? "" : "You must be logged in to leave a comment.")
      
 if @user 
 end 
 button_tag "#{comment.new_record?? "Post" : "Update"}",
        :class => "comment-post", :type => "button",
        :disabled => !@user 
 button_tag "Preview", :class => "comment-preview",
        :type => "button", :disabled => !@user 
 if comment.persisted? || comment.parent_comment_id 
 button_tag "Cancel", :class => "comment-cancel",
          :type => "button" 
 end 
 if @user && @user.hats.any? 
 select_tag "hat_id",
          options_from_collection_for_select(@user.hats, "id", "hat",
          comment.hat_id), :include_blank => true 
 end 
 if @user 
  if defined?(allow_images) && allow_images 
 end 
 
 end 
 end 
 if defined?(show_comment) && show_comment.valid? 
  comment.short_id 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 comment.short_id 
 if defined?(was_merged) && was_merged 
 end 
 if (@user && @user.show_avatars?) || !@user 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 comment.user.username 
 comment.html_class_for_user 

        comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 if @user && @user.is_moderator? && @user.id != comment.user_id 
 else 
 end 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary_for_user(@user).downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 
 
 end 
 
 end 
 comments_by_parent = @comments.group_by(&:parent_comment_id) 
 subtree = comments_by_parent[nil] 
 ancestors = [] 
 while subtree 
 if (comment = subtree.shift) 
  comment.short_id 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 comment.short_id 
 if defined?(was_merged) && was_merged 
 end 
 if (@user && @user.show_avatars?) || !@user 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 comment.user.username 
 comment.html_class_for_user 

        comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 if @user && @user.is_moderator? && @user.id != comment.user_id 
 else 
 end 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary_for_user(@user).downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 
 
 elsif (subtree = ancestors.pop) 
 end 
 end 
 end 
 
 end 
 if !@story.previewing 
 end 

end

  end

  def show
    @story = Story.where(:short_id => params[:id]).first!

    if @story.merged_into_story
      flash[:success] = "\"#{@story.title}\" has been merged into this story."
      return redirect_to @story.merged_into_story.comments_path
    end

    if @story.can_be_seen_by_user?(@user)
      @title = @story.title
    else
      @title = "[Story removed]"
    end

    @short_url = @story.short_id_url

    @comments = @story.merged_comments.includes(:user, :story,
      :hat).arrange_for_user(@user)

    if params[:comment_short_id]
      @comments.each do |c,x|
        if c.short_id == params[:comment_short_id]
          c.highlighted = true
          break
        end
      end
    end

    respond_to do |format|
      format.html {
        @comment = @story.comments.build

        @meta_tags = {
          "twitter:card" => "summary",
          "twitter:site" => "@lobsters",
          "twitter:title" => @story.title,
          "twitter:description" => "#{@story.comments_count} comment" <<
            "#{@story.comments_count == 1 ? "" : "s"}",
        }

        load_user_votes

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
 
 if @story.markeddown_description.present? 
 raw @story.markeddown_description 
 end 
 if @story.is_unavailable && @story.story_cache.present? 

    time_ago_in_words_label(@story.unavailable_at) 
 simple_format(@story.story_cache) 
 end 
 if !@story.previewing 
 if !@story.is_gone? && !@story.previewing 
  comment.short_id if comment.persisted? 
 form_for comment,
:html => { :id => "edit_comment_#{comment.short_id}" } do |f| 
 if comment.errors.any? 
 errors_for comment 
 end 
 hidden_field_tag "story_id", comment.story.short_id 
 if comment.parent_comment 
 hidden_field_tag "parent_comment_short_id",
      comment.parent_comment.short_id 
 end 
 text_area_tag "comment", comment.comment, :rows => 5,
      :style => "width: 100%;", :autocomplete => "off", :disabled => !@user,
      :placeholder => (@user ? "" : "You must be logged in to leave a comment.")
      
 if @user 
 end 
 button_tag "#{comment.new_record?? "Post" : "Update"}",
        :class => "comment-post", :type => "button",
        :disabled => !@user 
 button_tag "Preview", :class => "comment-preview",
        :type => "button", :disabled => !@user 
 if comment.persisted? || comment.parent_comment_id 
 button_tag "Cancel", :class => "comment-cancel",
          :type => "button" 
 end 
 if @user && @user.hats.any? 
 select_tag "hat_id",
          options_from_collection_for_select(@user.hats, "id", "hat",
          comment.hat_id), :include_blank => true 
 end 
 if @user 
  if defined?(allow_images) && allow_images 
 end 
 
 end 
 end 
 if defined?(show_comment) && show_comment.valid? 
  comment.short_id 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 comment.short_id 
 if defined?(was_merged) && was_merged 
 end 
 if (@user && @user.show_avatars?) || !@user 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 comment.user.username 
 comment.html_class_for_user 

        comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 if @user && @user.is_moderator? && @user.id != comment.user_id 
 else 
 end 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary_for_user(@user).downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 
 
 end 
 
 end 
 comments_by_parent = @comments.group_by(&:parent_comment_id) 
 subtree = comments_by_parent[nil] 
 ancestors = [] 
 while subtree 
 if (comment = subtree.shift) 
  comment.short_id 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 comment.short_id 
 if defined?(was_merged) && was_merged 
 end 
 if (@user && @user.show_avatars?) || !@user 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 comment.user.username 
 comment.html_class_for_user 

        comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 if @user && @user.is_moderator? && @user.id != comment.user_id 
 else 
 end 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary_for_user(@user).downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 
 
 elsif (subtree = ancestors.pop) 
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
      format.json {
        render :json => @story.as_json(:with_comments => @comments)
      }
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
 
 if @story.markeddown_description.present? 
 raw @story.markeddown_description 
 end 
 if @story.is_unavailable && @story.story_cache.present? 

    time_ago_in_words_label(@story.unavailable_at) 
 simple_format(@story.story_cache) 
 end 
 if !@story.previewing 
 if !@story.is_gone? && !@story.previewing 
  comment.short_id if comment.persisted? 
 form_for comment,
:html => { :id => "edit_comment_#{comment.short_id}" } do |f| 
 if comment.errors.any? 
 errors_for comment 
 end 
 hidden_field_tag "story_id", comment.story.short_id 
 if comment.parent_comment 
 hidden_field_tag "parent_comment_short_id",
      comment.parent_comment.short_id 
 end 
 text_area_tag "comment", comment.comment, :rows => 5,
      :style => "width: 100%;", :autocomplete => "off", :disabled => !@user,
      :placeholder => (@user ? "" : "You must be logged in to leave a comment.")
      
 if @user 
 end 
 button_tag "#{comment.new_record?? "Post" : "Update"}",
        :class => "comment-post", :type => "button",
        :disabled => !@user 
 button_tag "Preview", :class => "comment-preview",
        :type => "button", :disabled => !@user 
 if comment.persisted? || comment.parent_comment_id 
 button_tag "Cancel", :class => "comment-cancel",
          :type => "button" 
 end 
 if @user && @user.hats.any? 
 select_tag "hat_id",
          options_from_collection_for_select(@user.hats, "id", "hat",
          comment.hat_id), :include_blank => true 
 end 
 if @user 
  if defined?(allow_images) && allow_images 
 end 
 
 end 
 end 
 if defined?(show_comment) && show_comment.valid? 
  comment.short_id 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 comment.short_id 
 if defined?(was_merged) && was_merged 
 end 
 if (@user && @user.show_avatars?) || !@user 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 comment.user.username 
 comment.html_class_for_user 

        comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 if @user && @user.is_moderator? && @user.id != comment.user_id 
 else 
 end 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary_for_user(@user).downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 
 
 end 
 
 end 
 comments_by_parent = @comments.group_by(&:parent_comment_id) 
 subtree = comments_by_parent[nil] 
 ancestors = [] 
 while subtree 
 if (comment = subtree.shift) 
  comment.short_id 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 comment.short_id 
 if defined?(was_merged) && was_merged 
 end 
 if (@user && @user.show_avatars?) || !@user 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 comment.user.username 
 comment.html_class_for_user 

        comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 if @user && @user.is_moderator? && @user.id != comment.user_id 
 else 
 end 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary_for_user(@user).downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 
 
 elsif (subtree = ancestors.pop) 
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

  def suggest
    if (st = @story.suggested_taggings.where(:user_id => @user.id)).any?
      @story.tags_a = st.map{|st| st.tag.tag }
    end
    if tt = @story.suggested_titles.where(:user_id => @user.id).first
      @story.title = tt.title
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
 form_for @story, :url => story_suggest_path(@story.short_id),
  :method => :post, :html => { :id => "edit_story" } do |f| 
  if f.object.errors.count == 1 && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 elsif f.object.errors.any? 
 error_messages_for f.object 
 elsif !f.object.errors.any? && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 f.hidden_field :seen_previous 
 end 
 unless defined?(suggesting) 
 if f.object.url_is_editable_by_user?(@user) 
 f.label :url, "URL:", :class => "required" 
 f.text_field :url, :autocomplete => "off" 
 button_tag "Fetch Title", :id => "story_fetch_title",
        :type => "button" 
 elsif !f.object.new_record? && !f.object.url.blank? 
 f.label :url, "URL:", :class => "required" 
 f.object.url 
 f.object.url 
 end 
 end 
 f.label :title, "Title:", :class => "required" 
 f.text_field :title, :maxlength => 100, :autocomplete => "off"  
 if f.object.id && !defined?(suggesting) 
 title_votes = {} 
 f.object.suggested_titles.each do |st| 
 title_votes[st.title] ||= 0 
 title_votes[st.title] += 1 
 end 
 title_votes.delete(f.object.title) 
 if title_votes.any? 
 title_votes.each do |ti,c| 
 h(ti) 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 f.label :tags_a, "Tags:", :class => "required",
    :style => "line-height: 2.3em;" 
 f.select "tags_a", options_for_select(
    Tag.all_with_filtered_counts_for(@user).map{|t|
      html = "<strong>#{h(t.tag)}</strong> - #{h(t.description.to_s)}"

      if t.hotness_mod != 0
        html << " (hotness mod #{t.hotness_mod > 0 ? "+" : ""}#{t.hotness_mod})"
      end
      if t.filtered_count > 0
        html << " <em>#{t.filtered_count} user" <<
          (t.filtered_count == 1 ? "" : "s") << " filtering</em>"
      end

      [ "#{t.tag} - #{t.description}", t.tag, { "data-html" => raw(html) } ]},
    f.object.tags_a), {}, { :multiple => true } 
 if f.object.id && !defined?(suggesting) 
 tag_votes = {} 
 f.object.suggested_taggings.group_by(&:user_id).each do |u,stg| 
 tl = stg.map{|st| st.tag.tag }.sort.join(", ") 
 tag_votes[tl] ||= 0 
 tag_votes[tl] += 1 
 end 
 tag_votes.delete(f.object.tags_a.sort.join(", ")) 
 if tag_votes.any? 
 tag_votes.each do |ts,c| 
 ts 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 unless defined?(suggesting) 
 f.label :description, "Text:", :class => "required" 
 f.text_area :description, :rows => 15,
        :placeholder => "Optional when submitting a URL; please see guidelines",
        :autocomplete => "off" 
 show_guidelines?? "" :
      "display: none;" 
 Rails.application.root_url
        

        
 Rails.application.name 
 Rails.application.name 
 end 
 unless defined?(suggesting) 
 f.label :user_is_author, "Author:", :class => "required" 
 f.check_box :user_is_author 
 f.label :user_is_author,
        (f.object.id && f.object.user_id != @user.id ? "Submitter is" : "I am") +
        " the author of the story at this URL (or this text)",
        :class => "normal" 
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

  def submit_suggestions
    ostory = @story.dup

    @story.title = params[:story][:title]
    if @story.valid?
      dsug = false
      if @story.title != ostory.title
        @story.save_suggested_title_for_user!(@story.title, @user)
        dsug = true
      end

      sugtags = params[:story][:tags_a].reject{|t| t.to_s.strip == "" }.sort
      if @story.tags_a.sort != sugtags
        @story.save_suggested_tags_a_for_user!(sugtags, @user)
        dsug = true
      end

      if dsug
        ostory = @story.reload
        flash[:success] = "Your suggested changes have been noted."
      end
      redirect_to ostory.comments_path
    else
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
 form_for @story, :url => story_suggest_path(@story.short_id),
  :method => :post, :html => { :id => "edit_story" } do |f| 
  if f.object.errors.count == 1 && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 elsif f.object.errors.any? 
 error_messages_for f.object 
 elsif !f.object.errors.any? && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 f.hidden_field :seen_previous 
 end 
 unless defined?(suggesting) 
 if f.object.url_is_editable_by_user?(@user) 
 f.label :url, "URL:", :class => "required" 
 f.text_field :url, :autocomplete => "off" 
 button_tag "Fetch Title", :id => "story_fetch_title",
        :type => "button" 
 elsif !f.object.new_record? && !f.object.url.blank? 
 f.label :url, "URL:", :class => "required" 
 f.object.url 
 f.object.url 
 end 
 end 
 f.label :title, "Title:", :class => "required" 
 f.text_field :title, :maxlength => 100, :autocomplete => "off"  
 if f.object.id && !defined?(suggesting) 
 title_votes = {} 
 f.object.suggested_titles.each do |st| 
 title_votes[st.title] ||= 0 
 title_votes[st.title] += 1 
 end 
 title_votes.delete(f.object.title) 
 if title_votes.any? 
 title_votes.each do |ti,c| 
 h(ti) 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 f.label :tags_a, "Tags:", :class => "required",
    :style => "line-height: 2.3em;" 
 f.select "tags_a", options_for_select(
    Tag.all_with_filtered_counts_for(@user).map{|t|
      html = "<strong>#{h(t.tag)}</strong> - #{h(t.description.to_s)}"

      if t.hotness_mod != 0
        html << " (hotness mod #{t.hotness_mod > 0 ? "+" : ""}#{t.hotness_mod})"
      end
      if t.filtered_count > 0
        html << " <em>#{t.filtered_count} user" <<
          (t.filtered_count == 1 ? "" : "s") << " filtering</em>"
      end

      [ "#{t.tag} - #{t.description}", t.tag, { "data-html" => raw(html) } ]},
    f.object.tags_a), {}, { :multiple => true } 
 if f.object.id && !defined?(suggesting) 
 tag_votes = {} 
 f.object.suggested_taggings.group_by(&:user_id).each do |u,stg| 
 tl = stg.map{|st| st.tag.tag }.sort.join(", ") 
 tag_votes[tl] ||= 0 
 tag_votes[tl] += 1 
 end 
 tag_votes.delete(f.object.tags_a.sort.join(", ")) 
 if tag_votes.any? 
 tag_votes.each do |ts,c| 
 ts 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 unless defined?(suggesting) 
 f.label :description, "Text:", :class => "required" 
 f.text_area :description, :rows => 15,
        :placeholder => "Optional when submitting a URL; please see guidelines",
        :autocomplete => "off" 
 show_guidelines?? "" :
      "display: none;" 
 Rails.application.root_url
        

        
 Rails.application.name 
 Rails.application.name 
 end 
 unless defined?(suggesting) 
 f.label :user_is_author, "Author:", :class => "required" 
 f.check_box :user_is_author 
 f.label :user_is_author,
        (f.object.id && f.object.user_id != @user.id ? "Submitter is" : "I am") +
        " the author of the story at this URL (or this text)",
        :class => "normal" 
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
  end

  def undelete
    if !(@story.is_editable_by_user?(@user) &&
    @story.is_undeletable_by_user?(@user))
      flash[:error] = "You cannot edit that story."
      return redirect_to "/"
    end

    @story.is_expired = false
    @story.editor = @user
    @story.save(:validate => false)

    redirect_to @story.comments_path
  end

  def update
    if !@story.is_editable_by_user?(@user)
      flash[:error] = "You cannot edit that story."
      return redirect_to "/"
    end

    @story.is_expired = false
    @story.editor = @user

    if @story.url_is_editable_by_user?(@user)
      @story.attributes = story_params
    else
      @story.attributes = story_params.except(:url)
    end

    if @story.save
      return redirect_to @story.comments_path
    else
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
 form_for @story, :url => story_path(@story.short_id),
  :method => :put, :html => { :id => "edit_story" } do |f| 
  if f.object.errors.count == 1 && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 elsif f.object.errors.any? 
 error_messages_for f.object 
 elsif !f.object.errors.any? && f.object.already_posted_story 

    time_ago_in_words_label(f.object.already_posted_story.created_at) 
 f.object.already_posted_story.comments_path 
 f.hidden_field :seen_previous 
 end 
 unless defined?(suggesting) 
 if f.object.url_is_editable_by_user?(@user) 
 f.label :url, "URL:", :class => "required" 
 f.text_field :url, :autocomplete => "off" 
 button_tag "Fetch Title", :id => "story_fetch_title",
        :type => "button" 
 elsif !f.object.new_record? && !f.object.url.blank? 
 f.label :url, "URL:", :class => "required" 
 f.object.url 
 f.object.url 
 end 
 end 
 f.label :title, "Title:", :class => "required" 
 f.text_field :title, :maxlength => 100, :autocomplete => "off"  
 if f.object.id && !defined?(suggesting) 
 title_votes = {} 
 f.object.suggested_titles.each do |st| 
 title_votes[st.title] ||= 0 
 title_votes[st.title] += 1 
 end 
 title_votes.delete(f.object.title) 
 if title_votes.any? 
 title_votes.each do |ti,c| 
 h(ti) 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 f.label :tags_a, "Tags:", :class => "required",
    :style => "line-height: 2.3em;" 
 f.select "tags_a", options_for_select(
    Tag.all_with_filtered_counts_for(@user).map{|t|
      html = "<strong>#{h(t.tag)}</strong> - #{h(t.description.to_s)}"

      if t.hotness_mod != 0
        html << " (hotness mod #{t.hotness_mod > 0 ? "+" : ""}#{t.hotness_mod})"
      end
      if t.filtered_count > 0
        html << " <em>#{t.filtered_count} user" <<
          (t.filtered_count == 1 ? "" : "s") << " filtering</em>"
      end

      [ "#{t.tag} - #{t.description}", t.tag, { "data-html" => raw(html) } ]},
    f.object.tags_a), {}, { :multiple => true } 
 if f.object.id && !defined?(suggesting) 
 tag_votes = {} 
 f.object.suggested_taggings.group_by(&:user_id).each do |u,stg| 
 tl = stg.map{|st| st.tag.tag }.sort.join(", ") 
 tag_votes[tl] ||= 0 
 tag_votes[tl] += 1 
 end 
 tag_votes.delete(f.object.tags_a.sort.join(", ")) 
 if tag_votes.any? 
 tag_votes.each do |ts,c| 
 ts 
 c == 1 ? "" : " (#{c} votes)" 
 end 
 end 
 end 
 unless defined?(suggesting) 
 f.label :description, "Text:", :class => "required" 
 f.text_area :description, :rows => 15,
        :placeholder => "Optional when submitting a URL; please see guidelines",
        :autocomplete => "off" 
 show_guidelines?? "" :
      "display: none;" 
 Rails.application.root_url
        

        
 Rails.application.name 
 Rails.application.name 
 end 
 unless defined?(suggesting) 
 f.label :user_is_author, "Author:", :class => "required" 
 f.check_box :user_is_author 
 f.label :user_is_author,
        (f.object.id && f.object.user_id != @user.id ? "Submitter is" : "I am") +
        " the author of the story at this URL (or this text)",
        :class => "normal" 
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
  end

  def unvote
    if !(story = find_story)
      return render :text => "can't find story", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(0, story.id,
      nil, @user.id, nil)

    render :text => "ok"
  end

  def upvote
    if !(story = find_story)
      return render :text => "can't find story", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(1, story.id,
      nil, @user.id, nil)

    render :text => "ok"
  end

  def downvote
    if !(story = find_story)
      return render :text => "can't find story", :status => 400
    end

    if !Vote::STORY_REASONS[params[:reason]]
      return render :text => "invalid reason", :status => 400
    end

    if !@user.can_downvote?(story)
      return render :text => "not permitted to downvote", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(-1, story.id,
      nil, @user.id, params[:reason])

    render :text => "ok"
  end

  def hide
    if !(story = find_story)
      return render :text => "can't find story", :status => 400
    end

    HiddenStory.hide_story_for_user(story.id, @user.id)

    render :text => "ok"
  end

  def unhide
    if !(story = find_story)
      return render :text => "can't find story", :status => 400
    end

    HiddenStory.where(:user_id => @user.id, :story_id => story.id).delete_all

    render :text => "ok"
  end

private

  def story_params
    p = params.require(:story).permit(
      :title, :url, :description, :moderation_reason, :seen_previous,
      :merge_story_short_id, :is_unavailable, :user_is_author, :tags_a => [],
    )

    if @user.is_moderator?
      p
    else
      p.except(:moderation_reason, :merge_story_short_id, :is_unavailable)
    end
  end

  def find_story
    story = Story.where(:short_id => params[:story_id]).first
    if @user && story
      story.vote = Vote.where(:user_id => @user.id,
        :story_id => story.id, :comment_id => nil).first.try(:vote)
    end

    story
  end

  def find_story!
    @story = find_story
    if !@story
      raise ActiveRecord::RecordNotFound
    end
  end

  def find_user_story
    if @user.is_moderator?
      @story = Story.where(:short_id => params[:story_id] || params[:id]).first
    else
      @story = Story.where(:user_id => @user.id, :short_id =>
        (params[:story_id] || params[:id])).first
    end

    if !@story
      flash[:error] = "Could not find story or you are not authorized " <<
        "to manage it."
      redirect_to "/"
      return false
    end
  end

  def load_user_votes
    if @user
      if v = Vote.where(:user_id => @user.id, :story_id => @story.id,
      :comment_id => nil).first
        @story.vote = { :vote => v.vote, :reason => v.reason }
      end

      @story.is_hidden_by_cur_user = @story.is_hidden_by_user?(@user)

      @votes = Vote.comment_votes_by_user_for_story_hash(@user.id, @story.id)
      @comments.each do |c|
        if @votes[c.id]
          c.current_vote = @votes[c.id]
        end
      end
    end
  end
end
