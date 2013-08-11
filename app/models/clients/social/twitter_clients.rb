module Clients
  module Social
    class TwitterClients
      attr_reader :user_id
      PROVIDER = :twitter

      def initialize access_token
        @access_token = access_token
        @user_id = access_token.user_id
      end

      def provider
        PROVIDER
      end

      def photos last_date=nil, page=1
        clients.inject([]) { |acc, client|
          acc.concat(client.photos(last_date, page))
        }
      end

      private
      def clients
        [Clients::Social::TwitPic, Clients::Social::PicTwitter].map { |klass|
          klass.new(@access_token)
        }
      end
    end
  end
end
