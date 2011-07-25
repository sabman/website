mongoose = require 'mongoose'
ObjectId = mongoose.Schema.ObjectId

DeploySchema = module.exports = new mongoose.Schema
  teamId:
    type: ObjectId
    index: true
  hostname:
    type: String
  os:
    type: String
  isProduction:
    type: Boolean

DeploySchema.method 'team', (callback) ->
  Team = mongoose.model 'Team'
  Team.findById @teamId, callback

Deploy = mongoose.model 'Deploy', DeploySchema
