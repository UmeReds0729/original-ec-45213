Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  root to: 'chat_threads#index'
  resources :chat_threads, only: [:index, :create, :show] do
    resources :messages, only: [:create]
  end
end
