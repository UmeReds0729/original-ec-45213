class ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def add_menu
    menu = Menu.find(params[:menu_id])
    shopping_list = current_user.shopping_lists.find_or_create_by(title: "未分類")

    menu.menu_ingredients.each do |mi|
      shopping_list.shopping_items.create!(
        name: mi.ingredient.name,
        quantity: mi.quantity,
        unit: mi.unit
      )
    end

    redirect_back fallback_location: root_path, notice: "買い物リストに追加しました"
  end
end
