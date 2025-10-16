class CreateMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :menus do |t|
      t.string     :title,   null: false
      t.text    :description
      t.integer    :people
      t.timestamps
    end
  end
end
