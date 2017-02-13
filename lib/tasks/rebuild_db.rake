namespace :rebuild_db do
  desc "Rebuilds database for test purposes"
  task :god_mode => :environment do

    FitmentNotation.delete_all
    FitmentNote.delete_all
    Fitment.delete_all
    Vehicle.delete_all
    VehicleSubmodel.delete_all
    VehicleModel.delete_all
    VehicleYear.delete_all
    VehicleType.delete_all
    Discovery.delete_all
    Compatibility.delete_all
    Product.delete_all
    Category.delete_all
    EbayCategory.delete_all
    Part.delete_all
    PartAttribute.delete_all
    PartAttribution.delete_all
    ActsAsVotable::Vote.delete_all
    Brand.delete_all

    Brand.connection.execute('ALTER SEQUENCE brands_id_seq RESTART WITH 1')
    VehicleType.connection.execute('ALTER SEQUENCE vehicle_types_id_seq RESTART WITH 1')
    VehicleModel.connection.execute('ALTER SEQUENCE vehicle_models_id_seq RESTART WITH 1')
    VehicleSubmodel.connection.execute('ALTER SEQUENCE vehicle_submodels_id_seq RESTART WITH 1')
    VehicleYear.connection.execute('ALTER SEQUENCE vehicle_years_id_seq RESTART WITH 1')
    Vehicle.connection.execute('ALTER SEQUENCE vehicles_id_seq RESTART WITH 1')
    Discovery.connection.execute('ALTER SEQUENCE discoveries_id_seq RESTART WITH 1')
    Compatibility.connection.execute('ALTER SEQUENCE compatibilities_id_seq RESTART WITH 1')
    ActsAsVotable::Vote.connection.execute('ALTER SEQUENCE votes_id_seq RESTART WITH 1')
    Product.connection.execute('ALTER SEQUENCE products_id_seq RESTART WITH 1')
    Part.connection.execute('ALTER SEQUENCE parts_id_seq RESTART WITH 1')
    Fitment.connection.execute('ALTER SEQUENCE fitments_id_seq RESTART WITH 1')
    FitmentNote.connection.execute('ALTER SEQUENCE fitment_notes_id_seq RESTART WITH 1')
    FitmentNotation.connection.execute('ALTER SEQUENCE fitment_notations_id_seq RESTART WITH 1')
    Category.connection.execute('ALTER SEQUENCE categories_id_seq RESTART WITH 1')
    EbayCategory.connection.execute('ALTER SEQUENCE ebay_categories_id_seq RESTART WITH 1')
    PartAttribute.connection.execute('ALTER SEQUENCE part_attributes_id_seq RESTART WITH 1')
    PartAttribution.connection.execute('ALTER SEQUENCE part_attributions_id_seq RESTART WITH 1')

    janik = User.where(username: 'Janik').first
    advrider = User.where(username: 'ADVrider').first
    echo_94 = User.where(username: 'echo_94').first

    types = ["Motorcycle", "ATV/UTV", "Snowmobile", "Scooter", "Personal Watercraft", "Car", "Truck", "Golf Cart"]
    types.each do |name|
      VehicleType.create(name: name)
    end

    years = (1900..Date.today.year+1).to_a
    years.each do |year|
      VehicleYear.create(year: year)
    end

    #----------------------------#
    #Categories

    root_category = Category.create(name: "Motorcycle Parts")

    categories = ["Bearings", "Body", "Brakes", "Cooling Systems", "Drive", "Electrical", "Engine", "Exhaust", "Filters", "Fuel System", "Air Intake System", "Controls", "Suspension", "Wheels"]
    categories.each do |name|
      root_category.children.create(name: name)
    end


    bearings_sub = ["Crankshaft Bearings", "Shock Bearings", "Shock Linkage Bearings", "Steering Stem Beerings", "Swing Arm Bearings", "Wheel Bearings"]
    engine_sub = ["Clutch", "Camshafts", "Pistons", "Cluch Cover"]
    wheel_sub = ["Complete Wheel Assembly", "Rims", "Hubs", "Spokes", "Wheel Spacers"]

    bearing = Category.find_by(name: "Bearings")
    engine = Category.find_by(name: "Engine")
    wheel = Category.find_by(name: "Wheels")

    bearings_sub.each do |name|
      bearing.children.create(name: name)
    end
    engine_sub.each do |name|
      engine.children.create(name: name)
    end
    wheel_sub.each do |name|
      wheel.children.create(name: name)
    end

    Category.find_by(name: "Brakes").children.create(name: "Brake Pads")

    Category.refresh_leaves

    #----------------------------#
    #Part attributes

    ["Rim Size", "Color"].each do |name|
      PartAttribute.create(name: name)
    end

    color_variations = ["Black", "Red"]
    rim_size_variations = ["19", "21", "18"]

    color_variations.each do |name|
      PartAttribute.find_by(name: "Color").attribute_variations.create(name: name)
    end
    rim_size_variations.each do |name|
      PartAttribute.find_by(name: "Rim Size").attribute_variations.create(name: name)
    end

    #----------------------------#
    # Fitment Notes

    ["Location", "Quantity"].each do |name|
      FitmentNote.create(name: name)
    end

    location_variations = ["Front", "Rear"]
    quantity_variations = ["1", "2", "4"]

    location_variations.each do |name|
      FitmentNote.find_by(name: "Location").note_variations.create(name: name)
    end
    quantity_variations.each do |name|
      FitmentNote.find_by(name: "Quantity").note_variations.create(name: name)
    end

    #----------------------------#
    #Build those brands

    brands = ["Acerbis", "Hinson", "Tusk Racing", "ARC", "Barnett", "Yamaha", "Kawasaki", "KTM", "Beta", "FORD", "Chevrolet", "Husqvarna", "Honda"]
    brands.each do |name|
      Brand.create(name: name)
    end

    #----------------------------#
    # VehicleModels/ VehicleSubmodels / Vehicles

    yz250 = VehicleForm.new(model: "YZ250", year: 2006, brand: "Yamaha", type: "Motorcycle").save
    yz25004 = VehicleForm.new(model: "YZ250", year: 2004, brand: "Yamaha", type: "Motorcycle").save
    yz25008 = VehicleForm.new(model: "YZ250", year: 2008, brand: "Yamaha", type: "Motorcycle").save
    yz125 = VehicleForm.new(model: "YZ125", year: 2005, brand: "Yamaha", type: "Motorcycle").save
    yz12509 = VehicleForm.new(model: "YZ125", year: 2009, brand: "Yamaha", type: "Motorcycle").save
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

    #----------------------------#
    # Parts / Products / Fitments

    part1 = PartForm.new(brand: "Yamaha", product_name: "OEM Wheel Kit", part_number: "fwyz25006", root_category: "Motorcycle Parts", category: "Wheels", subcategory: "Complete Wheel Assembly", vehicle: yz250, attributes: [{parent_attribute: "Color", attribute: "Silver"}, {parent_attribute: "Rim Size", attribute: "21"}]).save
    part2 = PartForm.new(brand: "Yamaha", product_name: "OEM Wheel Kit", part_number: "fwyz25004", root_category: "Motorcycle Parts", category: "Wheels", subcategory: "Complete Wheel Assembly", vehicle: yz25004, attributes: [{parent_attribute: "Color", attribute: "Silver"}]).save
    part3 = PartForm.new(brand: "Yamaha", product_name: "OEM Wheel Kit", part_number: "fwyz25008", root_category: "Motorcycle Parts", category: "Wheels", subcategory: "Complete Wheel Assembly", vehicle: yz25008, attributes: [{parent_attribute: "Color", attribute: "Black"}]).save
    part4 = PartForm.new(brand: "Yamaha", product_name: "OEM Wheel Kit", part_number: "fwyz12505", root_category: "Motorcycle Parts", category: "Wheels", subcategory: "Complete Wheel Assembly", vehicle: yz125, attributes: [{parent_attribute: "Rim Size", attribute: "21"}]).save
    part5 = PartForm.new(brand: "Yamaha", product_name: "OEM Wheel Kit", part_number: "fwwr45012", root_category: "Motorcycle Parts", category: "Wheels", subcategory: "Complete Wheel Assembly", vehicle: wr450).save
    part6 = PartForm.new(brand: "Yamaha", product_name: "OEM Wheel Kit", part_number: "fwwr42602", root_category: "Motorcycle Parts", category: "Wheels", subcategory: "Complete Wheel Assembly", vehicle: wr426).save
    part7 = PartForm.new(brand: "Yamaha", product_name: "OEM Wheel Kit", part_number: "fwyz250F11", root_category: "Motorcycle Parts", category: "Wheels", subcategory: "Complete Wheel Assembly", vehicle: yz250f, attributes: [{parent_attribute: "Color", attribute: "Black"}]).save
    part8 = PartForm.new(brand: "Yamaha", product_name: "OEM Wheel Kit", part_number: "fwwr25009", root_category: "Motorcycle Parts", category: "Wheels", subcategory: "Complete Wheel Assembly", vehicle: wr250, attributes: [{parent_attribute: "Color", attribute: "Blue"}]).save
    part9 = PartForm.new(brand: "Acerbis", product_name: "Chain Guide v1.0", part_number: "217909", root_category: "Motorcycle Parts", category: "Body", subcategory: "Chain Guides", vehicle: rmz450, attributes: [{parent_attribute: "Color", attribute: "Yellow"}]).save
    part10 = PartForm.new(brand: "Tusk Racing", product_name: "Sintered Metal Brake Pad", part_number: "12345", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz250).save
    part11 = PartForm.new(brand: "Tusk Racing", product_name: "Sintered Metal Brake Pad", part_number: "12345", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz25008).save
    part12 = PartForm.new(brand: "Tusk Racing", product_name: "Sintered Metal Brake Pad", part_number: "12345", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz125).save
    part13 = PartForm.new(brand: "Tusk Racing", product_name: "Sintered Metal Brake Pad", part_number: "12345", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz25004).save
    part14 = PartForm.new(brand: "EBC", product_name: "Extreme brake pads", part_number: "56789", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz250).save
    part15 = PartForm.new(brand: "EBC", product_name: "Extreme brake pads", part_number: "56789", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz25008).save
    part16 = PartForm.new(brand: "EBC", product_name: "Extreme brake pads", part_number: "56789", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz25004).save
    part17 = PartForm.new(brand: "EBC", product_name: "Extreme brake pads", part_number: "56789", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz125).save
    part18 = PartForm.new(brand: "EBC", product_name: "Extreme brake pads", part_number: "56789", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: wr450).save
    part19 = PartForm.new(brand: "Braking", product_name: "Intimidator Organi Pads", part_number: "int-234", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz250).save
    part20 = PartForm.new(brand: "Braking", product_name: "Intimidator Organi Pads", part_number: "int-234", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz25008).save
    part21 = PartForm.new(brand: "Braking", product_name: "Intimidator Organi Pads", part_number: "int-234", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz25004).save
    part22 = PartForm.new(brand: "Braking", product_name: "Intimidator Organi Pads", part_number: "int-234", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: wr450).save
    part23 = PartForm.new(brand: "Braking", product_name: "Intimidator Organi Pads", part_number: "int-234-rear", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz250).save
    part24 = PartForm.new(brand: "Braking", product_name: "Intimidator Organi Pads", part_number: "int-234-rear", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz25008).save
    part25 = PartForm.new(brand: "Braking", product_name: "Intimidator Organi Pads", part_number: "int-234-rear", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz25004).save
    part26 = PartForm.new(brand: "Braking", product_name: "Intimidator Organi Pads", part_number: "int-234-rear", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: wr450).save
    part27 = PartForm.new(brand: "Braking", product_name: "Intimidator Organi Pads", part_number: "int-234", root_category: "Motorcycle Parts", category: "Brakes", subcategory: "Brake Pads", vehicle: yz12509).save

    #----------------------------#
    # Other

    Fitment.update_all(source: 1)
    Fitment.find_by(vehicle: yz250, part: part1).fitment_notations.create(fitment_note: FitmentNote.find_by(name: "Front"))
    Fitment.find_by(vehicle: yz250, part: part1).fitment_notations.create(fitment_note: FitmentNote.find_by(name: "1"))
    Fitment.find_by(vehicle: yz25004, part: part2).fitment_notations.create(fitment_note: FitmentNote.find_by(name: "Front"))
    Fitment.find_by(vehicle: yz25008, part: part3).fitment_notations.create(fitment_note: FitmentNote.find_by(name: "Front"))
    Fitment.find_by(vehicle: yz25004, part: part10).fitment_notations.create(fitment_note: FitmentNote.find_by(name: "Front"))
    Fitment.find_by(vehicle: yz25008, part: part11).fitment_notations.create(fitment_note: FitmentNote.find_by(name: "Front"))
    Fitment.find_by(vehicle: yz25004, part: part19).fitment_notations.create(fitment_note: FitmentNote.find_by(name: "Front"))
    Fitment.find_by(vehicle: yz25008, part: part20).fitment_notations.create(fitment_note: FitmentNote.find_by(name: "Front"))
    Fitment.find_by(vehicle: yz25008, part: part23).fitment_notations.create(fitment_note: FitmentNote.find_by(name: "Front"))
    Fitment.find_by(vehicle: yz12509, part: part27).fitment_notations.create(fitment_note: FitmentNote.find_by(name: "Front"))

    fitment10 = part1.fitments.create(vehicle: yz450f)
    fitment11 = part4.fitments.create(vehicle: yz25005)
    fitment12 = part7.fitments.create(vehicle: yz450f11)



    #----------------------------#
    #Parts

    dis1 = Discovery.create comment: "You'll need the 2008 Wheel Spacers", user: advrider
    compat1 = dis1.compatibilities.build(modifications: true, part: part3, compatible_part: part2, backwards: false).save
    dis2 = Discovery.create comment: "Quick swap across", user: janik
    compat2 = dis2.compatibilities.build(modifications: false, part: part1, compatible_part: part4, backwards: true).save
    dis3 = Discovery.create comment: "You'll need the 2011 Wheel Spacers", user: janik
    compat3 = dis3.compatibilities.build(modifications: true, part: part7, compatible_part: part6, backwards: false).save
    dis4 = Discovery.create comment: "Stuff and more stuff", user: echo_94
    compat4 = dis4.compatibilities.build(modifications: false, part: part8, compatible_part: part4, backwards: true).save
    dis5 = Discovery.create comment: "Blahhh!!!!", user: janik
    compat5 = dis5.compatibilities.build(modifications: false, part: part5, compatible_part: part6, backwards: true).save
    dis6 = Discovery.create comment: "Easy Peasy", user: advrider
    compat6 = dis6.compatibilities.build(modifications: false, part: part8, compatible_part: part1, backwards: true).save
    dis7 = Discovery.create comment: "This doesn't work backwards", user: advrider
    compat7 = dis7.compatibilities.build(modifications: true, part: part2, compatible_part: part9, backwards: false).save
    dis8 = Discovery.create comment: "This should be a backwards fit", user: janik
    compat8 = dis8.compatibilities.build(modifications: true, part: part4, compatible_part: part7, backwards: true).save
    dis9 = Discovery.create comment: "This is a third level test", user: advrider
    compat9 = dis9.compatibilities.build(modifications: false, part: part6, compatible_part: part7, backwards: true).save
    dis10 = Discovery.create comment: "This is another third level test", user: echo_94
    compat10 = dis10.compatibilities.build(modifications: false, part: part3, compatible_part: part1, backwards: true).save

    backwards_compats = Compatibility.where(backwards: true)
    backwards_compats.each do |c|
      c.make_backwards_compatible!
    end

    #----------------------------#
    #Voting on compatibilities

    compatibilities = Compatibility.all
    users = User.all
    badcompat = Compatibility.where(part: part2, compatible_part: part9).first

    users.each do |u|
      votables = compatibilities.sample(4)
      votables.each do |v|
        v.upvote_by u
      end
      badcompat.downvote_by u
    end

    puts "Finished rebuilding db"
  end
end
