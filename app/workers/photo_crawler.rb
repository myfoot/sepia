# -*- coding: utf-8 -*-

class PhotoCrawler
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(client_name, access_token_id)
    client = client_name.constantize.new(AccessToken.find(access_token_id))
    last_photo = Photo.where(provider: client.provider, user_id: client.user_id).order("posted_at DESC").first
    client.photos(last_photo.try(:posted_at)).each{|photo|
      photo.save! # TODO: save失敗時の対応は別途考える
    } 
  end
end
