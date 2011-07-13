_ = require 'underscore'
mongoose = require 'mongoose'

InviteSchema = require './invite'
Invite = mongoose.model 'Invite'
Person = mongoose.model 'Person'

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
  _.any @people_ids, (id) -> id.equals(person.id) if person

TeamSchema.method 'people', (callback) ->
  Person.find _id: { '$in': @people_ids }, callback

TeamSchema.method 'invited', (invite) ->
  _.detect @invites, (i) -> i.code == invite

# create invites
TeamSchema.pre 'save', (next) ->
  for email in @emails
    unless _.detect(@invites, (i) -> i.email == email)
      @invites.push new Invite(email: email)
  _.invoke @invites, 'send'
  next()
TeamSchema.post 'save', () ->
  for invite in @invites
    invite.remove() unless !invite or _.include(@emails, invite.email)
  @save() if @isModified 'invites'

mongoose.model 'Team', TeamSchema
