class EbayVehicleImporter < CSVParty
  column :epid, header: 'ePID', as: :integer
  column :vehicle_brand, header: 'Make', as: :pretty_string
  column :vehicle_model, header: 'Model', as: :pretty_string
  column :model_submodel, header: 'Model_Submodel'
  column :vehicle_submodel, header: 'Submodel', as: :pretty_string
  column :vehicle_year, header: 'Year', as: :integer
  column :kbb_model, header: 'KBB_MODEL'
  column :vehicle_type, header: 'Vehicle Type', as: :pretty_string
  column :vehicle_type_num, header: 'Vehicle Type Num'

  import do |row|
    next if Vehicle.find_by(epid: row.epid)

    begin
      ActiveRecord::Base.transaction do
        brand = initialize_brand(row.vehicle_brand)
        brand.save!

        type = initialize_vehicle_type(row.vehicle_type)

        model = initialize_model(brand, type, row.vehicle_model)
        model.save!

        submodel = initialize_submodel(model, row.vehicle_submodel)
        submodel.save!

        year = initialize_year(row.vehicle_year)
        year.save!

        vehicle = initialize_vehicle(year, submodel)
        vehicle.epid = row.epid
        vehicle.save!
      end
    rescue ActiveRecord::RecordInvalid, NoMethodError => e
      EbayVehicleImportError.create(row: row.csv_string,
                                    import_errors: e.message)
    end
  end

  def self.initialize_vehicle_type(vehicle_type)
    VehicleType.where('lower(name) = ?', vehicle_type.downcase).first
  end

  def self.initialize_brand(brand)
    Brand.where('lower(name) = ?', brand.downcase)
         .first_or_initialize(name: brand)
  end

  def self.initialize_model(brand, vehicle_type, model)
    VehicleModel.where(
      'lower(name) = ? AND vehicle_type_id = ? AND brand_id = ?',
      model.downcase, vehicle_type.id, brand.id
    ).first_or_initialize(name: model,
                          vehicle_type: vehicle_type,
                          brand: brand)
  end

  def self.initialize_submodel(model, submodel)
    if submodel == '--'
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

  def self.initialize_year(year)
    VehicleYear.where(year: year).first_or_initialize
  end

  def self.initialize_vehicle(year, submodel)
    Vehicle.where(vehicle_year: year, vehicle_submodel: submodel)
           .first_or_initialize
  end

  def pretty_string_parser(value)
    return if value.blank?
    value = value.strip
    value[0].upcase + value[1..-1]
  end
end
