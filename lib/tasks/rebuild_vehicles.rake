namespace :rebuild_vehicles do
  desc "Seeds updated vehicles"
  task :reset_vehicles => :environment do

    Vehicle.delete_all
    VehicleSubmodel.delete_all
    VehicleModel.delete_all
    VehicleYear.delete_all
    VehicleType.delete_all

    VehicleType.connection.execute('ALTER SEQUENCE vehicle_types_id_seq RESTART WITH 1')
    VehicleModel.connection.execute('ALTER SEQUENCE vehicle_models_id_seq RESTART WITH 1')
    VehicleSubmodel.connection.execute('ALTER SEQUENCE vehicle_submodels_id_seq RESTART WITH 1')
    VehicleYear.connection.execute('ALTER SEQUENCE vehicle_years_id_seq RESTART WITH 1')
    Vehicle.connection.execute('ALTER SEQUENCE vehicles_id_seq RESTART WITH 1')

    types = ["Motorcycle", "ATV/UTV", "Snowmobile", "Scooter", "Personal Watercraft", "Car", "Truck"]
    types.each do |name|
      VehicleType.create(name: name)
    end

    years = (1900..Date.today.year+1).to_a
    years.each do |year|
      VehicleYear.create(year: year)
    end

    yz250 = VehicleForm.new(model: "YZ250", year: 2006, brand: "Yamaha", type: "Motorcycle").save
    yz25004 = VehicleForm.new(model: "YZ250", year: 2004, brand: "Yamaha", type: "Motorcycle").save
    yz25008 = VehicleForm.new(model: "YZ250", year: 2008, brand: "Yamaha", type: "Motorcycle").save
    yz125 = VehicleForm.new(model: "YZ125", year: 2005, brand: "Yamaha", type: "Motorcycle").save
    wr450 = VehicleForm.new(model: "WR450", year: 2012, brand: "Yamaha", type: "Motorcycle").save
    wr426 = VehicleForm.new(model: "WR426", year: 2002, brand: "Yamaha", type: "Motorcycle").save
    yz250f = VehicleForm.new(model: "YZ250F", year: 2011, brand: "Yamaha", type: "Motorcycle").save
    wr250 = VehicleForm.new(model: "WR250", year: 2009, brand: "Yamaha", type: "Motorcycle").save
    rmz450 = VehicleForm.new(model: "RMZ450", year: 2008, brand: "Suzuki", type: "Motorcycle").save
    tm250 = VehicleForm.new(model: "250MX", year: 2011, brand: "TM Racing", type: "Motorcycle").save
    yz450f = VehicleForm.new(model: "YZ450F", year: 2006, brand: "Yamaha", type: "Motorcycle").save
    yz25005 = VehicleForm.new(model: "YZ250", year: 2005, brand: "Yamaha", type: "Motorcycle").save
    yz450f11 = VehicleForm.new(model: "YZ450F", year: 2011, brand: "Yamaha", type: "Motorcycle").save
    f150 = VehicleForm.new(model: "F150", year: 1994, brand: "ford", submodel: "lariat", type: "Truck").save
    silverado = VehicleForm.new(model: "2500", year: 2000, brand: "chevroLET", submodel: "King Ranch", type: "Truck").save

  end
end
