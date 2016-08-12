class VehicleYear < ApplicationRecord
  # TODO set permission so that only an admin can create a new vehicle_year
  # vehicle_years that aren't integers are still valid entries

  has_many :vehicles,
    dependent: :restrict_with_error

  validates :year,
    presence: true,
    numericality: true,
    inclusion: { in: 1900..Date.today.year+1, message: "needs to be between 1900-#{Date.today.year+1}"},
    uniqueness: true
end
