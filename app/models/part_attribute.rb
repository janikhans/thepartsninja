class PartAttribute < ApplicationRecord
  # FIXME rename this to something better
  # scope naming needs to be changed to something more concise

  belongs_to :parent
  has_many :part_traits, dependent: :destroy

  scope :specific_attributes, -> { where.not(parent_id: nil) }
  scope :attribute_parents, -> { where(parent_id: nil) }

  has_many :attribute_variations,
    class_name: "PartAttribute",
    foreign_key: "parent_id",
    dependent: :destroy

  belongs_to :parent_attribute,
    class_name: "PartAttribute",
    foreign_key: "parent_id"

  validates :name, presence: true
end
