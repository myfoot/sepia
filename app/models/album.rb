class Album < ActiveRecord::Base
  belongs_to  :user
  has_many :albums_photos, class_name: 'AlbumsPhotos', inverse_of: :album
  has_many :photos, through: :albums_photos
end
