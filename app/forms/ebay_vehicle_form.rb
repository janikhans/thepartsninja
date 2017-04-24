class EbayVehicleForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :vehicle_brand, :vehicle_model, :vehicle_submodel,
    :vehicle_year, :vehicle_type, :epid

  validates :vehicle_brand,
    length: { maximum: 75 },
    presence: true

  validates :vehicle_model,
    length: { maximum: 75 },
    presence: true

  validates :vehicle_year,
    presence: true,
    numericality: { only_integer: true },
    inclusion: { in: 1900..Date.current.year + 1,
                 message: "needs to be between 1900-#{Date.current.year + 1}" }

  validates :vehicle_type,
    presence: true,
    inclusion: { in: ['Motorcycle', 'ATV/UTV', 'Snowmobile', 'Scooter', 'Car',
                      'Personal Watercraft', 'Truck', 'Golf Cart'] }

  validates :epid, presence: true

  def save_or_update
    return false unless valid?
    ActiveRecord::Base.transaction do
      type = VehicleType.where('lower(name) = ?', vehicle_type.downcase).first
      brand = Brand.where('lower(name) = ?', vehicle_brand.downcase)
                   .first_or_create!(name: vehicle_brand)
      model = brand.vehicle_models
                   .where('lower(name) = ? AND vehicle_type_id = ?',
                     vehicle_model.downcase, type.id)
                   .first_or_create!(name: vehicle_model, vehicle_type: type)
      submodel = find_or_create_submodel(model)
      year = VehicleYear.where(year: vehicle_year).first_or_create!
      vehicle = submodel.vehicles.where(vehicle_year: year).first_or_initialize
      vehicle.epid = epid
      vehicle.save!
    end
    true
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  private

  def find_or_create_submodel(model)
    if vehicle_submodel == '--'
      model.vehicle_submodels.where(name: nil)
           .first_or_create!
    else
      model.vehicle_submodels.where(name: vehicle_submodel)
           .first_or_create!(name: vehicle_submodel)
    end
  end
end
