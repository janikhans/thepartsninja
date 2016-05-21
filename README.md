# The Parts Ninja

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

    bundle install                      # Are you surprised?

A few things to note...

    Running postgresql                  # Make sure you have PostGres installed and running locally
    Email port: http://127.0.0.1:1080   # Originally setup with Mailcatcher locally, choose your own poison

**Shimmy!!**

## Moar Setup
### Rolling deep in the data

To get yo'self rolling in the data, contact Janik for the latest dumpfile. Make sure you save this .dumpfile in the app root directory. From there...

    rake db:drop
    rake db:create
    pg_restore --verbose --clean --no-acl --no-owner -d ninja_development DUMPFILE # Make sure to substitute DUMPFILE with the correct file name.
    rake db:migrate

### Export local DB

  pg_dump -Fc --no-acl --no-owner ninja_development > local.dump

## Create an Admin User *'cause you're cool like that*

Admin users are (for the time being), users with an additional column 'admin'
column attribute. You will have to create a new user in the database to access
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

If you need to get a hold of Janik, please email janik.knittle@gmail.com. But realistically if
you're looking at this, you're probably a special person anyways and should either ask or
have Janik's phone number anyways.

# Go 'git r' dun!
