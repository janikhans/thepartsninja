class Brand < ActiveRecord::Base

  has_many :vehicles
  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "brand already exists" }
  
end
