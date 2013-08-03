class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_page, only: [:index]

  def index
    @photos =
      current_user
      .photos
      .page(params[:page] || 1)
      .per(Settings.photos.per_page)
      .order('posted_at DESC')
    @all_count = current_user.photos.size
  end

  private
  def validate_page
    params[:page] = 1 if (params[:page].try(:to_i) || 0) < 1
  end
end
