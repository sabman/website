var express = require('express')
  , auth = require('mongoose-auth')
  , env = require('./env')
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
var Hoptoad = require('hoptoad-notifier').Hoptoad;
Hoptoad.key = 'b76b10945d476da44a0eac6bfe1aeabd';
Hoptoad.environment = env.node_env;
process.on('uncaughtException', function(e) {
  util.debug(e.stack);
  if (env.node_env === 'production')
    Hoptoad.notify(e);
});
app.error(function(e, req, res, next) {
  if (typeof(e) === 'number')
    return res.render2('errors/' + e, { status: e });

  if (typeof(e) === 'string')
    e = new Error(e);

  if (env.node_env === 'production')
    Hoptoad.notify(e);

  util.debug(e.stack);
  res.render2('errors/500', { error: e });
});

// utilities & hacks
require('../lib/render2');
require('../lib/underscore.shuffle');

// db
var mongoose = require('mongoose')
require('mongoose-types').loadTypes(mongoose);
require('../models');
util.log('connecting to ' + env.mongo_url);
mongoose.connect(env.mongo_url, function(err) {
  if (err) {
    console.log(err);
    if (err === 'connection already opened') {
      console.log('eh, who cares');
      mongoose.connection.onOpen();
    }
  }
});
app.db = mongoose;

// config
app.configure(function() {
  var coffee = require('coffee-script')
    , uglify_jsp = require("uglify-js").parser
    , uglify_pro = require("uglify-js").uglify
    , stylus = require('stylus')
    , crypto = require('crypto')
    , cacheTimestamps = {};

  app.dynamicHelpers({
    'cacheTimeStamps': function() {
      return cacheTimestamps;
    }
  });

  app.use(stylus.middleware({
    src: app.paths.public,
    dest: app.paths.public,
    compile: function(str, path) {
      return stylus(str)
        .set('compress', true)
        .set('filename', path)
        .set('paths', [ __dirname, app.paths.public ]);
    }
  }));
  app.use(require('connect-assetmanager')({
    js: {
      route: /\/javascripts\/[a-z0-9]+\/all\.js/,
      path: __dirname + '/../public/javascripts/',
      dataType: 'javascript',
      debug: true,
      preManipulate: {
        '^': [
          function(file, path, index, isLast, callback) {
            if (/\.coffee$/.test(path)) {
              callback(coffee.compile(file));
            } else {
              callback(file);
            }
          }
        ]
      },
      files: [
        // order matters here
        'hoptoad-notifier.js',
        'hoptoad-key.js',
        'modernizr-2.0.4.js',
        'json2.js',
        'jquery-1.6.2.js',
        'jquery.border-image.js',
        'jquery.infinitescroll.js',
        'jquery.keylisten.js',
        'jquery.transform.light.js',
        'jquery.transloadit2.js',
        'console.js',
        'md5.js',
        'application.coffee',
        '*'
      ]
      , 'postManipulate': {
        '^': [
          function(file, path, index, isLast, callback) {
            if (env.production) {
              var ast = uglify_jsp.parse(file);
              ast = uglify_pro.ast_mangle(ast);
              ast = uglify_pro.ast_squeeze(ast);
              callback(uglify_pro.gen_code(ast, { beautify: true, indent_level: 0 }));
            } else {
              callback(file);
            }
          }
          , function (file, path, index, isLast, callback) {
            var md5 = crypto.createHash('md5');
            cacheTimestamps.js = md5.update(file).digest('hex');
            callback(file);
          }
        ]
      }
    }
  }));
});

app.configure('development', function() {
  app.use(express.static(app.paths.public));
  app.use(express.profiler());
  app.set('view options', { scope: { development: true }});
  app.enable('voting');
  require('../lib/mongo-log')(mongoose.mongo);
});
app.configure('production', function() {
  app.use(express.static(app.paths.public, { maxAge: 1000 * 5 * 60 }));
  app.set('view options', { scope: { development: false }});
  app.disable('voting');
});

app.configure(function() {
  var MongoStore = require('connect-mongodb');

  app.use(function(req, res, next) {
    if (req.headers.host.indexOf('www.') === 0)
      res.redirect('http://' + req.headers.host.substring(4) + req.url);
    else
      next();
  });
  app.use(express.cookieParser());
  app.use(express.session({
    secret: secrets.session,
    store: new MongoStore({ db: mongoose.connection.db })
  }));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.logger());
  app.use(auth.middleware());
  app.use(app.router);

  app.set('views', app.paths.views);
  app.set('view engine', 'jade');
});

// helpers
auth.helpExpress(app);
require('../helpers')(app);

app.listen(port);
app.ws = require('socket.io').listen(app);
if (env.production) app.ws.set('log level', 0);

app.on('listening', function() {
  require('util').log("listening on 0.0.0.0:" + port + ".");

  // if run as root, downgrade to the owner of this file
  if (env.production && process.getuid() === 0)
    require('fs').stat(__filename, function(err, stats) {
      if (err) return util.log(err)
      process.setuid(stats.uid);
    });
});
