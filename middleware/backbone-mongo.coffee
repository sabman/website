module.exports = BackboneMongo = require 'backbone'

BackboneMongo.sync = (method, model, success, error) ->
  console.log method
  console.dir model
