Rails.application.routes.draw do
  root 'static_pages#top'
  get '/top', to: 'static_pages#top'
  get '/about', to: 'static_pages#about'
  get '/trend', to: 'static_pages#trend'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  patch 'posts/:post_id/sort', to: 'post_images#sort'

  resources :users
  resources :posts do
    resources :images, controller: 'post_images'
  end
  
  resources :likes, only: [:create, :destroy]

  resource :password, only: [:show, :edit, :update]
  namespace :admin do
    root 'static_pages#top'
    resources :users, only: %I[index show destroy]
    resources :posts, only: %I[index destroy]
  end
end
