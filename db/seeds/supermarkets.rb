supermarkets = [
  "イオン",
  "西友",
  "OKストア"
]

supermarkets.each do |name|
  Supermarket.find_or_create_by!(name: name)
end

puts "✔ Supermarkets 登録完了（#{Supermarket.count}件）"
