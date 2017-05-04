class Vehicle < ApplicationRecord
  # FIXME should have an attribute for ebay vehicle ID
  # possible a user_id attribute for the user who created it?
  # change the slug in the future for canonical urls /year/brand/model/submodel - maybe?
  # look at these methods and see if there's a better way of clearning that up
  # Unique EPIDs

  #Lets make those URLs nice and SEO friendly
  extend FriendlyId
  friendly_id :slug_candidates, use: [:finders, :slugged]

  has_many :compatibility_searches
  has_many :check_searches
  has_many :comparing_check_searches, class_name: "CheckSearch", foreign_key: "comparing_vehicle_id"
  has_many :search_records
  has_many :comparing_search_records, class_name: "SearchRecord", foreign_key: "comparing_vehicle_id"

  has_many :fitments, dependent: :destroy
  has_many :oem_parts, through: :fitments, source: :part

  #Validations - woohoo!
  belongs_to :vehicle_year
  validates :vehicle_year, presence: true
  validates_uniqueness_of :vehicle_year,
    scope: :vehicle_submodel_id,
    message: "This model year already exists"

  validates_uniqueness_of :epid,
    if: 'epid.present?'

  belongs_to :vehicle_submodel, inverse_of: :vehicles
  validates :vehicle_submodel, presence: true

  def year
    vehicle_year.year.to_s
  end

  def brand
    vehicle_submodel.vehicle_model.brand
  end

  def model
    vehicle_submodel.vehicle_model
  end

  def submodel
    vehicle_submodel
  end

  def type
    vehicle_submodel.vehicle_model.vehicle_type
  end

  def submodel_name
    vehicle_submodel.try(:name)
  end

  def to_label
    if submodel_name
      "#{year} #{brand_name} #{model_name} #{submodel_name}"
    else
      "#{year} #{brand_name} #{model_name}"
    end
  end

  # This is very brittle right now. What happens if year doesn't fall in range?
  # No brand? No vehicle_model? submodel?
  def self.find_with_specs(brand, model, year, submodel = nil)
    brand = Brand.where('lower(name) = ?', brand.downcase).first
    return unless brand
    model = brand.vehicle_models.where('lower(name) = ?', model.downcase).first
    return unless model
    if submodel
      submodel = model.vehicle_submodels.where('lower(name) = ?', submodel.downcase).first
    else
      submodel = model.vehicle_submodels.where(name: nil).first
    end
    return unless submodel
    year = VehicleYear.find_by(year: year)
    return unless year
    submodel.vehicles.where(vehicle_year_id: year.id).first
  end

  private

    def brand_name
      vehicle_submodel.vehicle_model.brand.name
    end

    def model_name
      vehicle_submodel.vehicle_model.name
    end

    def slug_candidates
     [
      [:year, :brand_name, :model_name, :submodel_name],
     ]
    end

end
