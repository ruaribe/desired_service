Rails.application.routes.draw do
  root 'static_pages#top'
  get '/top', to: 'static_pages#top'
  get '/about', to: 'static_pages#about'
  get '/trend', to: 'static_pages#trend'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :posts
  resources :likes, only: %w[create destroy]

  namespace :admin do
    root 'static_pages#top'
    resources :users, only: %I[index show destroy]
    resources :posts, only: %I[index destroy]
  end
end
