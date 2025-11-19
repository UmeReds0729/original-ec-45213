class AiRequestsController < ApplicationController
  before_action :authenticate_user!

  def new
    @ai_request = AiRequest.new
  end

  def create
    @ai_request = AiRequest.new(ai_request_params.merge(user: current_user))
  
    if @ai_request.save
      menu = AiMenuService.generate_menu(@ai_request.input_text, people: @ai_request.people)
      menu.ai_request = @ai_request
      menu.save
  
      redirect_to ai_request_path(@ai_request), notice: "AIがメニューを提案しました！"
    else
      render :new, alert: "メニューの生成に失敗しました"
    end
  end
  

  def show
    @ai_request = AiRequest.find(params[:id])
    @menus = @ai_request.menus # 提案結果（AI生成メニュー一覧）
  end

  private

  def ai_request_params
    params.require(:ai_request).permit(:input_text, :people)
  end
end
