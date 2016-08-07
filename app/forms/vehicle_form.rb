class VehicleForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  def self.model_name
    ActiveModel::Name.new(self, nil, "Vehicle")
  end

  attr_accessor :brand, :vehicle_model, :vehicle_submodel, :vehicle_year
  attr_reader :vehicle

  # TODO better validations, such as only integers, no symbols etc
  # Return vehicle after save
  # more safety checks etc

  validates :brand, :vehicle_model,
    length: { maximum: 75},
    presence: true

  validates :vehicle_year,
    numericality: { only_integer: true },
    inclusion: { in: 1900..Date.today.year+1,
                 message: "needs to be between 1900-#{Date.today.year+1}"}

  before_validation :vehicle_string_to_integer, :sanitize_fields

  def save
    if valid?
      brand = Brand.where('lower(name) = ?', @brand.downcase).first_or_create!(name: @brand)
      model = brand.vehicle_models.where('lower(name) = ?', @vehicle_model.downcase).first_or_create!(name: @vehicle_model)
      if @vehicle_submodel.present?
        submodel = model.vehicle_submodels.where('lower(name) = ?', @vehicle_submodel.downcase).first_or_create!(name: @vehicle_submodel)
      else
        submodel = model.vehicle_submodels.where(name: nil).first_or_create!
      end
      @vehicle = Vehicle.where(vehicle_year: VehicleYear.where(year: @vehicle_year).first, vehicle_submodel: submodel).first_or_create!
    else
      false
    end
  end

  private

    def vehicle_string_to_integer
      if @vehicle_year.is_a? String
        @vehicle_year = @vehicle_year.to_i
      end
    end

    def sanitize_fields
      @brand = sanitize(@brand)
      @vehicle_model = sanitize(@vehicle_model)
      @vehicle_submodel = sanitize(@vehicle_submodel)
    end

    def sanitize(field)
      unless field.blank?
        field = field.strip
        field = field[0].upcase + field[1..-1]
      end
    end
end
