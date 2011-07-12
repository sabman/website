_ = require 'underscore'
app = require '../config/app'
Team = app.db.model 'Team'

# index
app.get '/teams', (req, res) ->
  Team.find (err, teams) ->
    res.render2 'teams', teams: teams

# new
app.get '/teams/new', (req, res) ->
  return res.redirect '/auth/github' unless req.loggedIn

  team = new Team people_ids: [ req.user.id ]
  team.emails = [ req.user.github.email ] if req.user.github.email?
  res.render2 'teams/new', team: team

# create
app.post '/teams', (req, res) ->
  return res.redirect '/teams/new' unless req.loggedIn

  team = new Team req.body
  team.people_ids.push req.user.id
  team.save (err) ->
    if err
      res.render2 'teams/new', team: team, errors: err.errors
    else
      res.redirect "/teams/#{team.id}"

# show
app.get '/teams/:id', (req, res, next) ->
  Team.findById req.params.id, (err, team) ->
    return next '404' unless team
    res.render2 'teams/show', team: team

# edit
app.get '/teams/:id/edit', (req, res, next) ->
  return res.redirect '/auth/github' unless req.loggedIn

  Team.findById req.params.id, (err, team) ->
    return next '404' unless team
    return next '401' unless team.includes req.user
    res.render2 'teams/edit', team: team

# update
app.put '/teams/:id', (req, res, next) ->
  return res.redirect '/auth/github' unless req.loggedIn

  Team.findById req.params.id, (err, team) ->
    return next '404' unless team
    return next '401' unless _.include team.people_ids, req.user.id
    _.extend team, req.body
    team.save (err) ->
      if err
        res.render2 'teams/edit', team: team, errors: err.errors
      else
        res.redirect "/teams/#{team.id}"
