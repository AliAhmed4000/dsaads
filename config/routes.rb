Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'home', to: 'pages#index'
  devise_for :users,:controllers => {:omniauth_callbacks => "omniauth_callbacks" }
  root to: "pages#index"

  resources :reviews
  resources :orders
  resources :revisions
  get '/orders/:id/feedback', to: 'orders#feedback', as: "order_feedback"
  get '/orders/:id/dispute', to: 'orders#dispute', as: "order_dispute"
  get '/orders/:id/status', to: 'orders#status', as: "order_status"
  get '/categories/search', to: 'categories#search', as: "search_category"
  get '/category/:id/search/:search', to: 'categories#online_users'
  get '/services/:ids/order/:order', to: 'categories#sort_highest', as: "sort_highest"
  get '/services/search', to: 'services#search', as: "search_service"
  resources :categories do
    member do
      get :services
    end
  end
  resources :services do 
    resources :packages
  end
  resources :balances
  resources :order_cancels
  post '/order_cancels/:id',to: 'order_cancels#reason', as: "order_cancel_reason"
  # get '/order_cancels/:id/:level/:reason',to: 'order_cancels#seller_detail', as: "order_cancel_seller_detail"
  get '/order_cancels/:id/:level',to: 'order_cancels#seller_detail', as: "order_cancel_seller_detail"
  get '/order_cancels/:id/:reason',to: 'order_cancels#buyer_detail', as: "order_cancel_buyer_detail"
  resources :wish_lists
  get '/wishlist/:wish_id',to: 'wish_lists#my_wishes', as: "my_wishes"
  get '/service/:service_id/wishlist/:wish_id',to: 'wish_lists#list', as: "wish_list_status"
  delete '/service/:service_id/wishlist/:wish_id',to: 'wish_lists#wish_list_delete', as: "wish_list_delete"
  get '/my_shopping', to: 'balances#my_shopping', as: "my_shopping"
  get '/manage_services', to: 'services#manage_services', as: "services_manage"
  get '/service/:service_id/status/:status',to: 'services#change_status', as: "change_status"
  get '/services/:service_id/packages/:id/payment',to: 'packages#payment', as: "packages_payment"
  get '/order/:id/requirement',to: 'packages#requirement', as: "packages_requirement" 
  resources :skills, only: [:destroy]
  resources :languages, only: [:destroy]
  resources :photos, only: [:destroy]
  resources :videos, only: [:destroy]
  post '/services/:id/image', to: 'services#file_upload', as: "file_upload"
  post '/services/:id/custom_offer_create', to: 'services#custom_offer_create', as: 'custom_offer_create'
  get '/services/:id/custom_offer/:custom_offer_id', to: 'services#show_custom_details', as: 'show_custom_details'
  post '/services/:id/video', to: 'services#video_upload', as: "video_upload"
  get  '/services/:id/image/show', to: 'services#show_files', as: "show_files"
  get  '/services/:id/edit/pricing', to: 'services#pricing', as: "services_pricing"
  get  '/services/:id/edit/description', to: 'services#description', as: "services_description"
  get  '/services/:id/edit/requirement', to: 'services#requirement', as: "services_requirement"
  get  '/services/:id/edit/gallery', to: 'services#gallery', as: "services_gallery"
  get  '/services/:id/edit/publish', to: 'services#publish', as: "services_publish"
  get  '/services/:id/edit/gallery_publish', to: 'services#gallery_publish', as: "services_gallery_publish"
  get  '/services/:id/conversation/:conversation_id', to: 'services#custom_offer', as: "services_custom_offer"

  resources :faqs, only: [:destroy]
  resources :favorites, only: [:create, :destroy, :index]
  resources :users, only: [:new, :create, :update], as: "onboarding", path: "seller_onboarding"
  get 'seller_onboarding/personal_info', to: 'users#seller_personal_info', as: "seller_personal_info"
  get 'seller_onboarding/professional_info', to: 'users#seller_professional_info', as: "seller_professional_info"
  get 'seller_onboarding/linked_accounts', to: 'users#seller_linked_accounts', as: "seller_linked_accounts"
  get 'seller_onboarding/account_security', to: 'users#seller_account_security', as: "seller_account_security"
  get 'seller_onboarding/conversation_id/:id', to: 'users#show_customer_offer', as: "show_customer_offer"
  get 'seller_dashboard', to: 'users#seller_dashboard', as: "seller_dashboard"
  get 'set_coookie_curreny', to: 'users#set_coookie_curreny', as: "set_coookie_for_currency"  
  get 'paypal_detail', to: 'users#paypal_detail', as: "paypal_detail"  
  get 'paypal_email_confirmation/:token', to: 'users#paypal_email_confirmation', as: "paypal_email_confirmation"  
  put 'add_paypal_email', to: 'users#add_paypal_email', as: "add_paypal_email"

  resources :users, only: [:show], as: "profile", path: "profile"
  get 'user/role', to: 'users#role', as: "user_role"
  resources :conversations do
    resources :chats, only: [:index]
      member do
        post :image
      end
  end
  get 'conversations/:id/filter/all_messages', to: 'conversations#all_messages', as: "conversations_all_message"
  get 'conversations/:id/filter/unread', to: 'conversations#unread', as: "conversations_unread"
  get 'conversations/:id/filter/customer_offer', to: 'conversations#customer_offer', as: "conversations_customer_offer"
  get 'conversations/:id/starred_me', to: 'conversations#starred_me', as: "starred_me"
  get 'starred', to: 'conversations#starred', as: "conversations_starred"
  get '/package/:id/:status', to: 'packages#status', as: "package_status"
  get '/search/:name', to: 'conversations#search_user', as: "search_user"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
