class Fitment < ActiveRecord::Base

  include CompatiblesFinder

  belongs_to :part
  belongs_to :vehicle
  belongs_to :user
  belongs_to :discovery

  has_many :compatibles
  has_many :replacements, class_name: "Compatible", foreign_key: "compatible_fitment_id"   

  has_many :known_compatibles,               -> {where backwards: true}, class_name: "Compatible", foreign_key: "fitment_id" 
  has_many :backwards_compatibles,           -> {where backwards: true}, class_name: "Compatible", foreign_key: "compatible_fitment_id" 
  has_many :known_not_backwards_compatibles, -> {where backwards: false}, class_name: "Compatible", foreign_key: "compatible_fitment_id"
  has_many :potential_compatibles,           -> {where backwards: false}, class_name: "Compatible", foreign_key: "fitment_id" 

  # def compats
  #   compatibles = []
  #   b_compatibles = []

  #   self.known_not_backwards_compatibles.each do |b|
  #     b.fitment, b.compatible_fitment = b.compatible_fitment, b.fitment
  #     b_compatibles << b
  #   end

  #   compatibles << self.backwards_compatibles
  #   compatibles << self.known_compatibles
  #   compatibles << b_compatibles

  #   compatibles.flatten!
  #   # compatibles.uniq{ |c| c.discovery_id}

  #   return compatibles
  # end

  def compatible_fitments
    comp_fits = []
    oem_fits = []
    oem_parts = []
    self.compats.each do |c|
      comp_fits << c.compatible_fitment
      oem_parts << c.fitment.part
    end
    oem_parts.each do |o|
     oem_fits << o.fitments
    end
    oem_fits.flatten!

    # oem_fits.reject! { |f| f == self }

    total_fits = comp_fits | oem_fits
    return total_fits
  end

  def potential_fitments
    comp_fits = []
    child_fits = []
    parent_fitments = self.compatible_fitments
    parent_fitments.each do |c|
      child_fits << c.compatible_fitments
    end
    child_fits.flatten!
    child_fits.reject! { |p| parent_fitments.include?(p) || p == self }
    return child_fits
  end         
                     
end



    