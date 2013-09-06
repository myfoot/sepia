class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:show, :update]
  before_action :set_user, only: [:show, :update]

  def show
  end

  def update
    @user.update(user_params)
  end

  private
  def check_user
    if current_user.id != params[:id].to_i
      respond_to do |format|
        format.html { render_403 }
        format.json { head :forbidden }
      end
    end
  end
  
  def set_user
    @user = User.where(id: params[:id]).first
    head :not_found unless @user
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
      
end
