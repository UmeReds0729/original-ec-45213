class RemovePersonalInfoFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :last_name, :string
    remove_column :users, :first_name, :string
    remove_column :users, :last_name_kana, :string
    remove_column :users, :first_name_kana, :string
    remove_column :users, :billing_postal_code, :string
    remove_column :users, :billing_prefecture_id, :integer
    remove_column :users, :billing_city, :string
    remove_column :users, :billing_address_line1, :string
    remove_column :users, :billing_address_line2, :string
    remove_column :users, :billing_phone, :string
  end
end
