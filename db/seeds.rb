# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

require 'csv'

csv_path = Rails.root.join('db/fixtures/ingredients.csv')

puts "🌱 食材データの登録を開始します..."

CSV.foreach(csv_path, headers: true) do |row|
  Ingredient.create!(
    name: row['name'],
    category: row['category']
  )
end

puts "✅ 食材データの登録が完了しました！"
