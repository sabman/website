_ = require 'underscore'
app = require '../config/app'
Team = app.db.model 'Team'

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
app.get '/teams/:id', (req, res, next) ->
  req.session.invite = req.param('invite') if req.param('invite')
  Team.findById req.param('id'), (err, team) ->
    return next err if err
    return next() unless team
    team.people (err, people) ->
      return next err if err
      res.render2 'teams/show',
        team: team
        people: people

# resend invitation
app.all '/teams/:id/invite/:inviteId', (req, res, next) ->
  return res.redirect '/auth/github' unless req.loggedIn

  Team.findById req.param('id'), (err, team) ->
    return next err if err
    return next() unless team
    return res.send 401 unless team.includes(req.user, req.session.team)
    team.invites.id(req.param('inviteId')).send(true)
    res.redirect "/teams/#{team.id}"

# edit
app.get '/teams/:id/edit', (req, res, next) ->
  Team.findById req.param('id'), (err, team) ->
    return next err if err
    return next() unless team
    return res.send 401 unless team.includes(req.user, req.session.team)
    team.people (err, people) ->
      return next err if err
      res.render2 'teams/edit', team: team, people: people

# update
app.put '/teams/:id', (req, res, next) ->
  return res.redirect '/auth/github' unless req.loggedIn

  Team.findById req.param('id'), (err, team) ->
    return next err if err
    return next() unless team
    return res.send 401 unless team.includes(req.user, req.session.team)
    _.extend team, req.body
    team.save (err) ->
      return next err if err and err.name != 'ValidationError'
      if team.errors
        team.people (err, people) ->
          return next err if err
          res.render2 'teams/edit', team: team, people: people
      else
        res.redirect "/teams/#{team.id}"
  null
