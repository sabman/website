app = require '../config/app'
{ Team } = require '../models/team'

# new
app.get '/teams/new', (req, res) ->
  res.render2 'teams/new', team: new Team

# create
app.post '/teams', (req, res) ->
  team = new Team
  team.save req.body,
    success: -> res.redirect "/teams/#{team.id}"
    error: -> res.render2 'teams/new', team: team

# show
app.get '/teams/:id', (req, res) ->
  team = new Team id: req.params.id
  team.fetch
    success: -> res.render2 'teams/show', team: team
    error: (e) -> next 'route' # 404

# edit
app.get '/teams/:id/edit', (req, res) ->
  team = new Team id: req.params.id
  team.fetch
    success: -> res.render2 'teams/edit', team: team
    error: (e) -> next 'route' # 404
