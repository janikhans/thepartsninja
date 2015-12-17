class Fitment < ActiveRecord::Base
  belongs_to :vehicle
  belongs_to :part
  belongs_to :user

  validates :part, presence: true
end