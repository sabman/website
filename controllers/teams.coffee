_ = require 'underscore'
qs = require 'querystring'
colors = require 'colors'
app = require '../config/app'
{ ensureAuth } = require './middleware'
Team = app.db.model 'Team'
Person = app.db.model 'Person'
Vote = app.db.model 'Vote'
Deploy = app.db.model 'Deploy'

# middleware
loadTeam = (req, res, next) ->
  if id = req.params.id
    try
      Team.findById id, (err, team) ->
        return next err if err
        return next 404 unless team
        req.team = team
        next()
    catch error
      throw error unless error.message == 'Id cannot be longer than 12 bytes'
      return next 404
  else if code = req.params.code
    code = qs.unescape(code)
    Team.findOne code: code, (err, team) ->
      return next err if err
      return next 404 unless team
      req.team = team
      next()
  else
    next()

loadPeople = (req, res, next) ->
  req.team.people (err, people) ->
    return next err if err
    req.people = people
    next()

loadVotes = (req, res, next) ->
  if (!app.enabled('voting') || !req.user)
    return next()
  Vote.findOne { type:'upvote', teamId: req.team.id, personId: req.user.id }, (err, vote) ->
    return next err if err
    req.user.upvote = vote.upvote if vote
    next()

ensureAccess = (req, res, next) ->
  return next 401 unless req.team.includes(req.user, req.session.team) or req.user?.admin
  next()

# index
app.get '/teams', (req, res, next) ->
  page = (req.param('page') or 1) - 1
  options = { sort: [['updatedAt', -1]], limit: 50, skip: 50 * page }
  Team.find {}, {}, options, (err, teams) ->
    return next err if err
    ids = _.reduce teams, ((r, t) -> r.concat(t.peopleIds)), []
    only =
      email: 1
      imageURL: 1
      'github.gravatarId': 1
      'github.login': 1
      'location': 1
      'twit.screenName': 1
    Person.find _id: { $in: ids }, only, (err, people) ->
      return next err if err
      people = _.reduce people, ((h, p) -> h[p.id] = p; h), {}
      Team.count {}, (err, count) ->
        return next err if err
        teams.count = count
        res.render2 'teams', teams: teams, people: people, layout: !req.xhr

# new
app.get '/teams/new', (req, res, next) ->
  Team.canRegister (err, yeah) ->
    return next err if err
    if yeah
      team = new Team
      team.emails = [ req.user.github.email ] if req.loggedIn
      res.render2 'teams/new', team: team
    else
      res.render2 'teams/max'

# create
app.post '/teams', (req, res, next) ->
  team = new Team req.body
  team.save (err) ->
    return next err if err and err.name != 'ValidationError'
    if team.errors
      res.render2 'teams/new', team: team
    else
      req.session.team = team.code
      res.redirect "/teams/#{team.id}"

# show (join)
app.get '/teams/:id', [loadTeam, loadPeople, loadVotes], (req, res) ->
  req.session.invite = req.param('invite') if req.param('invite')
  res.render2 'teams/show'
    team: req.team
    people: req.people
    voting: app.enabled('voting')
    votes: []
    upvoted: !!(req.user && req.user.upvote)

# resend invitation
app.all '/teams/:id/invites/:inviteId', [loadTeam, ensureAccess], (req, res) ->
  req.team.invites.id(req.param('inviteId')).send(true)
  res.redirect "/teams/#{req.team.id}"

# edit
app.get '/teams/:id/edit', [loadTeam, ensureAccess, loadPeople], (req, res) ->
  res.render2 'teams/edit', team: req.team, people: req.people

# update
app.put '/teams/:id', [loadTeam, ensureAccess], (req, res, next) ->
  _.extend req.team, req.body
  req.team.save (err) ->
    return next err if err and err.name != 'ValidationError'
    if req.team.errors
      req.team.people (err, people) ->
        return next err if err
        res.render2 'teams/edit', team: req.team, people: people
    else
      res.redirect "/teams/#{req.team.id}"
  null

# delete
app.delete '/teams/:id', [loadTeam, ensureAccess], (req, res, next) ->
  req.team.remove (err) ->
    return next err if err
    res.redirect '/teams'

# upvote
app.post '/teams/:id/love', [loadTeam, ensureAuth], (req, res) ->
  teamId = req.team.id
  personId = req.user.id
  console.log( 'team'.cyan, teamId, 'voter'.cyan, personId, 'love'.red )
  Vote.findOne { type:'upvote', teamId: teamId, personId: personId }, (err, vote) ->
    console.log arguments
    return res.send 400 if err
    if not vote
      vote = new Vote
      vote.type = 'upvote'
      vote.personId = personId
      vote.teamId = teamId
    vote.love()
    vote.save (err) ->
      return res.send 400 if err
      res.send 'love'

# un-upvote
app.delete '/teams/:id/love', [loadTeam, ensureAuth], (req, res) ->
  console.log( 'team'.cyan, req.team.id, 'voter'.cyan, req.user.id, 'nolove'.red )
  Vote.findOne { type:'upvote', teamId: req.team.id, personId: req.user.id }, (err, vote) ->
    return res.send 400 if err
    vote.nolove()
    vote.save (err) ->
      return res.send 400 if err
      res.send 'nolove'

app.post '/teams/:code/deploys', [loadTeam], (req, res) ->
  console.log( 'team'.cyan, req.team.name, 'deployed'.green )
  body = req.body
  # TODO check where the request came from
  body.isProduction = false
  body.teamId = req.team.id
  delete body.code
  deploy = new Deploy body
  deploy.save ->
    res.send 'ok'
