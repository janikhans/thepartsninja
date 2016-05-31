namespace :seed_discoveries do
  desc "Seeds discoveries and all compatibilities"
  task :reset_discoveries => :environment do
    Discovery.delete_all
    Compatible.delete_all
    ActsAsVotable::Vote.delete_all

    Discovery.connection.execute('ALTER SEQUENCE discoveries_id_seq RESTART WITH 1')
    Compatible.connection.execute('ALTER SEQUENCE compatibles_id_seq RESTART WITH 1')
    ActsAsVotable::Vote.connection.execute('ALTER SEQUENCE votes_id_seq RESTART WITH 1')

    janik = User.where(username: 'Janik').first
    advrider = User.where(username: 'ADVrider').first
    echo_94 = User.where(username: 'echo_94').first

    part1 = Part.first
    part2 = Part.find_by(id: 2)
    part3 = Part.find_by(id: 3)
    part4 = Part.find_by(id: 4)
    part5 = Part.find_by(id: 5)
    part6 = Part.find_by(id: 6)
    part7 = Part.find_by(id: 7)
    part8 = Part.find_by(id: 8)
    part9 = Part.find_by(id: 9)

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
