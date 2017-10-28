Rails.application.routes.draw do
  root    'home#index'

  # OmniAuth
  get     '/auth/google_oauth2/callback', to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'

  # Cookies
  get     '/cookies', to: 'home#cookies_eu'

  # Users
  resources :users, only: [:edit, :update, :destroy]
end
