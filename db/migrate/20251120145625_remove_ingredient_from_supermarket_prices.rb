class RemoveIngredientFromSupermarketPrices < ActiveRecord::Migration[7.1]
  def change
    remove_reference :supermarket_prices, :ingredient, null: false, foreign_key: true
  end
end
