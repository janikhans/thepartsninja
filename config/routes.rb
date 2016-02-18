Rails.application.routes.draw do

  #Users
  #Change the default devise routes to something more pleasing
  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new"
  end
  devise_for :users, controllers: {registrations: :registrations}

  #Basic resources
  resources :discoveries, :fitments, :parts, :products, :vehicles, :categories
  resources :profiles, only: [:update]
  resources :users, only: [:show]
  resources :compatibles do
    member do
      get 'upvote'
      get 'downvote'
    end
  end
  concern :autocompletable do
    get 'autocomplete', on: :collection
  end
  resources :brands, concerns: :autocompletable


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
