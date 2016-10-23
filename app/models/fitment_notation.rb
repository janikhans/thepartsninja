class FitmentNotation < ApplicationRecord
  belongs_to :fitment
  validates :fitment, presence: true

  belongs_to :fitment_note
  validates :fitment_note,
    presence: true,
    uniqueness: { scope: :fitment_id }
end
