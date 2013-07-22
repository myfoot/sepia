class AccessToken < ActiveRecord::Base
  PROVIDERS = [:twitter, :facebook, :google_oauth2]
  attr_accessible :user_id, :provider, :name, :uid, :token, :refresh_token, :secret
  belongs_to :user

  validates :user_id, presence: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: {scope: :provider}

  PROVIDERS.each {|provider|
    define_method("#{provider}?"){ self.provider.to_sym == provider }
  }
end
