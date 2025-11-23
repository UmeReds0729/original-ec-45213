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

  # ★ 価格比較関連
  def price_comparison
    puts "=== price_comparison START ==="
    @message = Message.find(params[:id])
  
    # ★ コードブロックを除去
    cleaned = @message.response.gsub(/```json/i, "").gsub(/```/, "").strip
  
    data = JSON.parse(cleaned) rescue {}
    
    raw_ingredients = data["ingredients"] || []
  
    parsed_ingredients = raw_ingredients.map do |item|
      parts = item.split(/\s+/, 2)
      { "name" => parts[0], "amount" => parts[1] || "" }
    end
  
    @products = parsed_ingredients.map do |ing|
      Product.find_or_create_by(name: ing["name"])
    end
  end

 
  private

  # ★ 材料リストからレシピプロンプトを作るメソッド
  def build_recipe_prompt(raw_input)
    ingredients = raw_input.split(/\s+/).join(", ")
  
    <<~PROMPT
      あなたはプロの料理研究家です。
      次の材料を使ったおすすめレシピを1つ提案してください。
  
      材料一覧: #{ingredients}
  
      【重要】
      以下のJSON形式で **必ず ingredients を使用** して返してください。
      ingredients 以外のフィールド名は使わないでください。
      「products」や「material」など他の名前は一切使わないでください。
  
      出力フォーマット（厳守）:
      ```json
      {
        "title": "",
        "ingredients": [
          { "name": "", "amount": "" }
        ],
        "instructions": [],
        "cooking_time": "",
        "calories": ""
      }
      ```
      JSON以外の文章は書かないでください。
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
end
