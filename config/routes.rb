Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'home', to: 'pages#index'
  devise_for :users
  root to: "pages#index"

  resources :reviews
  get '/categories/search', to: 'categories#search', as: "search_category"
  resources :categories do
    member do
      get :services
    end
  end
  resources :services
  get '/services/:id/edit/:type', to: 'services#edit', as: "services_pricing"
  resources :favorites, only: [:create, :destroy]
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
