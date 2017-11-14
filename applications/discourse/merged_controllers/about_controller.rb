require_dependency 'rate_limiter'

class AboutController < ApplicationController
  skip_before_filter :check_xhr, only: [:index]
  before_filter :ensure_logged_in, only: [:live_post_counts]

  def index
    @about = About.new

    respond_to do |format|
      format.html do
        # @list = list
        # store_preloaded(list.preload_key, MultiJson.dump(TopicListSerializer.new(list, scope: guardian)))
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :title do 
t "about" 
 end 
t "js.about.title", {title: @about.title} 
 @about.description 
t "js.about.our_admins" 
 @about.admins.each do |user| 
 user_path(user) 
 user_path(user) 
 user.small_avatar_url 
 user.username 
 if user.name.present? 
 user.name 
 end 
 end 
 if @about.moderators.count > 0 
t "js.about.our_moderators" 
 @about.moderators.each do |user| 
 user_path(user) 
 user_path(user) 
 user.small_avatar_url 
 user.username 
 if user.name.present? 
 user.name 
 end 
 end 
 end 
t 'js.about.stats' 
t 'js.about.stat.all_time' 
t 'js.about.stat.last_7_days' 
t 'js.about.stat.last_30_days' 
t 'js.about.topic_count' 
 @about.stats[:topic_count] 
 @about.stats[:topics_7_days] 
 @about.stats[:topics_30_days] 
t 'js.about.post_count' 
 @about.stats[:post_count] 
 @about.stats[:posts_7_days] 
 @about.stats[:posts_30_days] 
t 'js.about.user_count' 
 @about.stats[:user_count] 
 @about.stats[:users_7_days] 
 @about.stats[:users_30_days] 
t 'js.about.active_user_count' 
 @about.stats[:active_users_7_days] 
 @about.stats[:active_users_30_days] 
t 'js.about.like_count' 
 @about.stats[:like_count] 
 @about.stats[:likes_7_days] 
 @about.stats[:likes_30_days] 

end

      end
      format.json do
        render_serialized(@about, AboutSerializer)
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :title do 
t "about" 
 end 
t "js.about.title", {title: @about.title} 
 @about.description 
t "js.about.our_admins" 
 @about.admins.each do |user| 
 user_path(user) 
 user_path(user) 
 user.small_avatar_url 
 user.username 
 if user.name.present? 
 user.name 
 end 
 end 
 if @about.moderators.count > 0 
t "js.about.our_moderators" 
 @about.moderators.each do |user| 
 user_path(user) 
 user_path(user) 
 user.small_avatar_url 
 user.username 
 if user.name.present? 
 user.name 
 end 
 end 
 end 
t 'js.about.stats' 
t 'js.about.stat.all_time' 
t 'js.about.stat.last_7_days' 
t 'js.about.stat.last_30_days' 
t 'js.about.topic_count' 
 @about.stats[:topic_count] 
 @about.stats[:topics_7_days] 
 @about.stats[:topics_30_days] 
t 'js.about.post_count' 
 @about.stats[:post_count] 
 @about.stats[:posts_7_days] 
 @about.stats[:posts_30_days] 
t 'js.about.user_count' 
 @about.stats[:user_count] 
 @about.stats[:users_7_days] 
 @about.stats[:users_30_days] 
t 'js.about.active_user_count' 
 @about.stats[:active_users_7_days] 
 @about.stats[:active_users_30_days] 
t 'js.about.like_count' 
 @about.stats[:like_count] 
 @about.stats[:likes_7_days] 
 @about.stats[:likes_30_days] 

end

  end

  def live_post_counts
    RateLimiter.new(current_user, "live_post_counts", 1, 10.minutes).performed! unless current_user.staff?
    category_topic_ids = Category.pluck(:topic_id).compact!
    public_topics = Topic.listable_topics.visible.secured(Guardian.new(nil)).where.not(id: category_topic_ids)
    stats = { public_topic_count: public_topics.count }
    stats[:public_post_count] = public_topics.sum(:posts_count) - stats[:public_topic_count]
    render json: stats
  end
end
