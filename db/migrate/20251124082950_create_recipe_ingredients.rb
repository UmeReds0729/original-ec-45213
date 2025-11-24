class CreateRecipeIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_ingredients do |t|
      t.string :name, null: false
      t.string :category

      t.timestamps
    end
  end
end
