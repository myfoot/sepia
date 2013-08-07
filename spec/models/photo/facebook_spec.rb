# -*- coding: utf-8 -*-
require 'spec_helper'

describe Photo::Facebook do
  let(:photo){ Photo::Facebook.new(user_id: 1, provider: :facebook, platform_id: "idid", format: "png", posted_at: Time.now, fullsize_url: "full-size", thumbnail_url: "thumb") }

  describe "validations" do
    describe "fullsize_url" do
      before do
        photo.fullsize_url = nil
      end
      it "required" do
        expect(photo).not_to be_valid
      end
    end
    describe "thumbnail_url" do
      before do
        photo.thumbnail_url = nil
      end
      it "required" do
        expect(photo).not_to be_valid
      end
    end
  end  

  describe "#fullsize_url" do
    subject{ photo.fullsize_url }
    it { should == "full-size" }
  end
  describe "#thumbnail_url" do
    subject{ photo.thumbnail_url }
    it { should == "thumb" }
  end
end
