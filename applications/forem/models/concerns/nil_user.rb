  module Concerns
    module NilUser
      def user
        forem_user || NilUser.new
      end

      def user=(user)
        self.forem_user = user
      end
    end
  end
