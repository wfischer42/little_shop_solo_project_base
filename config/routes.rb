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

  resources :orders, only: [:index, :new, :show]
  resources :items, only: [:index, :new]
  resources :users, only: [:index, :new, :create, :edit, :show] do 
    # admins go here
    resources :orders, only: [:index]
  end
  # users go here to see their orders
  get '/profile/orders', to: 'orders#index'
  # merchants go here to see their orders
  get '/dashboard/orders', to: 'orders#index'

  get '/merchants', to: 'merchants#index'
  get '/merchants/:id', to: 'merchants#show'

  # custom error pages
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
end
