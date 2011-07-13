mongoose = require 'mongoose'
auth = require 'mongoose-auth'
env = require '../config/env'

# auth decoration
PersonSchema = module.exports = new mongoose.Schema
PersonSchema.plugin require('mongoose-types').useTimestamps
PersonSchema.plugin auth,
  everymodule:
    everyauth: { User: () -> Person }
  github:
    everyauth:
      myHostname: env.hostname
      appId: env.github_app_id
      appSecret: env.secrets.github
      redirectPath: '/people/me'
PersonSchema.method 'team', (callback) ->
  Team = mongoose.model 'Team'
  Team.find people_ids: @id, callback

Person = mongoose.model 'Person', PersonSchema
