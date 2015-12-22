class Part < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :fitments, dependent: :destroy
  has_many :oem_vehicles, through: :fitments, source: :vehicle
  has_many :potential_vehicles, through: :fitments, source: :known_compatibles
  has_many :compatible_vehicles, through: :fitments, source: :potential_compatibles

  validates :product, presence: true
end
