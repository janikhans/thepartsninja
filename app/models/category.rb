class Category < ActiveRecord::Base

  scope :subcategories, -> { where.not(parent_id: nil) }

  belongs_to :parent
  has_many :products, dependent: :restrict_with_error

  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent_category, class_name: "Category", foreign_key: "parent_id"

  validates :name, presence: true
end
