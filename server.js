require('coffee-script');

[ 'index',
  'teams',
  'redirect',
  'websocket'
].forEach(function(controller) {
  require('./controllers/' + controller);
});
