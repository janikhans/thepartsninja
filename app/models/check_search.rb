class CheckSearch < ApplicationRecord
  belongs_to :vehicle_one, class_name: "Vehicle"
  validates :vehicle_one, presence: true

  belongs_to :vehicle_two, class_name: "Vehicle"
  validates :vehicle_two, presence: true

  belongs_to :category
  belongs_to :user

  validates :category_name, presence: true
end
