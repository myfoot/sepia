class Photo < ActiveRecord::Base
  attr_accessible :provider, :platform_id, :format, :message, :width, :height, :posted_at
end
