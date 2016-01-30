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

  # This is in CompatiblesFinder but for reference here it is ##
  # def compats
  #   compatibles = []
  #   b_compatibles = []
  #   k_not_b_compatibles = []

  #   self.backwards_compatibles.each do |b|
  #     b.fitment, b.compatible_fitment = b.compatible_fitment, b.fitment
  #     b_compatibles << b
  #   end

  #   self.known_not_backwards_compatibles.each do |b|
  #     b.fitment, b.compatible_fitment = b.compatible_fitment, b.fitment
  #     k_not_b_compatibles << b
  #   end

  #   compatibles << k_not_b_compatibles
  #   compatibles << self.known_compatibles
  #   compatibles << b_compatibles

  #   compatibles.flatten!
  #   # compatibles.uniq{ |c| c.discovery_id}

  #   return compatibles
  # end

  def other_oem_fitments
    oem_fits = []
    oem_part = self.part

    oem_fits << oem_part.fitments
    oem_fits.flatten!

    oem_fits.reject! { |f| f == self}
    return oem_fits
  end

  def compatible_fitments
    comp_fits = []
    self.compats.each do |c|
      comp_fits << c.compatible_fitment
    end
    return comp_fits
  end

  def oem_and_compatible_fitments
    self.other_oem_fitments | self.compatible_fitments
  end

  def first_level_fitments #Finds all fitments for the oem_fitments from self and it self
    potentials = []
    same_level_fits = self.other_oem_fitments
    same_level_fits.each do |s|
      potentials << s.next_level_fitments
    end

    return potentials
  end

  def next_level_fitments ## Finds all compatible fitments or their OEM shared fitments for the next level
    oem_child_fits = []
    child_fits = self.compatible_fitments
    child_fits.each do |c|
      oem_child_fits << c.other_oem_fitments
    end
    total_fits = child_fits | oem_child_fits
    total_fits.flatten!
    return total_fits
  end

  def next_level 
    level_1 = self.next_level_fitments
    level_2 = []
    level_1.each do |l|
     level_2 << l.next_level_fitments
    end
    level_2.flatten!
    level_2.reject! { |f| f == self }
    return level_2
  end

  def potential_search
    level_1_compats = self.level_1

    level_2_compats = self.next_level
    potentials = []
    return level_2_compats
  end

  # def potentials
  #   oem_fits = self.other_oem_fitments
  #   compatible_fits = self.compatible_fitments
  #   known_fits = oem_fits | compatible_fits

  #   potential_fits = []

  #   lvl_1 = []
  #   lvl_1 << self << oem_fits
  #   lvl_1.flatten!

  #   lvl_2_compats = []
  #   lvl_2_oem = []

  #   lvl_1.each do |o|
  #     lvl_2_compats << o.compatible_fitments
  #   end
  #   lvl_2_compats.flatten!

  #   lvl_2_compats.each do |o|
  #     lvl_2_oem << o.other_oem_fitments
  #   end

  #   lvl_2_total = lvl_2_oem | lvl_2_compats
  #   lvl_2_total.flatten!

  #   lvl_3 = []
  #   lvl_3_oem = []
  #   lvl_3_compats = []
  #   lvl_2_total.each do |o|
  #     lvl_3_compats << o.compatible_fitments
  #   end
  #   lvl_3_compats.flatten!

  #   lvl_3_compats.each do |o|
  #     lvl_3_oem << o.other_oem_fitments
  #   end

  #   lvl_3_total = lvl_3_compats | lvl_3_oem
  #   lvl_3_total.flatten!
  #   lvl_3_total.reject! { |f| f == self}

  #   return lvl_3_total
  # end


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

  #Writing out how to find all potentials
  # def potentials(level)
  #   Take the fitment
  #   <!-- Level 1 --!>
  #   Find the other fitments that share a common part. ie 2006 YZ250 and 2006 YZ450F are the same wheel but fit multiple models
  #   Each of these gets a score of 1
  #   Build "potential" to prove why it fits {score: score, grandparent: fitment, parent: fitment, fitment: fitment} - or something. We want to say THIS PART fits because of THIS PART
  #   <!-- Level 2 --!>
  #   Find all next level fitments through shared part or through compatibilities on the resul from level 1
  #   Each of these will get a score of 1/2. 
  #   Build a "potential" again for each result
  #   <!-- Level 3+ --!>
  #   Do the same for the fitments
  #   Give score of 1/4. 

  #   Create 1 array of all the potentials.
  #   Add up score for the potentials sharing fitment
  # end   
                     
end



    