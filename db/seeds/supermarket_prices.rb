require "csv"

puts "=== Seeding SupermarketPrices ==="
CSV.foreach(Rails.root.join("db/seeds/supermarket_prices.csv"), headers: true) do |row|
  ri = RecipeIngredient.find_by(name: row["recipe_ingredient_name"])
  sm = Supermarket.find_by(name: row["supermarket_name"])

  next unless ri && sm

  SupermarketPrice.create!(
    recipe_ingredient: ri,
    supermarket: sm,
    price: row["price"],
    unit: row["unit"]
  )
end
puts "✔ SupermarketPrices 完了"
