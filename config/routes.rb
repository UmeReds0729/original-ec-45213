Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  root to: 'homes#index'
  resources :chat_threads, only: [:index, :create, :show] do
    resources :messages, only: [:create]
  end
  resources :menus, only: [:index, :show]
  resources :favorite_menus, only: [:index, :show]
end
