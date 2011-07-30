_ = require 'underscore'
mongoose = require 'mongoose'
rbytes = require 'rbytes'

InviteSchema = require './invite'
Invite = mongoose.model 'Invite'
Person = mongoose.model 'Person'
Deploy = mongoose.model 'Deploy'

TeamSchema = module.exports = new mongoose.Schema
  name:
    type: String
    required: true
    unique: true
  emails:
    type: [ mongoose.SchemaTypes.Email ]
    validate: [ ((v) -> v.length <= 4), 'max' ]
  invites: [ InviteSchema ]
  peopleIds:
    type: [ mongoose.Schema.ObjectId ]
    index: true
  code:
    type: String
    default: -> rbytes.randomBytes(12).toString('base64')
  description: String
TeamSchema.plugin require('mongoose-types').useTimestamps
TeamSchema.index updatedAt: -1

TeamSchema.method 'includes', (person, code) ->
  @code == code or person and _.any @peopleIds, (id) -> id.equals(person.id)
TeamSchema.method 'invited', (invite) ->
  _.detect @invites, (i) -> i.code == invite

# associations
TeamSchema.method 'people', (next) ->
  Person.find _id: { '$in': @peopleIds }, next
TeamSchema.method 'deploys', (next) ->
  Deploy.find teamId: @id, next
TeamSchema.method 'votes', (next) ->
  Vote = mongoose.model 'Vote'
  Vote.find teamId: @id, next

TeamSchema.static 'canRegister', (next) ->
  Team.count {}, (err, count) ->
    return next err if err
    max = 312 + 1 # +1 because team fortnight labs doesn't count
    next null, count < max, max - count

TeamSchema.static 'uniqueName', (name, next) ->
  Team.count { name: name }, (err, count) ->
    return next err if err
    next null, !count

# min people validation
TeamSchema.pre 'save', (next) ->
  if @peopleIds.length + @emails.length == 0
    error = new mongoose.Document.ValidationError this
    error.errors.emails = 'min'
    next error
  else
    next()

# max teams
TeamSchema.pre 'save', (next) ->
  return next() unless @isNew
  Team.canRegister (err, yeah) =>
    return next err if err
    if yeah
      next()
    else
      error = new mongoose.Document.ValidationError this
      error.errors._base = 'max'
      next error

# unique name
TeamSchema.pre 'save', (next) ->
  return next() unless @isNew
  Team.uniqueName @name, (err, yeah) =>
    return next err if err
    if yeah
      next()
    else
      error = new mongoose.Document.ValidationError this
      error.errors.name = 'unique'
      next error

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

Team = mongoose.model 'Team', TeamSchema
