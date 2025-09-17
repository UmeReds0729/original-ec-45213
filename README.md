#テーブル設計

## usersテーブル

| Column                  | Type        | Options                         |
| ----------------------- | ----------- | ------------------------------- |
| last_name               | string      | null: false                     |
| first_name              | string      | null: false                     |
| last_name_kana          | string      | null: false                     |
| first_name_kana         | string      | null: false                     |
| email                   | string      | null: false, unique: true       |
| encrypted_password      | string      | null: false                     |
| billing_postal_code     | string      | null: false                     |
| billing_prefecture_id   | integer     | null: false                     |
| billing_city            | string      | null: false                     |
| billing_address_line1   | string      | null: false                     |
| billing_address_line2   | string      |                                 |
| billing_phone           | string      | null: false                     |

### Association (users)
 - has_many :orders


## categoriesテーブル

| Column                  | Type        | Options                         |
| ----------------------- | ----------- | ------------------------------- |
| name                    | string      | null: false                     |

### Association (categories)
 - has_many :items


## itemsテーブル

| Column                  | Type        | Options                         |
| ----------------------- | ----------- | ------------------------------- |
| name                    | string      | null: false                     |
| description             | text        | null: false                     |
| stock                   | integer     | null: false                     |
| price                   | integer     | null: false                     |
| category                | references  | null: false, foreign_key: true  | # 生成されるのは category_id

### Association (items)
- belongs_to :category
- has_many :item_images
- has_many :order_items


## item_imagesテーブル

| Column                  | Type        | Options                         |
| ----------------------- | ----------- | ------------------------------- |
| image_url               | string      | null: false                     |
| item                    | references  | null: false, foreign_key: true  |

### Association (item_images)
- belongs_to :item


## ordersテーブル

| Column                  | Type        | Options                         |
| ----------------------- | ----------- | ------------------------------- |
| total_amount            | integer     | null: false                     |
| status_id               | integer     | null: false                     |
| purchased_at            | datetime    | null: false                     |
| user                    | references  | null: false, foreign_key: true  |

### Association (orders)
- has_many :order_items
- has_one :shipping_address
- has_one :payment


## order_itemsテーブル

| Column                  | Type        | Options                         |
| ----------------------- | ----------- | ------------------------------- |
| quantity                | integer     | null: false                     |
| price                   | integer     | null: false                     |
| order                   | references  | null: false, foreign_key: true  |
| item                    | references  | null: false, foreign_key: true  |

### Association (order_items)
- belongs_to :order
- belongs_to :item


## shipping_addressesテーブル

| Column                   | Type        | Options                         |
| ------------------------ | ----------- | ------------------------------- |
| shipping_last_name       | string      | null: false                     |
| shipping_first_name      | string      | null: false                     |
| shipping_last_name_kana  | string      | null: false                     |
| shipping_first_name_kana | string      | null: false                     |
| shipping_postal_code     | string      | null: false                     |
| shipping_prefecture_id   | integer     | null: false                     |
| shipping_city            | string      | null: false                     |
| shipping_address_line1   | string      | null: false                     |
| shipping_address_line2   | string      |                                 |
| shipping_phone           | string      | null: false                     |
| order                    | references  | null: false, foreign_key: true  |

### Association (shipping_addresses)
- belongs_to :order


## paymentsテーブル

| Column                  | Type        | Options                         |
| ----------------------- | ----------- | ------------------------------- |
| payment_method_id       | integer     | null: false                     |
| payment_status_id       | integer     | null: false                     |
| paid_at                 | datetime    | null: false                     |
| order                   | references  | null: false, foreign_key: true  |

### Association (payments)
- belongs_to :order