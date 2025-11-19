#テーブル設計

## usersテーブル

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| nickname                | string      | null: false                     |                                               |
| email                   | string      | null: false, unique: true       |                                               |
| encrypted_password      | string      | null: false                     |                                               |
| last_name               | string      |                                 | 編集時に登録可能                                |
| first_name              | string      |                                 | 編集時に登録可能                                |
| last_name_kana          | string      |                                 | 編集時に登録可能                                |
| first_name_kana         | string      |                                 | 編集時に登録可能                                |
| postal_code             | string      |                                 | 編集時に登録可能                                |
| prefecture_id           | integer     |                                 | 編集時に登録可能、ActiveHashなどで都道府県管理    |
| city                    | string      |                                 | 編集時に登録可能                                |
| address                 | string      |                                 | 編集時に登録可能                                |
| phone_number            | string      |                                 | 編集時に登録可能                                |
| family_structure        | string      |                                 | 編集時に登録可能、家族構成                       |

### Association (users)
- has_many :stocks, dependent: :destroy
- has_many :favorite_menus, dependent: :destroy
- has_many :shopping_lists, dependent: :destroy
- has_many :ai_requests, dependent: :destroy
- has_many :user_supermarkets, dependent: :destroy
- has_many :supermarkets, through: :user_supermarkets


## user_supermarketsテーブル（ユーザーとスーパーの中間テーブル）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| user                    | references  | null: false, foreign_key: true  |                                               |
| supermarket             | references  | null: false, foreign_key: true  |                                               |

### Association
- belongs_to :user
- belongs_to :supermarket


## ai_requestsテーブル（AIメニュー提案フロー管理）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| user                    | references  | null: false, foreign_key: true  | 依頼者                                         |
| input_text              | text        | null: false                     | 入力した食材文字列                              |
| status                  | string      | default: "pending"              | 状態（pending/completed）                      |
| people                  | integer     |                                 | 想定人数                                       |

### Association
- belongs_to :user
- has_many :menus, dependent: :destroy


## menusテーブル（AI提案・保存メニュー）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| title                   |	string      |	null: false                     |	メニュー名                                     |
| description             |	text		    |                                 | 概要・作り方など                               |
| people                  | integer     |                                 | 想定人数                                       |
| ai_request              | references  | foreign_key: true               | AI提案依頼（任意）                              |
| user                    | references  | foreign_key: true               | ユーザー登録メニュー用（任意）                   |

### Association
- belongs_to :ai_request, optional: true
- belongs_to :user, optional: true
- has_many :menu_ingredients, dependent: :destroy
- has_many :ingredients, through: :menu_ingredients
- has_many :favorite_menus, dependent: :destroy

## ingredientsテーブル（食材マスタ）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| name                    |	string      |	null: false                     |	食材名                                         |
| category                |	string      |                                 |	食材カテゴリ（野菜・肉・魚など）                 |

### Association (ingredients)
 - has_many :menu_ingredients, dependent: :destroy
 - has_many :menus, through: :menu_ingredients
 - has_many :supermarket_prices, dependent: :destroy
 - has_many :supermarkets, through: :supermarket_prices


## menu_ingredientsテーブル（メニューと食材の中間）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| menu                    | references  |	null: false, foreign_key: true  |	対応メニュー                                   |
| ingredient              |	references  |	null: false, foreign_key: true  |	対応食材                                       |
| quantity                |	integer     |                                 | 分量（整数のみ）                               |
| unit                    |	string      |                                 |	単位                                          |

### Association (menu_ingredients)
 - belongs_to :menu
 - belongs_to :ingredient


## stocksテーブル（食材ストック）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| user                    | references  | null: false, foreign_key: true  | 所有ユーザー                                   |
| name                    | string      | null: false                     | 食材名                                        |
| quantity                | integer     |                                 | 数量（整数のみ）                               |
| unit                    | string      |                                 | 単位                                          |

### Association (stocks)
 - belongs_to :user


## favorite_menusテーブル（お気に入りメニュー）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| user                    |	references  |	null: false, foreign_key: true  |	登録者                                        |
| menu                    |	references  |	null: false, foreign_key: true  |	お気に入り対象メニュー                          |
| note                    | text        |                                 |	メモ／アレンジ記録など                          |

### Association (favorite_menus)
 - belongs_to :user
 - belongs_to :menu


## shopping_listsテーブル（買い物リスト）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| user                    |	references  |	null: false, foreign_key: true  |	所有ユーザー                                   |
| title                   |	string      | null: false                     |	買い物リスト名（例: 今週の夕食用）               |

### Association (shopping_lists)
 - belongs_to :user
 - has_many :shopping_items, dependent: :destroy


## shopping_itemsテーブル（買い物リスト内アイテム）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| shopping_list           |	references  |	null: false, foreign_key: true  |	                                              |
| name                    |	string      | null: false                     |	商品名／食材名                                 |
| quantity                |	integer     |                                 |	数量（整数のみ）                               |
| unit                    |	string      |                                 |	単位                                          |

### Association (shopping_items)
 - belongs_to :shopping_list


## supermarketsテーブル（スーパー情報）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| name                    |	string      | null: false                     |	スーパー名                                     |
| address                 |	string      |                                 |	所在地（デモ用）                                |

### Association (supermarkets)
 - has_many :supermarket_prices, dependent: :destroy
 - has_many :ingredients, through: :supermarket_prices
 - has_many :user_supermarkets, dependent: :destroy
 - has_many :users, through: :user_supermarkets


## supermarket_pricesテーブル（スーパーごとの価格データ、スーパーと食材の中間）

| Column                  | Type        | Options                         | explanation                                   |
| ----------------------- | ----------- | ------------------------------- | --------------------------------------------- |
| supermarket             |	references  |	null: false, foreign_key: true  |	スーパー                                       |
| ingredient              |	references  |	null: false, foreign_key: true  |	食材                                          |
| price                   |	integer     |	null: false                     |	価格（円）                                     |

### Association (supermarket_prices)
 - belongs_to :supermarket
 - belongs_to :ingredient