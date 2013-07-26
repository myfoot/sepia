require 'oauth2'
require 'nokogiri'

module Clients
  module Social
    class Google
      attr_reader :client, :user_id
      AUTHORIZE_URL = 'https://accounts.google.com/o/oauth2/auth'
      TOKEN_URL = 'https://accounts.google.com/o/oauth2/token'
      MAX_PER_PAGE = 200
      MAX_COUNT = 1000

      def initialize access_token
        @access_token = access_token
        @user_id = access_token.user_id
        @uid = access_token.uid
        @token = access_token.token
        @oauth = OAuth2::Client.new(Settings.social.google.consumer_key,
                                    Settings.social.google.consumer_secret,
                                    site: AUTHORIZE_URL, token_url: TOKEN_URL, authorize_url: AUTHORIZE_URL)
        @client = OAuth2::AccessToken.new(@oauth,
                                          access_token.token,
                                          refresh_token: access_token.refresh_token)
      end

      def provider
        :google_oauth2
      end

      def refresh_token!
        @client = @client.refresh!
        @access_token.token = @client.token
        @access_token.refresh_token = @client.refresh_token
        @access_token.save!
        self
      end

      def photos last_date=nil, page=1
        photos = []

        while true do
          data = page_data( ( page - 1 ) * MAX_PER_PAGE ) || break

          tmp = data.inject([]){|acc, image|
            acc << photo(image) if !last_date || last_date.localtime < image.published_at
            acc
          }

          photos.concat tmp
          break if data.size < MAX_PER_PAGE || tmp.size < data.size || (page + 1) * MAX_PER_PAGE > MAX_COUNT
          page += 1
        end

        photos
      end

      private
      def photo(google_photo)
        Photo::Google.new(user_id: @user_id,
                          provider: self.provider,
                          platform_id: google_photo.id,
                          format: google_photo.format,
                          message: '',
                          width: google_photo.width,
                          height: google_photo.height,
                          posted_at:  google_photo.published_at,
                          fullsize_url: google_photo.fullsize_url,
                          thumbnail_url: google_photo.thumbnail_url
                          )
      end

      def page_data(offset)
        body = @client.get("https://picasaweb.google.com/data/feed/api/user/#{@uid}?kind=photo&max-results=#{MAX_PER_PAGE}&start-index=#{offset + 1}").body
        Nokogiri::XML(body).xpath('//xmlns:entry').map{|entry| GooglePhoto.new(entry) }
      end
    end

    class GooglePhoto
      attr_reader :entry
      def initialize entry
        @entry = entry
      end
      def id
        @id ||= @entry.xpath('gphoto:id').text
      end
      def album_id
        @album_id ||= @entry.xpath('gphoto:albumid').text
      end
      def title
        @title ||= @entry.xpath('xmlns:title').text
      end
      def format
        @format ||= @entry.xpath('media:group/media:content').attr('type').value.sub('image/','')
      end
      def width
        @width ||= @entry.xpath('media:group/media:content').attr('width').value
      end
      def height
        @height ||= @entry.xpath('media:group/media:content').attr('height').value
      end
      def summary
        @title ||= @entry.xpath('xmlns:summary').text
      end
      def fullsize_url
        @fullsize_url ||= @entry.xpath('media:group/media:content').attr('url').value
      end
      def thumbnail_url
        return @thumbnail_url if @thumbnail_url
        thumbnails = @entry.xpath("media:group/media:thumbnail")
        thumbnail = thumbnails[thumbnails.each_with_index.inject(0){|min_index, (v,i)| v.attr('height') < thumbnails[min_index].attr('height') ? i : min_index }]
        @thumbnail_url ||= thumbnail.try(:attr, 'url')
      end
      def published_at
        @published_at ||= Time.parse(@entry.xpath('xmlns:published').text).localtime
      end
    end
  end
end
