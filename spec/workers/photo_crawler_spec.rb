# -*- coding: utf-8 -*-
require 'spec_helper'

describe PhotoCrawler do
  let(:user) { User.create!(name: "test-user", email: "hoge@gmail.com") }
  let(:provider) { :twitter }
  let(:uid) { "1234567890" }
  let(:token) { "hoge" }
  let(:secret) { "secret" }
  let(:access_token) { AccessToken.create!(user_id: user.id, uid: uid, token: token, secret: secret, provider: provider) }

  let(:photo_crawler) { PhotoCrawler.new }
  let(:client) { Clients::Social::TwitPic.new(access_token) }
  let(:exist_photo) { Photo.new(platform: :twitter, platform_id: "10000", format: "png", posted_at: Time.now - 2.days) }
  let(:photo) { Photo.new(platform: :twitter, platform_id: "12000", format: "png", posted_at: Time.now) }

  before do
    client
    AccessToken.stub(:find).with(access_token.id).and_return(access_token)
    Clients::Social::TwitPic.stub(:new).with(access_token).and_return(client)
  end
  
  describe "#perform" do
    context "写真が未登録の場合" do
      before do
        Photo.stub_chain(:where, :order){ [] }
      end
      it "渡されたクライアントを使用して全写真を取得し登録する" do
        client.should_receive(:photos).with(nil).and_return([photo])
        photo.should_receive(:save)
        photo_crawler.perform(Clients::Social::TwitPic.to_s, access_token.id)
      end
    end
    context "写真が登録済みの場合" do
      before do
        Photo.stub_chain(:where, :order){ [exist_photo] }
      end
      it "渡されたクライアントを使用して最終登録日以降の写真を取得し登録する" do
        client.should_receive(:photos).with(exist_photo.posted_at) { [photo] }
        photo.should_receive(:save)
        photo_crawler.perform(Clients::Social::TwitPic.to_s, access_token.id)
      end
    end
  end
end
