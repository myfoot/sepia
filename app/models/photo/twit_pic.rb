class Photo::TwitPic < Photo
  def fullsize_url
    "http://twitpic.com/show/full/#{self.platform_id}"
  end
  def thumbnail_url
    "http://twitpic.com/show/thumb/#{self.platform_id}"
  end
end
