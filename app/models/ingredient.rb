class Ingredient < ApplicationRecord
  has_many :menu_ingredients, dependent: :destroy
  has_many :menus, through: :menu_ingredients
  has_many :supermarket_prices, dependent: :destroy
  has_many :supermarkets, through: :supermarket_prices
end
