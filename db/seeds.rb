# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

janik = User.create! :username => 'Janik', :email => 'janik.knittle@gmail.com', :password => 'password', :password_confirmation => 'password'

brands = ["Acerbis", "Hinson", "Tusk Racing", "ARC", "Barnett", "Yamaha", "Kawasaki", "KTM", "Beta", "FORD", "Chevrolet", "Husqvarna"]

brands.each do |name| 
  Brand.create(name: name)
end