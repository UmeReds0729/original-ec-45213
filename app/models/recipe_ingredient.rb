class RecipeIngredient < ApplicationRecord
  has_many :supermarket_prices, dependent: :destroy
  has_many :supermarkets, through: :supermarket_prices

  validates :canonical_name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["display_name", "canonical_name", "category", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["supermarket_prices", "supermarkets"]
  end
end
