_ = require 'underscore'
mongoose = require 'mongoose'
ObjectId = mongoose.Schema.ObjectId
Invite = require './invite'

TeamSchema = new mongoose.Schema
  name:
    type: String
    validate: [/./, "Name can't be blank"]
  emails: [String]
  invites: [Invite]
  people_ids: [ObjectId]

TeamSchema.path('emails').validate (v) ->
  1 <= v.length
, 'Team must have at least one member'

TeamSchema.path('emails').validate (v) ->
  v.length <= 4
, 'At most four members are allowed on a team'

Team = module.exports = mongoose.model 'Team', TeamSchema

Team.prototype.includes = (person) ->
  _.any this.people_ids, (id) -> id.equals(person.id)
