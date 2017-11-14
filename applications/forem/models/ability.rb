require 'cancan'

  class Ability
    include CanCan::Ability

    class_attribute :abilities
    self.abilities = Set.new

    # Allows us to go beyond the standard cancan initialize method which makes it difficult for engines to
    # modify the default +Ability+ of an application.  The +ability+ argument must be a class that includes
    # the +CanCan::Ability+ module.  The registered ability should behave properly as a stand-alone class
    # and therefore should be easy to test in isolation.
    def self.register_ability(ability)
      self.abilities.add(ability)
    end

    def self.remove_ability(ability)
      self.abilities.delete(ability)
    end

    def initialize(user)
      user ||= Forem.user_class.new
		end

    def can_read_Category(category)
        user.can_read_forem_category?(category)
    end

    def can_read_Topic(topic)
        user.can_read_forem_forum?(topic.forum) && user.can_read_forem_topic?(topic)
     end

			
     def can_read_Forum(forum)
      if user.can_read_forem_forums?
          user.can_read_forem_category?(forum.category) && user.can_read_forem_forum?(forum)
        end
     end

      def can_create_topic_Forum(forum)
        can?(:read, forum) && user.can_create_forem_topics?(forum)
      end

     	def can_reply_Topic(topic)
        can?(:read, topic.forum) && user.can_reply_to_forem_topic?(topic)
      end

      def can_edit_post_Forum(forum)
        user.can_edit_forem_posts?(forum)
      end
      
      def can_destroy_post_Forum(forum)
        user.can_destroy_forem_posts?(forum)
      end
      
      def can_moderate_Forum(forum)
        user.can_moderate_forem_forum?(forum) || user.forem_admin?
      end

      #include any abilities registered by extensions, etc.
      #Ability.abilities.each do |clazz|
      #  ability = clazz.send(:new, user)
      #  @rules = rules + ability.send(:rules)
      #end
  end
