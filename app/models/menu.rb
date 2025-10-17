class Menu < ApplicationRecord
  has_many :menu_ingredients, dependent: :destroy
  has_many :ingredients, through: :menu_ingredients
  has_many :favorite_menus, dependent: :destroy
end
