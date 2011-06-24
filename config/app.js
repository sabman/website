var express = require('express')
  , auth = require('connect-auth')
  , assets = require('connect-assetmanager')
  , io = require('socket.io')
  , pub = __dirname + '/../public'
  , env = require('./env')
  , port = env.port
  , secrets = env.secrets;


// express
var app = module.exports = express.createServer();

// config
app.configure(function() {
  app.use(require('stylus').middleware(pub));
  app.use(express.logger());
  app.use(express.cookieParser());
  app.use(express.session({ secret: secrets.session }));
  app.use(assets({
    js: {
      route: /\/javascripts\/all\.js/,
      path: './public/javascripts/',
      dataType: 'javascript',
      debug: true,
      files: [
        'modernizr-2.0.4.js',
        'json2.js',
        'jquery-1.5.2.js',
        'jquery.keylisten.js',
        'jquery.border-image.js',
        'jquery.transform.light.js',
        'application.js',
        '*']
    }
  }));
  app.set('views', __dirname + '/../views');
  app.set('view engine', 'jade');
});

app.configure('development', function() {
  app.use(auth([auth.Github({
    appId: 'c07cd7100ae57921a267',
    appSecret: secrets.github_dev,
    callback: 'http://localhost:' + port + '/auth/github'
  })]));
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
  app.use(express.static(pub));
  app.set('view options', { scope: { development: true }});
});

app.configure('production', function() {
  app.use(auth([auth.Github({
    appId: 'c294545b6f2898154827',
    appSecret: secrets.github,
    callback: 'http://nodeknockout.com/auth/github'
  })]));
  app.use(express.errorHandler());
  app.use(express.static(pub, { maxAge: 1000 * 5 * 60 }));
  app.set('view options', { scope: { development: false }});
});

app.listen(port);

// socket.io
app.ws = io.listen(app);

require('util').log("listening on 0.0.0.0:" + port + ".");
