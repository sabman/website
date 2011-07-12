require('coffee-script');

[
  'index',
  'people',
  'teams',
  'websocket',
  'redirect'
].forEach(function(controller) {
  require('./controllers/' + controller);
});
