Rails.application.routes.draw do

  #Users
  #Change the default devise routes to something more pleasing
    devise_for :users, controllers: {registrations: :registrations, invitations: :invitations}

  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new" if Rails.env.development?
  end

  namespace :account do
    root to: "activity#index"
    resources :settings, only: [:index]
    resources :profile, only: [:update] do
      get :edit, on: :collection
    end
  end
  #Namespace routes for Admins only
  namespace :admin do
    root to: 'statistics#index'
    resources :compatibilities, :vehicles
    resources :fitments, :brands, :fitment_notes, :categories, :ebay_categories, :part_attributes, :vehicle_types, :users, except: [:new]
    resources :search_records, only: [:index, :destroy]
    resources :leads, only: [:index, :create, :destroy]
    resources :discoveries, except: [:new, :create]
    resources :vehicle_models, except: [:index, :show]
    resources :bulk_edit_products, only: [:index, :new, :create]
    resources :bulk_edit_fitments, only: [:index, :new, :create]
    resources :parts, except: [:new] do
      get :update_ebay_fitments, on: :member
    end
    resources :products do
      get :update_ebay_fitments, on: :member
    end
  end

  #Resource routes for public
  resources :leads, only: [:create]
  resources :discoveries, except: [:index]
  resources :products, :vehicles, :users, only: [:show, :index]
  resources :parts, only: [:show]
  resources :compatibilities, only: [:show] do
    member do
      get 'upvote'
      get 'downvote'
    end
  end
  resources :brands, only: [:index, :show] do
    get :models, on: :member
  end
  resources :vehicle_models, only: [] do
    get :submodels, on: :member
  end
  resources :vehicle_submodels, only: [] do
    get :vehicles, on: :member
  end
  resource :check, controller: :compatibility_checks, only: [] do
    get :new, as: "/"
    get :results
  end

  resource :find, controller: :find_compatibilities, only: [] do
    get :new, as: "/"
    get :results
  end

  resources :categories, only: [] do
    member do
      get :subcategories
      get :part_attributes
      get :fitment_notes
      get :leaves
    end
  end

  get 'coming-soon' => 'leads#new'

  #Static Pages
  root 'pages#index'   # The Welcome Page!
  get 'help' => 'pages#help'
  get 'contact' => 'pages#contact'
  get 'terms-of-service' => 'pages#terms'
  get 'about' => 'pages#about'
  get 'privacy-policy' => 'pages#privacy'
  get 'search' => 'pages#search'
end
