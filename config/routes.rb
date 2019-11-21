Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'home', to: 'pages#index'
  devise_for :users,:controllers => {:omniauth_callbacks => "omniauth_callbacks" }
  root to: "pages#index"

  resources :reviews
  resources :orders
  get '/orders/:id/feedback', to: 'orders#feedback', as: "order_feedback"
  get '/categories/search', to: 'categories#search', as: "search_category"
  get '/category/:id/search/:search', to: 'categories#online_users'
  resources :categories do
    member do
      get :services
    end
  end
  resources :services do 
    resources :packages
  end
  resources :balances
  get '/manage_services', to: 'services#manage_services', as: "services_manage"
  get '/services/:service_id/packages/:id/payment',to: 'packages#payment', as: "packages_payment"
  get '/order/:id/requirement',to: 'packages#requirement', as: "packages_requirement" 
  resources :skills, only: [:destroy]
  resources :languages, only: [:destroy]
  resources :photos, only: [:destroy]
  resources :videos, only: [:destroy]
  post '/services/:id/image', to: 'services#file_upload', as: "file_upload"
  post '/services/:id/video', to: 'services#video_upload', as: "video_upload"
  get  '/services/:id/image/show', to: 'services#show_files', as: "show_files"
  get  '/services/:id/edit/pricing', to: 'services#pricing', as: "services_pricing"
  get  '/services/:id/edit/description', to: 'services#description', as: "services_description"
  get  '/services/:id/edit/requirement', to: 'services#requirement', as: "services_requirement"
  get  '/services/:id/edit/gallery', to: 'services#gallery', as: "services_gallery"
  get  '/services/:id/edit/publish', to: 'services#publish', as: "services_publish"
  get  '/services/:id/edit/gallery_publish', to: 'services#gallery_publish', as: "services_gallery_publish"

  resources :favorites, only: [:create, :destroy, :index]
  resources :users, only: [:new, :create, :update], as: "onboarding", path: "seller_onboarding"
  get 'seller_onboarding/personal_info', to: 'users#seller_personal_info', as: "seller_personal_info"
  get 'seller_onboarding/professional_info', to: 'users#seller_professional_info', as: "seller_professional_info"
  get 'seller_onboarding/linked_accounts', to: 'users#seller_linked_accounts', as: "seller_linked_accounts"
  get 'seller_onboarding/account_security', to: 'users#seller_account_security', as: "seller_account_security"
  resources :users, only: [:show], as: "profile", path: "profile"
  get 'user/role', to: 'users#role', as: "user_role"
  resources :conversations do
    resources :chats, only: [:index]
      member do
        post :image
      end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
