Rails.application.routes.draw do
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  scope module: :public do
    root 'homes#top'
    get 'about' => 'homes#about'
    resources :items, only: [:show, :index]
    resources :genres, only: [:show]
    resources :cart_items, only: [:create, :index, :update, :destroy]
    delete 'cart_items/destroy_all' => 'cart_items#destroy_all', as: 'destroy_all'
    resources :shipping_addresses, only: [:create, :index, :edit, :update, :destroy]
    resources :order, only: [:new, :create, :index, :show]
    patch 'orders/confirm' => 'orders#confirm'
    get 'orders/thanx' => 'orders#thanx'
    get 'customers/mypage' => 'customers#show'
    get 'customers/edit' => 'customers#edit'
    get 'customers/update' => 'customers#update'
    get 'customers/unsubscribe' => 'customers#unsubscribe'
    patch 'customers/withdraw' => 'customers#withdraw', as: 'customers_withdraw'
  end
  
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  namespace :admin do
    root 'orders#index'
    resources :customers, only: [:index, :show, :edit, :update]
    resources :items, only: [:index, :new, :create, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :orders, only: [:show, :update]
    resources :order_details, only: [:update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
