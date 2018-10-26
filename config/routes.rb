Rails.application.routes.draw do
  resources :order_items
  resources :orders
  resources :items
  resources :users
end
