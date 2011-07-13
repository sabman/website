var express = require('express')
  , assets = require('connect-assetmanager')
  , auth = require('mongoose-auth')
  , coffee = require('coffee-script')
  , cookieSession = require('connect-cookie-session')
  , env = require('./env')
  , io = require('socket.io')
  , mongoose = require('mongoose')
  , mongooseTypes = require('mongoose-types')
  , port = env.port
  , secrets = env.secrets;

// express
var app = module.exports = express.createServer();

// some paths
app.paths = {
  public: __dirname + '/../public',
  views: __dirname + '/../views'
};

// utilities & hacks
require('../lib/render2');
app.te = require('../lib/throw-runtime-error');

// db
mongooseTypes.loadTypes(mongoose);
require('../models');
mongoose.connect(process.env.MONGOHQ_URL || 'mongodb://localhost/nko_development');
app.db = mongoose;

// config
app.configure(function() {
  app.use(require('stylus').middleware(app.paths.public));
  app.use(assets({
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
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
  app.use(express.static(app.paths.public));

  app.set('view options', { scope: { development: true }});
});

app.configure('production', function() {
  app.use(express.errorHandler());
  app.use(express.static(app.paths.public, { maxAge: 1000 * 5 * 60 }));

  app.set('view options', { scope: { development: false }});
});

app.configure(function() {
  app.use(express.cookieParser());
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(cookieSession({ secret: secrets.session }));
  app.use(express.logger());
  app.use(auth.middleware());

  app.set('views', app.paths.views);
  app.set('view engine', 'jade');
});

// helpers
auth.helpExpress(app);
require('../helpers')(app);

app.listen(port);
app.ws = io.listen(app); // socket.io

require('util').log("listening on 0.0.0.0:" + port + ".");
