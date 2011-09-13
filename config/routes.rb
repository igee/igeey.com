Igeey::Application.routes.draw do
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
  match 'timeline' => 'site#timeline'
  match 'more_timeline' => 'site#more_timeline'
  match 'more_public_timeline' => 'site#more_public_timeline'
  
  match 'oauth(/:action)' => 'oauth#(/:action)'
  match 'plan(/:id)' => 'plans#redirect', :as => :plan
  match 'answer(/:id)' => 'answers#redirect', :as => :answer
  match 'kase(/:id)' => 'kases#show', :as => :kase
  match 'setting' => 'users#setting'
  
  match 'search' => 'search#result'
  match 'search/more' => 'search#more',:as => :more_search
  match 'search/tags' => 'search#tags',:as => :tags_search

  match 'standards(/:action)' => 'standards#(/:action)'
  
  resource :session, :only => [:new, :create, :destroy,:show]
  resource :sync, :only => [:new, :create]
  match 'chart' => 'chart#show'
  
  resources :venues do
    member do
      get  :cover
      get  :position
      get  :doings
      get  :records
      get  :photos
      get  :sayings
      get  :topics
      get  :tasks
      get  :followers
      get  :more_items
      post :watching
    end
  end
  
  resources :badges do
    get   :get_badges ,:on => :collection
  end
  
  resources :tasks do
    get   :more     ,:on => :collection
    put   :close    ,:on => :member
    get   :progress ,:on => :member
    resources :plans do
      get   :duplicate ,:on => :member
      get   :done      ,:on => :member
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
      get   :more_answers
      get   :more_questions
      get   :tasks
      get   :plans
      get   :sayings
      get   :topics
      get   :photos
      get   :badges
      get   :questions
      get   :answers
      get   :followers
      get   :following_venues
      get   :following_users
      get   :following_tasks
    end
  end
  
  resources :feedbacks do 
    get :thanks, :on => :collection
  end
  
  resources :follows,:photos,:topics,:sayings,:doings,:blogs
  
  resources :messages do
    get :clear, :on => :member  
  end
  
  resources :problems do
    resources :kases
    resources :solutions
    resources :posts
    collection do
      get   :thanks
    end
    member do
      get   :followers
      get   :map
      get   :add_url
    end
  end
  
  resources :questions do
    resources :answers do
      post :veto, :on => :member
    end
    get :more, :on => :collection
  end
  
  resources :comments do
    get :more, :on => :collection
  end
  
  resources :tags do
    get :questions, :on => :member
    get :timeline,  :on => :member
    get :more,      :on => :collection
  end
  resources :votes
  
  resources :notifications do
    get '/', :on => :member,:action => :destroy
    get :clear, :on => :member
    get :clear_all, :on => :collection
    post :redirect_clear, :on => :collection  
  end
  
  
  #short_url
  match "/v/:id" => redirect("/venues/%{id}")
  match "/c/:id" => redirect("/tasks/%{id}")
  match "/r/:id" => redirect("/records/%{id}")
  match "/p/:id" => redirect("/plan/%{id}")
  match "/t/:id" => redirect("/topics/%{id}")
  match "/s/:id" => redirect("/sayings/%{id}")
  match "/q/:id" => redirect("/questions/%{id}")

end
