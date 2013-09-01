# -*- coding: utf-8 -*-
require 'instagram'

module Clients
  module Social
    class InstagrAm
      attr_reader :client, :user_id
      MAX_PER_PAGE = 20
      PROVIDER = :instagram

      ::Instagram.configure do |conf|
        conf.client_id     = Settings.social.instagram.cosumer_key
        conf.client_secret = Settings.social.instagram.cosumer_secret
      end

      def initialize access_token
        @access_token = access_token
        @user_id = access_token.user_id
        @token = access_token.token
        @client = ::Instagram.client(access_token: access_token.token)
      end

      def provider
        PROVIDER
      end

      def photos last_date=nil
        photos = []

        max_date = nil

        while true do
          data = page_data(max_date, last_date)
          break if data.empty?

          tmp = data.inject([]){|acc, image|
            max_date = image.published_at
            acc << photo(image) if !last_date || last_date.localtime < image.published_at
            acc
          }

          photos.concat tmp
          break if data.size < MAX_PER_PAGE || tmp.size < data.size
        end

        photos
      end

      private
      def photo(instagram_photo)
        Photo::InstagrAm.new(user_id: @user_id,
                             provider: self.provider,
                             platform_id: instagram_photo.id,
                             format: instagram_photo.format,
                             message: instagram_photo.title,
                             width: instagram_photo.width,
                             height: instagram_photo.height,
                             posted_at:  instagram_photo.published_at,
                             fullsize_url: instagram_photo.fullsize_url,
                             thumbnail_url: instagram_photo.thumbnail_url
                             )
      end

      def page_data(max_date = nil, min_date)
        option = {
          max_timestamp: max_date.try(:to_i),
          min_timestamp: min_date.try(:to_i)
        }
        @client.user_recent_media(option).map{|m| InstagramPhoto.new(m) }
      end
    end

    class InstagramPhoto
      def initialize photo
        @photo = photo
      end
      def id
        @photo.id
      end
      def title
        @title ||= (@photo.caption.try(:text) || "")
      end
      def format
        "jpg"
      end
      def width
        @width ||= @photo.images.standard_resolution.width
      end
      def height
        @height ||= @photo.images.standard_resolution.height
      end
      def fullsize_url
        @fullsize_url ||= @photo.images.standard_resolution.url
      end
      def thumbnail_url
        @thumbnail_url ||= @photo.images.thumbnail.url
      end
      def published_at
        @published_at ||= Time.at(@photo.created_time.to_i)
      end
    end
  end
end
