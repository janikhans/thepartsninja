# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

sensei = User.create! username: 'Sensei', email: 'thepartsninja@gmail.com', password: 'adminadmin', password_confirmation: 'adminadmin'
janik = User.create! username: 'Janik', email: 'janik.knittle@gmail.com', password: 'password', password_confirmation: 'password', role: 'admin'

brands = ["Acerbis", "Hinson", "Tusk Racing", "ARC", "Barnett", "Yamaha", "Kawasaki", "KTM", "Beta", "FORD", "Chevrolet", "Husqvarna"]

brands.each do |name| 
  Brand.create(name: name)
end

yz250 = Vehicle.create model: "YZ250", year: 2006, brand_name: "Yamaha" 
yz125 = Vehicle.create model: "YZ125", year: 2005, brand_name: "Yamaha"
wr450 = Vehicle.create model: "WR450", year: 2012, brand_name: "Yamaha" 
wr426 = Vehicle.create model: "WR426", year: 2002, brand_name: "Yamaha"
yz250f = Vehicle.create model: "YZ250F", year: 2011, brand_name: "Yamaha" 
wr250 = Vehicle.create model: "WR250", year: 2009, brand_name: "Yamaha"
rmz450 = Vehicle.create model: "RMZ450", year: 2008, brand_name: "Suzuki"
tm250 = Vehicle.create model: "250MX", year: 2011, brand_name: "TM Racing"

front_wheel = Product.create name: "Front Wheel", description: "Complete front wheel assembly. Includes the hubs, spokes and bearings", brand_name: "Yamaha"
rekluse = Product.create name: "Core3.0", description: "Autoclutch that nearly gets rid of all possibility of stalling", brand_name: "Rekluse"
chain_guide = Product.create name: "Chain Guide v1.0", description: "Plastic 2 part chain guide block that replaces the stock unit", brand_name: "Acerbis"

part1 = front_wheel.parts.build(part_number: "fwyz25006").save
part2 = front_wheel.parts.build(part_number: "fwyz12505").save
part3 = front_wheel.parts.build(part_number: "fwwr25009").save
part4 = chain_guide.parts.build(part_number: "217909", note: "Specific part numbers are Black: 2179090001
White: 2179090002
Yellow: 2179090005").save

part1 = Part.first
part2 = Part.find_by(id: 2)
part3 = Part.find_by(id: 3)
part4 = Part.find_by(id: 4)
fitment1 = part1.fitments.build(vehicle: yz250).save
fitment2 = part2.fitments.build(vehicle: yz125).save
fitment3 = part3.fitments.build(vehicle: wr250).save
fitment4 = part4.fitments.build(vehicle: rmz450).save