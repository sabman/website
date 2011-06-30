app = require '../config/app'
module.exports = BackboneMongo = require 'backbone'

commands =
  read: (collection, model, callback) ->
    collection.findOne { _id: model._id }, { safe: true }, callback
  create: (collection, model, callback) ->
    collection.insert model.toJSON(), { safe: true }, callback
  update: (collection, model, callback) ->
    collection.update { _id: model._id }, { $set: model.toJSON() }, { safe: true }, callback
  delete: (collection, model, callback) ->
    collection.remove { _id: model._id }, { safe: true }, callback

BackboneMongo.sync = (method, model, success, error) ->
  model._id ?= app.db.BSON.ObjectID.createFromHexString(model.id) if model.id?
  collection = app.db[model.collection.name.toLowerCase()]

  commands[method] collection, model, (e, res) ->
    return error(e) if e

    res = if Array.isArray res then res[0] else res

    if typeof res is 'object'
      model._id ?= res._id
      model.id ?= res.id = res._id?.toHexString()
    else
      res = {}

    success(res)
