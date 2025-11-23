class ChatThreadsController < ApplicationController
  def index
    @chat_threads = ChatThread.order(created_at: :desc)
    
    respond_to do |format|
      format.json { render json: { chat_threads: @chat_threads } }
      format.html
    end
  end

  def create
    @chat_thread = ChatThread.create(title: 'レシピを作る')
  
    respond_to do |format|
      if @chat_thread.persisted?
  
        # ---- ① 初回メッセージを保存 ----
        if params[:initial_prompt].present?
          first_message = @chat_thread.messages.create(prompt: params[:initial_prompt])
        end
  
        # ---- ② AI に問い合わせてレシピ生成 ----
        if first_message
          ai_response = call_openai_for_recipe(params[:initial_prompt])
  
          # レスポンス保存
          first_message.update(response: ai_response)
  
          # タイトル自動設定（レスポンスJSONのtitleが取れるならそちら優先）
          if @chat_thread.title == "レシピを作る"
            generated_title = extract_title_from_response(ai_response, params[:initial_prompt])
            @chat_thread.update(title: generated_title)
          end
        end
  
        # ---- ③ showにリダイレクト ----
        format.html { redirect_to chat_thread_path(@chat_thread) }
  
        format.json {
          render json: { chat_thread: @chat_thread }, status: :created
        }
  
      else
        format.html { redirect_to chat_threads_path, alert: 'スレッド作成に失敗しました' }
        format.json {
          render json: { errors: @chat_thread.errors.full_messages },
                 status: :unprocessable_entity
        }
      end
    end
  end

  def show
    @chat_thread = ChatThread.find(params[:id])
    @message = @chat_thread.messages.new
  
    respond_to do |format|
      format.json {
        render json: {
          chat_thread: @chat_thread,
          messages: @chat_thread.messages.order(created_at: :asc)
        }
      }
      format.html # ← show.html.erb を表示
    end
  end

  private

  def call_openai_for_recipe(ingredients)
    prompt = <<~PROMPT
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

    response = HTTP.post(
      'https://api.openai.com/v1/chat/completions',
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}"
      },
      json: {
        model: "gpt-4o",
        messages: [{ role: "user", content: prompt }]
      }
    )

    body = JSON.parse(response.body.to_s)
    body['choices'][0]['message']['content']
  end

  def extract_title_from_response(ai_response, fallback)
    begin
      # ```json を削除して JSON パース
      cleaned = ai_response.gsub(/```json|```/, "").strip
      data = JSON.parse(cleaned)
      return data["title"] if data["title"].present?
    rescue
    end
  
    # 失敗時は「〇〇を使ったレシピ」
    "#{fallback} を使ったレシピ"
  end
end
