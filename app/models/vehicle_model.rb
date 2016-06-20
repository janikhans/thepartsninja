class VehicleModel < ActiveRecord::Base
  belongs_to :brand
  has_many :vehicle_submodels, inverse_of: :vehicle_model, dependent: :destroy
  validates :brand, :name, presence: true

  accepts_nested_attributes_for :vehicle_submodels
end
