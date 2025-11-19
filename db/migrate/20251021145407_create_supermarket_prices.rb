class CreateSupermarketPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :supermarket_prices do |t|
      t.references     :supermarket,   null: false #, foreign_key: true
      t.references     :ingredient,   null: false, foreign_key: true
      t.integer     :price,   null: false
      t.timestamps
    end
  end
end
