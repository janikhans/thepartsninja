Rails.application.routes.draw do

  #Users
  #Change the default devise routes to something more pleasing
  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new" if Rails.env.development?
  end

  devise_for :users, controllers: {registrations: :registrations, invitations: :invitations}

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
    resources :fitments, :brands, :categories, :ebay_categories, :part_attributes, :vehicle_types, :users, except: [:new]
    resources :searches, only: [:index, :destroy]
    resources :leads, only: [:index, :create, :destroy]
    resources :discoveries, except: [:new, :create]
    resources :vehicle_models, except: [:index, :show]
    resources :bulk_edit_products, only: [:index, :new, :create]
    controller :auto_complete do
      get :update_models
    end
    resources :parts, except: [:new] do
      get :update_ebay_fitments, on: :member
    end
    resources :products do
      get :update_ebay_fitments, on: :member
    end
    resources :fitment_notes, except: [:new] do
      scope module: "fitment_notes" do
        get :search_notes, on: :collection, controller: :search_notes, action: "index"
      end
    end
  end

  #Resource routes for public
  resources :leads, only: [:create]
  resources :discoveries, except: [:index]
  resources :products, :vehicles, only: [:show, :index]
  resources :users, :parts, only: [:show]
  resources :compatibilities, only: [:show] do
    member do
      get 'upvote'
      get 'downvote'
    end
  end
  concern :autocompletable do
    get 'autocomplete', on: :collection
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
  resources :product_types, only: [] do
    get :part_attributes, on: :member
    get :fitment_notes, on: :member
  end
  resources :compatibility_checks, only: [] do
    get :results, on: :collection
  end
  get 'compatibility-check' => 'compatibility_checks#new'

  resources :categories, only: [] do
    get :subcategories, on: :member
    get :product_types, on: :member
  end
  get 'coming-soon' => 'leads#index'

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
