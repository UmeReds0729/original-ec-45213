class Supermarket < ApplicationRecord
  has_many :supermarket_prices
  has_many :products, through: :supermarket_prices
end
