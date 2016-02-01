class Part < ActiveRecord::Base
  validates :product, presence: true

  include CompatiblesFinder
  
  belongs_to :product
  belongs_to :user
  has_many :fitments, dependent: :destroy
  has_many :oem_vehicles, through: :fitments, source: :vehicle

  has_many :compatibles

  has_many :known_compatibles,               -> {where backwards: true}, class_name: "Compatible", foreign_key: "part_id" 
  has_many :backwards_compatibles,           -> {where backwards: true}, class_name: "Compatible", foreign_key: "compatible_part_id" 
  has_many :known_not_backwards_compatibles, -> {where backwards: false}, class_name: "Compatible", foreign_key: "part_id"
  has_many :potential_compatibles,           -> {where backwards: false}, class_name: "Compatible", foreign_key: "compatible_part_id"

end

