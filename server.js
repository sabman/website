require('coffee-script');

[
  'index',
  'people',
  'teams',
  'websocket'
].forEach(function(controller) {
  require('./controllers/' + controller);
});
