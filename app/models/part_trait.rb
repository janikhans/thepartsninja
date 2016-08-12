class PartTrait < ApplicationRecord
  # FIXME as with PartAttribute, this model should be renamed
  # potentiall PartAttribution?

  belongs_to :part
  validates :part, presence: true

  belongs_to :part_attribute
  validates :part_attribute,
    presence: true,
    uniqueness: { scope: :part_id }
end
