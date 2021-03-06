class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include ControllerHelper
  include AsyncJob

  def failure
    logger.info "Auth Failure -- path: #{request.path}, message: #{failure_message}"
    redirect_to :root
  end

  def facebook
    create_and_redirect :facebook, {
      name: auth.info.nickname,
      email: auth.info.email,
      avatar_url: auth.info.image,
      uid: auth.uid,
      token: auth.credentials.token,
      expired_at: Time.at(auth.credentials.expires_at)
    }
    schedule_photo_collect @user
  end

  def twitter
    create_and_redirect :twitter, {
      name: auth.info.nickname,
      email: auth.info.email,
      avatar_url: auth.info.image,
      uid: auth.uid,
      token: auth.credentials.token,
      secret: auth.credentials.secret
    }
    schedule_photo_collect @user
  end

  def google_oauth2
    create_and_redirect :google_oauth2, {
      name: auth.info.name,
      email: auth.info.email,
      avatar_url: auth.info.image,
      uid: auth.uid,
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      secret: auth.credentials.secret,
      expired_at: Time.at(auth.credentials.expires_at)
    }
    schedule_photo_collect @user
  end

  def instagram
    create_and_redirect :instagram, {
      name: auth.info.nickname,
      email: auth.info.email,
      avatar_url: auth.info.image,
      uid: auth.uid,
      token: auth.credentials.token
    }
    schedule_photo_collect @user
  end

  def foursquare
    create_and_redirect :foursquare, {
      name: auth.info.first_name,
      email: auth.info.email,
      avatar_url: auth.info.image,
      uid: auth.uid,
      token: auth.credentials.token
    }
    schedule_photo_collect @user
  end

  private
  def auth
    @auth ||= request.env["omniauth.auth"]
  end

  def create_and_redirect provider, option
    ActiveRecord::Base.transaction do
      @user = if (origin = request.env['omniauth.origin']) && (user_id = session[:user_id])
        connect_and_redirect provider, option, origin, user_id
      else
        signin_and_redirect provider, option
      end
      session[:user_id] = @user.id if @user
    end
  end

  def connect_and_redirect provider, option, origin, user_id
    User.find(user_id).tap {|user|
      unless user.add_token_if_not_exist(provider, option)
        user.access_tokens.find_by(provider: provider).tap {|token|
          option.each {|(key, value)| token.send("#{key}=", value) if token.respond_to?("#{key}=") }
          token.save!
        }
      end
      safe_redirect origin
    }
  end

  def signin_and_redirect provider, option
    User.find_or_create_by_auth(option.merge({provider: provider})).tap {|user|
      redirect_to_authentication provider.capitalize, user
    }
  end

  def redirect_to_authentication provider, user
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => provider
    sign_in_and_redirect user, :event => :authentication
  end
end
