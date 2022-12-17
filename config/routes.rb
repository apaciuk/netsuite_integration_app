require 'sidekiq/web'

Rails.application.routes.draw do
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  authenticate :user, lambda { |u| u.admin? } do
  mount Sidekiq::Web => '/sidekiq'
    namespace :api do
    namespace :v1 do
        namespace :backoffice do
        get '/', to: 'backoffice#index'
        post '/login', to: 'sessions#create'
        delete '/logout', to: 'sessions#destroy'
        resources :admins, only: [:index, :create, :update, :destroy]
        resources :members, only: [:index, :create, :update, :destroy]
        resources :categories, only: [:index, :create, :update, :destroy]
        resources :subcategories, only: [:index, :create, :update, :destroy]
        resources :products, only: [:index, :create, :update, :destroy]
        resources :orders, only: [:index, :create, :update, :destroy]
        resources :order_items, only: [:index, :create, :update, :destroy]
        resources :payments, only: [:index, :create, :update, :destroy]
        resources :payment_types, only: [:index, :create, :update, :destroy]
        resources :shipping_companies, only: [:index, :create, :update, :destroy]
        resources :shipping_labels, only: [:index, :create, :update, :destroy]
        resources :shipping_statuses, only: [:index, :create, :update, :destroy]
        resources :shipping_types, only: [:index, :create, :update, :destroy]
        resources :users, only: [:index, :create, :update, :destroy]
        resources :user_statuses, only: [:index, :create, :update, :destroy]
        resources :user_types, only: [:index, :create, :update, :destroy]
      
      end
    end
  end
end




  resources :notifications, only: [:index]
  resources :announcements, only: [:index]
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root to: 'home#index'
  get 'api/v1/backoffice', to: 'api/v1/backoffice#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
