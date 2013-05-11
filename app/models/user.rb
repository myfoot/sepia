require 'pp'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email

  validates :name, presence: true

  class << self
    def find_or_create_by_auth(name: "", email: "",  provider: "", uid: "", token: "", secret: "", **others)
      access_token = AccessToken.where(provider: provider, uid: uid).first
      user = access_token.try(:user)
      if user.nil?
        user = User.create(name: name, email: email)
        access_token = AccessToken.create(provider: provider, uid: uid, token: token, secret: secret, user_id: user.id)
      else
        access_token.update(token: token, secret: secret)
      end
      user
    end
  end
end
