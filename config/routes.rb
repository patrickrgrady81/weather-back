Rails.application.routes.draw do
  namespace :api, constraints: {format: :json}, defaults: {format: :json} do
    namespace :v1 do
      resources :users, only: [:index]
      resources :sessions, only: [:create]
      resources :registrations, only: [:create]

      post "/restaurants", to: "travel#restaurants"
      post "/events", to: "travel#events"

      post "/login", to: "sessions#create"

    end
  end
end
