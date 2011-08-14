mongoose = require 'mongoose'
ObjectId = mongoose.Schema.ObjectId

DeploySchema = module.exports = new mongoose.Schema
  teamId:
    type: ObjectId
    index: true
    required: true
  hostname: String
  os: String
  remoteAddress: String

# associations
DeploySchema.method 'team', (callback) ->
  Team = mongoose.model 'Team'
  Team.findById @teamId, callback

# validations
DeploySchema.path('remoteAddress').validate (v) ->
  switch v
  when /72\.2\.12[67]\.\d+/ # 72.2.126.0/23 - joyent
    true
  else
    false
, 'not production'

Deploy = mongoose.model 'Deploy', DeploySchema
