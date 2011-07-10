mongoose = require 'mongoose'
ObjectId = mongoose.Schema.ObjectId
Invite = require './invite'

Team = module.exports = new mongoose.Schema
  name:
    type: String
    validate: [/./, "Name can't be blank"]
  emails: [String]
  invites: [Invite]
  member_ids: [ObjectId]

Team.path('emails').validate (v) ->
  1 <= v.length
, 'Team must have at least one member'

Team.path('emails').validate (v) ->
  v.length <= 4
, 'At most four members are allowed on a team'

mongoose.model 'Team', Team
