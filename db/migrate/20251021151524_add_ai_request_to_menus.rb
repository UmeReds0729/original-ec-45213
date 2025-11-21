class AddAiRequestToMenus < ActiveRecord::Migration[7.1]
  def change
    add_reference :menus, :ai_request, null: false, foreign_key: true
  end
end
