class FitmentNote < ApplicationRecord
  # FIXME rename this to something better
  # scope naming needs to be changed to something more concise
  validates :name, presence: true

  belongs_to :parent
  has_many :fitment_notations, dependent: :destroy
  has_many :fitments, through: :fitment_notations

  scope :parent_groups, -> { where(parent_id: nil)}
  scope :individual_notes, -> { where.not(parent_id: nil)}

  has_many :note_variations,
    class_name: "FitmentNote",
    foreign_key: "parent_id",
    dependent: :destroy

  belongs_to :parent_note,
    class_name: "FitmentNote",
    foreign_key: "parent_id"

  has_many :check_searches
  has_many :compatibility_searches
  has_many :search_records
  has_many :available_fitment_notes
end
