_ = require 'underscore'
app = require '../config/app'
Team = app.db.model 'Team'

# middleware
loadTeam = (req, res, next) ->
  if id = req.param('id')
    Team.findById id, (err, team) ->
      return next err if err
      return res.send 404 unless team
      req.team = team
      next()
  else
    next()

loadPeople = (req, res, next) ->
  req.team.people (err, people) ->
    return next err if err
    req.people = people
    next()

ensureAccess = (req, res, next) ->
  return res.send 401 unless req.team.includes(req.user, req.session.team)
  next()

# index
app.get '/teams', (req, res, next) ->
  Team.find (err, teams) ->
    return next err if err
    res.render2 'teams', teams: teams

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
app.get '/teams/:id', [loadTeam, loadPeople], (req, res) ->
  req.session.invite = req.param('invite') if req.param('invite')
  res.render2 'teams/show', team: req.team, people: req.people

# resend invitation
app.all '/teams/:id/invite/:inviteId', [loadTeam, ensureAccess], (req, res) ->
  req.team.invites.id(req.param('inviteId')).send(true)
  res.redirect "/teams/#{req.team.id}"

# edit
app.get '/teams/:id/edit', [loadTeam, loadPeople, ensureAccess], (req, res) ->
  res.render2 'teams/edit', team: req.team, people: req.people

# update
app.put '/teams/:id', [loadTeam, ensureAccess], (req, res, next) ->
  _.extend req.team, req.body
  req.team.save (err) ->
    return next err if err and err.name != 'ValidationError'
    if req.team.errors
      req.team.people (err, people) ->
        return next err if err
        res.render2 'teams/edit', team: req.team, people: req.people
    else
      res.redirect "/teams/#{req.team.id}"
  null
