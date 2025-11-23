class Product < ApplicationRecord
  has_many :supermarket_prices, dependent: :destroy
end