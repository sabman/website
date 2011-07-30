require('coffee-script');

[ 'login',
  'index',
  'people',
  'judges',
  'teams',
  'votes',
  'websocket',
  'redirect'
].forEach(function(controller) {
  require('./controllers/' + controller);
});
