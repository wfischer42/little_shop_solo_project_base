Rails.application.routes.draw do
  root 'welcome#show'

  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  get '/logout', to: 'session#destroy'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get '/profile', to: 'users#show'
  namespace :profile do
    get 'edit'
    get 'orders'
  end

  get '/dashboard', to: 'dashboard#show'
  namespace :dashboard do
    resources :orders, only: [:index]
    resources :inventory_items, only: [:index]
  end

  resources :orders, only: [:index, :show, :create] do
    patch ':order_item_id/fulfill', to: 'order_items#update', as: 'item_fulfill'
  end

  resources :order_items, only: [:update]

  resources :items, only: [:new, :create, :edit, :update, :index, :show] do
    patch 'enable', to: 'items#update'
    patch 'disable', to: 'items#update'
  end
  resources :users, only: [:index, :new, :create, :edit, :show, :update] do
    resources :orders, only: [:index, :update]
    patch 'enable', to: 'users#update'
    patch 'disable', to: 'users#update'
  end

  resources :merchants, only: [:index, :update, :show] do
    resources :orders, only: [:index]
    resources :inventory_items, only: [:index, :new, :show, :edit, :create, :update], param: :item_id
  end
  scope as: "merchant_inventory_item_enable" do
    patch '/merchants/:merchant_id/inventory_items/:item_id/enable', to: 'inventory_items#update'
  end
  scope as: "merchant_inventory_item_disable" do
    patch '/merchants/:merchant_id/inventory_items/:item_id/disable', to: 'inventory_items#update'
  end

  resources :carts, path: '/cart', only: [:index]
  delete '/cart', to: 'carts#empty'
  delete '/cart/:item_id', to: 'carts#remove'
  patch '/cart/:item_id', to: 'carts#update', as: 'cart_item_quantity'

  # custom error pages
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
end
