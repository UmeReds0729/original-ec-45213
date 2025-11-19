class CreateFavoriteMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :favorite_menus do |t|
      t.references     :user,   null: false, foreign_key: true
      t.references     :menu,   null: false, foreign_key: true
      t.text     :note
      t.timestamps
    end
  end
end
