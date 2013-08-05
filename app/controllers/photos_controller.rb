class PhotosController < ApplicationController
  include Paginate
  before_action :authenticate_user!

  def index
    @photos =
      current_user
      .photos
      .page(params[:page] || 1)
      .per(Settings.photos.per_page)
      .order('posted_at DESC')
    @all_count = current_user.photos.size
  end

end
