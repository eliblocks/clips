Rails.application.routes.draw do
  mount UPPY_S3_MULTIPART_APP => "/s3/multipart"



  devise_for :users, :controllers => {:registrations => "registrations"}

  authenticated :user do
    root 'videos#index', as: :authenticated_root
  end

  root 'static#welcome'

  # resources :users
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

  patch 'profile', to: 'profile#update'
  get 'about', to: 'static#about'
  get 'contact', to: 'static#contact'
  get 'privacy', to: 'static#privacy'
  get 'terms', to: 'static#terms'
  get 'close_tab', to: 'static#close_tab'

  get 'users/edit', to: 'users#edit'
  get 'users/show' , to: 'users#show'
  get 'upload', to: 'users#upload'
  post 'upload', to: 'users#save_uploads'
  get 'dashboard', to: 'users#dashboard'
  get 'usage', to: 'users#usage'
  get 'library', to: 'users#library'
  get 'search', to: 'videos#search'

  get 'landing', to: 'embeds#landing'
  get 'video_test/:id', to: 'video_test#show'
  get 'buy_message', to: 'embeds#buy_message'
  get 'thank_you', to: 'embeds#thank_you'
  get 'logged_in', to: 'embeds#logged_in'
  get 'stats', to: 'static#stats'
  get 'upload', to: 'static#upload'
  get 'dmca', to: 'static#dmca'

  post 'webhooks/mux', to: 'webhooks#mux'

  get 'sessions/impersonate', to: 'sessions#impersonate'

  get "/creators/sign_up", to: "creators#new"
  post "creators", to: "creators#create"

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
    get 'demo', to: 'users/sessions#demo'
    namespace :users do
      get 'sessions/present', to: "sessions#present"
      get 'test_login/:id', to: 'sessions#test_login', as: "test_login"
    end
  end

  get '/:id', to: 'users#show', as: :user
end
