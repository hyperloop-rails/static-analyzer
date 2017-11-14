# encoding: utf-8

class ConversationsController < ApplicationController
  include ExchangesController

  requires_authentication
  requires_user

  before_action :find_exchange, except: [:index, :new, :create]
  before_action :verify_editable, only: [:edit, :update, :destroy]
  before_action :find_recipient, only: [:create]
  before_action :require_and_set_search_query, only: [:search, :search_posts]
  before_action :find_remove_user, only: [:remove_participant]

  def index
    @exchanges = current_user.conversations.page(params[:page]).for_view
    respond_with_exchanges(@exchanges)
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
 'current' if params[:controller] == 'discussions' && params[:action] == "index" 
 link_to "Everything", discussions_path 
 Discussion.viewable_by(current_user).count 
 if current_user? 
 if current_user.following_count > 0 
 'current' if params[:controller] == 'discussions' && params[:action] == "following" 
 link_to "Followed", following_discussions_path 
 current_user.following_count 
 end 
 if current_user.favorites_count > 0 
 'current' if params[:controller] == 'discussions' && params[:action] == "favorites" 
 link_to "Favorites", favorites_discussions_path 
 current_user.favorites_count 
 end 
 if current_user.hidden_count > 0 
 'current' if params[:controller] == 'discussions' && params[:action] == "hidden" 
 link_to "Hidden", hidden_discussions_path 
 current_user.hidden_count 
 end 
 end 
 'current' if params[:controller] == 'discussions' && params[:action] == "popular" 
 link_to "Popular", popular_discussions_path 
 if current_user? 
 link_to "Start a new discussion", new_discussion_path, class: 'create button' 
 end 
 if current_user? && (current_user.admin? || current_user.moderator?) 
 if current_user.admin? 
 link_to "Forum configuration", admin_configuration_path 
 end 
 end 
 end 

  add_body_class "discussions conversations"
  @page_title = "Conversations"

  
 link_to "Start a conversation", new_conversation_path, class: :add 
 link_to "Conversations", conversations_path 
 
  no_exchanges ||= "No discussions here yet. " + link_to("Create the first!", new_discussion_path)
  pagination_params ||= {}

 if exchanges.any? 
 @exchanges.each do |d| 
 exchange_classes(exchanges, d).flatten.compact.join(' ') 
 if new_posts?(d) 
 new_posts_count(d) 
 end 
 if d.labels? 
 d.labels.join(',') 
 end 
 link_to d.title, last_viewed_page_path(d) 
 if d.kind_of?(Conversation) 

            other_participants = d.participants.reject{|p| p == current_user}
          
 if other_participants.length == 0 
 elsif other_participants.length > 2 
 other_participants.length 
 else 
 safe_join other_participants.map{|p| profile_link(p)}, ', ' 
 end 
 else 
 d.poster.username 
 end 
 d.posts_count 
 d.last_poster.username 
 time_tag d.last_post_at, class: 'relative' 
 end 
 
  anchor ||= nil
  pagination_params ||= {}

 if p.total_pages > 1 
 link_to_unless((p.current_page == 1),
                           "First",
                           {
                             page: 1,
                             anchor: anchor
                           }.merge(pagination_params),
                           class: :first_page_link) 
 link_to_if(p.previous_page,
                       "Previous",
                       {
                         page: p.previous_page,
                         anchor: anchor
                       }.merge(pagination_params),
                       class: :prev_page_link) 
 link_to_if(p.next_page,
                       "Next",
                       {
                         page: p.next_page,
                         anchor: anchor
                       }.merge(pagination_params),
                       class: :next_page_link) 
 link_to_unless((p.current_page == p.total_pages),
                           "Last",
                           {
                             page: p.total_pages,
                             anchor: anchor
                           }.merge(pagination_params),
                           class: :last_page_link) 
 end 
 p.current_page 
 p.total_pages 
 
 else 
 no_exchanges 
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

  def show
    super
    current_user.mark_conversation_viewed(@exchange)
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
 participants.each do |participant| 
 profile_link(participant) 
 if exchange.removeable_by?(participant, current_user) 
 link_to("Remove",
                    remove_participant_conversation_path(
                      exchange,
                      username: participant.username
                    ),
                    class: "remove-participant",
                    method: :delete,
                    data: { confirm: "Are you sure?" }) 
 end 
 end 
 end 

  add_body_class "discussion", "conversation", "discussion_by_user#{@exchange.poster_id}"
  add_body_class 'last_page' if @posts.last_page?
  @page_title = @exchange.title
  previous_post = nil

  
 if current_user? 
 if @exchange.editable_by?(current_user) 
 link_to "Edit", [:edit, @exchange], class: :edit 
 end 
 if @exchange.removeable?(current_user) 
 link_to("Remove conversation",
                  remove_participant_conversation_path(
                    @exchange,
                    username: current_user.username
                  ),
                  method: :delete,
                  data: {
                    confirm: "Are you sure? You'll have to ask one of the " \
                    "other participants to invite you back if you regret it."
                  }) 
 end 
 if current_user.muted_conversation?(@exchange) 
 link_to "Unmute", unmute_conversation_path(@exchange, page: @posts.current_page) 
 else 
 link_to "Mute", mute_conversation_path(@exchange, page: @posts.current_page) 
 end 
 end 
 if @exchange.labels? 
 @exchange.labels.join(",") 
 end 
 link_to @exchange.title, @exchange, id: 'discussionLink'  
 cache [@exchange, @page] do 
 @exchange.id 
 @exchange.posts_count 
 @exchange.class 
 
  # Options
  discussion         ||= false
  functions          ||= false
  permalink          ||= false
  post_distance      ||= false
  title              ||= false
  new_posts_notifier ||= false
  no_pagination      ||= false
  no_container       ||= false

  previous_post = nil
  pagination_params ||= {}

 
  anchor ||= nil
  pagination_params ||= {}

 if p.total_pages > 1 
 link_to_unless((p.current_page == 1),
                           "First",
                           {
                             page: 1,
                             anchor: anchor
                           }.merge(pagination_params),
                           class: :first_page_link) 
 link_to_if(p.previous_page,
                       "Previous",
                       {
                         page: p.previous_page,
                         anchor: anchor
                       }.merge(pagination_params),
                       class: :prev_page_link) 
 link_to_if(p.next_page,
                       "Next",
                       {
                         page: p.next_page,
                         anchor: anchor
                       }.merge(pagination_params),
                       class: :next_page_link) 
 link_to_unless((p.current_page == p.total_pages),
                           "Last",
                           {
                             page: p.total_pages,
                             anchor: anchor
                           }.merge(pagination_params),
                           class: :last_page_link) 
 end 
 p.current_page 
 p.total_pages 
 
 unless no_container 
 end 
 posts.each do |post| 
 if posts.kind_of?(Paginatable::ClassMethods::WithContext) && posts.context? && posts.to_a.index(post) == 0 
 end 
 
  # Options
  posts              ||= false
  discussion         ||= false
  functions          ||= false
  permalink          ||= false
  post_distance      ||= false
  title              ||= false
  preview            ||= false

  previous_post      ||= nil

 if post_distance && previous_post 
 if (post.created_at - previous_post.created_at) >= 12.hours 
 distance_of_time_in_words(post.created_at, previous_post.created_at) 
 elsif (previous_post.created_at - post.created_at) >= 12.hours 
 distance_of_time_in_words(post.created_at, previous_post.created_at) 
 end 
 end 
 post.user.id 
 " me_post" if post.me_post? 
 post.user.id 
 post.exchange_id 
 post.exchange.type 
 post.id 
 post.id 
 if title 
 if post.exchange.labels? 
 post.exchange.labels.join(',') 
 end 
 link_to post.exchange.title, polymorphic_path(post.exchange, page: post.page, anchor: "post-#{post.id}") 
 profile_link(post.exchange.poster) 
 time_tag post.exchange.last_post_at, class: 'relative' 
 post.exchange.posts_count 
 end 
 if functions 
 end 
 if post.me_post? 
 avatar_image_tag(post.user) 
 post.id 
 format_post post.body, post.user 
 if preview 
 else 
 if permalink 
 link_to(polymorphic_path((discussion||post.exchange), page: post_page(post), anchor: "post-#{post.id}"), title: "Permalink to this post", class: "permalink") do 
 time_tag post.created_at, class: 'relative date' 
 end 
 else 
 time_tag post.created_at, class: 'relative date' 
 end 
 end 
 else 
 avatar_image_tag(post.user) 
 profile_link(post.user) 
 if preview 
 else 
 if permalink 
 link_to(polymorphic_path((discussion||post.exchange), page: post_page(post), anchor: "post-#{post.id}"), title: "Permalink to this post", class: "permalink") do 
 time_tag post.created_at, class: 'relative date' 
 end 
 else 
 time_tag post.created_at, class: 'relative date' 
 end 
 end 
 post.id 
 format_post(post.body_html, post.user) 
 if post.edited? 
 time_tag post.edited_at, class: 'relative' 
 end 
 end 
 
 previous_post = post 
 if posts.kind_of?(Paginatable::ClassMethods::WithContext) && posts.context? && posts.to_a.index(post) == (posts.context-1) 
 end 
 end 
 unless no_container 
 end 
 if new_posts_notifier 
 end 
 
  anchor ||= nil
  pagination_params ||= {}

 if p.total_pages > 1 
 link_to_unless((p.current_page == 1),
                           "First",
                           {
                             page: 1,
                             anchor: anchor
                           }.merge(pagination_params),
                           class: :first_page_link) 
 link_to_if(p.previous_page,
                       "Previous",
                       {
                         page: p.previous_page,
                         anchor: anchor
                       }.merge(pagination_params),
                       class: :prev_page_link) 
 link_to_if(p.next_page,
                       "Next",
                       {
                         page: p.next_page,
                         anchor: anchor
                       }.merge(pagination_params),
                       class: :next_page_link) 
 link_to_unless((p.current_page == p.total_pages),
                           "Last",
                           {
                             page: p.total_pages,
                             anchor: anchor
                           }.merge(pagination_params),
                           class: :last_page_link) 
 end 
 p.current_page 
 p.total_pages 
 
 
 end 
 link_to "Back to discussions", discussions_path, id: 'back_link' 
 if current_user? && current_user.following?(@exchange) 
 link_to "Back to followed", following_discussions_path 
 end 
 link_to "Top of page", "#top" 
 if @exchange.postable_by?(current_user) 
  form_for([exchange, exchange.posts.new]) do |f| 
 f.hidden_field(:format, class: "format") 
 f.text_area(
        :body,
        id:                    "compose-body",
        class:                 "rich",
        "data-format-binding"  => ".format",
        "data-formats"         => "markdown html",
        "data-remember-format" => "true"
      ) 
 submit_tag "Post" 
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

  def new
    @exchange = Conversation.new
    @recipient = User.find_by_username(params[:username]) if params[:username]
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

  @page_title = "New #{@exchange.class.to_s.downcase}"

 form_for(@exchange) do |f| 
  f.hidden_field :type 
 f.hidden_field(:format, class: "format") 
 if @recipient 
 hidden_field_tag :recipient_id, @recipient.id 
 end 
 f.labelled_text_field :title, class: "text title" 
 f.labelled_text_area :body, id: "compose-body", class: "rich", "data-format-binding" => ".format", "data-formats" => "markdown html", "data-remember-format" => @exchange.new_record? 
 f.labelled_check_box :nsfw 
 if @exchange.closeable_by?(current_user) 
 f.labelled_check_box :closed 
 end 
 if @exchange.kind_of?(Discussion) && current_user.moderator? 
 f.labelled_check_box :sticky 
 end 
 if @exchange.kind_of?(Discussion) && current_user.trusted? 
 f.labelled_check_box :trusted 
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

  def create
    @exchange = Conversation.create(exchange_params.merge(poster: current_user))
    if @exchange.valid?
      @exchange.add_participant(@recipient) if @recipient
      redirect_to @exchange
    else
      flash.now[:notice] = "Could not save your conversation! " \
                           "Please make sure all required fields are filled in."
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

  @page_title = "New #{@exchange.class.to_s.downcase}"

 form_for(@exchange) do |f| 
  f.hidden_field :type 
 f.hidden_field(:format, class: "format") 
 if @recipient 
 hidden_field_tag :recipient_id, @recipient.id 
 end 
 f.labelled_text_field :title, class: "text title" 
 f.labelled_text_area :body, id: "compose-body", class: "rich", "data-format-binding" => ".format", "data-formats" => "markdown html", "data-remember-format" => @exchange.new_record? 
 f.labelled_check_box :nsfw 
 if @exchange.closeable_by?(current_user) 
 f.labelled_check_box :closed 
 end 
 if @exchange.kind_of?(Discussion) && current_user.moderator? 
 f.labelled_check_box :sticky 
 end 
 if @exchange.kind_of?(Discussion) && current_user.trusted? 
 f.labelled_check_box :trusted 
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

  def edit
    super
  end

  def update
    super
  end

  def invite_participant
    if params[:username]
      add_participants(@exchange, params[:username].split(/\s*,\s*/))
    end
    if request.xhr?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  participants.each do |participant| 
 profile_link(participant) 
 if exchange.removeable_by?(participant, current_user) 
 link_to("Remove",
                    remove_participant_conversation_path(
                      exchange,
                      username: participant.username
                    ),
                    class: "remove-participant",
                    method: :delete,
                    data: { confirm: "Are you sure?" }) 
 end 
 end 
 

