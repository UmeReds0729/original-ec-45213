class Menu < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :ai_request, optional: true
  has_many :menu_ingredients, dependent: :destroy
  has_many :ingredients, through: :menu_ingredients
  has_many :favorite_menus, dependent: :destroy
end