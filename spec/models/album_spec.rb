# -*- coding: utf-8 -*-
require 'spec_helper'

describe Album do
  let(:user) { User.create!(name: "test-user", email: "hoge@gmail.com") }
  let(:user2) { User.create!(name: "test-user", email: "hoge@gmail.com") }
  let(:album){ Album.create!(user_id: user.id, name: 'hoge-album') }
  let(:photo){ Photo::Google.create!(user_id: user.id, provider: :hoge, platform_id: "100", format: "jpg", posted_at: Time.now, fullsize_url: "hoge", thumbnail_url: "foo") }
  let(:other_photo){ Photo::Google.create!(user_id: user2.id, provider: :hoge, platform_id: "100", format: "jpg", posted_at: Time.now, fullsize_url: "hoge", thumbnail_url: "foo") }

  describe 'relation' do
    describe 'user' do
      subject{ album.user }
      it { should eq(user) }
    end

    describe 'photos' do
      subject{ album.photos }
      before do
        AlbumsPhotos.create(album_id: album.id, photo_id: photo.id)
      end
      it "紐づくPhotoが取得できる" do
        expect(subject.first).to eq(photo)
      end
    end
  end

  describe "validation" do
    describe "add photos" do
      context "AlbumのユーザーとPhotoのユーザーが同じ場合" do
        it "Albumに紐づくPhotoとして登録される" do
          expect(album.photos << photo).to eq([photo])
          expect(Album.find(album.id).photos.first).to eq(photo)
        end
      end
      context "AlbumのユーザーとPhotoのユーザーが別の場合" do
        it "Albumに紐づくPhotoとして登録されない" do
          expect{ album.photos << other_photo }.to raise_error{|error|
            expect(error.record.errors[:user]).to have(1).item
          }
          expect(Album.find(album.id).photos.first).to be_nil
        end
      end
      context "登録済みの写真の場合" do
        before do
          album.photos << photo
        end
        it "Albumに紐づくPhotoとして登録されない" do
          expect{ album.photos << photo }.to raise_error{|error|
            expect(error.record.errors[:photo_id]).to match_array ['unique']
          }
          expect(Album.find(album.id).photos.size).to eq(1)
        end
      end
    end
  end
end
