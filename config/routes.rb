Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'posts#index'

  resources :comments
  resources :posts do
    resources :comments
  end

  resources :users do
    resources :posts
    resources :comments
    member do
      get 'friends'
    end
  end

  # Add the add_friend route
  post '/add_friend/:id', to: 'users#add_friend', as: 'add_friend'

  # Add the remove_friend route
  delete '/remove_friend/:id', to: 'users#remove_friend', as: 'remove_friend'

  post '/messages/new', to: 'messages#create'

  resources :messages, only: [:new, :create, :index]


end
