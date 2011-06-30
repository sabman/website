app = require '../config/app'
{ Team } = require '../models/team'

app.get '/teams/new', (req, res) ->
  res.render2 'teams/new', team: new Team

app.post '/teams', (req, res) ->
  team = new Team
  team.save req.body,
    success: -> res.redirect "/teams/#{team.id}"
    error: -> res.render2 'teams/new', team: team

app.get '/teams/:id', (req, res) ->
  team = new Team id: req.params.id
  team.fetch
    success: -> res.render2 'teams/show', team: team
    error: (e) -> app.te e
