  class PostsController < ApplicationController
    before_filter :authenticate_forem_user, except: :show
    before_filter :find_topic
    before_filter :reject_locked_topic!, only: [:new, :create]

    def show
      find_post
      page = (@topic.posts.count.to_f / Forem.per_page.to_f).ceil

      redirect_to forum_topic_url(@topic.forum, @topic, pagination_param => page, anchor: "post-#{@post.id}")
    end

    def new
      authorize_reply_for_topic!
      block_spammers
      @post = @topic.posts.build
      find_reply_to_post

      if params[:quote] && @reply_to_post
        @post.text = view_context.forem_quote(@reply_to_post.text)
      elsif params[:quote] && !@reply_to_post
        flash[:notice] = t("forem.post.cannot_quote_deleted_post")
        redirect_to [@topic.forum, @topic]
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
 
 t("forem.post.new") 
 if @reply_to_post 
  post.id 
 post.id 
 cycle('odd', 'even') 
 link_to_if Forem.user_profile_links, post.user.forem_name, [main_app, post.user] 
 forem_avatar(post.user, :size => 60) 
 post.created_at.to_s(:db) 
 "#{time_ago_in_words(post.created_at)} #{t("ago")}" 
 forem_format(post.text) 
 if post.reply_to 
 link_to "#{t("forem.post.in_reply_to")} #{post.reply_to.user.forem_name}", "#post-#{post.reply_to.id}" 
 end 
 
 else 
 @topic.subject 
 end 
 simple_form_for [forem, @topic.forum, @topic, @post] do |f| 
  f.input :text, :input_html => { :class => "field col-md-12" } 
 if params[:reply_to_id] 
 f.hidden_field :reply_to_id, :value => params[:reply_to_id] 
 end 
 
 f.submit t("forem.post.buttons.reply"), :class => "btn btn-primary" 
 end 

end

    end

    def create
      authorize_reply_for_topic!
      block_spammers
      @post = @topic.posts.build(post_params)
      @post.user = forem_user

      if @post.save
        create_successful
      else
        create_failed
      end
    end

    def edit
      authorize_edit_post_for_forum!
      find_post
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
 
 t("forem.post.edit", :post => @post) 
 simple_form_for [forem, @topic.forum, @topic, @post] do |f| 
  f.input :text, :input_html => { :class => "field col-md-12" } 
 if params[:reply_to_id] 
 f.hidden_field :reply_to_id, :value => params[:reply_to_id] 
 end 
 
 f.submit t("forem.post.buttons.edit"), :class => "btn btn-primary" 
 end 

end

    end

    def update
      authorize_edit_post_for_forum!
      find_post
      if @post.owner_or_admin?(forem_user) && @post.update_attributes(post_params)
        update_successful
      else
        update_failed
      end
    end

    def destroy
      authorize_destroy_post_for_forum!
      find_post
      unless @post.owner_or_admin? forem_user
        flash[:alert] = t("forem.post.cannot_delete")
        redirect_to [@topic.forum, @topic] and return
      end
      @post.destroy
      destroy_successful
    end

    private

    def post_params
      params.require(:post).permit(:text, :reply_to_id)
    end

    def authorize_reply_for_topic!
      authorize! :reply, @topic
    end

    def authorize_edit_post_for_forum!
      authorize! :edit_post, @topic.forum
    end

    def authorize_destroy_post_for_forum!
      authorize! :destroy_post, @topic.forum
    end

    def create_successful
      flash[:notice] = t("forem.post.created")
      redirect_to forum_topic_url(@topic.forum, @topic, pagination_param => @topic.last_page)
    end

    def create_failed
      params[:reply_to_id] = params[:post][:reply_to_id]
      flash.now.alert = t("forem.post.not_created")
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
 
 t("forem.post.new") 
 if @reply_to_post 
  post.id 
 post.id 
 cycle('odd', 'even') 
 link_to_if Forem.user_profile_links, post.user.forem_name, [main_app, post.user] 
 forem_avatar(post.user, :size => 60) 
 post.created_at.to_s(:db) 
 "#{time_ago_in_words(post.created_at)} #{t("ago")}" 
 forem_format(post.text) 
 if post.reply_to 
 link_to "#{t("forem.post.in_reply_to")} #{post.reply_to.user.forem_name}", "#post-#{post.reply_to.id}" 
 end 
 
 else 
 @topic.subject 
 end 
 simple_form_for [forem, @topic.forum, @topic, @post] do |f| 
  f.input :text, :input_html => { :class => "field col-md-12" } 
 if params[:reply_to_id] 
 f.hidden_field :reply_to_id, :value => params[:reply_to_id] 
 end 
 
 f.submit t("forem.post.buttons.reply"), :class => "btn btn-primary" 
 end 

end

    end

    def destroy_successful
      if @post.topic.posts.count == 0
        @post.topic.destroy
        flash[:notice] = t("forem.post.deleted_with_topic")
        redirect_to [@topic.forum]
      else
        flash[:notice] = t("forem.post.deleted")
        redirect_to [@topic.forum, @topic]
      end
    end

    def update_successful
      redirect_to [@topic.forum, @topic], :notice => t('edited', :scope => 'forem.post')
    end

    def update_failed
      flash.now.alert = t("forem.post.not_edited")
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
 
 t("forem.post.edit", :post => @post) 
 simple_form_for [forem, @topic.forum, @topic, @post] do |f| 
  f.input :text, :input_html => { :class => "field col-md-12" } 
 if params[:reply_to_id] 
 f.hidden_field :reply_to_id, :value => params[:reply_to_id] 
 end 
 
 f.submit t("forem.post.buttons.edit"), :class => "btn btn-primary" 
 end 

end

    end

    def find_topic
      @topic = Topic.friendly.find params[:topic_id]
    end

    def find_post
      @post = @topic.posts.find params[:id]
    end

    def block_spammers
      if forem_user.forem_spammer?
        flash[:alert] = t('forem.general.flagged_for_spam') + ' ' +
                        t('forem.general.cannot_create_post')
        redirect_to :back
      end
    end

    def reject_locked_topic!
      if @topic.locked?
        flash.alert = t("forem.post.not_created_topic_locked")
        redirect_to [@topic.forum, @topic] and return
      end
    end

    def find_reply_to_post
      @reply_to_post = @topic.posts.find_by_id(params[:reply_to_id])
    end
  end
