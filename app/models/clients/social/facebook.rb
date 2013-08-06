# -*- coding: utf-8 -*-
require 'koala'

module Clients
  module Social
    class Facebook
      attr_reader :client, :user_id

      def initialize access_token
        @access_token = access_token
        @user_id = access_token.user_id
        @token = access_token.token
        @client = Koala::Facebook::API.new(access_token.token)
      end

      def provider
        :facebook
      end

      def photos last_date=nil, page=1
        @client.get_connection('me', 'albums').inject([]){ |photos, album|
          photos.concat(album_photos(album['id'], last_date))
        }
      end

      private
      def album_photos id, last_date
        page = @client.get_connection(id, 'photos')
        next_photos page, last_date
      end

      def next_photos page, last_date, photos = []
        return photos if page.nil? or page.empty?
        photos.concat page.inject([]){ |acc, json|
          acc << photo(json) if last_date.nil? || (posted_at(json) > last_date)
          acc
        }
        next_photos page.next_page, last_date, photos
      end

      def photo(photo)
        Photo::Facebook.new(user_id: @user_id,
                            provider: self.provider,
                            platform_id: photo['id'],
                            format: photo['picture'].match(/.+\.(\w+)$/)[1],
                            message: photo['name'] || '',
                            width: photo['width'],
                            height: photo['height'],
                            posted_at: posted_at(photo),
                            fullsize_url: photo['source'],
                            thumbnail_url: photo['picture']
                          )
      end
      def posted_at json
        Time.parse(json['created_time'])
      end
    end
  end
end
