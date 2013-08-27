Sepia::Application.routes.draw do
  root to: 'photos#index'

  resources :photos, only: [:index]
  resources :albums, only: [:index, :show, :create, :update, :destroy] do
    resources :photos, controller: 'albums/photos', only: [:create], constraints: { format: 'json' }, format: true do
      delete :destroy, on: :collection
    end
  end
  resources :users,  only: [:show, :update]

  # for devise
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  # TODO : authenticate
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

end
