puts "AiMenuService loaded"
class AiMenuService
  UNIT_MAP = {
    /g|グラム/i => "g",
    /kg|キロ/i => "g",
    /ml|ミリ/i => "ml",
    /l|リットル/i => "ml",
    /個|コ/i => "個"
  }.freeze

  # メニュー生成メイン
  def self.generate_menu(input_text, people: 2)
    # OpenAI クライアント
    api_key = Rails.application.credentials.openai[:api_key]
    client = OpenAI::Client.new

    prompt = <<~PROMPT
      以下の条件で夕食メニューを提案してください。
      ・食材: #{input_text}
      ・人数: #{people}人分
      ・メニュー名、簡単な説明、材料（材料名、数量、単位）のリスト形式
      ・数量の単位はできるだけ明確に書く
      ・返答はJSON形式で出力してください
      例:
      {
        "title": "メニュー名",
        "description": "説明文",
        "ingredients": [
          {"name": "材料1", "quantity": "100g"},
          {"name": "材料2", "quantity": "2個"}
        ]
      }
    PROMPT

    # Chat API 呼び出し（0.34.1 形式）
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7
      }
    )

    result_text = response.dig("choices", 0, "message", "content")
    menu_data = self.parse_json_safe(result_text)

    return self.fallback_menu(input_text, people) unless menu_data

    # Menu レコード作成
    menu = Menu.new(
      title: menu_data["title"] || "AI提案メニュー",
      description: menu_data["description"] || "説明なし",
      people: people
    )

    # 材料ループ
    menu_data["ingredients"]&.each do |ing|
      name = ing["name"].to_s.strip
      next if name.blank?

      quantity, unit = self.parse_quantity_unit(ing["quantity"])
      ingredient = Ingredient.find_or_create_by(name: name)

      menu.menu_ingredients.build(
        ingredient: ingredient,
        quantity: quantity,
        unit: unit
      )
    end

    menu
  end

  # JSON パース、安全
  def self.parse_json_safe(text)
    JSON.parse(text)
  rescue JSON::ParserError
    nil
  end

  # 数量と単位をパース
  def self.parse_quantity_unit(raw)
    return [1, "個"] if raw.nil? || raw.to_s.strip.empty?

    str = raw.to_s.strip
    if str =~ /([\d\.]+)\s*(\D+)/
      quantity = $1.to_f
      unit = self.normalize_unit($2)

      # kg/L を g/ml に変換
      if $2 =~ /kg/i
        quantity *= 1000
      elsif $2 =~ /l/i
        quantity *= 1000
      end

      [quantity, unit]
    else
      [str, "個"]
    end
  end

  # 単位統一
  def self.normalize_unit(unit_str)
    UNIT_MAP.each do |regex, norm|
      return norm if unit_str =~ regex
    end
    unit_str.strip
  end

  # JSON パース失敗時のフォールバック
  def self.fallback_menu(input_text, people)
    Menu.new(
      title: "AI提案メニュー",
      description: "AIが提案したメニューです。入力食材: #{input_text}",
      people: people
    )
  end
end
