class PhotosController < ApplicationController
  before_action :authenticate_user!
  def index
    @photos = current_user.photos.order('posted_at DESC')
  end
end
