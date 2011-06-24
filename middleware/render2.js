var http = require('http')
  , res = http.ServerResponse.prototype;

res.render2 = function() {
  res.local('view', arguments[0]);
  return res.render.apply(this, arguments);
};
