ActiveAdmin.register RecipeIngredient do
  permit_params :display_name, :canonical_name, :category

  # ===== CSV アップロード =====
  action_item :import, only: :index do
    link_to "CSVインポート", upload_csv_admin_recipe_ingredients_path
  end

  collection_action :upload_csv, method: :get do
    render "admin/csv/upload", locals: {
      upload_path: import_csv_admin_recipe_ingredients_path
    }
  end

  # ★ canonical_name も取り込めるCSVにする（無ければ display_name を使う）
  collection_action :import_csv, method: :post do
    if params[:file].blank?
      redirect_to admin_recipe_ingredients_path, alert: "CSVファイルを選択してください"
      return
    end

    rows = CsvImporter.load(params[:file])

    rows.each_with_index do |row, i|
      RecipeIngredient.find_or_create_by!(
        display_name:   row["display_name"],
        canonical_name: row["canonical_name"].presence || row["display_name"],
        category:       row["category"]
      )
    end

    redirect_to admin_recipe_ingredients_path, notice: "CSVインポート完了！"
  end

  # ===== 一覧画面 =====
  index do
    selectable_column
    id_column
    column :display_name
    column :canonical_name
    column :category
    actions
  end

  # ===== 編集画面 =====
  form do |f|
    f.inputs do
      f.input :display_name
      f.input :canonical_name, hint: "標準化する名前（例：'玉ねぎスライス' → '玉ねぎ'）"
      f.input :category
    end
    f.actions
  end

  # ===== Ransack 検索 =====
  filter :display_name
  filter :canonical_name
  filter :category
end
