app = require '../config/app'
Team = require '../models/team'

app.get '/teams/new', (req, res) ->
  res.render2 'teams/new', team: new Team
