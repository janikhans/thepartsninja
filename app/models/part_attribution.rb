class PartAttribution < ApplicationRecord
  belongs_to :part
  validates :part, presence: true

  belongs_to :part_attribute
  validates :part_attribute,
    presence: true,
    uniqueness: { scope: :part_id }
end
