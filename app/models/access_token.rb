class AccessToken < ActiveRecord::Base
  attr_accessible :user_id, :token, :secret, :provider
  belongs_to :user
end
