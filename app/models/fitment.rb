class Fitment < ActiveRecord::Base

  include CompatiblesFinder

  belongs_to :part
  belongs_to :vehicle
  belongs_to :user
  belongs_to :discovery

  # has_many :compatibles
  # has_many :replacements, class_name: "Compatible", foreign_key: "compatible_fitment_id"   

  # has_many :known_compatibles,               -> {where backwards: true}, class_name: "Compatible", foreign_key: "fitment_id" 
  # has_many :backwards_compatibles,           -> {where backwards: true}, class_name: "Compatible", foreign_key: "compatible_fitment_id" 
  # has_many :known_not_backwards_compatibles, -> {where backwards: false}, class_name: "Compatible", foreign_key: "compatible_fitment_id"
  # has_many :potential_compatibles,           -> {where backwards: false}, class_name: "Compatible", foreign_key: "fitment_id" 

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

  def other_oem_fitments # Finds same level fitments from parts
    oem_fits = []
    oem_part = self.part

    oem_fits << oem_part.fitments
    oem_fits.flatten!

    oem_fits.reject! { |f| f == self}
    return oem_fits
  end

  def compatible_fitments #Finds just the compatible fitments to the fitment being searched
    comp_fits = []
    self.compats.each do |c|
      comp_fits << c.compatible_fitment
    end
    return comp_fits
  end

  def next_level (level) # Finds all fitments from the next level down, including the other oem fitments related to each compatible fitment.
    previous_level = level
    compats = []
    oem = []
    total = []

    previous_level.each do |p|
      compats << p.compatible_fitments
    end
    compats.flatten!

    compats.each do |o|
      oem << o.other_oem_fitments
    end

    total << oem << compats
    total.flatten!
    return total
  end

  def find_potentials  
    oem_fits = self.other_oem_fitments

    potentials = []

    ## Top Level represents the level on which the fitment that is being searched is on. This level will include all other fitments that the part belongs too. '06 yz250 front wheel == 06 yz450f front wheel
    top_level = []
    top_level << self << oem_fits
    top_level.flatten!

    ## Second level represents the immediate compatibilities found to the searched fitment
    second_level = next_level(top_level)
    ## Third level is the first level of Potentials to the searched fitment. Basically we're just looping this step over and over. Then pushing the unique ids into the potentials array. 
    third_level = next_level(second_level)
    third_level.reject! { |f| top_level.include?(f) || second_level.include?(f) }
    potentials << third_level.uniq

    fourth_level = next_level(third_level)

    fourth_level.reject! { |f| top_level.include?(f) || second_level.include?(f) || third_level.include?(f) }
    potentials << fourth_level.uniq

    potentials.flatten!
    return potentials
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



    