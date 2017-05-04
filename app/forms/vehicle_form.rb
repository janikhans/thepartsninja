class VehicleForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Vehicle')
  end

  attr_accessor :vehicle_brand, :vehicle_model, :vehicle_submodel,
    :vehicle_year, :vehicle_type, :vehicle

  # TODO better validations, such as only integers, no symbols etc
  # Return vehicle after save
  # more safety checks etc
  # validate inclusion of vehicle_types
  # unique Epid again

  validates :vehicle_brand, :vehicle_model,
    length: { maximum: 75 },
    presence: true

  validates :vehicle_year,
    numericality: { only_integer: true },
    inclusion: { in: 1900..Date.today.year + 1,
                 message: "needs to be between 1900-#{Date.today.year + 1}" }

  validates :vehicle_type,
    presence: true,
    inclusion: { in: ['Motorcycle', 'ATV/UTV', 'Snowmobile', 'Scooter', 'Car',
                      'Personal Watercraft', 'Truck', 'Golf Cart', 'TBD'] }

  before_validation :sanitize_fields

  def find_or_create
    ActiveRecord::Base.transaction do
      brand = initialize_brand(vehicle_brand)
      brand.save!

      type = initialize_vehicle_type(vehicle_type)

      model = initialize_model(brand, type, vehicle_model)
      model.save!

      submodel = initialize_submodel(model, vehicle_submodel)
      submodel.save!

      year = initialize_year(vehicle_year)
      year.save!

      vehicle = initialize_vehicle(year, submodel)
      vehicle.save!
      self.vehicle = vehicle
    end
  rescue ActiveRecord::RecordInvalid, NoMethodError => e
    errors.add(:base, e.message)
    return false
  end

  private

  def sanitize_fields
    self.vehicle_brand = sanitize(vehicle_brand)
    self.vehicle_model = sanitize(vehicle_model)
    self.vehicle_submodel = sanitize(vehicle_submodel)
    self.vehicle_year = vehicle_year.to_i
  end

  def sanitize(field)
    return if field.blank?
    field = field.strip
    field[0].upcase + field[1..-1]
  end

  def initialize_vehicle_type(vehicle_type)
    VehicleType.where('lower(name) = ?', vehicle_type.downcase).first
  end

  def initialize_brand(brand)
    Brand.where('lower(name) = ?', brand.downcase)
         .first_or_initialize(name: brand)
  end

  def initialize_model(brand, vehicle_type, model)
    VehicleModel.where(
      'lower(name) = ? AND vehicle_type_id = ? AND brand_id = ?',
      model.downcase, vehicle_type.id, brand.id
    ).first_or_initialize(name: model,
                          vehicle_type: vehicle_type,
                          brand: brand)
  end

  def initialize_submodel(model, submodel)
    if submodel.nil?
      VehicleSubmodel.where(
        name: nil, vehicle_model: model
      ).first_or_initialize
    else
      VehicleSubmodel.where(
        'lower(name) = ? AND vehicle_model_id = ?',
        submodel.downcase, model.id
      ).first_or_initialize(name: submodel, vehicle_model: model)
    end
  end

  def initialize_year(year)
    VehicleYear.where(year: year).first_or_initialize
  end

  def initialize_vehicle(year, submodel)
    Vehicle.where(vehicle_year: year, vehicle_submodel: submodel)
           .first_or_initialize
  end
end
