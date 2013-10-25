class Public::AlbumsController < ApplicationController
  layout 'public'
  before_action :check_viewable, only: [:show]

  def show
    @album = Album.where(id: params[:id]).first
    unless @album
      render_404
    else
      render 'albums/show'
    end
  end

  private
  def check_viewable
    render_404 unless public_album?(params[:id])
  end
  def public_album? id
    target = Album.find_by(id: id)
    target && target.public?
  end

end
