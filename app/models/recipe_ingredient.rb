class RecipeIngredient < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["display_name", "category"]
  end
end