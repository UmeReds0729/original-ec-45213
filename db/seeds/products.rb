# AI レシピで出やすい基本食材
products = [
  "たまご",
  "牛乳",
  "塩",
  "こしょう",
  "バター"
]

products.each do |name|
  Product.find_or_create_by!(name: name)
end

puts "✔ Products 登録完了（#{Product.count}件）"
