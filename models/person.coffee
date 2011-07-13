_ = require 'underscore'
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
  Team.findOne people_ids: @id, callback

PersonSchema.method 'join', (team, invite) ->
  team.people_ids.push @id unless team.includes(this)
  if old = _.detect(team.invites, (i) -> i.code == invite)
    team.emails = _.without team.emails, old.email
    old.remove()

Person = mongoose.model 'Person', PersonSchema
