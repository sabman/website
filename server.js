require('coffee-script');

[ 'login',
  'index',
  'people',
  'teams',
  'websocket',
  'redirect'
].forEach(function(controller) {
  require('./controllers/' + controller);
});
