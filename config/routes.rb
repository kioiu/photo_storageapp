Rails.application.routes.draw do
  root 'photos#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'guest_login', to: 'sessions#guest'
  delete 'logout', to: 'sessions#destroy'

  resource :settings, only: %i[edit update]
  resources :users, only: %i[new create]
  resources :photos, only: %i[index new create show destroy]
  resources :photo_sessions, only: %i[index show]

  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
end
