_This is the 3rd in a series of posts leading up to [Node.js
Knockout][1] on how to use [Express][2]. This post was written by guest
author and [former Node.js Knockout judge][3] Tj Holowaychuk and is
[cross-posted on his blog][4]._

[1]: http://nodeknockout.com
[2]: http://expressjs.com/
[3]: http://2010.nodeknockout.com/people/fb1f6a4cc5ec0c6f76270000
[4]: http://tjholowaychuk.com/post/937557927/getting-started-with-express

In this short tutorial for Node Knockout we will be creating a small
application using the popular [Express][2] framework.

Express is a light-weight [Sinatra][5]-inspired web development framework.
Express provides several great features such as an intuitive view
system, robust routing, an executable for generating applications and
much more.

[5]: http://www.sinatrarb.com/

## Installation

To get started with Express we first have to install it. There are
several ways to do so, however the easiest is with [npm][6]:

    $ npm install express

[6]: http://npmjs.org/

## First Express Application

To create our first application we could use `express(1)` to generate an
app for us, however an Express app can be a single JavaScript file if we
wish, and in our case of a simple “Hello World” app that is exactly what
we will do.

The first thing we need to do is require express, and create an app. The
app variable shown below is an **express.Server**, however by convention
we typically refer to Express servers as “apps”.

    var express = require('express'),
        app = express.createServer();

Our next task is to set up one or more routes. A route consists of a
path (string or regexp), callback function, and HTTP method. Our hello
world example calls `app.get()` which represents the HTTP **GET**
method, with the path “/”, representing our “root” page, followed by the
callback function.

    app.get('/', function(req, res){
        res.send('Hello World');
    });

Next we need our server to listen on a given port. Below we call
`listen(3000)` which attempts to bind the server to port 3000. This can
be whatever you like, for example `listen(80)`.

    app.listen(3000);
    console.log('Express server started on port %s', app.address().port);

We can execute the app simply by executing `node(1)` against our
JavaScript file:

    $ node app.js
    Express server started on port 3000

Finally to confirm everything is working as expected:

    $ curl http://localhost:3000
    Hello World

## Middleware

Behind the scenes the [Connect][7] middleware framework developed by
myself ([TJ Holowaychuk][8]) and Tim Caswell is utilized to power the
Express middleware. For example if we wish to add logging support to our
hello world application, we can add the following line below `app =
express.createServer();`:

    app.use(express.logger());

For more information on middleware usage view the [Middleware][9]
section of the [Express Guide][10].

[7]: https://github.com/senchalabs/connect
[8]: http://tjholowaychuk.com/
[9]: http://expressjs.com/guide.html#middleware
[10]: http://expressjs.com/guide.html

## Source

Below is all 12 lines of source we used to create our first Express
application:

    var express = require('express'),
        app = express.createServer();

    app.use(express.logger());

    app.get('/', function(req, res){
        res.send('Hello World');
    });

    app.listen(3000);
    console.log('Express server started on port %s', app.address().port);
