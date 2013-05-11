class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_or_create_by_auth(name: auth.info.nickname,
                                        email: auth.info.email,
                                        provider: :facebook,
                                        uid: auth.uid,
                                        token: auth.credentials.token)
    redirect_to_authentication :Facebook
  end
  def twitter
    @user = User.find_or_create_by_auth(name: auth.info.nickname,
                                        provider: :twitter,
                                        uid: auth.uid,
                                        token: auth.credentials.token,
                                        secret: auth.credentials.secret)
    redirect_to_authentication :Twitter
  end

  private

  def auth
    request.env["omniauth.auth"]
  end

  def redirect_to_authentication provider
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => provider
    sign_in_and_redirect @user, :event => :authentication
  end
end
