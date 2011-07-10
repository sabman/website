_ = require 'underscore'
app = require '../config/app'
Team = app.db.model 'Team'

# index
app.get '/teams', (req, res) ->
  Team.find (err, teams) ->
    res.render2 'teams', teams: teams

# new
app.get '/teams/new', (req, res) ->
  res.render2 'teams/new', team: new Team

# create
app.post '/teams', (req, res) ->
  team = new Team req.body
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
  Team.findById req.params.id, (err, team) ->
    return next '404' unless team
    res.render2 'teams/edit', team: team

# update
app.put '/teams/:id', (req, res) ->
  Team.findById req.params.id, (err, team) ->
    _.extend team, req.body
    team.save (err) ->
      if err
        res.render2 'teams/edit', team: team, errors: err.errors
      else
        res.redirect "/teams/#{team.id}"
