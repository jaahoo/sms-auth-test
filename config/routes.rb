Rails.application.routes.draw do
  get  'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get  'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'
  get  'verify/:id', to: 'registrations#verify', as: :verify
  post 'verify/:id', to: 'registrations#confirm', as: :confirm

  resource  :password, only: %i[edit update]

  namespace :identity do
    resource :sms_verifications, only: %i[new create]
  end

  resources :sessions, only: %i[index destroy]

  namespace :sessions do
    resource :sms, only: %i[new create]
  end

  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
