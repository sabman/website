var express = require('express')
  , auth = require('connect-auth')
  , io = require('socket.io')
  , pub = __dirname + '/public'
  , port = process.env.PORT || 8000
  , secrets;

try { secrets = require('./secrets'); }
catch(e) { throw "Secret keys file is missing. See ./secrets.js.sample."; }

// express
var app = express.createServer();

// config
app.configure(function() {
  app.use(require('stylus').middleware(pub));
  app.use(express.logger());
  app.use(express.cookieParser());
  app.use(express.session({ secret: secrets.session }));
  app.use(auth([ auth.Github({
    appId: 'c294545b6f2898154827',
    appSecret: secrets.github,
    callback: '/auth/github'
  })]));
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
});

app.configure('development', function() {
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
  app.use(express.static(pub));
  app.set('view options', { scope: { development: true }});
});

app.configure('production', function() {
  app.use(express.errorHandler());
  app.use(express.static(pub, { maxAge: 1000 * 5 * 60 }));
  app.set('view options', { scope: { development: false }});
});

// TODO: put this in a lib or push back to tj
(function() {
  var jade = require('jade')
    , content;

  jade.filters.content = function(str, options) {
    var k = Object.keys(options)[0]
      , v = jade.render(str.replace(/\\n/g, '\n'));
    if (content[k])
      content[k] += v;
    else
      content[k] = v;

    return '';
  };

  app.dynamicHelpers({
    content: function(req, res) {
      return content = {};
    }
  });
})();

app.listen(port);
// socket.io
app.ws = io.listen(app);

require('util').log("listening on 0.0.0.0:" + port + ".");

module.exports = app;
