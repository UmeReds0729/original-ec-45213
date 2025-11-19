class MenusController < ApplicationController
  before_action :authenticate_user!

  def show
    @menu = Menu.find(params[:id])
    @menu_ingredients = @menu.menu_ingredients.includes(:ingredient)
  end
end
