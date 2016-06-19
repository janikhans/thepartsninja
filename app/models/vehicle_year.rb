class VehicleYear < ActiveRecord::Base
  has_many :vehicles, dependent: :restrict_with_error

  validates :year,
    presence: true,
    numericality: true,
    inclusion: { in: 1900..Date.today.year+1, message: "needs to be between 1900-#{Date.today.year+1}"}
end
