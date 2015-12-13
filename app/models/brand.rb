class Brand < ActiveRecord::Base

  has_many :vehicles
  validates :name, uniqueness: { case_sensitive: false, message: "brand already exists" }

end
