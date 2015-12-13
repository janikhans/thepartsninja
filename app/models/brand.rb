class Brand < ActiveRecord::Base

  validates :name, uniqueness: { case_sensitive: false, message: "brand already exists" }

end
