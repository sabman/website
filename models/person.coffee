mongoose = require 'mongoose'
auth = require 'mongoose-auth'
env = require '../config/env'

# auth decoration
PersonSchema = module.exports = new mongoose.Schema
PersonSchema.plugin auth,
  everymodule:
    everyauth: { User: () -> Person }
  github:
    everyauth:
      myHostname: env.hostname
      appId: env.github_app_id
      appSecret: env.secrets.github
      redirectPath: '/people/me'

Person = module.exports = mongoose.model 'Person', PersonSchema
Person.prototype.team = (callback) ->
  Team = mongoose.model 'Team'
  Team.find people_ids: this.id, callback
