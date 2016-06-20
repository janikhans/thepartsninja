class VehicleSubmodel < ActiveRecord::Base
  belongs_to :vehicle_model, inverse_of: :vehicle_submodels
  has_many :vehicles, inverse_of: :vehicle_submodel, dependent: :destroy

  accepts_nested_attributes_for :vehicles
  validates :vehicle_model, presence: true
end
