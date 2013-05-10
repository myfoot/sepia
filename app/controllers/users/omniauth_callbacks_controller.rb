require 'pp'
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = AccessToken.where(provider: :twitter, token: auth.credentials.token, secret: auth.credentials.secret).first.try(:user)

    if @user.nil?
      @user = User.create(name: auth.info.nickname)
      AccessToken.create(provider: :twitter, token: auth.credentials.token, secret: auth.credentials.secret).tap{|a|
        a.user = @user
        a.save
      }
    end
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
    sign_in_and_redirect @user, :event => :authentication
  end

  private
  def auth
    request.env["omniauth.auth"]
  end
end
