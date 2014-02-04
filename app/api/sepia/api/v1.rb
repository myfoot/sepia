module Sepia
  class API::V1 < Grape::API
    helpers do
      def current_token; env['api.token'] end
      def current_user; @current_user ||= Acl::User.find(current_token.resource_owner_id) if current_token end
    end

    version 'v1', using: :path, vendor: 'sepia'
    format :json
    mount Sepia::API::V1::Photo
  end
end
