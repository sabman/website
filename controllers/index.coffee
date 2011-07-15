app = require '../config/app'
Person = app.db.model 'Person'

# middleware
loadCurrentPersonWithTeam = (req, res, next) ->
  return next() unless req.loggedIn
  req.user.team (err, team) ->
    app.te err
    req.team = team
    next()

app.get '/', [loadCurrentPersonWithTeam], (req, res) ->
  res.render2 'index/index', team: req.team

['about', 'how-to-win', 'locations', 'rules', 'sponsors'].forEach (p) ->
  app.get '/' + p, (req, res) -> res.render2 "index/#{p}"
