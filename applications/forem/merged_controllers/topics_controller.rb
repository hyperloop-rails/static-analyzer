  class TopicsController < ApplicationController
    helper 'forem/posts'
    before_filter :authenticate_forem_user, :except => [:show]
    before_filter :find_forum
    before_filter :block_spammers, :only => [:new, :create]

    def show
      if find_topic
        register_view(@topic, forem_user)
        @posts = find_posts(@topic)

        # Kaminari allows to configure the method and param used
        @posts = @posts.send(pagination_method, params[pagination_param]).per(Forem.per_page)
      end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    "forem", media: "all", "data-turbolinks-track" => true 
 javascript_include_tag "forem", "data-turbolinks-track" => true 
 csrf_meta_tags 
 forem_atom_auto_discovery_link_tag 
 flash.each do |k,v| 
 k 
 v 
 end 
 'un' unless @topic.locked? 
  link_to t('forem.forum.forums'), forem.forums_path 
 link_to forem_emojify(topic.forum.title), [forem, topic.forum] 
 forem_emojify(topic.subject) 
 
 if @topic.can_be_replied_to? && can?(:reply, @topic) 
 link_to t(".reply"), forem.new_forum_topic_post_path(@forum, @topic), :class => "btn btn-primary " 
 end 
 if @topic.user == forem_user || forem_admin? 
 link_to t(".delete"), forem.forum_topic_path(@forum, @topic), :method => :delete, data: { :confirm => t("are_you_sure") }, :class => "btn btn-danger" 
 end 
 if forem_user 
 if !@topic.subscriber?(forem_user.id) 
 link_to t(".subscribe"), forem.subscribe_forum_topic_path(@forum, @topic), :method => :post, :class => "btn btn-success" 
 else 
 link_to t(".unsubscribe"), forem.unsubscribe_forum_topic_path(@forum, @topic), :method => :post, :class => "btn btn-danger" 
 end 
 end 
 if forem_admin? 
 link_to t('forem.topic.links.edit'), forem.edit_admin_forum_topic_path(@forum, @topic), :class => "btn" 
 link_to t(".hide.#{@topic.hidden}"), forem.toggle_hide_admin_forum_topic_path(@forum, @topic), :method => :put, :class => "btn" 
 link_to t(".lock.#{@topic.locked}"), forem.toggle_lock_admin_forum_topic_path(@forum, @topic), :method => :put, :class => "btn" 
 link_to t(".pin.#{@topic.pinned}"), forem.toggle_pin_admin_forum_topic_path(@forum, @topic), :method => :put, :class => "btn" 
 end 
 if @topic.pending_review? 
 t(".pending_review") 
 if forem_admin_or_moderator?(@topic.forum) 
 form_for @topic, :url => forem.moderate_forum_topic_path(@topic.forum, @topic), :method => :put do |f| 
  f.radio_button "moderation_option", "approve" 
 f.label "moderation_option_approve", t('approve', :scope => 'forem.posts.moderation'), :class => "label label-success" 
 f.radio_button "moderation_option", "spam" 
 f.label "moderation_option_spam", t('spam', :scope => 'forem.posts.moderation'), :class => "label label-danger" 
 f.submit t('moderate', :scope => 'forem.posts.moderation'), :class => "btn btn-primary" 
 
 end 
 end 
 end 
 forem_pages_widget(@posts) 
  post.id 
 post_counter + 1 
 cycle('odd', 'even') 
 if post.pending_review? 
 t(".pending_review") 
 if forem_admin_or_moderator?(post.topic.forum) 
 if local_assigns[:mass_moderation] 
  fields_for "posts[#{post.id}]" do |f| 
  f.radio_button "moderation_option", "approve" 
 f.label "moderation_option_approve", t('approve', :scope => 'forem.posts.moderation'), :class => "label label-success" 
 f.radio_button "moderation_option", "spam" 
 f.label "moderation_option_spam", t('spam', :scope => 'forem.posts.moderation'), :class => "label label-danger" 
 f.submit t('moderate', :scope => 'forem.posts.moderation'), :class => "btn btn-primary" 
 
 end 
 
 else 
 form_tag forem.forum_moderate_posts_path(post.topic.forum), :method => :put do 
  fields_for "posts[#{post.id}]" do |f| 
  f.radio_button "moderation_option", "approve" 
 f.label "moderation_option_approve", t('approve', :scope => 'forem.posts.moderation'), :class => "label label-success" 
 f.radio_button "moderation_option", "spam" 
 f.label "moderation_option_spam", t('spam', :scope => 'forem.posts.moderation'), :class => "label label-danger" 
 f.submit t('moderate', :scope => 'forem.posts.moderation'), :class => "btn btn-primary" 
 
 end 
 
 end 
 end 
 end 
 end 
 if post.user.is_a?(NilUser) 
 t(:deleted) 
 else 
 link_to_if Forem.user_profile_links, post.user.forem_name, [main_app, post.user] 
 end 
 forem_avatar(post.user, :size => 60) 
 post.id 
 post_time_tag(post) 
 forem_format(post.text) 
 if post.reply_to 
 link_to "#{t("forem.post.in_reply_to")} #{post.reply_to.user.forem_name}", "#post-#{post.reply_to.id}" 
 end 
 if forem_user 
 if can?(:reply, post.topic) 
 if post.topic.can_be_replied_to? 
 link_to t('reply', :scope => 'forem.topic'), forem.new_forum_topic_post_path(post.forum, post.topic, :reply_to_id => post.id), :class => "btn btn-primary" 
 link_to t('quote', :scope => 'forem.topic'), forem.new_forum_topic_post_path(post.forum, post.topic, :reply_to_id => post.id, :quote => true), :class => "btn btn-success" 
 end 
 end 
 if post.owner_or_admin?(forem_user) 
 if can?(:edit_post, post.topic.forum) 
 link_to t('edit', :scope => 'forem.post'), forem.edit_forum_topic_post_path(post.forum, post.topic, post), :class => "btn btn-info" 
 end 
 if can?(:destroy_post, post.topic.forum) 
 link_to t('delete', :scope => 'forem.topic'), forem.forum_topic_post_path(post.forum, post.topic, post), :method => :delete, data: { :confirm => t("are_you_sure") }, :class => "btn btn-danger" 
 end 
 end 
 end 
 
 forem_pages_widget(@posts) 

