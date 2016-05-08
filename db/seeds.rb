#----------------------------#
#Lets build those users!
janik = User.new(username: 'Janik', email: 'janik.knittle@gmail.com', password: 'password', password_confirmation: 'password', role: 'admin')
janik.skip_confirmation!
janik.confirmed_at = DateTime.now
janik.save

advrider = User.new(username: 'ADVrider', email: 'jknittle613@hotmail.com', password: 'password', password_confirmation: 'password')
advrider.skip_confirmation!
advrider.confirmed_at = DateTime.now
advrider.save

echo_94 = User.new(username: 'echo_94', email: 'freecomputervirus@gmail.com', password: 'password', password_confirmation: 'password')
echo_94.skip_confirmation!
echo_94.confirmed_at = DateTime.now
echo_94.save

sensei = User.new(username: 'Sensei', email: 'contact@theparts.ninja', password: 'sensei', password_confirmation: 'sensei')
sensei.skip_confirmation!
sensei.confirmed_at = DateTime.now
sensei.save

30.times do |n|
  username  = Faker::Internet.user_name(5)
  email = Faker::Internet.free_email
  password = "password"
  user = User.new(username:  username,
               email: email,
               password:              password,
               password_confirmation: password)
  user.skip_confirmation!
  user.save!
end

users = User.all

users.each do |u|
  u.profile.location = Faker::Address.city
  u.profile.bio = Faker::Lorem.paragraph(2)
  u.profile.save
end

#----------------------------#
#Build those brands

brands = ["Acerbis", "Hinson", "Tusk Racing", "ARC", "Barnett", "Yamaha", "Kawasaki", "KTM", "Beta", "FORD", "Chevrolet", "Husqvarna", "Honda"]
brands.each do |name|
  Brand.create(name: name)
end

#----------------------------#
#Categories

categories = ["Bearings", "Body", "Brakes", "Cooling Systems", "Drive", "Electrical", "Engine", "Exhaust", "Filters", "Fuel System", "Air Intake System", "Controls", "Suspension", "Wheels"]
categories.each do |name|
  Category.create(name: name)
end

bearings_sub = ["Crankshaft Bearings", "Shock Bearings", "Shock Linkage Bearings", "Steering Stem Beerings", "Swing Arm Bearings", "Wheel Bearings"]
engine_sub = ["Clutch", "Camshafts", "Pistons", "Cluch Cover"]
wheel_sub = ["Complete Wheel Assembly", "Rims", "Hubs", "Spokes", "Wheel Spacers"]

bearing = Category.first
engine = Category.find(7)
wheel = Category.last

bearings_sub.each do |name|
  Category.create(name: name, parent_category: bearing)
end
engine_sub.each do |name|
  Category.create(name: name, parent_category: engine)
end
wheel_sub.each do |name|
  Category.create(name: name, parent_category: wheel)
end

#----------------------------#
#Part attributes

part_attributes = ["Location", "Rim Size"]
part_attributes.each do |name|
  PartAttribute.create(name: name)
end

location_variation = ["Front", "Rear"]
rim_size_variation = ["19", "21", "18"]

location = PartAttribute.first
size = PartAttribute.find(2)

location_variation.each do |name|
  PartAttribute.create(name: name, parent_attribute: location)
end
rim_size_variation.each do |name|
  PartAttribute.create(name: name, parent_attribute: size)
end

#----------------------------#
#Vehicles

yz250 = Vehicle.create model: "YZ250", year: 2006, brand_name: "Yamaha"
yz25004 = Vehicle.create model: "YZ250", year: 2004, brand_name: "Yamaha"
yz25008 = Vehicle.create model: "YZ250", year: 2008, brand_name: "Yamaha"
yz125 = Vehicle.create model: "YZ125", year: 2005, brand_name: "Yamaha"
wr450 = Vehicle.create model: "WR450", year: 2012, brand_name: "Yamaha"
wr426 = Vehicle.create model: "WR426", year: 2002, brand_name: "Yamaha"
yz250f = Vehicle.create model: "YZ250F", year: 2011, brand_name: "Yamaha"
wr250 = Vehicle.create model: "WR250", year: 2009, brand_name: "Yamaha"
rmz450 = Vehicle.create model: "RMZ450", year: 2008, brand_name: "Suzuki"
tm250 = Vehicle.create model: "250MX", year: 2011, brand_name: "TM Racing"
yz450f = Vehicle.create model: "YZ450F", year: 2006, brand_name: "Yamaha"
yz25005 = Vehicle.create model: "YZ250", year: 2005, brand_name: "Yamaha"
yz450f11 = Vehicle.create model: "YZ450F", year: 2011, brand_name: "Yamaha"

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

#----------------------------#
#Fitments
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

#----------------------------#
#Discoveries and Compatibilities

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

#----------------------------#
#Voting on compatibles

compatibles = Compatible.all
comp7 = Compatible.find(7)

users.each do |u|
  votables = compatibles.sample(4)
  votables.each do |v|
    v.upvote_by u
  end
  comp7.downvote_by u
end
