class CreateMenuIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_ingredients do |t|
      t.references     :menu,   null: false, foreign_key: true
      t.references     :ingredient,   null: false, foreign_key: true
      t.integer    :quantity
      t.string    :unit
      t.timestamps
    end
  end
end
