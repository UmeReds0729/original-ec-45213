class Supermarket < ApplicationRecord
  has_many :supermarket_prices, dependent: :destroy
  has_many :recipe_ingredients, through: :supermarket_prices

  # ActiveAdmin（通常配列版）
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "location", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["supermarket_prices", "recipe_ingredients"]
  end
end
