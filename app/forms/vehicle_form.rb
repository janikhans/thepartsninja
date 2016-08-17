class VehicleForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  def self.model_name
    ActiveModel::Name.new(self, nil, "Vehicle")
  end

  attr_accessor :brand, :model, :submodel, :year, :type, :epid
  attr_reader :vehicle

  # TODO better validations, such as only integers, no symbols etc
  # Return vehicle after save
  # more safety checks etc
  # validate inclusion of vehicle_types

  validates :brand, :model, :type,
    length: { maximum: 75},
    presence: true

  validates :year,
    presence: true,
    numericality: { only_integer: true },
    inclusion: { in: 1900..Date.today.year+1,
                 message: "needs to be between 1900-#{Date.today.year+1}"}

  before_validation :sanitize_to_integer, :sanitize_fields

  def save
    if valid?
      brand = Brand.where('lower(name) = ?', @brand.downcase).first_or_create!(name: @brand)
      type = VehicleType.where('lower(name) = ?', @type.downcase).first
      model = brand.vehicle_models.where('lower(name) = ? AND vehicle_type_id = ?', @model.downcase, type.id).first_or_create!(name: @model, vehicle_type_id: type.id)
      submodel = find_or_set_submodel(model)
      year = VehicleYear.where(year: @year).first
      @vehicle = Vehicle.where(vehicle_year_id: year.id, vehicle_submodel_id: submodel.id).first_or_create!(vehicle_year: year, vehicle_submodel: submodel, epid: @epid)
    else
      false
    end
  end

  private

    def sanitize_to_integer
      @year = @year.to_i if @year.is_a? String
      @epid = @epid.to_i if @epid.is_a? String
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

    def find_or_set_submodel(model)
      if @submodel.present?
        model.vehicle_submodels.where('lower(name) = ?', @submodel.downcase).first_or_create!(name: @submodel)
      else
        model.vehicle_submodels.where(name: nil).first_or_create!
      end
    end
end