end

    end

    def new
      authorize! :create_topic, @forum
      @topic = @forum.topics.build
      @topic.posts.build
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    "forem", media: "all", "data-turbolinks-track" => true 
 javascript_include_tag "forem", "data-turbolinks-track" => true 
 csrf_meta_tags 
 forem_atom_auto_discovery_link_tag 
 flash.each do |k,v| 
 k 
 v 
 end 
  link_to t('forem.forum.forums'), forem.root_path 
 link_to forem_emojify(forum.category), [forem, forum.category] 
 link_to forem_emojify(forum.title), [forem, forum] 
 forem_format(forum.description) 
 unless @topic.try(:new_record?) 
 if can? :create_topic, @forum 
 link_to t('forem.topic.links.new'), forem.new_forum_topic_path(forum), :class => "btn btn-primary", :id => "new-topic" 
 end 
 end 
 if @topic 
 link_to t('forem.topic.links.back_to_topics'), forem.forum_path(forum), :class => "btn" 
 end 
 if can? :moderate, @forum 
 link_to t('forem.forum.moderator_tools'), forem.forum_moderator_tools_path(forum), :class => "btn btn-primary" 
 end 
 
 t("forem.topic.new") 
  simple_form_for [forem, @forum, @topic] do |f| 
 f.input :subject 
 f.simple_fields_for :posts do |post| 
  f.input :text, :input_html => { :class => "field col-md-12" } 
 if params[:reply_to_id] 
 f.hidden_field :reply_to_id, :value => params[:reply_to_id] 
 end 

 end 
 f.submit :class => "btn btn-primary" 
 end 
 

