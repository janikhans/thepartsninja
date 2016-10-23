class FitmentNote < ApplicationRecord
  # FIXME rename this to something better
  # scope naming needs to be changed to something more concise
  validates :name, presence: true

  belongs_to :parent
  has_many :fitment_notations, dependent: :destroy

  scope :parent_groups, -> { where(parent_id: nil)}
  scope :individual_notes, -> { where.not(parent_id: nil)}

  has_many :note_variations,
    class_name: "FitmentNote",
    foreign_key: "parent_id",
    dependent: :destroy

  belongs_to :parent_note,
    class_name: "FitmentNote",
    foreign_key: "parent_id"
end
