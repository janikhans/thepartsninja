class Vehicle < ActiveRecord::Base
  #Lets make those URLs nice and SEO friendly
  extend FriendlyId
  friendly_id :slug_candidates, use: [:finders, :slugged]

  has_many :searches
  has_many :fitments, dependent: :destroy
  has_many :oem_parts, through: :fitments, source: :part

  #Validations - woohoo!
  belongs_to :vehicle_year
  validates :vehicle_year, presence: true
  validates_uniqueness_of :vehicle_year,
    scope: :vehicle_submodel_id,
    message: "This model year already exists"

  belongs_to :vehicle_submodel, inverse_of: :vehicles
  validates :vehicle_submodel, presence: true

  def year
    vehicle_year.year
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

  def brand_name
    vehicle_submodel.vehicle_model.brand.name
  end

  def model_name
    vehicle_submodel.vehicle_model.name
  end

  def submodel_name
    vehicle_submodel.try(:name)
  end

  def to_label
    "#{year} #{brand_name} #{model_name} #{submodel_name}"
  end

private

    def slug_candidates
     [
      [:year, :brand_name, :model_name, :submodel_name],
     ]
    end

end
