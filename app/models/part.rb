class Part < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :fitments, dependent: :destroy
  has_many :oem_vehicles, through: :fitments, source: :vehicle
  has_many :compatible_vehicles, through: :fitments, source: :knowns
  has_many :potential_vehicles, through: :fitments, source: :potentials

  validates :product, presence: true
end
