Igee::Application.routes.draw do
  root :to => 'site#index'
    
  match 'signup' => 'users#new', :as => :signup
  match 'oauth_signup' => 'users#oauth_signup', :as => :oauth_signup
  match 'oauth_user_create' => 'users#oauth_user_create', :as => :oauth_user_create
  match 'oauth_login' => 'sessions#oauth_login', :as => :oauth_login
  match 'oauth_session_create' => 'sessions#oauth_session_create', :as => :oauth_session_create
  match 'connect_account' => 'users#connect_account', :as => :connect_account
  match 'register' => 'users#create', :as => :register
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'reset_password' => 'sessions#reset_password',:as => :reset_password
  
  match 'about' => 'site#about'
  match 'report' => 'site#report'
  match 'guide' => 'site#guide'
  match 'faq' => 'site#faq'
  
  match 'public'  => 'site#public'
  match 'followings' => 'site#followings'
  match 'actions' => 'site#actions'
  match 'unread_comments' => 'site#unread_comments'
  match 'unread_plans' => 'site#unread_plans'
  match 'unread_followers' => 'site#unread_followers'
  
  match 'more_timeline' => 'site#more_timeline'
  match 'city_timeline' => 'site#city_timeline'
  
  match 'oauth(/:action)' => 'oauth#(/:action)'
  match 'plan(/:id)' => 'plans#redirect', :as => :plan
  match 'setting' => 'users#setting'
  
  match 'search' => 'search#result'
  match 'search/more' => 'search#more',:as => :more_search
  
  resource :session, :only => [:new, :create, :destroy,:show]
  resource :sync, :only => [:new, :create]
  match 'chart' => 'chart#show'
  
  resources :venues do
    member do
      get  :cover
      get  :position
      get  :records
      get  :photos
      get  :sayings
      get  :topics
      get  :callings
      get  :followers
      get  :more_timeline
      post :watching
    end
    resources :sayings
  end
  
  resources :badges do
    get   :get_badges ,:on => :collection
  end
  
  resources :callings do
    put   :close    ,:on => :member
    get   :progress ,:on => :member
    resources :plans do
      get   :duplicate ,:on => :member
    end
  end
  
  resources :records do
    get   :select_venue ,:on => :collection
    get   :select_action ,:on => :collection
    get   :find_by_tag ,:on => :collection
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
      get   :more_timeline
      get   :callings
      get   :records
      get   :sayings
      get   :topics
      get   :photos
      get   :badges
      get   :followers
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
  resources :sayings
  resources :comments do
    get :more, :on => :collection
  end
  resources :photos
  
  resources :tags do
    get :name, :on => :collection
    get :more, :on => :collection
  end
  
  #short_url
  match "/v/:id" => redirect("/venues/%{id}")
  match "/c/:id" => redirect("/callings/%{id}")
  match "/r/:id" => redirect("/records/%{id}")
  match "/p/:id" => redirect("/plan/%{id}")
  match "/t/:id" => redirect("/topics/%{id}")
  match "/v/:id" => redirect("/venues/%{id}")
end
