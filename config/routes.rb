Rails.application.routes.draw do

  get 'search' => 'search#results', as: :search

  resources :discoveries

  resources :compatibles do
    member do
      get 'upvote'
      get 'downvote'
    end
  end

  resources :fitments
  resources :parts
  resources :products
  concern :autocompletable do
    get 'autocomplete', on: :collection
  end

  resources :vehicles
  resources :brands, concerns: :autocompletable

# The Welcome Page!
  root 'pages#index'

  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new"
  end

  devise_for :users

  resources :users, only: [:show]

  get 'dashboard' => 'users#dashboard'
  get 'help' => 'pages#help'
  get 'contact' => 'pages#contact'
  get 'terms-of-service' => 'pages#terms'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
