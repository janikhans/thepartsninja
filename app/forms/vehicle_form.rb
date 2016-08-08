class VehicleForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  def self.model_name
    ActiveModel::Name.new(self, nil, "Vehicle")
  end

  attr_accessor :brand, :model, :submodel, :year
  attr_reader :vehicle

  # TODO better validations, such as only integers, no symbols etc
  # Return vehicle after save
  # more safety checks etc

  validates :brand, :model,
    length: { maximum: 75},
    presence: true

  validates :year,
    numericality: { only_integer: true },
    inclusion: { in: 1900..Date.today.year+1,
                 message: "needs to be between 1900-#{Date.today.year+1}"}

  before_validation :vehicle_string_to_integer, :sanitize_fields

  def save
    if valid?
      brand = Brand.where('lower(name) = ?', @brand.downcase).first_or_create!(name: @brand)
      model = brand.vehicle_models.where('lower(name) = ?', @model.downcase).first_or_create!(name: @model)
      if @submodel.present?
        submodel = model.vehicle_submodels.where('lower(name) = ?', @submodel.downcase).first_or_create!(name: @submodel)
      else
        submodel = model.vehicle_submodels.where(name: nil).first_or_create!
      end
      @vehicle = Vehicle.where(vehicle_year: VehicleYear.where(year: @year).first, vehicle_submodel: submodel).first_or_create!
    else
      false
    end
  end

  private

    def vehicle_string_to_integer
      if @year.is_a? String
        @year = @year.to_i
      end
    end

    def sanitize_fields
      @brand = sanitize(@brand)
      @model = sanitize(@model)
      @submodel = sanitize(@submodel)
    end

    def sanitize(field)
      unless field.blank?
        field = field.strip
        field = field[0].upcase + field[1..-1]
      end
    end
end
