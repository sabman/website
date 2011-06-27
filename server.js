require('coffee-script');

[ 'index',
  'auth',
  'teams',
  'redirect',
  'websocket'
].forEach(function(controller) {
  require('./controllers/' + controller);
});
