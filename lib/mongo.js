var util = require('util')
  , EventEmitter = require('events').EventEmitter
  , mongodb = require('mongodb')
  , Db = mongodb.Db
  , Connection = mongodb.Connection
  , Server = mongodb.Server
  , BSON = mongodb.BSONNative;

function Mongo(options) {
  var self = this
    , collections = options.collections
    , name = options.name
    , urlopts = parseMongoUrl(options.url || process.env.MONGO_URL)
    , host = options.host || process.env.MONGO_HOST || urlopts.host || 'localhost'
    , port = options.port || process.env.MONGO_PORT || urlopts.port || Connection.DEFAULT_PORT
    , user = options.user || process.env.MONGO_USER || urlopts.user
    , pass = options.password || process.env.MONGO_PASSWORD || urlopts.password
    , node_env = options.node_env || process.env.NODE_ENV || 'development'
    , server = new Server(host, port, {})
    , dbname = urlopts.dbname || name + '_' + node_env
    , db = new Db(dbname, server, { native_parser: true })
    , objs = {
        server: server,
        connection: db,
        lib: mongodb,
        BSON: BSON }
    , ready = false;

  EventEmitter.call(self);

  // open the database connection, authenticating if necessary
  db.open(function(err, db) {
    if (err) return self.emit('error', err);

    if (user) {
      db.authenticate(user, pass, loadCollections);
    } else {
      loadCollections();
    }
  });

  // still fire ready if a new "ready" listener comes in after load
  self.on('newListener', function(evt, listener) {
    if ((evt === 'ready') && ready) listener(objs);
  });

  function loadCollections() {
    var threads = collections.length;

    // load collections
    collections.forEach(function(name) {
      db.collection(name, function(err, collection) {
        if (err) return self.emit('error', err);

        objs[name] = collection;
        console.log('loaded collection ' + name);

        if (--threads === 0) {
          ready = true;
          self.emit('ready', objs);
        }
      });
    });
  }
};
util.inherits(Mongo, EventEmitter);

function parseMongoUrl(urlString) {
  var r = {}, u, p
    , url = require('url');
  if (urlString) {
    u = url.parse(urlString);
    r.host = u.hostname;
    r.port = parseInt(u.port);
    r.dbname = u.pathname.replace(/^\//,'');
    if (u.auth) {
      p = u.auth.split(':');
      r.user = p[0];
      r.password = p[1];
    }
  }

  return r;
}

module.exports = function(options) { return new Mongo(options); };
