class Product < ApplicationRecord
  # ActiveAdmin / Ransack 用
  def self.ransackable_associations(auth_object = nil)
    []  # ← もう関連検索しない
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "category", "created_at", "updated_at"]
  end
end
