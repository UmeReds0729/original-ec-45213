class FixSupermarketPricesProductReference < ActiveRecord::Migration[7.1]
  def change
    if column_exists?(:supermarket_prices, :ingredient_id)
      remove_reference :supermarket_prices, :ingredient, foreign_key: true
    end

    unless column_exists?(:supermarket_prices, :product_id)
      add_reference :supermarket_prices, :product, foreign_key: true, null: false
    end
  end
end
