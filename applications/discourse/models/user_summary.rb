# ViewModel used on Summary tab on User page

class UserSummary

  MAX_FEATURED_BADGES = 10
  MAX_TOPICS = 6

  alias :read_attribute_for_serialization :send

  def initialize(user, guardian)
    @user = user
    @guardian = guardian
  end

  def topics
    Topic
      .secured(@guardian)
      .listable_topics
      .visible
      .where(user: @user)
      .order('like_count desc, created_at asc')
      .includes(:user, :category)
      .limit(MAX_TOPICS)
  end

  def replies
    Post
      .secured(@guardian)
      .includes(:user, {topic: :category})
      .references(:topic)
      .merge(Topic.listable_topics.visible.secured(@guardian))
      .where(user: @user)
      .where('post_number > 1')
      .where('topics.archetype <> ?', Archetype.private_message)
      .order('posts.like_count desc, posts.created_at asc')
      .limit(MAX_TOPICS)
  end

  def badges
    @user.featured_user_badges(MAX_FEATURED_BADGES)
  end

  def user_stat
    @user.user_stat
  end

  delegate :likes_given, :likes_received, :days_visited,
           :posts_read_count, :topic_count, :post_count,
           to: :user_stat

end
