ActiveAdmin.register Product do
  permit_params :name, :category

  # ▼ CSVインポートボタン
  action_item :import, only: :index do
    link_to "CSVインポート", upload_csv_admin_products_path
  end

  # ▼ CSVアップロード画面
  collection_action :upload_csv, method: :get do
    render "admin/csv/upload", locals: {
      upload_path: import_csv_admin_products_path
    }
  end

  # ▼ CSVインポート処理
  collection_action :import_csv, method: :post do
    if params[:file].blank?
      redirect_to admin_products_path, alert: "CSVファイルを選択してください"
      return
    end

    rows = CsvImporter.load(params[:file])

    rows.each do |row|
      Product.find_or_create_by!(
        name:     row["name"],
        category: row["category"]
      )
    end

    redirect_to admin_products_path, notice: "CSVインポートが完了しました"
  end

  # ▼ フィルタ（シンプルに）
  filter :name
  filter :category
end
