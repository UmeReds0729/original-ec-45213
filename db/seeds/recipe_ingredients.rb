require "csv"

puts "=== Seeding RecipeIngredients ==="
CSV.foreach(Rails.root.join("db/seeds/recipe_ingredients.csv"), headers: true) do |row|
  RecipeIngredient.find_or_create_by!(name: row["name"]) do |ri|
    ri.category = row["category"]
  end
end
puts "✔ RecipeIngredients 完了"
