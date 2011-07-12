_ = require 'underscore'
mongoose = require 'mongoose'
env = require '../config/env'
postageapp = require('postageapp')(env.secrets.postageapp)

TeamSchema = new mongoose.Schema
  name:
    type: String
    validate: [ /./, "Name can't be blank" ]
  emails: [ String ]
  people_ids: [ mongoose.Schema.ObjectId ]
TeamSchema.plugin require('mongoose-types').useTimestamps

TeamSchema.method 'includes', (person) ->
  _.any this.people_ids, (id) -> id.equals(person.id)

TeamSchema.index people_ids: 1

TeamSchema.path('emails').validate (v) ->
  1 <= v.length
, 'Team must have at least one member'

TeamSchema.path('emails').validate (v) ->
  v.length <= 4
, 'At most four members are allowed on a team'

# create stub people? and send emails
TeamSchema.pre 'save', (next) ->
  postageapp.apiCall this.emails, 'teams_new', null, 'all@nodeknockout.com',
    team_id: this.id
    team_name: this.name
    person_github_login: 'visnup'
    invite_code: 'awef'
  next()

Team = module.exports = mongoose.model 'Team', TeamSchema
