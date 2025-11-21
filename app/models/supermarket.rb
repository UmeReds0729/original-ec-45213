class Supermarket < ApplicationRecord
  has_many :supermarket_prices, dependent: :destroy
  has_many :products, through: :supermarket_prices
  has_many :user_supermarkets, dependent: :destroy
  has_many :users, through: :user_supermarkets
end
