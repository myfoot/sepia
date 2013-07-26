class Photo < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :provider, :platform_id, :format, :message, :width, :height, :posted_at

  validates :user_id, presence: true
  validates :provider, presence: true
  validates :platform_id, presence: true
  validates :format, presence: true
  validates :posted_at, presence: true

  def fullsize_url
  end
  def thumbnail_url
  end
end
