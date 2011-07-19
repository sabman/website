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

// db
var mongoose = require('mongoose')
require('../lib/mongo-log')(mongoose.mongo);
require('mongoose-types').loadTypes(mongoose);
require('../models');
util.log('connecting to ' + env.mongo_url);
mongoose.connect(env.mongo_url);
app.db = mongoose;

// config
app.configure(function() {
  var coffee = require('coffee-script')
    , uglify_jsp = require("uglify-js").parser
    , uglify_pro = require("uglify-js").uglify
    , stylus = require('stylus');
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
      path: './public/javascripts/',
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
        'hoptoad-notifier.js',
        'hoptoad-key.js',
        'modernizr-2.0.4.js',
        'json2.js',
        'jquery-1.6.2.js',
        'jquery.keylisten.js',
        'jquery.border-image.js',
        'jquery.transform.light.js',
        'application.js',
        '*'
      ]
      , 'postManipulate': {
        '^': [
          function(file, path, index, isLast, callback) {
            file = '(function(){'+file+'})();';
            var ast = uglify_jsp.parse(file);
            ast = uglify_pro.ast_mangle(ast);
            ast = uglify_pro.ast_squeeze(ast);
            callback(uglify_pro.gen_code(ast, { beautify: true, indent_level: 0 }));
          }
          , function (file, path, index, isLast, callback) {
            cacheTimestamps.js = crypto.createHash('md5').update(file).digest('hex');
            callback(file);
          }
        ]
      }
    }
  }));
});

app.configure('development', function() {
  app.use(express.static(app.paths.public));
  app.set('view options', { scope: { development: true }});
  app.enable('voting');
});
app.configure('production', function() {
  app.use(express.static(app.paths.public, { maxAge: 1000 * 5 * 60 }));
  app.set('view options', { scope: { development: false }});
  app.disable('voting');
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

// Cache busting
var crypto = require('crypto')
  , cacheTimestamps = {};

app.dynamicHelpers({
  'cacheTimeStamps': function() {
    return cacheTimestamps;
  }
});

// helpers
auth.helpExpress(app);
require('../helpers')(app);

app.listen(port);
app.ws = require('socket.io').listen(app);

require('util').log("listening on 0.0.0.0:" + port + ".");
