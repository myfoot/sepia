module Sepia
  class API::V1
    module Helper::Auth
      def current_token
        env['api.token']
      end
      def current_user
        @current_user ||= User.find(current_token.resource_owner_id) if current_token
      end
    end
  end
end
