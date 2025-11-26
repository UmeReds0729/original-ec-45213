class DropProductsSupermarketsAndPrices < ActiveRecord::Migration[7.1]
  def change
    drop_table :supermarket_prices, if_exists: true
    drop_table :supermarkets, if_exists: true
    drop_table :products, if_exists: true
  end
end
