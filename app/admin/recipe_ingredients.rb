ActiveAdmin.register RecipeIngredient do
  permit_params :display_name, :category

  action_item :import, only: :index do
    link_to "CSVインポート", upload_csv_admin_recipe_ingredients_path
  end

  collection_action :upload_csv, method: :get do
    render "admin/csv/upload", locals: {
      upload_path: import_csv_admin_recipe_ingredients_path
    }
  end

  # ★ 正規化なしの完全版 CSV インポート
  collection_action :import_csv, method: :post do
    if params[:file].blank?
      redirect_to admin_recipe_ingredients_path, alert: "CSVファイルを選択してください"
      return
    end

    rows = CsvImporter.load(params[:file])

    rows.each_with_index do |row, i|
      RecipeIngredient.find_or_create_by!(
        display_name: row["display_name"],
        category:     row["category"]
      )
    end

    redirect_to admin_recipe_ingredients_path, notice: "CSVインポート完了！"
  end

  # ★ Ransack allowlist
  filter :display_name
  filter :category
end
