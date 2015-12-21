class Fitment < ActiveRecord::Base
  belongs_to :part
  belongs_to :vehicle
  belongs_to :user
  has_many :known_compatibles, class_name: "Compatible",
                           foreign_key: "replaces_id",
                           dependent: :destroy

  has_many :possible_compatibles, class_name: "Compatible",
                           foreign_key: "original_id",
                           dependent: :destroy

  has_many :originals, through: :known_compatibles, source: :original                        
  has_many :potentials, through: :possible_compatibles, source: :replaces                         
end
