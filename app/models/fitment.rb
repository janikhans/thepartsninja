class Fitment < ActiveRecord::Base
  belongs_to :part
  belongs_to :vehicle
  belongs_to :user

  has_many :compatibles

  ## This is confusing and abstract - but it works! ##
  # A fitment is known to be the compatible (aka the part being used as the replacement) when it is in the compatible_fitment cloumn on the Compatible table
  # This finds all the Compatibles where this Fitment (vehicle/part) is being used as the replacement
  has_many :known_compatibles, class_name: "Compatible",
                                foreign_key: "compatible_fitment_id",
                                dependent: :destroy

  #This one is returning all the comaptibles where the Fitment is the original part being replaced                              
  has_many :potential_compatibles, class_name: "Compatible",
                                foreign_key: "fitment_id",
                                dependent: :destroy

  #This is where it gets confusing IMO. Here is finding the parts where it is known that this part can be used as a replacement                              
  has_many :potentials, through: :known_compatibles,  source: :fitment

  #This one finds those records where this fitment was used as the replacement but we can't be sure it fits. If it's verified to fit, we'll create a new compatible record
  has_many :knowns, through: :potential_compatibles, source: :compatible_fitment                              
                     
end


    