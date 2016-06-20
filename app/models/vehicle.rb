class Vehicle < ActiveRecord::Base

  # scope :unique_models, -> { select("model").order("model ASC").group("model, vehicles.id") }

  #Lets make those URLs nice and SEO friendly
  extend FriendlyId
  friendly_id :slug_candidates, use: [:finders, :slugged]
  belongs_to :vehicle_year
  belongs_to :brand
  has_many :searches
  has_many :fitments, dependent: :destroy
  has_many :oem_parts, through: :fitments, source: :part

  #Validations - woohoo!
  before_validation :set_model
  # before_validation :sanitize_model
  validates :brand, presence: true
  validates :vehicle_year, presence: true

  belongs_to :vehicle_submodel, inverse_of: :vehicles
  validates :vehicle_submodel, presence: true

  def brand_name
    brand.try(:name)
  end

  def vec_year
    vehicle_year.try(:year)
  end

  #This works but could be DRY'd with the same method from each model. Also doesn't allow for 2 companies with the same exact name.
  def brand_name=(name)
    name = name.strip
    self.brand = Brand.where('lower(name) = ?', name.downcase).first_or_create(name: name)
  end

  def to_label
    "#{vehicle_year.year} #{brand.name} #{model}"
  end

private
  #This and the strip_and_upcase_name in brand.rb can be DRY'd up at some point

    def set_model
      self.model = "Blah"
    end

    def sanitize_model
      return if self.model.nil?
      self.model = model.strip
      self.model = model[0].upcase + model[1..-1]
    end

    def slug_candidates
     [
      [:vec_year, :brand_name, :model],
     ]
    end

end
