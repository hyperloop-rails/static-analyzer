class CampfireService < Service
  prop_accessor :token, :subdomain, :room
  validates :token, presence: true, if: :activated?

  def title
    'Campfire'
  end

  def description
    'Simple web-based real-time group chat'
  end

  def to_param
    'campfire'
  end

  def fields
    [
      { type: 'text', name: 'token',     placeholder: '' },
      { type: 'text', name: 'subdomain', placeholder: '' },
      { type: 'text', name: 'room',      placeholder: '' }
    ]
  end

  def supported_events
    %w(push)
  end

  def execute(data)
    return unless supported_events.include?(data[:object_kind])

    room = gate.find_room_by_name(self.room)
    return true unless room

    message = build_message(data)

    room.speak(message)
  end

  private

  def gate
    @gate ||= Tinder::Campfire.new(subdomain, token: token)
  end

  def build_message(push)
    ref = Gitlab::Git.ref_name(push[:ref])
    before = push[:before]
    after = push[:after]

    message = ""
    message << "[#{project.name_with_namespace}] "
    message << "#{push[:user_name]} "

    if Gitlab::Git.blank_ref?(before)
      message << "pushed new branch #{ref} \n"
    elsif Gitlab::Git.blank_ref?(after)
      message << "removed branch #{ref} \n"
    else
      message << "pushed #{push[:total_commits_count]} commits to #{ref}. "
      message << "#{project.web_url}/compare/#{before}...#{after}"
    end

    message
  end
end
