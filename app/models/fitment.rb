class Fitment < ActiveRecord::Base
  belongs_to :part
  belongs_to :vehicle
  belongs_to :user

  has_many :compatibles
  has_many :replacements, class_name: "Compatible", foreign_key: "compatible_fitment_id"   

  has_many :known_compatibles,               -> {where backwards: true}, class_name: "Compatible", foreign_key: "fitment_id" 
  has_many :backwards_compatibles,           -> {where backwards: true}, class_name: "Compatible", foreign_key: "compatible_fitment_id" 
  has_many :known_not_backwards_compatibles, -> {where backwards: false}, class_name: "Compatible", foreign_key: "compatible_fitment_id"
  has_many :potential_compatibles,           -> {where backwards: false}, class_name: "Compatible", foreign_key: "fitment_id" 

  def compats
    compatibles = []
    b_compatibles = []

    self.known_not_backwards_compatibles.each do |b|
      b.fitment, b.compatible_fitment = b.compatible_fitment, b.fitment
      b_compatibles << b
    end

    compatibles << self.backwards_compatibles
    compatibles << self.known_compatibles
    compatibles << b_compatibles

    compatibles.flatten!
    # compatibles.uniq{ |c| c.discovery_id}

    return compatibles
  end

  def compatible_fitments
    self.compats
  end         
                     
end



    