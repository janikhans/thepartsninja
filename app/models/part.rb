class Part < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :fitments, dependent: :destroy
  has_many :oem_vehicles, through: :fitments, source: :vehicle
  has_many :compatible_fitments, through: :fitments

  validates :product, presence: true
end
