class Fitment < ActiveRecord::Base
  belongs_to :part
  belongs_to :vehicle
  belongs_to :user
end
