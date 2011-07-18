app = require '../config/app'
Team = app.db.model 'Team'

# middleware
loadCurrentPersonWithTeam = (req, res, next) ->
  return next() unless req.loggedIn
  req.user.team (err, team) ->
    return next err if err
    req.team = team
    next()
loadCanRegister = (req, res, next) ->
  Team.canRegister (err, canRegister, left) ->
    return next err if err
    req.canRegister = canRegister
    req.teamsLeft = left
    next()

app.get '/', [loadCurrentPersonWithTeam, loadCanRegister], (req, res) ->
  res.render2 'index/index',
    team: req.team
    canRegister: req.canRegister
    teamsLeft: req.teamsLeft

['faq', 'how-to-win', 'locations', 'rules', 'sponsors', 'judging'].forEach (p) ->
  app.get '/' + p, (req, res) -> res.render2 "index/#{p}"
