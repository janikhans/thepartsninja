class Category < ApplicationRecord
  # TODO should users have the ability to go through and add new categories?

  has_ancestry

  # scope :subcategories, -> { where.not(parent_id: nil) }
  # scope :parent_categories, -> {where(parent_id: nil)}

  # belongs_to :parent
  has_many :products, dependent: :restrict_with_error
  has_many :part_attributes, -> { distinct }, through: :products
  has_many :fitment_notes, -> { distinct }, through: :products
  #
  # has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  # belongs_to :parent_category, class_name: "Category", foreign_key: "parent_id"
  # accepts_nested_attributes_for :subcategories, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true

  # TODO this validation probably needs to be set
  # validates :name,
  #   uniqueness: { scope: :parent_id, case_sensitive: false },
  #   if: "parent_id.present?"
end
