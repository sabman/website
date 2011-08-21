# Countdown to KO #12: SpacialDB Intro

*This is the 12th in series of posts leading up [Node.js Knockout][1],
and covers using [SpacialDB] in your node app.*

[1]: http://nodeknockout.com
[SpacialDB]: http://spacialdb.com

## What is SpacialDB?

SpacialDB is a Geospatial database service that allows you to create,
operate and scale dedicated Geospatial databases in the cloud. Your
SpacialDB databases can be used transparently in place of any database
in cloud such as Amazon RDS or Rackspace Storage or Heroku PostgreSQL.

Building sophisticated location aware applications is hard! SpacialDB
makes it easy by:

  * Instantly provisioning Geospatial databases
  * Prebuilt functions to perform spatial queries and analysis
  * Wealth of knowledge and tutorials at the [SpacialDB Devcenter]
  * Easy mobile SDK integration
  * Built on Open Source PostGIS database with a vibrant community and
    support
  * Easy nodejs connectivity: Check out [this article][2]


[SpacialDB Devcenter]: http://devcenter.spacialdb.com/
[2]: http://devcenter.spacialdb.com/Node.html

With SpacialDB you just sign up and instantly load location data and
access spatial functions from your existing app.

## Learn to quickly import geospatial data and view a map

The rest of this article is to take us from sign up to a working
instance of SpacialDB. By the end we will know how to create a SpacialDB
instance and import-data to it and see it on a map. Something like:

![German Cities](http://devcenter.spacialdb.com/img/German-Cities.png)

Sign up via the website or the command-line. For command-line use the
SpacialDB Ruby Gem. If you are not familiar with Ruby or Gems (Ruby's
package manager) then you just have to make sure you have ruby
installed. Most flavours of \*nixs come installed with ruby. If you are
on windows you can get a single click installer from:
[http://ruby-lang.org](http://ruby-lang.org).

To install the command-line client just do `gem install spacialdb` in
you terminal or windows console.

For a complete reference of the Command-Line Usage check out
[this page](http://devcenter.spacialdb.com/CLI-Usage.html).

## Sign up

Via the website sign up at:
[http://beta.spacialdb.com/signup/free](http://beta.spacialdb.com/signup/free)
or use the special sign-up for NKO participants shown on the [services
page](http://nodeknockout.com/services) (login required).

Create a username and password. Username can only contain alpha-numeric
values.

CLI command:

      $ spacialdb signup

      Sign up to Spacialdb.
      Email: shoaib@spacialdb.com
      Username: shoaib
      Password:
      Password confirmation:
      Signed up successfully.

## Login

If you just signed up you are also automatically logged in. Otherwise,
to login you need your email or username and password.

Via the website login at:
[http://beta.spacialdb.com/login](http://beta.spacialdb.com/login)

CLI command:

      $ spacialdb login

      Enter your Spacialdb credentials.
      Email or Username: shoaib
      Password:
      Logged in successfully.


## Creating a Geospatial database

Awesome! Signed up, logged-in; we are ready for our first geospatial
database. If you have used PostGIS before you will have all the PostGIS
goodness you are used to, with the added bonus of accessibility from
anywhere and anytime. Not to mention some of the real-time APIs for
mobile development that will be available soon.

Via the website after login you will be redirected to your dashboard at:
[http://beta.spacialdb.com/dashboard](http://beta.spacialdb.com/dashboard).
You will see the **New Database** button here. Go ahead and click it...
and bam! you have a fresh install of a personal Geospatial database. You
will see the connection parameters here.

CLI command:

      $ spacialdb create

      {
        "host":"beta.spacialdb.com",
        "name":"spacialdb1_shoaib",
        "password":"13971abfeb",
        "port":9999,
        "username":"shoaib"
      }


## Connecting via QGIS

QGIS is big! but get it. Why? Its one of the most feature rich open
source desktop GIS packages out-there. And it will come in handy as you
work with more and more geospatial data. We would recommend the last
stable release:
[http://www.qgis.org/en/download/current-software.html](http://www.qgis.org/en/download/current-software.html).
On MacOS X you can grab standalone binaries from [http://www.kyngchaos.com/software/qgis](http://www.kyngchaos.com/software/qgis).

Install it. After installing QGIS its time to connect and import some
initial data.

## Download data

We want Shapefiles. Most prevalent geospatial data format currently
available on the web... SpacialDB envisions changing that (but more on
that later). For now lets get the following datasets which are in a Shapefile format:

* [boundary_with_populations_germany (zip)](http://dl.dropbox.com/u/1415964/6367-boundary_with_populations_germany.zip)
* [german_cities_ranked_by_population (zip)](http://dl.dropbox.com/u/1415964/21273-german_cities_ranked_by_population.zip)

## Download the PostGIS plugin

QGIS has a plugin manager. From there we get our hands on the Spit
plugin. A great little utility for importing Shapefiles straight into
PostGIS. To install Spit go to: Plugins > Manage Plugins... 

![Manage Plugins](https://img.skitch.com/20110821-d65eqj8npdwpb2t78h9kw3je5e.png)

Here you can find the plugin via the search filter and enbable it. 

![Spit](https://img.skitch.com/20110821-piswg9utcma2hw8xudj7t5wsmj.png)

Now its time to connect to your database and load up the Shapefiles.

## Upload some data

Lets fire up the plugin to connect to your new database and import the
Shapefiles we have just downloaded. Go to: Plugins > Spit > Import Shapefiles to PostgreSQL

![Import Shapefiles to PostgreSQL](https://img.skitch.com/20110821-881mk2tent8r3j2yt4bewf35xe.png)

Add a new connection and connect to the database:

![New connection](https://img.skitch.com/20110821-d8np16ftyt31qxkf7i5kxncatw.png)

Next we add the Shapefiles we downloaded for this demo to our database. Click on Add and select the unzipped files:

![Add Shpfiles for import](https://img.skitch.com/20110821-bjmc1qeug6b474xx38m7im9i9g.png)

Make sure you have picked the correct SRID (Spatial Reference ID). 
We set ours to 4326 which is what our original dataset was in and is also used by GPS.


It should slurps it right in.

## View the data.

Click **Add a PostGIS layer** button and you can connect to your new
database.

## Further Reading:

* **[Using SpacialDB with nodejs](http://devcenter.spacialdb.com/Node.html)**
* [Importing OpenStreetMap data into SpacialDB](http://devcenter.spacialdb.com/Import-OSM.html)
* [Adding navigation & routing to your applications](http://devcenter.spacialdb.com/Routing-Introduction.html)


## Data Sources:

* [cloudmade](http://downloads.cloudmade.com/)
* [geofabrik](http://www.geofabrik.de/data/shapefiles.html)
* [geocommons](http://geocommons.com/search?model=Overlay&page=1)

