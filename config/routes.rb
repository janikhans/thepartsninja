Rails.application.routes.draw do

  #Users
  #Change the default devise routes to something more pleasing
  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new"
  end
  devise_for :users, controllers: {registrations: :registrations}

  #Namespace routes for Admins only
  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :leads, only: [:index, :create, :destroy]
    resources :fitments, :brands, :categories, :parts, :products, :vehicles, except: [:new]
    resources :compatibles
    resources :users, except: [:new]
    resources :discoveries, except: [:new, :create]
  end

  #Resource routes for public
  resources :leads, only: [:create]
  resources :discoveries, except: [:index]
  resources :products, :vehicles, only: [:show, :index]
  resources :profiles, only: [:update]
  resources :users, :parts, only: [:show]
  resources :compatibles, only: [:show] do
    member do
      get 'upvote'
      get 'downvote'
    end
  end
  concern :autocompletable do
    get 'autocomplete', on: :collection
  end
  resources :brands, only: [:index, :show], concerns: :autocompletable


  #User Dashboard
  get 'dashboard' => 'dashboard#activity'
  get 'dashboard/account-settings' => 'dashboard#settings'
  get 'dashboard/user-profile' => 'dashboard#profile'

  #Static Pages
  root 'pages#index'   # The Welcome Page!
  get 'help' => 'pages#help'
  get 'contact' => 'pages#contact'
  get 'terms-of-service' => 'pages#terms'

  #Search
  get 'search' => 'search#results', as: :search

end
