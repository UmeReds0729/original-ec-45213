class Supermarket < ApplicationRecord
  has_many :supermarket_prices

  def self.ransackable_attributes(auth_object = nil)
    %w[id name location created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[supermarket_prices]
  end
end
