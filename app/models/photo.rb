class Photo < ActiveRecord::Base
  attr_accessible :user_id, :provider, :platform_id, :format, :message, :width, :height, :posted_at

  belongs_to :user
  has_many :albums_photos, class_name: 'AlbumsPhotos', inverse_of: :photo, dependent: :destroy
  has_many :albums, through: :albums_photos

  validates :user_id, presence: true
  validates :provider, presence: true
  validates :platform_id, presence: true, uniqueness: { scope: :provider }
  validates :format, presence: true
  validates :posted_at, presence: true

  def fullsize_url
  end
  def thumbnail_url
  end
end
