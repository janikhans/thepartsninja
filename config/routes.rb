Rails.application.routes.draw do

  #Users
  #Change the default devise routes to something more pleasing
  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new" if Rails.env.development?
  end

  devise_for :users, controllers: {registrations: :registrations, invitations: :invitations}

  #Namespace routes for Admins only
  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :leads, only: [:index, :create, :destroy]
    resources :fitments, :brands, :categories, :parts, :products, :part_attributes, except: [:new]
    resources :compatibles, :vehicles
    resources :users, except: [:new]
    resources :discoveries, except: [:new, :create]
    resources :searches, only: [:index, :destroy]
    resources :vehicle_models, only: [:new, :edit, :create, :update, :destroy]
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
  get 'coming-soon' => 'leads#index'


  #User Dashboard
  get 'dashboard' => 'dashboard#activity'
  get 'dashboard/account-settings' => 'dashboard#settings'
  get 'dashboard/user-profile' => 'dashboard#profile'

  #Static Pages
  root 'pages#index'   # The Welcome Page!
  get 'help' => 'pages#help'
  get 'contact' => 'pages#contact'
  get 'terms-of-service' => 'pages#terms'
  get 'about' => 'pages#about'
  get 'privacy-policy' => 'pages#privacy'

  resources :pages, only: [] do
    get :autocomplete_brand_name, on: :collection
    get :autocomplete_category_name, on: :collection
    get :autocomplete_vehicle_model, on: :collection
  end

  #Search
  get 'search' => 'searches#results', as: :search

end
