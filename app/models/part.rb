class Part < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :fitments, dependent: :destroy
  has_many :oem_vehicles, through: :fitments, source: :vehicle

  has_many :known_compatibles, through: :fitments
  has_many :known_not_backwards_compatibles, through: :fitments
  has_many :backwards_compatibles, through: :fitments
  has_many :potential_compatibles, through: :fitments

  def compatible_vehicles
    known_compatibles | known_not_backwards_compatibles
  end


  validates :product, presence: true
end

