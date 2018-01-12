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

30.times do
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

brands = ["Acerbis", "Hinson", "Tusk Racing", "ARC", "Barnett", "Yamaha", "Kawasaki", "KTM", "Beta", "FORD", "Chevrolet", "Husqvarna", "Honda", "Rekluse"]
brands.each do |name|
  Brand.create(name: name)
end

#----------------------------#
#Build those Vehicle Types

types = ["Motorcycle", "ATV/UTV", "Snowmobile", "Scooter", "Car", "Personal Watercraft", "Truck", "Golf Cart"]
types.each do |name|
  VehicleType.create(name: name)
end

#----------------------------#
# Build the VehicleYears

years = (1900..Date.today.year+1).to_a
years.each do |year|
  VehicleYear.create(year: year)
end

#----------------------------#
#Categories

Category.create(
  [
    { name: 'Motorcycle' },
    { name: 'ATV' }
  ]
)

root_motorcycle = Category.find_by(name: 'Motorcycle')

categories = ["Bearings", "Body", "Brakes", "Cooling Systems", "Drive", "Electrical", "Engine", "Exhaust", "Filters", "Fuel System", "Air Intake System", "Controls", "Suspension", "Wheels"]
categories.each do |name|
  root_motorcycle.children.create(name: name)
end

bearings_sub = ["Crankshaft Bearings", "Shock Bearings", "Shock Linkage Bearings", "Steering Stem Beerings", "Swing Arm Bearings", "Wheel Bearings"]
engine_sub = ["Clutch", "Camshafts", "Pistons", "Cluch Cover"]
wheel_sub = ["Complete Wheel", "Rims", "Hubs", "Spokes", "Wheel Spacers"]

bearing = Category.find_by(name: 'Bearings')
engine = Category.find_by(name: 'Engine')
wheel = Category.find_by(name: 'Wheels')

bearings_sub.each do |name|
  bearing.children.create(name: name, searchable: true)
end
engine_sub.each do |name|
  engine.children.create(name: name, searchable: true)
end
wheel_sub.each do |name|
  wheel.children.create(name: name, searchable: true)
end

Category.refresh_leaves

#----------------------------#
#Part attributes

part_attributes = ["Color", "Rim Size"]
part_attributes.each do |name|
  PartAttribute.create(name: name)
end

color_variation = ["Black", "Silver"]
rim_size_variation = ["19", "21", "18"]

color = PartAttribute.find_by(name: 'Color')
size = PartAttribute.find_by(name: 'Rim Size')

color_variation.each do |name|
  PartAttribute.create(name: name, parent_attribute: color)
end
rim_size_variation.each do |name|
  PartAttribute.create(name: name, parent_attribute: size)
end

#----------------------------#
#Vehicles

yz250 = VehicleForm.new(vehicle_model: "YZ250", vehicle_year: 2006, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
yz25004 = VehicleForm.new(vehicle_model: "YZ250", vehicle_year: 2004, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
yz25008 = VehicleForm.new(vehicle_model: "YZ250", vehicle_year: 2008, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
yz125 = VehicleForm.new(vehicle_model: "YZ125", vehicle_year: 2005, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
wr450 = VehicleForm.new(vehicle_model: "WR450", vehicle_year: 2012, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
wr426 = VehicleForm.new(vehicle_model: "WR426", vehicle_year: 2002, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
yz250f = VehicleForm.new(vehicle_model: "YZ250F", vehicle_year: 2011, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
wr250 = VehicleForm.new(vehicle_model: "WR250", vehicle_year: 2009, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
rmz450 = VehicleForm.new(vehicle_model: "RMZ450", vehicle_year: 2008, vehicle_brand: "Suzuki", vehicle_type: "Motorcycle").find_or_create
tm250 = VehicleForm.new(vehicle_model: "250MX", vehicle_year: 2011, vehicle_brand: "TM Racing", vehicle_type: "Motorcycle").find_or_create
yz450f = VehicleForm.new(vehicle_model: "YZ450F", vehicle_year: 2006, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
yz25005 = VehicleForm.new(vehicle_model: "YZ250", vehicle_year: 2005, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
yz450f11 = VehicleForm.new(vehicle_model: "YZ450F", vehicle_year: 2011, vehicle_brand: "Yamaha", vehicle_type: "Motorcycle").find_or_create
f150 = VehicleForm.new(vehicle_model: "F150", vehicle_year: 1994, vehicle_brand: "ford", vehicle_submodel: "lariat", vehicle_type: "Truck").find_or_create
silverado = VehicleForm.new(vehicle_model: "2500", vehicle_year: 2000, vehicle_brand: "chevroLET", vehicle_submodel: "King Ranch", vehicle_type: "Truck").find_or_create

#----------------------------#
#Parts

front_wheel = Product.create name: "OEM Wheel Kit", description: "Complete front wheel assembly. Includes the hubs, spokes and bearings", brand: Brand.find_by(name: "Yamaha"), category: Category.find_by(name: "Complete Wheel")
rekluse = Product.create name: "Core3.0", description: "Autoclutch that nearly gets rid of all possibility of stalling", brand: Brand.find_by(name: "Rekluse"), category: Category.find_by(name: "Clutch")
chain_guide = Product.create name: "Chain Guide v1.0", description: "Plastic 2 part chain guide block that replaces the stock unit", brand: Brand.find_by(name: "Acerbis"), category: Category.find_by(name: "Body")

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
#Part Traits

parts = Part.all.sample(5)

parts.each do |part|
  PartAttribution.create(part: part, part_attribute: PartAttribute.all.sample)
end

#----------------------------#
#Fiment Notes

notes = ['Location', 'Quantity']
notes.each do |name|
  FitmentNote.create(name: name)
end

location_variations = ['Front', 'Rear']

location_variations.each do |variation|
  FitmentNote.find_by(name: 'Location').note_variations.create(name: variation, used_for_search: true)
end


quantity_variations = ['1', '2', '3']
quantity_variations.each do |variation|
  FitmentNote.find_by(name: 'Quantity').note_variations.create(name: variation, used_for_search: true)
end

front = FitmentNote.find_by(name: 'Front')

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

front_wheel.parts.each do |part|
  part.fitments.each do |fitment|
    fitment.fitment_notations.create(fitment_note: front)
  end
end

AvailableFitmentNote.refresh
Category.refresh_fitment_notables

#----------------------------#
#Discoveries and Compatibilities

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
badcompat = Compatibility.where(part: part2, compatible_part: part9).first

users.each do |u|
  votables = compatibilities.sample(4)
  votables.each do |v|
    v.upvote_by u
  end
  badcompat.downvote_by u
end

#----------------------------#
# Forum stuff
['Support', 'Features'].each do |root_topic|
  ForumTopic.create(title: root_topic)
end

5.times do
  ForumTopic.where(ancestry: nil).sample.children.create(title: Faker::Hipster.sentence(3, true), icon: 'bug')
end

10.times do
  ForumThread.create(
    user: User.all.sample,
    title: Faker::Hipster.sentence(3, true),
    body: Faker::Hipster.paragraph(2),
    forum_topic: ForumTopic.all.where.not(ancestry: nil).sample
  )
end

25.times do
  ForumPost.create(
    forum_thread: ForumThread.all.sample,
    user: User.all.sample,
    body: Faker::Hipster.paragraph(1)
  )
end
