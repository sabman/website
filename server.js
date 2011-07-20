require('coffee-script');

[ 'login',
  'index',
  'people',
  'judges',
  'teams',
  'websocket',
  'redirect'
].forEach(function(controller) {
  require('./controllers/' + controller);
});
