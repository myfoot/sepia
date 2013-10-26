class AlbumsController < ApplicationController
  include Paginate
  before_action :authenticate_user!
  before_action :check_viewable, only: [:show]
  before_action :check_own, only: [:update, :destroy]

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
    @album = Album.find(params[:id])
    @album_photos = @album.photos
                      .page(params[:page] || 1)
                      .per(Settings.photos.per_page)
                      .order('posted_at DESC')
    @all_count = @album.photos.size
    render layout: "public" unless @album.owner? current_user
  end

  def create
    @album = current_user.albums.create(album)
  end

  def update
    @album = current_user.albums.find(params[:id])
    album.each{ |(key, value)| @album.send("#{key}=", value) }
    @album.save!
  end

  def destroy
    @album = current_user.albums.find(params[:id])
    current_user.albums.destroy(@album)
  end

  private
  def check_own
    head :forbidden unless own_album? params[:id]
  end

  def check_viewable
    head :forbidden unless own_album?(params[:id]) or public_album?(params[:id])
  end

  def album
    params.require(:album).permit(:name, :public)
  end

  def public_album? id
    target = Album.find_by(id: id)
    target && target.public?
  end

  def own_album? id
    id && (album = Album.find_by(id: id)) ? current_user.id == album.user_id : false;
  end
end
