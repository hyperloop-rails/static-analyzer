  class ForumsController < ApplicationController
    load_and_authorize_resource :class => 'Forum', :only => :show
    helper 'forem/topics'

    def index
      @categories = Category.by_position
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    "forem", media: "all", "data-turbolinks-track" => true 
 javascript_include_tag "forem", "data-turbolinks-track" => true 
 csrf_meta_tags 
 forem_atom_auto_discovery_link_tag 
 flash.each do |k,v| 
 k 
 v 
 end 
 t('.title') 
 render @categories 
 if forem_admin? 
 link_to t("area", :scope => "forem.admin"), forem.admin_root_path 
 end 

end

    end

    def show
      authorize! :show, @forum
      register_view
      
      @topics = if forem_admin_or_moderator?(@forum)
        @forum.topics
      else
        @forum.topics.visible.approved_or_pending_review_for(forem_user)
      end

      @topics = @topics.by_pinned_or_most_recent_post

      # Kaminari allows to configure the method and param used
      @topics = @topics.send(pagination_method, params[pagination_param]).per(Forem.per_page)

      respond_to do |format|
        format.html
        format.atom { render :layout => false }
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
 
 forem_pages_widget(@topics) 
 t('forem.topic.headings.topic') 
 t('forem.topic.headings.latest') 
 t('forem.topic.headings.posts') 
 t('forem.topic.headings.views') 
 if @topics.empty? 
 t('forem.topic.none') 
 end 
 render @topics 
 forem_pages_widget(@topics) 

end

    end

    private
    def register_view
      @forum.register_view_by(forem_user)
    end
  end
