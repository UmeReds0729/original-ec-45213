ActiveAdmin.register Supermarket do
  permit_params :name, :location

  action_item :import, only: :index do
    link_to "CSVインポート", upload_csv_admin_supermarkets_path
  end

  collection_action :upload_csv, method: :get do
    render "admin/csv/upload", locals: {
      upload_path: import_csv_admin_supermarkets_path
    }
  end

  collection_action :import_csv, method: :post do
    if params[:file].blank?
      redirect_to admin_supermarkets_path, alert: "CSVファイルを選択してください"
      return
    end

    rows = CsvImporter.load(params[:file])

    rows.each do |row|
      Supermarket.find_or_create_by!(
        name: row["name"],
        location: row["location"]
      )
    end

    redirect_to admin_supermarkets_path, notice: "CSVインポートが完了しました"
  end

  filter :name
  filter :location
end
