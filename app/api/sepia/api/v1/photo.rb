module Sepia
  class API::V1::Photo < Grape::API
    helpers Sepia::API::V1::Helper::Auth

    doorkeeper_for :all
    
    desc "Get photos"
    resource :photo do
      get do
        current_user
          .photos
          .page(params[:page] || 1)
          .per(Settings.photos.per_page)
          .order('posted_at DESC')
      end
    end
  end
end
