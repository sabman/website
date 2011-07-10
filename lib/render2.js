var http = require('http')
  , util = require('util')
  , res = http.ServerResponse.prototype;

res.render2 = function() {
  util.log('Rendering ' + arguments[0]);
  res.local('view', arguments[0]);
  return res.render.apply(this, arguments);
};
