class AccessToken < ActiveRecord::Base
  PROVIDERS = [:twitter, :facebook]
  attr_accessible :user_id, :provider, :name, :uid, :token, :secret
  belongs_to :user

  validates :user_id, presence: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: {scope: :provider}

  PROVIDERS.each {|provider|
    define_method("#{provider}?"){ self.provider.to_sym == provider }
  }
end
