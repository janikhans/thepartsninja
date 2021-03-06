class Fitment < ApplicationRecord
  # TODO a column showing the source of the fitment. User/Discovery/Ebay/etc
  # Will have has_many flag table to show which fitments are reported.

  belongs_to :part
  validates :part,
    presence: true,
    uniqueness: { scope: :vehicle_id }

  belongs_to :vehicle
  validates :vehicle, presence: true

  # The source of this fitment. Ebay, User, Scraping, etc
  # We don't know the accuracy of these fitments unless they're imported from a
  # known catalog.
  enum source: [:user, :ebay]

  # TODO figure out if these are worth having
  belongs_to :user
  belongs_to :discovery

  has_many :fitment_notations, dependent: :destroy
  has_many :fitment_notes, through: :fitment_notations, source: :fitment_note
  accepts_nested_attributes_for :fitment_notations, reject_if: :all_blank, allow_destroy: true
end
