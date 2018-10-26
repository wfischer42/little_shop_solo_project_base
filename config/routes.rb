Rails.application.routes.draw do
  root 'welcome#show'

  get '/login', to: 'session#new'
  # post '/login', to: 'session#create'
  get '/register', to: 'users#new'
  # post '/register', to: 'users#create'

  get '/cart', to: 'cart#show'
  # patch '/cart', to: 'cart#update'
  
  get '/dashboard', to: 'dashboard#show'

  namespace :profile, only: [:show] do
    resources :orders, only: [:index]
  end

  resources :orders
  resources :items
  resources :users
  get '/merchants', to: 'merchants#index'
  get '/merchants/:id', to: 'merchants#show'
end
