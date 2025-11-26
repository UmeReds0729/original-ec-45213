class AddNameNormalizedToRecipeIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :recipe_ingredients, :name_normalized, :string
    add_column :recipe_ingredients, :display_name, :string
  end
end
