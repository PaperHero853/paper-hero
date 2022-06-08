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
  get 'cells/:id', to: 'cells#play', as: 'cell'

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  get '*unmatched_route', to: 'pages#home'
end