end

    end

    def create
      authorize! :create_topic, @forum
      @topic = @forum.topics.build(topic_params)
      @topic.user = forem_user
      if @topic.save
        create_successful
      else
        create_unsuccessful
      end
    end

    def destroy
      @topic = @forum.topics.friendly.find(params[:id])
      if forem_user == @topic.user || forem_user.forem_admin?
        @topic.destroy
        destroy_successful
      else
        destroy_unsuccessful
      end
    end

    def subscribe
      if find_topic
        @topic.subscribe_user(forem_user.id)
        subscribe_successful
      end
    end

    def unsubscribe
      if find_topic
        @topic.unsubscribe_user(forem_user.id)
        unsubscribe_successful
      end
    end

    protected

    def topic_params
      params.require(:topic).permit(:subject, :posts_attributes => [[:text]])
    end
    
    def create_successful
      redirect_to [@forum, @topic], :notice => t("forem.topic.created")
    end

    def create_unsuccessful
      flash.now.alert = t('forem.topic.not_created')
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    "forem", media: "all", "data-turbolinks-track" => true 
 javascript_include_tag "forem", "data-turbolinks-track" => true 
 csrf_meta_tags 
 forem_atom_auto_discovery_link_tag 
 flash.each do |k,v| 
 k 
 v 
 end 
  link_to t('forem.forum.forums'), forem.root_path 
 link_to forem_emojify(forum.category), [forem, forum.category] 
 link_to forem_emojify(forum.title), [forem, forum] 
 forem_format(forum.description) 
 unless @topic.try(:new_record?) 
 if can? :create_topic, @forum 
 link_to t('forem.topic.links.new'), forem.new_forum_topic_path(forum), :class => "btn btn-primary", :id => "new-topic" 
 end 
 end 
 if @topic 
 link_to t('forem.topic.links.back_to_topics'), forem.forum_path(forum), :class => "btn" 
 end 
 if can? :moderate, @forum 
 link_to t('forem.forum.moderator_tools'), forem.forum_moderator_tools_path(forum), :class => "btn btn-primary" 
 end 
 
 t("forem.topic.new") 
  simple_form_for [forem, @forum, @topic] do |f| 
 f.input :subject 
 f.simple_fields_for :posts do |post| 
  f.input :text, :input_html => { :class => "field col-md-12" } 
 if params[:reply_to_id] 
 f.hidden_field :reply_to_id, :value => params[:reply_to_id] 
 end 

 end 
 f.submit :class => "btn btn-primary" 
 end 
 

end

    end

    def destroy_successful
      flash[:notice] = t("forem.topic.deleted")

      redirect_to @topic.forum
    end

    def destroy_unsuccessful
      flash.alert = t("forem.topic.cannot_delete")

      redirect_to @topic.forum
    end

    def subscribe_successful
      flash[:notice] = t("forem.topic.subscribed")
      redirect_to forum_topic_url(@topic.forum, @topic)
    end

    def unsubscribe_successful
      flash[:notice] = t("forem.topic.unsubscribed")
      redirect_to forum_topic_url(@topic.forum, @topic)
    end

    private
    def find_forum
      @forum = Forum.friendly.find(params[:forum_id])
      authorize! :read, @forum
    end

    def find_posts(topic)
      posts = topic.posts
      unless forem_admin_or_moderator?(topic.forum)
        posts = posts.approved_or_pending_review_for(forem_user)
      end
      @posts = posts
    end

    def find_topic
      begin
        @topic = forum_topics(@forum, forem_user).friendly.find(params[:id])
        authorize! :read, @topic
      rescue ActiveRecord::RecordNotFound
        flash.alert = t("forem.topic.not_found")
        redirect_to @forum and return
      end
    end

    def register_view(topic, user)
      topic.register_view_by(user)
    end

    def block_spammers
      if forem_user.forem_spammer?
        flash[:alert] = t('forem.general.flagged_for_spam') + ' ' +
                        t('forem.general.cannot_create_topic')
        redirect_to :back
      end
    end

    def forum_topics(forum, user)
      if forem_admin_or_moderator?(forum)
        forum.topics
      else
        forum.topics.visible.approved_or_pending_review_for(user)
      end
    end
  end
