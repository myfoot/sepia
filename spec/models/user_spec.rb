# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  let(:user) { User.new(name: "test-user", email: "hoge@gmail.com") }
  let(:provider) { :twitter }
  let(:uid) { "1234567890" }
  let(:token) { "hoge" }
  let(:secret) { "secret" }
  let(:access_token) { AccessToken.create(user_id: user.id, uid: uid, token: token, secret: secret, provider: provider) }

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

  describe ".find_or_create" do
    before do
      user.save
      access_token
    end
    context "provider, uid が一致するユーザーが存在する場合" do
      subject { User.find_or_create_by_auth(name: "hoge", email: "aaa", provider: provider, uid: uid, token: token, secret: secret) }
      it { should == user }
    end
    context "provider, uid が一致するユーザーが存在しない場合" do
      subject { User.find_or_create_by_auth(name: "hoge", email: "aaa", provider: provider, uid: "aaaaaa", token: token, secret: secret) }
      it "新規ユーザーを取得できる" do
        expect(subject).not_to eq(user)
      end
    end
  end
end
