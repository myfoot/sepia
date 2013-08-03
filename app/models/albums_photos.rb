class AlbumsPhotos < ActiveRecord::Base
  self.table_name = :albums_photos
  belongs_to :album, inverse_of: :albums_photos
  belongs_to :photo, inverse_of: :albums_photos

  validates :album_id, presence: true
  validates :photo_id, presence: true
  validates :photo_id, uniqueness: { scope: :album_id, message: 'unique' }
  validate :check_user

  private
  def check_user
    self.errors.add(:user, 'invalid user') unless self.album.user_id == self.photo.user_id
  end
end
