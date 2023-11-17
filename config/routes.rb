Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :users do
    resources :posts
    member do
      get 'friends'
      post 'add_friend'
      delete 'remove_friend'
    end
    resources :messages, only: [:index, :create]
  end

  # Add the add_friend route
  post '/add_friend/:id', to: 'users#add_friend', as: 'add_friend'

  # Add the remove_friend route
  delete '/remove_friend/:id', to: 'users#remove_friend', as: 'remove_friend'

  post '/messages/new', to: 'messages#create'

  resources :posts do
    resources :comments
  end

  resources :messages, only: [:new, :create, :index]
end