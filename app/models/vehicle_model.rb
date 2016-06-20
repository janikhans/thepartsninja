class VehicleModel < ActiveRecord::Base
  belongs_to :brand
  has_many :vehicle_submodels, inverse_of: :vehicle_model, dependent: :destroy
  has_many :vehicles, through: :vehicle_submodels
  validates :brand, :name, presence: true

  # validates :name, uniqueness: {scope: :brand_id, case_sensitive: false, message: 'This model already exists'}

  accepts_nested_attributes_for :vehicle_submodels

  accepts_nested_attributes_for :brand
end
