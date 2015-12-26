class Fitment < ActiveRecord::Base
  belongs_to :part
  belongs_to :vehicle
  belongs_to :user

  has_many :compatibles
  has_many :replacements, class_name: "Compatible",
                          foreign_key: "compatible_fitment_id"

  has_many :known_compatibles, -> { where(compatibles: { backwards: true})}, through: :compatibles, source: :compatible_fitment
  has_many :known_not_backward_compatibles, -> { where(compatibles: { backwards: true})}, through: :replacements, source: :fitment
  has_many :backwards_compatibles, ->{ where(compatibles: { backwards: false})}, through: :compatibles, source: :compatible_fitment                             
  has_many :potential_compatibles, -> { where(compatibles: { backwards: false}) }, through: :replacements, source: :fitment                      
                     
end


    