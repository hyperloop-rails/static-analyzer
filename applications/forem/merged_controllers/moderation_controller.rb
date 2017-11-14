  class ModerationController < ApplicationController
    before_filter :ensure_moderator_or_admin

    helper 'forem/posts'

    def index
      @posts = forum.posts.pending_review
      @topics = forum.topics.pending_review
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    "forem", media: "all", "data-turbolinks-track" => true 
 javascript_include_tag "forem", "data-turbolinks-track" => true 
 csrf_meta_tags 
 forem_atom_auto_discovery_link_tag 
 flash.each do |k,v| 
 k 
 v 
 end 
 t('.title', :forum => forum) 
 t('posts_count', :count => @posts.count, :scope => 'forem.general') 
 form_tag forem.forum_moderate_posts_url(forum), :method => :put do 
 @posts.limit(25).group_by(&:topic).each do |topic, posts| 
 forem_emojify(topic.forum.title) 
 forem_emojify(topic.subject) 
 render posts, :mass_moderation => true 
 end 
 end 
 t('topics_count', :count => @topics.count, :scope => 'forem.forum') 
 @topics.limit(25).each_with_index do |topic, topic_counter| 
 topic_counter + 1 
 cycle('odd', 'even', name: 'topics') 
 link_to forem_emojify(topic.subject),
                    forem.forum_topic_path(forum, topic) 
 end 

end

    end

    def posts
      Post.moderate!(params[:posts] || [])
      flash[:notice] = t('forem.posts.moderation.success')
      redirect_to :back
    end

    def topic
      if params[:topic]
        topic = forum.topics.friendly.find(params[:topic_id])
        topic.moderate!(params[:topic][:moderation_option])
        flash[:notice] = t("forem.topic.moderation.success")
      else
        flash[:error] = t("forem.topic.moderation.no_option_selected")
      end
      redirect_to :back
    end

    private

    def forum
      @forum = Forum.friendly.find(params[:forum_id])
    end

    helper_method :forum

    def ensure_moderator_or_admin
      unless forem_admin? || forum.moderator?(forem_user)
        raise CanCan::AccessDenied
      end
    end

  end
