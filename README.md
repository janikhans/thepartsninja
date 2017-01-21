ne# The Parts Ninja

![alt tag](https://raw.githubusercontent.com/janikhans/thepartsninja/master/app/assets/images/ThePartsNinjaDark.png?token=APaPoMBWgJJwwZd84rj1ictpW17PH_CUks5XSSw3wA%3D%3D)

The Parts Ninja is totally built using [Ruby on Rails](http://rubyonrails.org/)
and can be accessed at [http://www.theparts.ninja](http://www.theparts.ninja) or
[http://www.thepartsninja.com](http://www.thepartsninja.com) for those who don't
appreciate cool/fun/ridiculous TLDs.

## About

The Parts Ninja is a web based app that aims to make finding compatible parts for
vehicles easier. Many parts can be used in place of the OEM part with either no
modifications or slight modifications. Many times, these non-OEM parts are cheaper
and more easily accessed than the OEM. Mostly crowd sourced information but by using
the 'Compatibility Web', the Parts Ninja can discover new parts that have a high
probability of fitting.

## Git up 'n running!

Clone this repo to your local machine:

    git clone https://github.com/janikhans/thepartsninja.git

Once you have cloned a copy of the ninja repo, do your typical...

    bundle install                      # Shocker, right?

A few things to note...

    Running postgresql                  # Make sure you have PostGresql installed and running locally
    Email port: http://127.0.0.1:1080   # Originally setup with Mailcatcher locally

**Shimmy!!**

## Postgres DB
The main database for the Ninja is Postgres. You will need this to do anything within the app.
### PG Setup

To get yo'self the data, contact Janik for the latest dumpfile. Make sure you save this .dumpfile in the app root directory. From there...

    rake db:drop
    rake db:create
    pg_restore --verbose --clean --no-acl --no-owner -d ninja_development DUMPFILE # Make sure to substitute DUMPFILE with the correct file name.
    rake db:migrate

#### Export local PG DB

    pg_dump -Fc --no-acl --no-owner ninja_development > local.dump

## Neo4j
Neo4j is used for the recommendation/compatibility engine. Neo4j is a NoSQL graph database.
The current Neo4j setup is very simple consisting of Nodes: Vehicle and Part connected with a Fitment relationship.
This app also uses the neo4j.rb gem to mimic ActiveRecord ORM to communicate with the neo4j database.
For neo4j.rb information http://neo4jrb.readthedocs.io/en/7.2.x/
For the Cyhper cheatsheet, go here https://neo4j.com/docs/cypher-refcard/current/

### Setting up Neo4j
Make sure the following are installed and/or running

    Java 8

Neo4j will be installed within the root directory if installed this way. If you need to install it in a different location, following the Neo4j setup instructions.

    Install server - rake neo4j:install[community-latest,development]
    Start server - rake neo4j:start[development]
    Migrate neo4j migrations - rake neo4j:migrate
    Neo4j admin panel - http://localhost:7474/browser/

#### Neo4j CSV exports from PG

  \copy (Select * From table) To 'db/neo4j/development/import/table.csv' With CSV header

#### Neo4j imports

Make sure the neo4j server is running and then run the following.

    // Parts
    USING PERIODIC COMMIT 1000
    LOAD CSV WITH HEADERS FROM "file:///parts_with_category_id.csv" AS csvLine
    CREATE (part:NeoPart { part_id: toInteger(csvLine.id), note: csvLine.note, category_id: toInteger(csvLine.category_id)} )

    // Vehicles
    USING PERIODIC COMMIT 1000
    LOAD CSV WITH HEADERS FROM "file:///vehicles.csv" AS csvLine
    CREATE (vehicle:NeoVehicle { vehicle_id: toInteger(csvLine.id)})

    // FITMENTS
    USING PERIODIC COMMIT 10000
    LOAD CSV WITH HEADERS FROM "file:///fitments.csv" AS csvLine
    MATCH (part:NeoPart { part_id: toInteger(csvLine.part_id)})
    MATCH (vehicle:NeoVehicle { vehicle_id: toInteger(csvLine.vehicle_id)})
    CREATE (part)-[:FITS {fitment_id: toInteger(csvLine.id), note: csvLine.note, source: csvLine.source}]->(vehicle)

#### Neo4j rebuild

    rake neo4j:stop[development]
    delete db/neo4j/development/data/databases/graph.db
    rake neo4j:start[development]
    rake neo4j:migrate
    rake neo4j:build_ninja_db

## Create an Admin User *'cause you're cool like that*

Admin users are (for the time being), users with an additional attribute 'admin'
in the role column. You will have to create a new user in the database to access
every aspect of the site. One admin user will get you into everything. To create
a temporary user in the database, run these commands within the rails console.

    u = User.new
    u.email = "YOUREMAIL"
    u.username = "USERNAME"                 # There aren't too many restrictions here, have some fun Francis!
    u.password = "YOURPASSWORD"             # "password" is an acceptable choice - We'll probably want to change the rules later...
    u.password_confirmation = "YOURPASSWORD"
    u.role = "admin"                        # Create a normal user by either leaving this field blank or calling "user"
    u.skip_confirmation!                    # Every user has to accept a confirmation email, keep this in mind if you're creating users.
    u.confirmed_at = DateTime.now           
    u.save # This will persist the changes on the database.

## Special Notes / methods

    *test methods*
    sign_in(user)                   # Signs in a user as through the form (such as a user would do)
    login_as(user, scope: :user)    # Signs in a user through warden/devise, skipping the login page
    sign_out                        # Uses destroy_user_session_path to sign_out and gets redirected
    logout(:user)                   # Logs out via warden/devise and does not trigger the redirect

## The Basic Layout

*It's currently very simple... there's a user side and an admin dashboard.*

### The Public Side

This is the general public facing side where the users (aka almost everyone
*but you!*) will be hanging out. Currently they are limited to certain pages
within the app but those restrictions will be lifted as time goes on.

#### Currently Available Pages

* Home/index
* Privacy Policy
* Terms and Conditions
* Login
* Coming soon lead funnel

#### Next Up

* Blog
* Contact
* About
* Dashboard
* Search

### The Admin Area

The admin area is located at [/admin](https://www.theparts.nina/admin). This is
where an admin has access to everything that is happening in the app. *What else
do you think happens in there?* An admin has access to every section of the site,
in the future we'll include other access levels.

## Future Goals

This is obviously a basic MVP right now. There are quite a few plans in the works
but this is the basic timeline...

* Finish the Discovery form
* Integrate eBay API and/or find another API source for parts
* Marketplace
* Clean up compatibility algorithm - Use SQL queries as much as possible
* ...

## Contact

If you need to get a hold of Janik, please email janik.knittle@gmail.com. But
realistically if you're looking at this, you're probably someone special and
should have Janik's phone number anyways.

# Go 'git r' dun!
