_ = require 'underscore'
mongoose = require 'mongoose'
auth = require 'mongoose-auth'
env = require '../config/env'
twitterAuthRename = require '../lib/twitter_auth_rename'
facebookAuthRename = require '../lib/facebook_auth_rename'
ROLES = [ 'nomination', 'contestant', 'judge', 'voter' ]

# auth decoration
PersonSchema = module.exports = new mongoose.Schema
  name: String
  email: String
  imageURL: String
  location: String
  company: String
  twitterScreenName: String
  bio: String
  admin: Boolean
  role: { type: String, enum: ROLES }
  technical: Boolean
PersonSchema.plugin require('mongoose-types').useTimestamps
PersonSchema.plugin auth,
  everymodule:
    everyauth:
      moduleTimeout: 10000
      User: -> Person
      handleLogout: (req, res) ->
        req.logout()
        res.redirect(req.param('returnTo') || req.header('referrer') || '/')
  github:
    everyauth:
      redirectPath: '/login/done'
      myHostname: env.hostname
      appId: env.github_app_id
      appSecret: env.secrets.github
      findOrCreateUser: (sess, accessTok, accessTokExtra, ghUser) ->
        promise = @Promise()
        Person.findOne 'github.id': ghUser.id, (err, foundUser) ->
          if foundUser
            foundUser.updateWithGithub ghUser, (err, updatedUser) ->
              return promise.fail err if err
              promise.fulfill updatedUser
          else
            Person.createWithGithub ghUser, accessTok, (err, createdUser) ->
              return promise.fail err if err
              promise.fulfill createdUser
        promise
  twitter:
    everyauth:
      redirectPath: '/login/done'
      myHostname: env.hostname
      consumerKey: env.twitter_app_id
      consumerSecret: env.secrets.twitter
      authorizePath: '/oauth/authenticate'
      findOrCreateUser: (session, accessTok, accessTokExtra, twit) ->
        promise = @Promise()
        twitter = twitterAuthRename accessTok, accessTokExtra, twit
        Person.findOrCreateFromTwitter twitter, (err, person) ->
          return promise.fail err if err
          promise.fulfill person
        promise
  facebook:
    everyauth:
      redirectPath: '/login/done'
      myHostname: env.hostname
      appId: env.facebook_app_id
      appSecret: env.secrets.facebook
      scope: 'email'
      findOrCreateUser: (session, accessTok, accessTokExtra, face) ->
        promise = @Promise()
        fb = facebookAuthRename accessTok, accessTokExtra, face
        Person.findOrCreateFromFacebook fb, (err, person) ->
          return promise.fail err if err
          promise.fulfill person
        promise

ROLES.forEach (t) ->
  PersonSchema.virtual(t).get -> @role == t
PersonSchema.virtual('login').get ->
  @github?.login or @twit?.screenName or @name.split(' ')[0]
PersonSchema.virtual('githubLogin').get -> @github?.login
# twitterScreenName isn't here because you can edit it

# associations
PersonSchema.method 'team', (next) ->
  Team = mongoose.model 'Team'
  Team.findOne peopleIds: @id, next
PersonSchema.method 'votes', (next) ->
  Vote = mongoose.model 'Vote'
  Vote.find personId: @id, next

PersonSchema.pre 'remove', (next) ->
  myId = @_id
  @team (err, team) ->
    return next err if err
    if team
      if team.peopleIds.length is 1
        team.remove next
      else
        team.peopleIds = _.reject team.peopleIds, (id) -> id.equals(myId)
        team.save next
    else
      next()

# leaves saving up to the calling code: if passing in an invite, you'll
# probably want to save both the person and the team. w/o an invite, you just
# need to save the team.
PersonSchema.method 'join', (team, invite) ->
  team.peopleIds.push @id unless team.includes(this)
  if invite and old = _.detect(team.invites, (i) -> i.code == invite)
    _.extend this,
      name: @github.name
      email: old.email || @github.email
      role: 'contestant'
      company: @github.company
      location: @github.location
    team.emails = _.without team.emails, old.email
    old.remove()

PersonSchema.method 'updateWithGithub', (ghUser, callback) ->
  Person.createWithGithub.call
    create: (params, callback) =>
      _.extend this, params
      @company or= @github.company
      @location or= @github.location
      @save callback
    , ghUser, null, callback

PersonSchema.method 'updateFromTwitter', (twitter) ->
  @twit = twitter
  @twitterScreenName = twitter.screenName
  @name ||= twitter.name
  @location ||= twitter.location
  @bio ||= twitter.description
  @imageURL ||= twitter.profileImageUrl.replace('_normal.', '.')

PersonSchema.method 'updateFromFacebook', (facebook) ->
  @fb = facebook
  @name ||= facebook.name
  @location ||= facebook.location
  @imageURL ||= facebook.picture
  @role ||= 'voter'

PersonSchema.static 'findOrCreateFromTwitter', (twitter, callback) ->
  Person.findOne
    $or: [
      { twitterScreenName: new RegExp("^#{RegExp.escape twitter.screenName}$", 'i') }
      { 'twit.id': twitter.id }]
    (error, person) ->
      return callback(error) if error
      person ||= new Person
      try person.updateFromTwitter twitter catch e then callback(e)
      person.save (err) -> callback(err, person)

PersonSchema.static 'findOrCreateFromFacebook', (facebook, callback) ->
  Person.findOne 'fb.id': facebook.id, (error, person) ->
    return callback(error) if error
    person ||= new Person
    try person.updateFromFacebook facebook catch e then callback(e)
    person.save (err) -> callback(err, person)

Person = mongoose.model 'Person', PersonSchema
Person.ROLES = ROLES
