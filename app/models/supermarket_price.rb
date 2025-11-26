class SupermarketPrice < ApplicationRecord
  belongs_to :supermarket
  belongs_to :recipe_ingredient

  # ActiveAdmin（通常配列版）
  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "price",
      "unit",
      "supermarket_id",
      "recipe_ingredient_id",
      "created_at",
      "updated_at"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [
      "supermarket",
      "recipe_ingredient"
    ]
  end
end
