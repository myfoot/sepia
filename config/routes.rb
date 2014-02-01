Sepia::Application.routes.draw do
  root to: 'photos#index'

  resources :photos, only: [:index]
  resources :albums, only: [:index, :show, :create, :update, :destroy] do
    resources :photos, controller: 'albums/photos', only: [:create], constraints: { format: 'json' }, format: true do
      delete :destroy, on: :collection
    end
  end
  resources :users,  only: [:show, :update, :index]

  namespace :public do
    resources :albums, only: [:show]
  end

  # for devise
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  # for oauth2 api
  use_doorkeeper do
    controllers :applications => 'oauth/applications'
  end
  mount Sepia::API, at: '/api'

  # TODO : authenticate
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  if Rails.env.production?
    match '*not_found', to: 'application#render_404', via: :all
  end
end
