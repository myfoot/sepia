# -*- coding: utf-8 -*-
require 'foursquare2'

module Clients
  module Social
    class Foursquare
      attr_reader :client, :user_id
      MAX_PER_PAGE = 50
      PROVIDER = :foursquare

      def initialize access_token
        @access_token = access_token
        @user_id = access_token.user_id
        @token = access_token.token
        @client = Foursquare2::Client.new(oauth_token: access_token.token)
      end

      def provider
        PROVIDER
      end

      def photos last_date=nil
        photos = []
        offset = 0

        while true do
          data = page_data(offset)
          break if data.empty?

          offset += data.size
          photos.concat data.select{|p| (!last_date || last_date.localtime < p.published_at) }

          break if data.size < MAX_PER_PAGE || photos.size < offset
        end

        photos.map{|p| photo(p) }
      end

      private
      def photo(p)
        Photo::Foursquare.new(user_id: @user_id,
                              provider: self.provider,
                              platform_id: p.id,
                              format: p.format,
                              message: p.title,
                              width: p.width,
                              height: p.height,
                              posted_at:  p.published_at,
                              fullsize_url: p.fullsize_url,
                              thumbnail_url: p.thumbnail_url
                              )
      end

      def page_data(offset=0)
        option = {
          limit: MAX_PER_PAGE,
          offset: offset
        }
        photos = @client.user_photos(option).try(:items)
        photos ? photos.map{|m| FoursquarePhoto.new(m) } : []
      end
    end

    class FoursquarePhoto
      def initialize photo
        @photo = photo
      end
      def id
        @photo.id
      end
      def title
        @title ||= (@photo.try(:venue).try(:name) || "")
      end
      def format
        "jpg"
      end
      def width
        @width ||= @photo.sizes.items.first.width
      end
      def height
        @height ||= @photo.sizes.items.first.height
      end
      def fullsize_url
        @fullsize_url ||= @photo.url
      end
      def thumbnail_url
        @thumbnail_url ||= @photo.sizes.items.third.url
      end
      def published_at
        @published_at ||= Time.at(@photo.createdAt)
      end
    end
  end
end
