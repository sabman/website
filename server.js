require('coffee-script');

[ 'index',
  'auth',
  'redirect',
  'websocket'
].forEach(function(controller) {
  require('./controllers/' + controller);
});
