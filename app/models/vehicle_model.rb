class VehicleModel < ActiveRecord::Base
  # TODO will we ever need those accepts_nested_attributes_for?
  # sanitizing - first letter for sure

  validates :name,
    presence: true,
    uniqueness: { scope: :brand_id, case_sensitive: false }

  belongs_to :brand
  validates :brand, presence: true

  belongs_to :vehicle_type,
    inverse_of: :vehicle_models
  validates :vehicle_type, presence: true

  has_many :vehicle_submodels,
    inverse_of: :vehicle_model,
    dependent: :destroy

  has_many :vehicles, through: :vehicle_submodels

  accepts_nested_attributes_for :vehicle_submodels
  accepts_nested_attributes_for :brand
end
