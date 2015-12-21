class Fitment < ActiveRecord::Base
  belongs_to :part
  belongs_to :vehicle
  belongs_to :user
  has_many :compatibles
  has_many :compatible_fitments, through: :compatibles                         
end
