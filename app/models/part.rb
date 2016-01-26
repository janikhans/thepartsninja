class Part < ActiveRecord::Base

  include CompatiblesFinder
  
  belongs_to :product
  belongs_to :user
  has_many :fitments, dependent: :destroy
  has_many :oem_vehicles, through: :fitments, source: :vehicle

  has_many :compatibles, through: :fitments

  has_many :known_compatibles, through: :fitments
  has_many :known_not_backwards_compatibles, through: :fitments
  has_many :backwards_compatibles, through: :fitments
  has_many :potential_compatibles, through: :fitments

  def compatible_fitments
    fitments = []
    self.compats.each do |c|
      fitments << c.compatible_fitment
    end
    fitments.flatten!
    return fitments
  end

  # def compats
  #   compatibles = []
  #   b_compatibles = []

  #   self.backwards_compatibles.each do |b|
  #     b.fitment, b.compatible_fitment = b.compatible_fitment, b.fitment
  #     b_compatibles << b
  #   end

  #   compatibles << self.known_not_backwards_compatibles
  #   compatibles << self.known_compatibles
  #   compatibles << b_compatibles

  #   compatibles.flatten!
  #   # compatibles.uniq{ |c| c.discovery_id}

  #   return compatibles
  # end 


  validates :product, presence: true
end

