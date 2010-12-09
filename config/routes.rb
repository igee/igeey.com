Igee::Application.routes.draw do
  root :to => 'site#index'
    
  match 'signup' => 'users#new', :as => :signup
  match 'register' => 'users#create', :as => :register
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'reset_password' => 'sessions#reset_password',:as => :reset_password
  
  match 'about' => 'site#about'
  match 'report' => 'site#report'
  match 'guide' => 'site#guide'
  match 'faq' => 'site#faq'
  
  match 'myigeey' => 'site#myigeey'
  match 'followings' => 'site#followings'
  match 'actions' => 'site#actions'
  match 'unread_comments' => 'site#unread_comments'
  match 'unread_plans' => 'site#unread_plans'
  match 'unread_venues' => 'site#unread_venues'
  
  match 'my_timeline' => 'site#my_timeline'
  match 'city_timeline' => 'site#city_timeline'
  match 'oauth(/:action)' => 'oauth#(/:action)'
  match 'plan(/:id)' => 'plans#redirect', :as => :plan
  match 'setting' => 'users#setting'
  
  resource :session, :only => [:new, :create, :destroy,:show]
  resource :sync, :only => [:new, :create]
  match 'chart' => 'chart#show'
  
  resources :venues do
    member do
      get :cover
      get :position
    end
  end
  
  resources :badges do
    get   :get_badges ,:on => :collection
  end
  
  resources :callings do
    put   :close ,:on => :member
    resources :plans do
      get   :duplicate ,:on => :member
    end
  end
  
  resources :records do
    get   :select_venue ,:on => :collection
    get   :select_action ,:on => :collection
  end
  
  resources :geos do
    get   :list     ,:on => :collection
    get   :selector ,:on => :collection
  end
  resources :users do
    collection do
      get   :welcome
      post  :reset_password
      get   :reset_completed
    end
    member do
      post  :update_account
      get   :following_venues
      get   :following_users
      get   :following_callings
    end
  end
  
  resources :feedbacks do 
    get :thanks, :on => :collection
  end
  
  resources :follows
  resources :topics
  resources :comments
  resources :photos
  resources :actions
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
