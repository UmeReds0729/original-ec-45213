class AddProductToSupermarketPrices < ActiveRecord::Migration[7.1]
  def change
    add_reference :supermarket_prices, :product, null: false, foreign_key: true
  end
end
