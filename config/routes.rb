Rails.application.routes.draw do
  root 'welcome#show'

  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  get '/logout', to: 'session#destroy'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get '/cart', to: 'cart#show'
  # patch '/cart', to: 'cart#update'
  
  get '/profile', to: 'users#show'
  get '/dashboard', to: 'dashboard#show'

  resources :orders, only: [:index, :new]
  resources :items, only: [:index, :new]
  resources :users, only: [:new, :create, :edit]
  get '/merchants', to: 'merchants#index'
  get '/merchants/:id', to: 'merchants#show'
end
