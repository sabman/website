var app = require('app');

// routes
app.get('/', function(req, res) {
  res.render('index');
});

[ 'about', 'how-to-win', 'sponsors' ].forEach(function(p) {
  app.get('/' + p, function(req, res) {
    res.render(p);
  });
});

app.get('/auth/github', function(req, res) {
  req.authenticate(['github'], function(error, authenticated) {
    if (error) { throw error; }

    if (authenticated) {
      res.end("<html><h1>Hello github user:" + JSON.stringify( req.getAuthDetails().user ) + ".</h1></html>")
    } else {
      res.end("<html><h1>Github authentication failed :( </h1></html>")
    }
  });
});

// let 2010 routes redirect for a while
app.get(/\/(.*)\//, function(req, res, next) {
  var path = req.params[0];
  if (/^(stylesheets|javascripts|images|fonts)/.test(path)) {
    next(); // don't redirect for stylesheets and the like
  } else {
    res.redirect('http://2010.nodeknockout.com' + req.url, 301);
  }
});

// websockets
app.ws.on('connection', function(client) {
  client
    .on('message', function(data) {
      data = JSON.parse(data);
      data.sessionId = client.sessionId;

      app.ws.broadcast(JSON.stringify(data), client.sessionId);
    })
    .on('disconnect', function() {
      app.ws.broadcast(JSON.stringify({
        sessionId: client.sessionId, disconnect: true
      }));
    });
});
