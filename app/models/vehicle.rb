class Vehicle < ActiveRecord::Base

  # scope :unique_models, -> { select("model").order("model ASC").group("model, vehicles.id") }

  #Lets make those URLs nice and SEO friendly
  extend FriendlyId
  friendly_id :slug_candidates, use: [:finders, :slugged]
  belongs_to :vehicle_year
  has_many :searches
  has_many :fitments, dependent: :destroy
  has_many :oem_parts, through: :fitments, source: :part

  #Validations - woohoo!
  validates :vehicle_year, presence: true

  belongs_to :vehicle_submodel, inverse_of: :vehicles
  validates :vehicle_submodel, presence: true

  # Testing reverse creation
  accepts_nested_attributes_for :vehicle_submodel, reject_if: :all_blank

  def vec_year
    vehicle_year.try(:year)
  end

  def vec_brand
    vehicle_submodel.vehicle_model.brand.try(:name)
  end

  def vec_model
    vehicle_submodel.vehicle_model.try(:name)
  end

  def to_label
    "#{vec_year} #{vec_brand} #{vec_model}"
  end

private

    def slug_candidates
     [
      [:vec_year, :vec_brand, :vec_model],
     ]
    end

end
