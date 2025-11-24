class SupermarketPrice < ApplicationRecord
  belongs_to :supermarket
  belongs_to :recipe_ingredient, optional: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "price", "unit", "created_at", "updated_at", "supermarket_id", "recipe_ingredient_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["supermarket", "recipe_ingredient"]
  end
end
