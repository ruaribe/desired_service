Rails.application.routes.draw do
  root 'static_pages#top'
  get '/top', to: 'static_pages#top'
  get '/about', to: 'static_pages#about'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users
  resources :posts
end
