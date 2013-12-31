class Album < ActiveRecord::Base
  belongs_to  :user
  has_many :albums_photos, class_name: 'AlbumsPhotos', inverse_of: :album, dependent: :destroy
  has_many :photos, through: :albums_photos

  scope :public, -> { where(public: true) }

  validates :name, presence: true

  def owner? user
    user.id == self.user_id
  end
end
