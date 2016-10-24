class ProductType < ApplicationRecord
  belongs_to :category
  has_many :products

  validates :category, presence: true

  validates :name,
    presence: true,
    uniqueness: { scope: :category_id }

  has_many :part_attributes, -> { distinct }, through: :products
  has_many :fitment_notes, -> { distinct }, through: :products
end
