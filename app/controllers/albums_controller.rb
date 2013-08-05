class AlbumsController < ApplicationController
  include Paginate
  before_action :authenticate_user!

  def index
    @albums =
      current_user
      .albums
      .page(params[:page] || 1)
      .per(Settings.photos.per_page)
      .order('created_at DESC')
    @all_count = current_user.albums.size
  end

  def show
    @album = current_user.albums.find(params[:id])
  end

  def create
    @album = current_user.albums.create(album)
  end

  def update
    @album = current_user.albums.find(params[:id])
    @album.name = album[:name]
    @album.update
  end

  def destroy
    @album = current_user.albums.find(params[:id])
    current_user.albums.destroy(@album)
  end

  private
  def album
    params.require(:album).permit(:name)
  end
end
