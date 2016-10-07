class ProductType < ApplicationRecord
  belongs_to :category
  has_many :products

  validates :category, presence: true
  
  validates :name,
    presence: true,
    uniqueness: { scope: :category_id }
end
