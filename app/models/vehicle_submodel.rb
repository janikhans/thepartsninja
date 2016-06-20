class VehicleSubmodel < ActiveRecord::Base
  belongs_to :vehicle_model, inverse_of: :vehicle_submodels
  has_many :vehicles, inverse_of: :vehicle_submodel, dependent: :destroy

  accepts_nested_attributes_for :vehicles, reject_if: :all_blank
  validates :vehicle_model, presence: true

  # Testing reverse creation
  accepts_nested_attributes_for :vehicle_model, reject_if: :all_blank
end