end

    else
      redirect_to @exchange
    end
  end

  def remove_participant
    @exchange.remove_participant(@user)

    if @user == current_user
      flash[:notice] = "You have been removed from the conversation"
      redirect_to conversations_url
    else
      flash[:notice] = "#{@user.username} has been removed from " \
        "the conversation"
      redirect_to @exchange
    end
  end

  def mute
    current_user
      .conversation_relationships.where(conversation: @exchange)
      .update_all(notifications: false)
    redirect_to conversation_url(@exchange, page: params[:page])
  end

  def unmute
    current_user
      .conversation_relationships.where(conversation: @exchange)
      .update_all(notifications: true)
    redirect_to conversation_url(@exchange, page: params[:page])
  end

  private

  def add_participants(exchange, usernames)
    usernames.each do |username|
      user = User.find_by_username(username)
      exchange.add_participant(user) if user
    end
  end

  def exchange_params
    params.require(:conversation).permit(
      :recipient_id, :title, :body, :format, :recipient_id
    )
  end

  def find_exchange
    @exchange = Conversation.find(params[:id])
    render_error 403 unless @exchange.viewable_by?(current_user)
  end

  def find_recipient
    if params[:recipient_id]
      begin
        @recipient = User.find(params[:recipient_id])
      rescue ActiveRecord::RecordNotFound
        @recipient = nil
      end
    end
  end

  def find_remove_user
    @user = User.find_by_username(params[:username])
    return if @exchange.removeable_by?(@user, current_user)
    flash[:error] = "You can't do that!"
    redirect_to @exchange
  end
end
