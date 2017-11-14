class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  attr_accessible :content, :action
	after_save :after_save_observer, :message_broadcast_data, :upload_broadcast_data

  paginates_per Kandan::Config.options[:per_page]

  def user_or_deleted_user
    self.user || User.deleted_user
  end


	def after_save_observer
    if self.action == "message" || activity.action == "upload"
      faye_channel, broadcast_data = self.send "#{self.action}_broadcast_data", activity
      Kandan::Config.broadcaster.broadcast(faye_channel, broadcast_data)
    end
  end

  def message_broadcast_data
    faye_channel = "/channels/#{self.channel.to_param}"
    broadcast_data = self.attributes.merge({
        :user => self.user.as_json(:only => [:id, :email, :first_name, :last_name, :gravatar_hash, :active, :locale, :username, :is_admin, :avatar_url]),
        :channel => self.channel.attributes
      })
    [faye_channel, broadcast_data]
  end

  def upload_broadcast_data
    faye_channel = "/app/activities"
    broadcast_data = {
      :event  => "attachment#upload",
      :entity => self.attributes.merge({
          :user => self.user.as_json(:only => [:id, :email, :first_name, :last_name, :gravatar_hash, :active, :locale, :username, :is_admin, :avatar_url]),
          :channel => self.channel.attributes
        }),
      :extra  => {
        :attachments => self.channel.attachments.as_json(:methods => :url)
      }
    }
    [faye_channel, broadcast_data]
  end

end
