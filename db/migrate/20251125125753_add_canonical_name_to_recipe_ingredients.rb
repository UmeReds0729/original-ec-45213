class AddCanonicalNameToRecipeIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :recipe_ingredients, :canonical_name, :string
  end
end
