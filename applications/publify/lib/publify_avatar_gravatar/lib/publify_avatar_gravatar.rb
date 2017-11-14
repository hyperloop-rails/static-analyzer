# PublifyAvatarGravatar

module PublifyPlugins
  class Gravatar < AvatarPlugin
    @description = 'Provide user avatar image throught the http://gravatar.com service.'

    class << self
      def get_avatar(options = {})
        email = options.delete(:email) || ''
        gravatar_tag(email, options)
      end

      def name
        'Gravatar'
      end

      private

      # Generate the image tag for a commenters gravatar based on their email address
      # Valid options are described at http://www.gravatar.com/implement.php
      def gravatar_tag(email, options = {})
        options[:gravatar_id] = Digest::MD5.hexdigest(email.strip)
        options[:default] = CGI.escape(options[:default]) if options.include?(:default)
        options[:size] ||= 48
        klass = options[:class] ? options[:class] : 'avatar gravatar'

        url = '//www.gravatar.com/avatar.php?' << options.map { |key, value| "#{key}=#{value}" }.sort.join('&amp;')
        "<img src=\"#{url}\" class=\"#{klass}\" alt=\"Gravatar\" />"
      end
    end
  end
end
