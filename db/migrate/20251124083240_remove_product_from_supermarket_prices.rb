class RemoveProductFromSupermarketPrices < ActiveRecord::Migration[7.1]
  def change
    remove_reference :supermarket_prices, :product, foreign_key: true
  end
end
