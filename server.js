require('coffee-script');

[ 'login',
  'index',
  'people',
  'judges',
  'teams',
  'deploys',
  'votes',
  'websocket',
  'redirect'
].forEach(function(controller) {
  require('./controllers/' + controller);
});
