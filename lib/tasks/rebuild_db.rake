namespace :rebuild_db do
  desc "Seeds discoveries and all compatibilities"
  task :god_mode => :environment do

    Fitment.delete_all
    Vehicle.delete_all
    VehicleSubmodel.delete_all
    VehicleModel.delete_all
    VehicleYear.delete_all
    VehicleType.delete_all
    Discovery.delete_all
    Compatible.delete_all
    Product.delete_all
    ActsAsVotable::Vote.delete_all

    VehicleType.connection.execute('ALTER SEQUENCE vehicle_types_id_seq RESTART WITH 1')
    VehicleModel.connection.execute('ALTER SEQUENCE vehicle_models_id_seq RESTART WITH 1')
    VehicleSubmodel.connection.execute('ALTER SEQUENCE vehicle_submodels_id_seq RESTART WITH 1')
    VehicleYear.connection.execute('ALTER SEQUENCE vehicle_years_id_seq RESTART WITH 1')
    Vehicle.connection.execute('ALTER SEQUENCE vehicles_id_seq RESTART WITH 1')
    Discovery.connection.execute('ALTER SEQUENCE discoveries_id_seq RESTART WITH 1')
    Compatible.connection.execute('ALTER SEQUENCE compatibles_id_seq RESTART WITH 1')
    ActsAsVotable::Vote.connection.execute('ALTER SEQUENCE votes_id_seq RESTART WITH 1')
    Product.connection.execute('ALTER SEQUENCE products_id_seq RESTART WITH 1')
    Fitment.connection.execute('ALTER SEQUENCE fitments_id_seq RESTART WITH 1')

    janik = User.where(username: 'Janik').first
    advrider = User.where(username: 'ADVrider').first
    echo_94 = User.where(username: 'echo_94').first

    types = ["Motorcycle", "ATV/UTV", "Snowmobile", "Scooter", "Personal Watercraft", "Car", "Truck"]
    types.each do |name|
      VehicleType.create(name: name)
    end

    years = (1900..Date.today.year+1).to_a
    years.each do |year|
      VehicleYear.create(year: year)
    end

    #----------------------------#
    #Parts

    front_wheel = Product.create name: "OEM Wheel Kit", description: "Complete front wheel assembly. Includes the hubs, spokes and bearings", brand_name: "Yamaha", category_name: "Complete Wheel Assembly"
    rekluse = Product.create name: "Core3.0", description: "Autoclutch that nearly gets rid of all possibility of stalling", brand_name: "Rekluse", category_name: "Clutch"
    chain_guide = Product.create name: "Chain Guide v1.0", description: "Plastic 2 part chain guide block that replaces the stock unit", brand_name: "Acerbis", category_name: "Body"

    part1 = front_wheel.parts.build(part_number: "fwyz25006").save
    part2 = front_wheel.parts.build(part_number: "fwyz25004").save
    part3 = front_wheel.parts.build(part_number: "fwyz25008").save
    part4 = front_wheel.parts.build(part_number: "fwyz12505").save
    part5 = front_wheel.parts.build(part_number: "fwwr45012").save
    part6 = front_wheel.parts.build(part_number: "fwwr42602").save
    part7 = front_wheel.parts.build(part_number: "fwyz250F11").save
    part8 = front_wheel.parts.build(part_number: "fwwr25009").save
    part9 = chain_guide.parts.build(part_number: "217909", note: "Specific part numbers are Black: 2179090001 White: 2179090002 Yellow: 2179090005").save

    part1 = Part.first
    part2 = Part.find_by(id: 2)
    part3 = Part.find_by(id: 3)
    part4 = Part.find_by(id: 4)
    part5 = Part.find_by(id: 5)
    part6 = Part.find_by(id: 6)
    part7 = Part.find_by(id: 7)
    part8 = Part.find_by(id: 8)
    part9 = Part.find_by(id: 9)

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

    part1 = Part.first
    part2 = Part.find_by(id: 2)
    part3 = Part.find_by(id: 3)
    part4 = Part.find_by(id: 4)
    part5 = Part.find_by(id: 5)
    part6 = Part.find_by(id: 6)
    part7 = Part.find_by(id: 7)
    part8 = Part.find_by(id: 8)
    part9 = Part.find_by(id: 9)

    fitment1 = part1.fitments.build(vehicle: yz250).save
    fitment2 = part2.fitments.build(vehicle: yz25004).save
    fitment3 = part3.fitments.build(vehicle: yz25008).save
    fitment4 = part4.fitments.build(vehicle: yz125).save
    fitment5 = part5.fitments.build(vehicle: wr450).save
    fitment6 = part6.fitments.build(vehicle: wr426).save
    fitment7 = part7.fitments.build(vehicle: yz250f).save
    fitment8 = part8.fitments.build(vehicle: wr250).save
    fitment9 = part9.fitments.build(vehicle: rmz450).save
    fitment10 = part1.fitments.build(vehicle: yz450f).save
    fitment11 = part4.fitments.build(vehicle: yz25005).save
    fitment12 = part7.fitments.build(vehicle: yz450f11).save

    dis1 = Discovery.create modifications: true, comment: "You'll need the 2008 Wheel Spacers", user: advrider
    compat1 = dis1.compatibles.build(part: part3, compatible_part: part2, backwards: false).save
    dis2 = Discovery.create modifications: false, comment: "Quick swap across", user: janik
    compat2 = dis2.compatibles.build(part: part1, compatible_part: part4, backwards: true).save
    dis3 = Discovery.create modifications: true, comment: "You'll need the 2011 Wheel Spacers", user: janik
    compat3 = dis3.compatibles.build(part: part7, compatible_part: part6, backwards: false).save
    dis4 = Discovery.create modifications: false, comment: "Stuff and more stuff", user: echo_94
    compat4 = dis4.compatibles.build(part: part8, compatible_part: part4, backwards: true).save
    dis5 = Discovery.create modifications: false, comment: "Blahhh!!!!", user: janik
    compat5 = dis5.compatibles.build(part: part5, compatible_part: part6, backwards: true).save
    dis6 = Discovery.create modifications: false, comment: "Easy Peasy", user: advrider
    compat6 = dis6.compatibles.build(part: part8, compatible_part: part1, backwards: true).save
    dis7 = Discovery.create modifications: true, comment: "This doesn't work backwards", user: advrider
    compat7 = dis7.compatibles.build(part: part2, compatible_part: part9, backwards: false).save
    dis8 = Discovery.create modifications: true, comment: "This should be a backwards fit", user: janik
    compat8 = dis8.compatibles.build(part: part4, compatible_part: part7, backwards: true).save
    dis9 = Discovery.create modifications: false, comment: "This is a third level test", user: advrider
    compat9 = dis9.compatibles.build(part: part6, compatible_part: part7, backwards: true).save
    dis10 = Discovery.create modifications: false, comment: "This is another third level test", user: echo_94
    compat10 = dis10.compatibles.build(part: part3, compatible_part: part1, backwards: true).save

    backwards_compats = Compatible.where(backwards: true)
    backwards_compats.each do |c|
      c.make_backwards_compatible
    end

    #----------------------------#
    #Voting on compatibles

    compatibles = Compatible.all
    users = User.all
    badcompat = Compatible.where(part: part2, compatible_part: part9).first

    users.each do |u|
      votables = compatibles.sample(4)
      votables.each do |v|
        v.upvote_by u
      end
      badcompat.downvote_by u
    end

  end
end
