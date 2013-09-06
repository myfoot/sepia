class AlbumsController < ApplicationController
  include Paginate
  before_action :authenticate_user!
  before_action :check_viewable

  def index
    @albums =
      current_user
      .albums
      .eager_load(:photos)
      .page(params[:page] || 1)
      .per(Settings.albums.per_page)
      .order('albums.created_at DESC')
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
  def check_viewable
    if params[:id] && (album = Album.find_by(id: params[:id]))
      head :forbidden if current_user.id != album.user_id
    end
  end
  def album
    params.require(:album).permit(:name)
  end
end
