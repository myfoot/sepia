class AccessToken < ActiveRecord::Base
  attr_accessible :user_id, :provider, :uid, :token, :secret
  belongs_to :user
end
