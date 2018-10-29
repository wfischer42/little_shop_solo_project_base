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
  namespace :profile do
    get 'edit'
  # get '/profile/edit', to: 'users#edit'
    get 'orders'
  # get '/profile/orders', to: 'orders#index'
end

  get '/dashboard', to: 'dashboard#show'
  namespace :dashboard do
    # get '/dashboard/orders', to: 'orders#index'
    resources :orders, only: [:index]
    # get '/dashboard/items', to: 'items#index'
    resources :items, only: [:index]
  end

  resources :orders, only: [:index, :show, :new]
  resources :items, only: [:index, :show]
  resources :users, only: [:index, :new, :create, :edit, :show, :update] do 
    # admins go here
    resources :orders, only: [:index]
    patch 'enable', to: 'users#update'
    patch 'disable', to: 'users#update'
  end
  
  resources :merchants, only: [:index, :update, :show] do
    # get '/merchants/:user_id', to: 'dashboard#show'
    # admins go here to see a merchant's orders
    # get '/merchants/:user_id/orders', to: 'orders#index', as: :merchant_orders
    resources :orders, only: [:index]
    resources :items, only: [:index, :new, :edit, :create, :update] do
      patch 'enable', to: 'items#update'
      patch 'disable', to: 'items#update'
    end
  end
  
  # custom error pages
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
end
