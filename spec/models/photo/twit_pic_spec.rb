# -*- coding: utf-8 -*-
require 'spec_helper'

describe Photo::TwitPic do
  let(:id){ "hogefoobar" }
  let(:photo){ Photo::TwitPic.new(provider: :twitter, platform_id: id, format: "png", posted_at: Time.now) }
  
  describe "#fullsize_url" do
    subject{ photo.fullsize_url }
    it { should == "http://twitpic.com/show/full/#{id}" }
  end
  describe "#thumbnail_url" do
    subject{ photo.thumbnail_url }
    it { should == "http://twitpic.com/show/thumb/#{id}" }
  end
end
