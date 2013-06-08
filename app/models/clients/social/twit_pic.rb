module Clients
  module Social
    class TwitPic
      RESOURCE_URL = "http://api.twitpic.com/2/users/show.json"

      def initialize access_token
        @user_name = access_token.name
      end

      def photos last_date=nil, page=1
        photos = []

        while true do
          json = JSON.parse(Net::HTTP.get(URI("#{RESOURCE_URL}?username=#{@user_name}&page=#{page}")))
          images = json["images"]

          break unless images

          tmp = []
          images.each{|image|
            posted_at = Time.parse(image["timestamp"]) + 9.hours
            puts posted_at
            tmp << Photo.new(provider: :twit_pic,
                                platform_id: image["short_id"],
                                format: image["type"],
                                message: image["message"],
                                width: image["width"],
                                height: image["height"],
                                posted_at:  posted_at) if !last_date || last_date < posted_at
          }
          photos.concat tmp
          break if images.size < 20 || tmp.size < images.size
          page += 1
        end

        photos
      end
    end
  end
end
