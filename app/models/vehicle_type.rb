class VehicleType < ActiveRecord::Base
  validates :name,
    presence: true,
    uniqueness: true

  has_many :vehicle_models,
    inverse_of: :vehicle_type
end
