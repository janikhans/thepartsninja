Rails.application.routes.draw do

  # Users
  # Change the default devise routes to something more pleasing
  devise_for :users, path: '',
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' },
    controllers: { registrations: :registrations, invitations: :invitations }

  namespace :account do
    root to: "activity#index"
    resources :settings, only: [:index]
    resources :profile, only: [:update] do
      get :edit, on: :collection
    end
  end

  # Admin
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
    resources :charts, only: [] do
      collection do
        get :searches_by_type
        get :search_records
        get :vehicles_by_type
      end
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
  resources :check, controller: :check_searches, only: [:show] do
    collection do
      get :new, as: ""
      get :results
    end
  end
  resources :find, controller: :compatibility_searches, only: [:show] do
    collection do
      get :new, as: ""
      get :results
    end
  end

  resources :categories, only: [] do
    member do
      get :subcategories
      get :part_attributes
      get :fitment_notes
      get :leaves
    end
  end

  # Static Pages
  root 'pages#index'   # The Welcome Page!
  resources :pages, path: "", only: [] do
    collection do
      get :help
      get :contact
      get :terms_of_service, path: "terms-of-service"
      get :about
      get :privacy_policy, path: "privacy-policy"
      get :search
    end
  end

  # Leads / Coming soon
  get 'coming-soon' => 'leads#new'
end
