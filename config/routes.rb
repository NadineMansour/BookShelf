Rails.application.routes.draw do
  resources :users do
    collection do
      post 'search'
      post 'add_friend/:friend_id'=> :add_friend
      post 'remove/:friend_id'=> :remove
      post 'accept/:friend_id'=> :accept
      post 'reject/:friend_id'=> :reject
      post 'friends/:user_id'=> :friends
      get 'requests'
      get 'newsfeed'
      get 'quotes'
      get 'reviews'
      get 'status'
      delete 'sign_out' , to: "sessions#destroy", as: 'sign_out'
    end
  end

  resources :posts do
    collection do
      get 'new_quote', to: "posts#new_quote"
      post 'new_quote', to: 'posts#create_quote'
      get 'new_review', to: "posts#new_review"
      post 'new_review', to: 'posts#create_review'
      get 'new_status', to: "posts#new_status"
      post 'new_status', to: 'posts#create_status'
      post 'create_comment'
      delete 'sign_out' , to: "sessions#destroy", as: 'sign_out'
    end
  end

  resources :comments do
    collection do
      post 'create_comment/:post_id' => :create_comment
    end
  end

  
  
  get 'home/index' => 'home#index'

  get 'home/profile' => 'home#profile'

  get 'auth/:provider/callback', to: "sessions#create"

  delete 'sign_out' , to: "sessions#destroy", as: 'sign_out'

  root 'home#index'

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
