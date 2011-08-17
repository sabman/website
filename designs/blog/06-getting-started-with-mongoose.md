_This is the 8th in a series of posts leading up to [Node.js
Knockout][1] on using [Mongoose][].  This post was
written by [Node Knockout judge][2] and [Mongoose][] author Aaron
Heckmann._

[1]: http://nodeknockout.com
[2]: http://nodeknockout.com/people/4e24e73eab65aa01000005ac

# Getting started with Mongoose and Node

In this post we'll talk about getting started with [Mongoose][], an
object modeling tool for [MongoDB][] and [node.js][].

[mongoose]: http://mongoosejs.com (Mongoose)
[mongodb]: http://www.mongodb.com (Mongodb)
[node.js]: http://nodejs.org (nodejs)

## Install

We're going to assume that you have both [MongoDB][4] and [npm][]
installed for this post. Once we those let's install Mongoose:

[4]: http://www.mongodb.org/display/DOCS/Quickstart (Installing mongodb)
[npm]: http://npmjs.org/ (node package manager)

    $ npm install mongoose

Hurray! Now we can simply require mongoose like any other npm package.

    var mongoose = require('mongoose');

## Schema definition

Though MongoDB is a schema-less database we often want some level of
control over what goes in and out of our database collections. We're
confident that we're going to be the next Netflix so we'll need a
**Movie** schema and a **Rating** schema. Each Movie is allowed to have
multiple Ratings.

    var Schema = mongoose.Schema;
    var RatingSchema = new Schema({
        stars    : { type: Number, required: true }
      , comment  : { type: String, trim: true }
      , createdAt: { type: Date, default: Date.now }
    });

So far we've created a **Rating** schema with a _stars_ property of type
Number, a _comment_ property of type String, and a _createdAt_ property
of type Date. Whenever we set the _stars_ property it will automatically
be cast as a Number. Note also that we specified _required_ which means
validation will fail if an attempt is made to save a rating without
setting the number of stars. Likewise, whenever we set the _comment_
property it will first be cast as a String before being set, and since
whitespace around comments is very uncool, we use the built-in _trim_
setter.

Now that we're happy with our **Rating** model we'll use it within our
**Movie** model. Each movie should have name, director, year, and
ratings properties.

    var MovieSchema = new Schema({
        name    : { type: String, trim: true, index: true }
      , ratings : [RatingSchema]
      , director: Schema.ObjectId
      , year    : Number
    });

Here we see that _ratings_ is set to an array of **Rating** schemas.
This means that we'll be storing **Ratings** as subdocuments on each
**Movie** document. A subdocument is simply a document nested within
another.

You might have noticed the _index_ option we added to the name property.
This tells MongoDB to create an index on this field.

We've also defined _director_ as an ObjectId. [ObjectIds][5] are the
default primary key type MongoDB creates for you on each document. We'll
use this as a foreign key field, storing the document ObjectId of
another imaginary Person document which we'll leave out for brevity.

[5]: http://www.mongodb.org/display/DOCS/Object+IDs (ObjectId)

_**TIP: Note that we needed to declare the subdocument Rating schema before
using it within our Movie schema definition for everything to work
properly.**_

This is what a movie might look like within the [mongo shell][6]:

[6]: http://www.mongodb.org/display/DOCS/mongo+-+The+Interactive+Shell (MongoDB shell)

    {
      "name" : "Inception",
      "year" : 2010,
      "ratings" : [
        {
          "stars" : 8.9,
          "comment" : "I fell asleep during this movie, and yeah, you've heard this joke before"
        },
        {
          "stars" : 9.3
        }
      ],
      "director" : ObjectId("4e4b4a8b73e1d576d6a1438e")
    }

Now that we've finished our schemas we're ready to create our movie model.

    var Movie = mongoose.model('Movie', MovieSchema);

And thats it! Everything is all set with the exception of being able to
actually talk to MongoDB. So let's create a connection.

    mongoose.connect('mongodb://localhost/nodeknockout');
    var db = mongoose.connection;
    db.on('open', function () {
      // now we can start talking
    });

Now we're ready to create a movie and save it.

    var super8 = new Movie({ name: "Super 8", director: anObjectId, year: 2011 });

    super8.save(function (err) {
      if (err) return console.error(err); // we should handle this
    });

Oh, but what about adding ratings?

    Movie.findOne({ name: "Super 8" }).where('year', 2011).run(function (err, super8) {
      if (err) // handle this

      // add a rating
      super8.ratings.push({ stars: 7.7, comment: "it made me happy" });
      super8.save(callback);
    });

To look up our movie we used _Model.findOne_ which accepts a where
clause as its first argument. We also took advantage of the Query object
returned by this method to add some more sugary filtering. Finally, we
called the Query's _run_ method to execute it.

We didn't have to do it this way, instead you could just pass all of
your _where_ params directly as the first argument like so:

    Movie.findOne({ name: "Super 8", year: 2011 }, callback);

Though the first example is more verbose it highlights some of the
expressive flexibility provided by the Query object returned.

Here are a couple more ways we could write this query:

    Movie.where('name', /^Super 8/i).where('year', 2011).limit(1).exec(callback);

    Movie.find({ name: "Super 8", year: { $gt: 2010, $lt: 2012 } }, null, { limit: 1 }, callback);

This is all well and good but what if we look up movies by director and
year a lot and need the query to be fast? First we'll create a _static_
method on our Movie model:

    MovieSchema.statics.byNameAndYear = function (name, year, callback) {
      // this could return multiple results
      return this.find({ name: name, year: year }, callback);
    }

We'll also add a compound index on these two fields to give us a
performance boost:

    MovieSchema.index({ name: 1, year: 1 });

For good measure we'll add a movie instance method to conveniently look
up the director:

    MovieSchema.methods.findDirector = function (callback) {
      // Person is our imaginary Model we skipped for brevity
      return this.db.model('Person').findById(this.director, callback);
    }

Putting it all together:

    Movie.byNameAndYear("Super 8", 2011, function (err, movies) {
      if (err) return console.error(err); // handle this
      var movie = movies[0];
      movie.findDirector(function (err, director) {
        if (err) ...
        // woot
      })
    });

Thats it for this post. For more info check out [mongoosejs.com][7], the
github [README][8], or the Mongoose test directory to see even [more
examples][9].

[7]: http://mongoosejs.com (Mongoosejs)
[8]: https://github.com/LearnBoost/mongoose/blob/master/README.md (Mongoose README)
[9]: https://github.com/LearnBoost/mongoose/tree/master/test (Mongoose examples)
