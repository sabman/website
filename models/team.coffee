_ = require 'underscore'
mongoose = require 'mongoose'
env = require '../config/env'
postageapp = require('postageapp')(env.secrets.postageapp)

InviteSchema = require './invite'
Invite = mongoose.model 'Invite'

TeamSchema = module.exports = new mongoose.Schema
  name:
    type: String
    required: true
  emails:
    type: [ mongoose.SchemaTypes.Email ]
    validate: [
      (v) -> 1 <= v.length
      'min'
      (v) -> v.length <= 4
      'max'
    ]
  invites: [ InviteSchema ]
  people_ids:
    type: [ mongoose.Schema.ObjectId ]
    index: true
TeamSchema.plugin require('mongoose-types').useTimestamps

TeamSchema.method 'includes', (person) ->
  _.any this.people_ids, (id) -> id.equals(person.id)

# create stub people? and send emails
TeamSchema.pre 'save', (next) ->
  this.invites = for email in this.emails
    _.detect(this.invites, (i) -> i.email == email) or new Invite email: email
  ###
  postageapp.apiCall this.emails, 'teams_new', null, 'all@nodeknockout.com',
    team_id: this.id
    team_name: this.name
    person_github_login: 'visnup'
    invite_code: 'awef'
  ###
  next()

mongoose.model 'Team', TeamSchema
