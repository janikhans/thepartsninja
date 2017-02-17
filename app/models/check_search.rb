class CheckSearch < ApplicationRecord
  belongs_to :vehicle
  validates :vehicle, presence: true

  belongs_to :comparing_vehicle, class_name: "Vehicle"
  validates :comparing_vehicle, presence: true

  belongs_to :category
  belongs_to :user

  validates :category_name, presence: true
end
