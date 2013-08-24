# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  let(:avatar_url) { "http://hoge.jpg" }
  let(:user) { User.new(name: "test-user", email: "hoge@gmail.com", avatar_url: avatar_url) }
  let(:provider) { :twitter }
  let(:uid) { "1234567890" }
  let(:token) { "hoge" }
  let(:secret) { "secret" }
  let(:access_token) { AccessToken.create!(user_id: user.id, uid: uid, token: token, secret: secret, provider: provider) }
  let(:other_token) { AccessToken.create!(user_id: 100, uid: uid, token: "other_token", secret: "other_secret", provider: provider) }

  describe "validations" do
    describe "name" do
      before do
        @noname_user = user.tap{|u|
          u.name = ""
          u.save
        }
      end
      it "required" do
        expect(@noname_user).not_to be_valid
      end
    end
  end

  describe "#add_token_if_not_exist" do
    before do
      user.save
    end
    context "指定したプロバイダのAccessTokenが対象ユーザーに既に登録済みの場合" do
      it "新規に登録されない" do
        user.add_token_if_not_exist(access_token.provider, {})
        expect(user.access_tokens.size).to eq(1)
      end
    end
    context "指定したプロバイダのAccessTokenが対象ユーザーに未登録の場合" do
      before do
        access_token
      end
      it "新規に登録される" do
        user.add_token_if_not_exist(:facebook, {})
        expect(user.access_tokens.size).to eq(2)
      end
    end
    context "指定したuidのトークンが既に別ユーザーで登録済みの場合" do
      before do
        other_token
      end
      it "自分のトークンとして更新する" do
        user.add_token_if_not_exist(:twitter, {name: user.name, uid: uid, token: token, secret: secret})

        expect(user.access_tokens.size).to eq(1)

        new_token = user.access_tokens.first
        expect(new_token.persisted?).to be_true
        expect(new_token.token).to eq(token)
        expect(new_token.secret).to eq(secret)
      end
    end
  end

  describe ".find_or_create_by_auth" do
    before do
      user.save
      access_token
    end
    context "provider, uid が一致するユーザーが存在する場合" do
      let(:new_name){ "hoge" }
      let(:new_token){ "hoge-token" }
      let(:new_secret){ "hoge-secret" }
      let(:new_expired_at){ Time.now }
      let(:new_avatar_url){ "hoge-url" }

      subject { User.find_or_create_by_auth(name: new_name, provider: provider, uid: uid, token: new_token, secret: new_secret, avatar_url: new_avatar_url, expired_at: new_expired_at) }

      it { should == user }
      it "name, token, secret, expired_at, avatar_urlが更新される" do
        token = subject.access_tokens.first
        expect(token.name).to eq(new_name)
        expect(token.token).to eq(new_token)
        expect(token.secret).to eq(new_secret)
        expect(token.expired_at).to eq(new_expired_at)

        expect(subject.avatar_url).to eq(new_avatar_url)
      end
    end
    context "provider, uid が一致するユーザーが存在しない場合" do
      subject { User.find_or_create_by_auth(name: "hoge", provider: provider, uid: "aaaaaa", token: token, secret: secret, avatar_url: avatar_url) }
      it "新規ユーザーを取得できる" do
        expect(subject).not_to eq(user)
        expect(subject.name).to eq("hoge")
        expect(subject.email).to eq("")
        expect(subject.avatar_url).to eq(avatar_url)
      end
    end
  end

end
