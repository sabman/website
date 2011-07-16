var express = require('express')
  , auth = require('mongoose-auth')
  , coffee = require('coffee-script')
  , env = require('./env')
  , io = require('socket.io')
  , mongoose = require('mongoose')
  , mongooseTypes = require('mongoose-types')
  , Hoptoad = require('hoptoad-notifier').Hoptoad
  , util = require('util')
  , port = env.port
  , secrets = env.secrets;

// express
var app = module.exports = express.createServer();

// some paths
app.paths = {
  public: __dirname + '/../public',
  views: __dirname + '/../views'
};

// error handling
Hoptoad.key = 'b76b10945d476da44a0eac6bfe1aeabd';
Hoptoad.environment = env.node_env;
process.on('uncaughtException', function(e) {
  util.debug(e.stack);
  Hoptoad.notifiy(e);
});
app.error(function(e, req, res, next) {
  if (typeof(e) === 'string') e = new Error(e);
  Hoptoad.notify(e);
  next(e);
});

// utilities & hacks
require('../lib/render2');
require('../lib/mongo-log')(mongoose.mongo);

// db
mongooseTypes.loadTypes(mongoose);
require('../models');
util.log('connecting to ' + env.mongo_url);
mongoose.connect(env.mongo_url);
app.db = mongoose;

// config
app.configure(function() {
  app.use(require('stylus').middleware(app.paths.public));
  app.use(require('connect-assetmanager')({
    js: {
      route: /\/javascripts\/all\.js/,
      path: './public/javascripts/',
      dataType: 'javascript',
      debug: true,
      preManipulate: {
        '^': [function(file, path, index, isLast, callback) {
            if (/\.coffee$/.test(path)) {
              callback(coffee.compile(file));
            } else {
              callback(file);
            }
          }]
      },
      files: [
        'hoptoad-notifier.js',
        'hoptoad-key.js',
        'modernizr-2.0.4.js',
        'json2.js',
        'jquery-1.5.2.js',
        'jquery.keylisten.js',
        'jquery.border-image.js',
        'jquery.transform.light.js',
        'application.js',
        '*'
      ]
    }
  }));
});

app.configure('development', function() {
  app.use(express.static(app.paths.public));
});
app.configure('production', function() {
  app.use(express.static(app.paths.public, { maxAge: 1000 * 5 * 60 }));
});

app.configure(function() {
  app.use(express.cookieParser());
  app.use(require('connect-cookie-session')({
    secret: secrets.session,
    cookie: { maxAge: 31536000000 } // ~1 year
  }));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.logger());
  app.use(auth.middleware());
  app.use(app.router);
  app.set('views', app.paths.views);
  app.set('view engine', 'jade');
});

app.configure('development', function() {
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
  app.set('view options', { scope: { development: true }});
});

app.configure('production', function() {
  app.use(express.errorHandler());
  app.set('view options', { scope: { development: false }});
});

// helpers
auth.helpExpress(app);
require('../helpers')(app);

app.listen(port);
app.ws = io.listen(app); // socket.io

require('util').log("listening on 0.0.0.0:" + port + ".");
