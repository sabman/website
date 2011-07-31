util = require 'util'
mongoose = require 'mongoose'
require('mongoose-types').loadTypes mongoose
require('../lib/mongo-log')(mongoose.mongo)

require "./#{lib}" for lib in ['invite', 'person', 'deploy', 'team', 'vote']

module.exports = (env) ->
  util.log 'connecting to ' + env.mongo_url.cyan
  mongoose.connect env.mongo_url, (err) -> throw Error err if err
