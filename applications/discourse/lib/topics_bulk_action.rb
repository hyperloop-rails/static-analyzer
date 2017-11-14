class TopicsBulkAction

  def initialize(user, topic_ids, operation, options={})
    @user = user
    @topic_ids = topic_ids
    @operation = operation
    @changed_ids = []
    @options = options
  end

  def self.operations
    @operations ||= %w(change_category close archive change_notification_level
                       reset_read dismiss_posts delete unlist archive_messages
                       move_messages_to_inbox)
  end

  def self.register_operation(name, &block)
    operations << name
    define_method(name, &block)
  end

  def perform!
    raise Discourse::InvalidParameters.new(:operation) unless TopicsBulkAction.operations.include?(@operation[:type])
    send(@operation[:type])
    @changed_ids
  end

  private

    def find_group
      return unless @options[:group]

      group = Group.where('name ilike ?', @options[:group]).first
      raise Discourse::InvalidParameters.new(:group) unless group
      unless group.group_users.where(user_id: @user.id).exists?
        raise Discourse::InvalidParameters.new(:group)
      end
      group
    end

    def move_messages_to_inbox
      group = find_group
      topics.each do |t|
        if guardian.can_see?(t) && t.private_message?
          if group
            GroupArchivedMessage.move_to_inbox!(group.id, t.id)
          else
            UserArchivedMessage.move_to_inbox!(@user.id,t.id)
          end
        end
      end
    end

    def archive_messages
      group = find_group
      topics.each do |t|
        if guardian.can_see?(t) && t.private_message?
          if group
            GroupArchivedMessage.archive!(group.id, t.id)
          else
            UserArchivedMessage.archive!(@user.id, t.id)
          end
        end
      end
    end

    def dismiss_posts
      sql = "
      UPDATE topic_users tu
      SET highest_seen_post_number = t.highest_post_number , last_read_post_number = highest_post_number
      FROM topics t
      WHERE t.id = tu.topic_id AND tu.user_id = :user_id AND t.id IN (:topic_ids)
      "

      Topic.exec_sql(sql, user_id: @user.id, topic_ids: @topic_ids)
      @changed_ids.concat @topic_ids
    end

    def reset_read
      PostTiming.destroy_for(@user.id, @topic_ids)
    end

    def change_category
      topics.each do |t|
        if guardian.can_edit?(t)
          @changed_ids << t.id if t.change_category_to_id(@operation[:category_id])
        end
      end
    end

    def change_notification_level
      topics.each do |t|
        if guardian.can_see?(t)
          TopicUser.change(@user, t.id, notification_level: @operation[:notification_level_id].to_i)
          @changed_ids << t.id
        end
      end
    end

    def close
      topics.each do |t|
        if guardian.can_moderate?(t)
          t.update_status('closed', true, @user)
          @changed_ids << t.id
        end
      end
    end

    def unlist
      topics.each do |t|
        if guardian.can_moderate?(t)
          t.update_status('visible', false, @user)
          @changed_ids << t.id
        end
      end
    end

    def archive
      topics.each do |t|
        if guardian.can_moderate?(t)
          t.update_status('archived', true, @user)
          @changed_ids << t.id
        end
      end
    end

    def delete
      topics.each do |t|
        t.trash! if guardian.can_delete?(t)
      end
    end

    def guardian
      @guardian ||= Guardian.new(@user)
    end

    def topics
      @topics ||= Topic.where(id: @topic_ids)
    end


end

