# -*- coding: utf-8 -*-
require 'spec_helper'

describe Photo do
  let(:photo){ Photo.new(user_id: 1, provider: :hoge, platform_id: "100", format: "jpg", posted_at: Time.now) }
  let(:photo_duplicate){ Photo.new(user_id: 1, provider: :hoge, platform_id: "100", format: "jpg", posted_at: Time.now) }

  describe "validations" do
    describe "user_id" do
      before do
        photo.user_id = nil
      end
      it "required" do
        expect(photo).not_to be_valid
      end
    end
    describe "provider" do
      before do
        photo.provider = nil
      end
      it "required" do
        expect(photo).not_to be_valid
      end
    end
    describe "platform_id" do
      context "platform_id is nil" do
        before do
          photo.platform_id = nil
        end
        it "required" do
          expect(photo).not_to be_valid
        end
      end
      context "same provider and plaftom_id" do
        before do 
          photo.save
        end
        it "unique" do
          expect(photo_duplicate).not_to be_valid
        end
      end
    end
    describe "format" do
      before do
        photo.format = nil
      end
      it "required" do
        expect(photo).not_to be_valid
      end
    end
    describe "posted_at" do
      before do
        photo.posted_at = nil
      end
      it "required" do
        expect(photo).not_to be_valid
      end
    end
  end
end
