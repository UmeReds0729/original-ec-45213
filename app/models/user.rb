class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :stocks, dependent: :destroy
  has_many :favorite_menus, dependent: :destroy
  has_many :shopping_lists, dependent: :destroy
  has_many :user_supermarkets, dependent: :destroy
  has_many :supermarkets, through: :user_supermarkets
  has_many :ai_requests, dependent: :destroy
  has_many :menus, dependent: :destroy
end
