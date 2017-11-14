  module Admin
    class ForumsController < BaseController
      before_filter :find_forum, :only => [:edit, :update, :destroy]

      def index
        @forums = Forum.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("forem.admin.forum.index") 
 link_to t('back_to_admin', :scope => "forem.admin"), forem.admin_root_path 
 link_to t("forem.admin.forum.new_link"), forem.new_admin_forum_path, :class => "btn btn-primary" 
 @forums.group_by(&:category).each do |category, forums| 
 category.try(:name) || t('.no_category') 
 t('edit', :scope => 'forem.admin.forums') 
 t('delete', :scope => 'forem.admin.forums') 
 t('forum', :scope => 'forem.general') 
 t('topics', :scope => 'forem.general') 
 t('posts', :scope => 'forem.general') 
 forums.each do |forum| 
 cycle("odd", "even") 
 link_to t('edit', :scope => 'forem.admin.forums'), forem.edit_admin_forum_path(forum), :class => "btn btn-info" 
 link_to t('delete', :scope => 'forem.admin.forums'), forem.admin_forum_path(forum), :method => :delete, data: { :confirm => t("delete_confirm", :scope => 'forem.admin.forums') }, :class => "btn btn-danger" 
 link_to forem_emojify(forum.title), forem.forum_path(forum) 
 forem_format(forum.description) 
 t('.last_post') 
 if last_post = forum.posts.last 
 link_to(forem_emojify(last_post.topic.subject), forem.forum_topic_path(forum, last_post.topic)) 
 t('by') 
 link_to_if Forem.user_profile_links, last_post.user.forem_name, [main_app, last_post.user] 
 time_ago_in_words(last_post.created_at) 
 else 
 t('.none') 
 end 
 t('.moderators') 
 if forum.moderators.exists? 
 forum.moderators.map do |moderator| 
 link_to moderator, [forem, :admin, moderator] 
 end.to_sentence 
 else 
 t('.none') 
 end 
 forum.topics.count 
 forum.posts.count 
 end 
 end 

end

      end

      def new
        @forum = Forum.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("forem.forum.new") 
  simple_form_for [forem, :admin, @forum] do |f| 
 f.association :category, :include_blank => false 
 f.input :title 
 f.input :position 
 f.input :description, :as => :text 
 t('forem.admin.forum.moderator_groups') 
 f.association :moderators, :as => :check_boxes 
 f.submit :class => "btn btn-primary" 
 end 
 

end

      end

      def create
        @forum = Forum.new(forum_params)
        if @forum.save
          create_successful
        else
          create_failed
        end
      end

      def update
        if @forum.update_attributes(forum_params)
          update_successful
        else
          update_failed
        end
      end

      def destroy
        @forum.destroy
        destroy_successful
      end

      private

      def forum_params
        params.require(:forum).permit(:category_id, :title, :description, :position, { :moderator_ids => []})
      end

      def find_forum
        @forum = Forum.friendly.find(params[:id])
      end

      def create_successful
        flash[:notice] = t("forem.admin.forum.created")
        redirect_to admin_forums_path
      end

      def create_failed
        flash.now.alert = t("forem.admin.forum.not_created")
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("forem.forum.new") 
  simple_form_for [forem, :admin, @forum] do |f| 
 f.association :category, :include_blank => false 
 f.input :title 
 f.input :position 
 f.input :description, :as => :text 
 t('forem.admin.forum.moderator_groups') 
 f.association :moderators, :as => :check_boxes 
 f.submit :class => "btn btn-primary" 
 end 
 

end

      end

      def destroy_successful
        flash[:notice] = t("forem.admin.forum.deleted")
        redirect_to admin_forums_path
      end

      def update_successful
        flash[:notice] = t("forem.admin.forum.updated")
        redirect_to admin_forums_path
      end

      def update_failed
        flash.now.alert = t("forem.admin.forum.not_updated")
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("forem.forum.edit", :title => forem_emojify(@forum.title)).html_safe 
  simple_form_for [forem, :admin, @forum] do |f| 
 f.association :category, :include_blank => false 
 f.input :title 
 f.input :position 
 f.input :description, :as => :text 
 t('forem.admin.forum.moderator_groups') 
 f.association :moderators, :as => :check_boxes 
 f.submit :class => "btn btn-primary" 
 end 
 

end

      end

    end
  end
