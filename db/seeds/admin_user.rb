# 開発環境のみ AdminUser を作成
if Rails.env.development?
  AdminUser.find_or_create_by!(
    email: "admin@example.com"
  ) do |user|
    user.password = "password"
    user.password_confirmation = "password"
  end

  puts "✔ AdminUser 登録完了"
end
