_ = require 'underscore'
app = require '../config/app'
Team = app.db.model 'Team'

# index
app.get '/teams', (req, res) ->
  Team.find (err, teams) ->
    app.te err
    res.render2 'teams', teams: teams

# new
app.get '/teams/new', (req, res) ->
  return res.redirect '/auth/github' unless req.loggedIn

  team = new Team people_ids: [ req.user.id ]
  team.emails = []
  team.people (err, people) ->
    app.te err
    res.render2 'teams/new', team: team, people: people

# create
app.post '/teams', (req, res) ->
  return res.redirect '/teams/new' unless req.loggedIn

  team = new Team req.body
  req.user.join team
  team.save (err) ->
    team.people (err2, people) ->
      if err
        res.render2 'teams/new',
          team: team
          people: people
          errors: err.errors
      else
        res.redirect "/teams/#{team.id}"

# show (join)
app.get '/teams/:id', (req, res, next) ->
  req.session.invite = req.param('invite') if req.param('invite')
  Team.findById req.param('id'), (err, team) ->
    return next '404' unless team
    team.people (err, people) ->
      app.te err
      res.render2 'teams/show',
        team: team
        people: people
        invite: req.session.invite

# resend invitation
app.all '/teams/:id/invite/:inviteId', (req, res, next) ->
  Team.findById req.param('id'), (err, team) ->
    app.te err
    return next '404' unless team
    return next '401' unless team.includes req.user
    team.invites.id(req.param('inviteId')).send(true)
    res.redirect "/teams/#{team.id}"

# edit
app.get '/teams/:id/edit', (req, res, next) ->
  return res.redirect '/auth/github' unless req.loggedIn

  Team.findById req.param('id'), (err, team) ->
    app.te err
    return next '404' unless team
    return next '401' unless team.includes req.user
    team.people (err, people) ->
      app.te err
      res.render2 'teams/edit', team: team, people: people

# update
app.put '/teams/:id', (req, res, next) ->
  return res.redirect '/auth/github' unless req.loggedIn

  Team.findById req.param('id'), (err, team) ->
    app.te err
    return next '404' unless team
    return next '401' unless team.includes req.user
    _.extend team, req.body
    team.save (err) ->
      if err
        res.render2 'teams/edit', team: team, errors: err.errors
      else
        res.redirect "/teams/#{team.id}"
  null
