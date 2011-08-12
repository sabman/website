app = require '../config/app'
Team = app.db.model 'Team'
Person = app.db.model 'Person'

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

['faq', 'how-to-win', 'locations', 'rules', 'sponsors'].forEach (p) ->
  app.get '/' + p, (req, res) -> res.render2 "index/#{p}"

app.get '/judging', (req, res) ->
  res.redirect '/judges/new'

app.get '/media', (req, res) ->
  Team.count {}, (err, teams) ->
    return next err if err
    Person.count { role: 'contestant' }, (err, people) ->
      return next err if err
      res.render2 'index/media',
        teams: teams - 1   # compensate for team fortnight
        people: people - 4
