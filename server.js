require('coffee-script');

[
  'index',
  'people',
  'redirect',
  'teams',
  'websocket'
].forEach(function(controller) {
  require('./controllers/' + controller);
});
