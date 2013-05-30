class AccessTokensController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @access_token = AccessToken.find(params[:id])
    if @access_token.user_id == current_user.id
      @access_token.destroy
    end
  end

  private
  def access_token_params
    params.require(:access_token).permit(:provider, :name, :token, :secret)
  end
end
