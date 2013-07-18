module Clients
  module Social
    class TwitPic
      attr_reader :user_id
      RESOURCE_URL = "http://api.twitpic.com/2/users/show.json"
      MAX_PER_PAGE = 20

      def initialize access_token
        @user_name = access_token.name
        @user_id = access_token.user_id
      end

      def provider
        :twitter
      end

      def photos last_date=nil, page=1
        photos = []

        while true do
          images = page_images(uri(@user_name, page)) || break

          tmp = images.inject([]){|acc, image|
            posted_at = posted_at(image)
            acc << photo(image, posted_at) if !last_date || last_date < posted_at
            acc
          }
          photos.concat tmp
          break if images.size < MAX_PER_PAGE || tmp.size < images.size
          page += 1
        end

        photos
      end

      private
      def photo(image, posted_at)
        Photo::TwitPic.new(user_id: @user_id,
                           provider: self.provider,
                           platform_id: image["short_id"],
                           format: image["type"],
                           message: image["message"],
                           width: image["width"],
                           height: image["height"],
                           posted_at:  posted_at)
      end

      def page_images(uri)
        JSON.parse(Net::HTTP.get(uri))["images"]
      end

      def uri(user_name, page)
        URI("#{RESOURCE_URL}?username=#{user_name}&page=#{page}")
      end

      def posted_at(image)
        Time.parse("#{image["timestamp"]} UTC").localtime
      end
    end
  end
end
