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
    @user.access_tokens.where(provider: :twitter).select(:id).each{|access_token|
      PhotoCrawler.perform_async(Clients::Social::TwitPic.to_s, access_token.id)
    }
  end

  def google_oauth2
    create_and_redirect :google_oauth2, {
      name: auth.info.name,
      email: auth.info.email,
      uid: auth.uid,
      token: auth.credentials.token,
      secret: auth.credentials.secret
    }
  end

  private
  def auth
    @auth ||= request.env["omniauth.auth"]
  end

  def create_and_redirect provider, option
    ActiveRecord::Base.transaction do
      if (origin = request.env['omniauth.origin']) && (user_id = request.env["omniauth.params"]["user_id"])
        @user = User.find(user_id)
        @user.add_token_if_not_exist provider, option
        safe_redirect origin
      else
        @user = User.find_or_create_by_auth(option.merge({provider: provider}))
        redirect_to_authentication provider.capitalize
      end
    end
  end

  def redirect_to_authentication provider
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => provider
    sign_in_and_redirect @user, :event => :authentication
  end

end
