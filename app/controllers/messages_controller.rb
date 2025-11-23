require 'http'

class MessagesController < ApplicationController
  def create
    @chat_thread = ChatThread.find(params[:chat_thread_id])
  
    raw_input = message_params[:prompt]
    rewritten_prompt = build_recipe_prompt(raw_input)
  
    @message = @chat_thread.messages.build(prompt: raw_input)
  
    context = @chat_thread.context || ""
    full_prompt = context + "\n" + rewritten_prompt
  
    response = openai_api_call(full_prompt)
  
    if response.status.success?
      response_body = JSON.parse(response.body)
      @message.response = response_body['choices'][0]['message']['content']
  
      # -----------------------------
      # ★ 最初のレシピだけタイトルにする処理
      # -----------------------------
      if @chat_thread.messages.count == 0
        response_text = @message.response
  
        # ```json や ``` を除去
        cleaned = response_text.gsub(/```json/i, "").gsub(/```/, "").strip
  
        begin
          json = JSON.parse(cleaned)
          if json["title"].present?
            @chat_thread.update(title: json["title"])
          end
        rescue JSON::ParserError
          # JSONでない場合は何もしない
        end
      end
      # -----------------------------
  
      if @message.save
        new_context = context + "\n" + rewritten_prompt + "\n" + @message.response
        @chat_thread.update(context: new_context.last(1500))
  
        render json: {
          response: @message.response,
          thread_title: @chat_thread.title
        }
      else
        render json: { error: @message.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    else
      render json: { error: 'APIリクエストが失敗しました' }, status: :unprocessable_entity
    end
  end
  
  private

  # ★ 材料リストからレシピプロンプトを作るメソッド
  def build_recipe_prompt(raw_input)
    # 半角/全角スペースを区切りとして材料の配列を作る
    ingredients = raw_input.split(/\s+/).join(", ")

    <<~PROMPT
      あなたはプロの料理研究家です。
      次の材料を使ったおすすめレシピを1つ提案してください。

      材料: #{ingredients}

      出力は必ず次のJSON形式にしてください:

      {
        "title": "",
        "ingredients": [],
        "instructions": [],
        "cooking_time": "",
        "calories": ""
      }
    PROMPT
  end

  def message_params
    params.require(:message).permit(:prompt)
  end

  def openai_api_call(prompt)
    HTTP.post(
      'https://api.openai.com/v1/chat/completions',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer #{ENV['OPENAI_API_KEY']}"
      },
      json: {
        model: "gpt-4o",
        messages: [{ role: "user", content: prompt }]
      }
    )
  end

  # ★ 価格比較関連
  def price_comparison
    @message = Message.find(params[:id])
  
    # レシピの JSON をパースして ingredients 配列を抽出
    ingredients = extract_ingredients_from_response(@message.response)
  
    # ingredients の名前部分だけ取り出す（例: "玉ねぎ 1個" → "玉ねぎ"）
    ingredient_names = ingredients.map { |item| item.split(/[\s　]/).first }
  
    # 商品テーブルと紐づくデータを検索
    @products = Product.includes(:supermarket_prices)
                       .where(name: ingredient_names)
  
    render :price_comparison
  end
  
  
  # JSONパース用のメソッド（MessagesController内に追加）
  def extract_ingredients_from_response(response_text)
    cleaned = response_text.gsub(/```json/i, "").gsub(/```/, "").strip
    json = JSON.parse(cleaned)
    json["ingredients"] || []
  rescue JSON::ParserError
    []
  end
  
end
