class AddAiRequestAndUserToMenus < ActiveRecord::Migration[7.1]
  def change
    # add_reference :menus, :ai_request, foreign_key: true
    add_reference :menus, :user, foreign_key: true
  end
end
