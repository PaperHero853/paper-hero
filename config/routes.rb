Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :index]
  resources :games, only: [:show, :index, :new, :create] do
    member do
      patch 'quit'
    end
  end
end
