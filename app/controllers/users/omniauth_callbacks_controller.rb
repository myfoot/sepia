class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include ControllerHelper

  def facebook
    create_and_redirect :facebook, {
      name: auth.info.nickname,
      email: auth.info.email,
      uid: auth.uid,
      token: auth.credentials.token
    }
  end

  def twitter
    create_and_redirect :twitter, {
      name: auth.info.nickname,
      email: auth.info.email,
      uid: auth.uid,
      token: auth.credentials.token,
      secret: auth.credentials.secret
    }
  end

  private
  def auth
    request.env["omniauth.auth"]
  end

  def create_and_redirect provider, option
    if (origin = request.env['omniauth.origin']) && (user_id = request.env["omniauth.params"]["user_id"])
      User.find(user_id).add_token_if_not_exist provider, option
      safe_redirect origin
    else
      @user = User.find_or_create_by_auth(option.merge({provider: provider}))
      redirect_to_authentication provider.capitalize
    end
  end

  def redirect_to_authentication provider
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => provider
    sign_in_and_redirect @user, :event => :authentication
  end

end
