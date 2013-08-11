# -*- coding: utf-8 -*-
require 'twitter'

module Clients
  module Social
    class PicTwitter
      attr_reader :user_id
      MAX_PER_PAGE = 20
      PROVIDER = :twitter

      def initialize access_token
        Twitter.configure do |config|
          config.consumer_key       = Settings.social.twitter.consumer_key
          config.consumer_secret    = Settings.social.twitter.consumer_secret
          config.oauth_token        = access_token.token
          config.oauth_token_secret = access_token.secret
        end
        @client = Twitter::Client.new
        @user_name = access_token.name
        @user_id = access_token.user_id
      end

      def provider
        PROVIDER
      end

      # 引用などを用いて1ツイートに複数pic.twitterを含んでも全て取得できないことがある
      # TwitterのAPIがmediaとして解釈してくれれば問題ないが、
      # 条件によっては1枚(もしくは特定枚数？)しかmediaと認識されない。条件は不明。
      #
      # TODO pageは使わないけれどSocial::TwitterClientsから呼ばれる際の
      #      インターフェースに合わせて定義してある
      def photos last_date=nil, page=1
        photos = []
        max_id = nil
        while true do
          all_tweets = read_user_timeline(@user_name, max_id)
          if all_tweets.empty? ||
               (last_date && all_tweets.first.created_at <= last_date.localtime)
            break
          end

          # max_idで指定したツイートも結果に含まれてしまう。
          # そのツイートが重複して登録されてしまうので除外して処理する
          # ただし初回(max_idがnil)の場合は除外しない
          target_tweets = max_id ? all_tweets[1..-1] : all_tweets

          img_tweets = fetch_img_tweets(target_tweets, last_date)
          photos.concat(img_tweets[:data])
          break if all_tweets.size < MAX_PER_PAGE || img_tweets[:finish]
          max_id = all_tweets.last.id
        end
        photos
      end

      private
      def photo tweet, image
        Photo::PicTwitter.new(user_id: @user_id,
                              provider: self.provider,
                              platform_id: image.id,
                              # .jpg -> jpg
                              format: File.extname(image.media_url_https)[1..-1],
                              message: tweet.text,
                              width: image.sizes[:large].w,
                              height: image.sizes[:large].h,
                              posted_at: tweet.created_at.localtime,
                              fullsize_url: "#{image.media_url_https}:large",
                              thumbnail_url: "#{image.media_url_https}:thumb"
                              )
      end

      def fetch_img_tweets tweets, last_date
        img_tweets = {finish: false, data: []}
        img_tweets[:data] = tweets.inject([]) { |acc, tweet|
          if img_tweets[:finish]
            next acc
          end
          if !last_date || last_date.localtime < tweet.created_at
            tweet.media.each { |image|
              # 非公式RTやQTの場合における他人の画像を除外し、自分の画像だけに限定する
              acc << photo(tweet, image) if image.expanded_url.include?("http://twitter.com/#{@user_name}/status")
            }
          else
            img_tweets[:finish] = true
          end
          acc
        }
        img_tweets
      end

      def read_user_timeline user_name, max_id
        options = max_id.nil? ? {count: MAX_PER_PAGE} : {count: MAX_PER_PAGE, max_id: max_id}
        begin
          @client.user_timeline(user_name, options)
        rescue Twitter::Error::TooManyRequests
          # API使用制限(180回/15分)
          # TODO 例外処理どうする？
          []
        end
      end
    end
  end
end
