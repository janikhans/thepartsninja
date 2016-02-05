# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

sensei = User.create!(username: 'Sensei', email: 'thepartsninja@gmail.com', password: 'adminadmin', password_confirmation: 'adminadmin')
janik = User.create!(username: 'Janik', email: 'janik.knittle@gmail.com', password: 'password', password_confirmation: 'password', role: 'admin')
tommy = User.create!(username: 'Tommy', email: 'tommy@gmail.com', password: 'password', password_confirmation: 'password', role: 'user')

30.times do |n|
  username  = Faker::Internet.user_name(5)
  email = Faker::Internet.free_email
  password = "password"
  User.create!(username:  username,
               email: email,
               password:              password,
               password_confirmation: password)
end

user1 = User.first

brands = ["Acerbis", "Hinson", "Tusk Racing", "ARC", "Barnett", "Yamaha", "Kawasaki", "KTM", "Beta", "FORD", "Chevrolet", "Husqvarna", "N/A"]

brands.each do |name| 
  Brand.create(name: name)
end


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

front_wheel = Product.create name: "Front Wheel", description: "Complete front wheel assembly. Includes the hubs, spokes and bearings", brand_name: "Yamaha"
rekluse = Product.create name: "Core3.0", description: "Autoclutch that nearly gets rid of all possibility of stalling", brand_name: "Rekluse"
chain_guide = Product.create name: "Chain Guide v1.0", description: "Plastic 2 part chain guide block that replaces the stock unit", brand_name: "Acerbis"

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

dis1 = Discovery.create modifications: true, comment: "You'll need the 2008 Wheel Spacers", user: user1
compat1 = dis1.compatibles.build(part: part3, compatible_part: part2, backwards: false).save
dis2 = Discovery.create modifications: false, comment: "Quick swap across", user: user1
compat2 = dis2.compatibles.build(part: part1, compatible_part: part4, backwards: true).save
dis3 = Discovery.create modifications: true, comment: "You'll need the 2011 Wheel Spacers", user: user1
compat3 = dis3.compatibles.build(part: part7, compatible_part: part6, backwards: false).save
dis4 = Discovery.create modifications: false, comment: "Stuff and more stuff", user: user1
compat4 = dis4.compatibles.build(part: part8, compatible_part: part4, backwards: true).save
dis5 = Discovery.create modifications: false, comment: "Blahhh!!!!", user: user1
compat5 = dis5.compatibles.build(part: part5, compatible_part: part6, backwards: true).save
dis6 = Discovery.create modifications: false, comment: "Easy Peasy", user: user1
compat6 = dis6.compatibles.build(part: part8, compatible_part: part1, backwards: true).save
dis7 = Discovery.create modifications: true, comment: "This doesn't work backwards", user: user1
compat7 = dis7.compatibles.build(part: part2, compatible_part: part9, backwards: false).save
dis8 = Discovery.create modifications: true, comment: "This should be a backwards fit", user: user1
compat8 = dis8.compatibles.build(part: part4, compatible_part: part7, backwards: true).save
dis9 = Discovery.create modifications: false, comment: "This is a third level test", user: user1
compat9 = dis9.compatibles.build(part: part6, compatible_part: part7, backwards: true).save
dis10 = Discovery.create modifications: false, comment: "This is another third level test", user: user1
compat10 = dis10.compatibles.build(part: part3, compatible_part: part1, backwards: true).save


users = User.all
compatibles = Compatible.all
comp7 = Compatible.find(7)

users.each do |u|
  votables = compatibles.sample(4)
  votables.each do |v|
    v.upvote_by u
  end
  comp7.downvote_by u
end




