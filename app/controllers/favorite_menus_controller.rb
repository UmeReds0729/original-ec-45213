class FavoriteMenusController < ApplicationController
  before_action :authenticate_user!

  def create
    @favorite = current_user.favorite_menus.create(menu_id: params[:menu_id])
    redirect_back fallback_location: root_path
  end

  def destroy
    @favorite = current_user.favorite_menus.find(params[:id])
    @favorite.destroy
    redirect_back fallback_location: root_path
  end
end
