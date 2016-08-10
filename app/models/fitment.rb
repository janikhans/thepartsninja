class Fitment < ActiveRecord::Base
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
