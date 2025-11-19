class SupermarketPrice < ApplicationRecord
  belongs_to :supermarket
  belongs_to :ingredient
end
