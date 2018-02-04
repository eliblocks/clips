Rails.application.routes.draw do
  mount ClipUploader.upload_endpoint(:cache) => "/clips/upload"
  mount Shrine.presign_endpoint(:cache) => "/clips/presign"

  # root to: 'static#welcome', constraints:
  #   lambda { |request| request.env['warden'].user == nil }

  # root to: 'accounts#usage', constraints:
  #   lambda { |request| request.env['warden'].user.viewer? }

  # root to: 'accounts#dashboard', constraints:
  #   lambda { |request| request.env['warden'].user.uploader? }

  root to: 'videos#index'

  devise_for :users, controllers: { sessions: 'users/sessions',
                                  registrations: "users/registrations",
                                  omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users
  resources :charges

  resources :videos do
    member do
      patch 'remove'
      patch 'restore'
      get 'preview'
    end
  end

  resources :plays
  resources :embeds

  get 'about', to: 'static#about'
  get 'contact', to: 'static#contact'
  get 'privacy', to: 'static#privacy'
  get 'terms', to: 'static#terms'

  patch 'accounts', to: 'accounts#update'
  get 'accounts/edit', to: 'accounts#edit'
  get 'accounts/show' , to: 'accounts#show'
  get 'dashboard', to: 'accounts#dashboard'
  get 'usage', to: 'accounts#usage'
  get 'library', to: 'users#library'
  get 'account', to: 'accounts#show'
  get 'search', to: 'videos#search'
  get 'landing', to: 'embeds#landing'
  get 'video_test/:id', to: 'video_test#show'
  get 'buy_message', to: 'embeds#buy_message'
  get 'thank_you', to: 'embeds#thank_you'
  get 'stats', to: 'static#stats'
  get 'upload', to: 'static#upload'



  get 'sessions/impersonate', to: 'sessions#impersonate'


  namespace :admin do
    get '', to: 'dashboard#index', as: '/'

    resources :users
    resources :videos do
      member do
        patch 'toggle_approval'
        patch 'toggle_featured'
        patch 'toggle_suspended'
      end
    end
    get 'sessions/:id', to: 'sessions#impersonate', as: "impersonate"
  end


  devise_scope :user do
      namespace :users do
        get 'sessions/present', to: "sessions#present"
        get 'test_login/:id', to: 'sessions#test_login', as: "test_login"
      end
  end
end
