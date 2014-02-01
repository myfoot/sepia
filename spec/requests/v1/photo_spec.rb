# -*- coding: utf-8 -*-
require 'spec_helper'
require 'json'

describe Sepia::API::V1::Photo do
  
  let(:user) { User.new(name: "test-user", email: "hoge@gmail.com" ) }
  let!(:application) {
    Doorkeeper::Application.new(name: "MyApp", redirect_uri: "http://app.com").tap{|app|
      app.owner = user
      app.save
    }
  }
  let!(:token) { Doorkeeper::AccessToken.create! application_id: application.id, resource_owner_id: user.id }
  let!(:photo1){ Photo.create!(user_id: user.id, provider: :hoge, platform_id: "100", format: "jpg", posted_at: Time.now - 1.day) }
  let!(:photo2){ Photo.create!(user_id: user.id, provider: :hoge, platform_id: "101", format: "jpg", posted_at: Time.now) }

  describe "invalid token" do
    subject {
      get "/api/v1/photo.json?access_token=hoge"
      response
    }
    it { should_not be_success }
  end

  describe "GET /api/v1/photo.json" do
    subject {
      get "/api/v1/photo.json?access_token=#{token.token}"
      response
    }

    it { should be_success }
    it "all photos of user", autodoc: true do
      expect(subject.body).to eq [ photo2, photo1 ].to_json
    end
  end
end
