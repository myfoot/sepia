class Photo::Google < Photo
  attr_accessible :fullsize_url, :thumbnail_url
  store :optional, accessors: [ :fullsize_url, :thumbnail_url ]

  validates :fullsize_url, presence: true
  validates :thumbnail_url, presence: true

end
