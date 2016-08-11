class VehicleType < ActiveRecord::Base
  # TODO subcategories for vehicle_types
  # Motorcycle: [dirtbike, dual-sport, streetbike, enduro, etc]
  # set permission so that only admin can create a new vehicle_type
  
  before_validation :sanitize_name
  validates :name,
    presence: true,
    uniqueness: true

  has_many :vehicle_models,
    inverse_of: :vehicle_type

  private

    def sanitize_name
      unless self.name.blank?
        self.name = self.name.strip
        self.name = self.name[0].upcase + self.name[1..-1]
      end
    end
end
