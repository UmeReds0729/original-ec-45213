class AddRecipeIngredientToSupermarketPrices < ActiveRecord::Migration[7.1]
  def change
    add_reference :supermarket_prices, :recipe_ingredient, null: false, foreign_key: true
  end
end
