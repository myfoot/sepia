# -*- coding: utf-8 -*-
require 'spec_helper'

describe Clients::Social::PicTwitter do
  def make_tweet(entities={}, created_at: "Tue Aug 06 03:59:24 +0000 2013")
    default = {
      id: 1,
      created_at: created_at,
      text: "some text",
      entities: {}
    }
    Twitter::Tweet.new(default.merge(entities))
  end

  def make_img_tweet(media_id, user_name="my_user", created_at: "Tue Aug 06 03:59:24 +0000 2013")
    make_tweet({
      entities: {
        media: [{
          id: media_id,
          type: "photo",
          media_url_https: "https://pbs.twimg.com/media/BQ9HijZCAAEZi6t.jpg",
          expanded_url: "http://twitter.com/#{user_name}/status/364588753777459202/photo/1",
          sizes: { large: { w: 100, h: 200 } }
        }]
      }
    }, created_at: created_at)
  end

  let(:token) { AccessToken.new(user_id: 1, name: "my_user") }
  let(:client) { Clients::Social::PicTwitter.new(token) }
  let(:img_tweet) { make_img_tweet(10) }
  let(:mixed_tweet) {
    [make_tweet,
     make_img_tweet(10, "fake_user"),
     make_img_tweet(20),
     make_img_tweet(30, "dummy_user")]
  }
  let(:max_tweets) {
    Clients::Social::PicTwitter::MAX_PER_PAGE.times.map{|i|
      make_img_tweet(i, created_at: "Tue Aug 07 03:59:#{59-i} +0000 2013")
    }
  }
  let(:few_tweets) {
    (Clients::Social::TwitPic::MAX_PER_PAGE - 10).times.map{|i|
      make_img_tweet(i*100)
    }
  }

  describe "#photos" do
    context "データが無い場合" do
      subject { client.photos }
      before do
        client.stub(:read_user_timeline).and_return([])
      end
      it "空配列を返す" do
        expect(subject).to match_array([])
      end
    end

    context "データが存在する場合" do
      describe "戻り値の型" do
        subject { client.photos.first }
        before do
          client.should_receive(:read_user_timeline).once.and_return([img_tweet])
        end
        it "Photo::PicTwitterのオブジェクトを返す" do
          expect(subject).to be_a(Photo::PicTwitter)
        end
      end

      describe "画像ツイートの絞り込み" do
        subject { client.photos }
        before do
          client.should_receive(:read_user_timeline).once.and_return(mixed_tweet)
        end
        it "自身の画像ツイートだけに絞り込まれる" do
          expect(subject.size).to eq(1)
          expect(subject.first.platform_id).to eq(20)
        end
      end

      context "日付指定なしの場合" do
        subject { client.photos }
        before do
          client.should_receive(:read_user_timeline).once.and_return(max_tweets)
          client.should_receive(:read_user_timeline).once.and_return(few_tweets)
        end
        it "全データを取得する" do
          expect(subject.size).to eq(max_tweets.size + few_tweets.size - 1)
          expect(subject.last.platform_id).to eq(few_tweets.last.media.last.id)
        end
      end

      context "日付指定ありの場合" do
        subject { client.photos Time.parse("2013-08-07 03:59:57 UTC") }
        before do
          client.should_receive(:read_user_timeline).once.and_return(max_tweets)
        end
        it "指定した日付より後のデータを取得する" do
          expect(subject.size).to eq(2)
          expect(subject.last.platform_id).to eq(max_tweets[1].media.last.id)
        end
      end

      describe "戻り値の配列要素" do
        subject { client.photos.first }
        before do
          client.should_receive(:read_user_timeline).once.and_return([img_tweet])
        end
        it "オブジェクトにデータがセットされている" do
          expect(subject.user_id).to eq(token.user_id)
          expect(subject.provider).to eq(:twitter)
          expect(subject.platform_id).to eq(10)
          expect(subject.format).to eq("jpg")
          expect(subject.message).to eq("some text")
          expect(subject.width).to eq(100)
          expect(subject.height).to eq(200)
          expect(subject.posted_at).to eq("Tue Aug 06 03:59:24 +0000 2013")
          expect(subject.thumbnail_url).to eq("https://pbs.twimg.com/media/BQ9HijZCAAEZi6t.jpg:thumb")
          expect(subject.fullsize_url).to eq("https://pbs.twimg.com/media/BQ9HijZCAAEZi6t.jpg:large")
        end
      end
    end
  end
end
