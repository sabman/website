var http = require('http'),
    qs = require('querystring'),
    os = require('os');

function ping(code, callback) {
  if (typeof code !== 'string') {
    throw Error('Go to http://nodeknockout.com/teams/mine to get your code.');
  }
  var options = {
    host: 'nodeknockout.com',
    port: 80,
    path: '/teams/' + qs.escape(code) + '/deploys',
    method: 'GET'
  },
  msg = {
    hostname: os.hostname(),
    os: os.type()
  },

  req = http.request(options);
  req.setHeader('Content-Type', 'application/json');
  req.end(JSON.stringify(msg));

  if (callback) {
    req.on('response', function (res) {
      callback(null, res);
    });
    req.on('error', function (err) {
      callback(err);
    });
  }
}

module.exports = ping;
