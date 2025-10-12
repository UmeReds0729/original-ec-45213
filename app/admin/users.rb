ActiveAdmin.register User do
  actions :all, except: [:new, :edit, :destroy]

  # 一覧画面
  index do
    selectable_column
    id_column
    column :email
    column :last_name
    column :first_name
    row :billing_prefecture do |user|
      user.billing_prefecture&.name
    end
    column :billing_city
    column :created_at
    actions defaults: false do |user|
      link_to "詳細", admin_user_path(user)
    end
  end

  # 詳細画面
  show do
    attributes_table do
      row :email
      row :last_name
      row :first_name
      row :billing_postal_code
      row :billing_prefecture do |user|
        user.billing_prefecture&.name
      end
      row :billing_city
      row :billing_address_line1
      row :billing_address_line2
      row :billing_phone
      row :created_at
      row :updated_at
    end
  end
end
