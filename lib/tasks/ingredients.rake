namespace :ingredients do
  desc "display_name を元に canonical_name を自動生成する"
  task normalize_canonical_name: :environment do
    RecipeIngredient.find_each do |ri|
      next if ri.canonical_name.present?

      name = ri.display_name.dup

      # よくある調理法ワード削除
      name = name.gsub(/スライス|みじん切り|千切り|乱切り|ざく切り|角切り|一口大|薄切り|厚切り|細切り|輪切り/, "")

      # 補足情報（括弧）除去
      name = name.gsub(/（.*?）/, "").gsub(/\(.*?\)/, "")

      # 全角→半角・全体trim
      name = name.tr('　', ' ').strip

      # 「たまねぎ」系統のゆれを統一（必要に応じて追加可能）
      replacements = {
        "玉ねぎ" => "玉ねぎ",
        "玉葱"   => "玉ねぎ",
        "たまねぎ" => "玉ねぎ",
        "葱" => "ねぎ",
        "長ねぎ" => "ねぎ",
        "長ネギ" => "ねぎ"
      }
      replacements.each { |k,v| name = name.gsub(k, v) }

      # 空になったら元に戻す
      canonical = name.presence || ri.display_name

      ri.update!(canonical_name: canonical)
      puts "[SET] #{ri.display_name} → #{canonical}"
    end

    puts "=== canonical_name 自動設定 完了 ==="
  end
end
