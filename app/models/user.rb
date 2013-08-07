require 'pp'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email

  has_many :access_tokens
  has_many :photos
  has_many :albums

  validates :name, presence: true

  def add_token_if_not_exist(provider, name: "", uid: "", token: "", secret: "", expired_at: nil, **others)
    return unless access_tokens.where(provider: provider).count == 0
    exist_token = AccessToken.where(provider: provider, uid: uid).first
    if exist_token
      exist_token.token = token
      exist_token.secret = secret
      exist_token.expired_at = expired_at if expired_at
      access_tokens << exist_token
    else
      access_tokens << AccessToken.new(provider: provider, uid: uid, token: token, secret: secret, name: name, expired_at: expired_at) 
    end
  end

  class << self
    def find_or_create_by_auth(provider: "", name: "", email: "", uid: "", token: "", refresh_token: "", secret: "", expired_at: nil, **others)
      access_token = AccessToken.where(provider: provider, uid: uid).first
      user = access_token.try(:user)
      if user.nil?
        user = User.create(name: name, email: email)
        access_token = AccessToken.create(provider: provider, uid: uid, token: token, refresh_token: refresh_token, secret: secret, user_id: user.id, name: name, expired_at: expired_at)
      else
        access_token.update(name: name, token: token, secret: secret, expired_at: expired_at)
      end
      user
    end
  end
end
