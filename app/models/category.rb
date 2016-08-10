class Category < ActiveRecord::Base
  scope :subcategories, -> { where.not(parent_id: nil) }

  belongs_to :parent
  has_many :products, dependent: :restrict_with_error

  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent_category, class_name: "Category", foreign_key: "parent_id"

  validates :name, presence: true
  
  # TODO this validation probably needs to be set
  # validates :name,
  #   uniqueness: { scope: :parent_id, case_sensitive: false },
  #   if: "parent_id.present?"
end
