Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  root to: 'chat_threads#index'

  # チャットスレッドとメッセージ作成
  resources :chat_threads, only: [:index, :new, :create, :show] do
    resources :messages, only: [:create]
  end

  # 価格比較用の message 単体ルーティング
  resources :messages, only: [] do
    post :price_comparison, on: :member
  end
end
