Rails.application.routes.draw do
  namespace :api, constraints: {format: :json}, defaults: {format: :json} do
    namespace :v1 do
      resources :travel, only: [:index]
      resources :users, only: [:index]
      resources :sessions, only: [:create]
      resources :registrations, only: [:create]

      post "/login", to: "sessions#create"
      post "/logout", to: "sessions#destroy"
      post "/signup", to: "users#create"
    end
  end
end
