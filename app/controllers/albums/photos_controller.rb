class Albums::PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album

  def create
    @photos = current_user.photos.where(id: params[:photo_ids]) if params[:photo_ids]
    if @album && @photos && !@photos.empty?
      begin 
        ActiveRecord::Base.transaction do 
          @album.photos.concat(@photos)
        end
      rescue => e
        logger.warn e
        @error = e
      end
    end
  end

  def destroy
    @photos = current_user.photos.where(id: params[:photo_ids]) if params[:photo_ids]
    if @album && @photos && !@photos.empty?
      begin
        ActiveRecord::Base.transaction do 
          @album.photos.destroy(@photos)
        end
      rescue => e
        logger.warn e
        @error = e
      end
    end
  end

  private
  def set_album
    @album = current_user.albums.where(id: params[:album_id]).first
    head :not_found unless @album
  end
end
