ActiveAdmin.register SupermarketPrice do
  permit_params :recipe_ingredient_id, :supermarket_id, :price, :unit

  action_item :import, only: :index do
    link_to "CSVインポート", upload_csv_admin_supermarket_prices_path
  end

  collection_action :upload_csv, method: :get do
    render "admin/csv/upload", locals: {
      upload_path: import_csv_admin_supermarket_prices_path
    }
  end

  collection_action :import_csv, method: :post do
    if params[:file].blank?
      redirect_to admin_supermarket_prices_path, alert: "CSVファイルを選択してください"
      return
    end

    rows = CsvImporter.load(params[:file])

    rows.each do |row|
      display_name = row["product"]
      supermarket  = row["supermarket"]
      price        = row["price"]
      unit         = row["unit"]

      # ★ display_name で完全一致検索（正規化なし）
      ingredient = RecipeIngredient.find_by(display_name: display_name)
      if ingredient.nil?
        raise "食材が見つかりません: #{display_name}"
      end

      sm = Supermarket.find_by(name: supermarket)
      if sm.nil?
        raise "スーパーが見つかりません: #{supermarket}"
      end

      SupermarketPrice.create!(
        recipe_ingredient_id: ingredient.id,
        supermarket_id:       sm.id,
        price:                price,
        unit:                 unit
      )
    end

    redirect_to admin_supermarket_prices_path, notice: "CSVインポート完了！"
  end

  filter :supermarket
  filter :recipe_ingredient
end
