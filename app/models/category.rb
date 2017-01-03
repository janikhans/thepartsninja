class Category < ApplicationRecord
  # TODO should users have the ability to go through and add new categories?
  # Would be nice to to have a :leaves_of scope
  # this validation probably needs to be set
  # validates :name,
  #   uniqueness: { scope: :parent_id, case_sensitive: false },
  #   if: "parent_id.present?"

  has_ancestry

  scope :leaves, -> { where(leaf: true) }

  has_many :products, dependent: :restrict_with_error
  has_many :part_attributes, -> { distinct }, through: :products
  has_many :fitment_notes, -> { distinct }, through: :products

  validates :name, presence: true

  def is_leaf?
    leaf
  end

  def refresh_leaf
    if is_childless?
      update_attribute(:leaf, true)
    else
      update_attribute(:leaf, false)
    end
  end

  def self.refresh_leaves
    all.map(&:refresh_leaf)
  end
end
