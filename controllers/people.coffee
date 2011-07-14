app = require '../config/app'
Person = app.db.model 'Person'
Team = app.db.model 'Team'

# middleware
ensureAuth = (req, res, next) ->
  return res.redirect '/auth/github' unless req.loggedIn
  next()

loadPerson = (req, res, next) ->
  uid = req.param('id') or req.user.id
  Person.findById uid, (err, person) ->
    app.te err
    return next '404' unless person
    req.person = person
    next()

loadTeam = (req, res, next) ->
  req.person.team (err, team) ->
    app.te err
    req.team = team
    next()

ensureAccess = (req, res, next) ->
  ensureAuth req, res, ->
    return next '401' unless req.person.id is req.user.id
    next()

# index
app.get '/people', (req, res) ->
  Person.find (err, people) ->
    app.te err
    res.render2 'people', people: people

app.get '/people/me', [ensureAuth, loadPerson, loadTeam], (req, res) ->
  if req.team
    res.redirect "/people/#{req.person.id}"
  else if invite = req.session.invite
    Team.findOne 'invites.code': invite, (err, team) ->
      if team
        req.user.join team, invite
        req.user.save (err) ->
          team.save (err) ->
            req.session.invite = null
            res.redirect "/people/#{req.person.id}"
      else
        res.redirect '/teams/new'
  else
    res.redirect '/teams/new'

# show
app.get '/people/:id', [loadPerson, loadTeam], (req, res, next) ->
  res.render2 'people/show', person: req.person, team: req.team

# edit
app.get '/people/:id/edit', [loadPerson, ensureAccess], (req, res, next) ->
  res.render2 'people/edit', person: req.person

# update
app.put '/people/:id', [loadPerson, ensureAccess], (req, res) ->
  _.extend req.person, req.body
  req.person.save (err) ->
    if err
      res.render2 'people/edit', person: req.person, errors: err.errors
    else
      res.redirect "/people/#{req.person.id}"
