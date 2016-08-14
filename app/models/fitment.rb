class Fitment < ApplicationRecord
  # TODO a column showing the source of the fitment. User/Discovery/Ebay/etc
  # Will have has_many flag table to show which fitments are reported.

  belongs_to :part
  validates :part,
    presence: true,
    uniqueness: { scope: :vehicle_id }

  belongs_to :vehicle
  validates :vehicle, presence: true

  # TODO figure out if these are worth having
  belongs_to :user
  belongs_to :discovery
end
