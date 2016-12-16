class Category < ApplicationRecord
  # TODO should users have the ability to go through and add new categories?

  scope :subcategories, -> { where.not(parent_id: nil) }
  scope :parent_categories, -> {where(parent_id: nil)}

  belongs_to :parent
  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true

  has_many :product_types, dependent: :destroy
  accepts_nested_attributes_for :product_types, reject_if: :all_blank, allow_destroy: true

  # TODO this validation probably needs to be set
  # validates :name,
  #   uniqueness: { scope: :parent_id, case_sensitive: false },
  #   if: "parent_id.present?"
end
