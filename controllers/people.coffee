app = require '../config/app'
Person = app.db.model 'Person'
Team = app.db.model 'Team'

# middleware
ensureAuth = (req, res, next) ->
  return res.redirect '/auth/github' unless req.loggedIn
  next()

loadPerson = (req, res, next) ->
  if id = req.param('id')
    Person.findById id, (err, person) ->
      return next err if err
      return next 404 unless person
      req.person = person
      next()
  else
    req.person = req.user
    next()

loadTeam = (req, res, next) ->
  req.person.team (err, team) ->
    return next err if err
    req.team = team
    next()

ensureAccess = (req, res, next) ->
  ensureAuth req, res, ->
    return next 401 unless req.person.id is req.user.id
    next()

# index
app.get '/people', (req, res, next) ->
  Person.find (err, people) ->
    return next err if err
    res.render2 'people', people: people

app.get '/people/me', [ensureAuth, loadPerson, loadTeam], (req, res, next) ->
  if req.team
    res.redirect "/people/#{req.person.id}"
  else if invite = req.session.invite
    Team.findOne 'invites.code': invite, (err, team) ->
      if team
        req.person.join team, invite
        req.person.save (err) ->
          team.save (err) ->
            delete req.session.invite
            res.redirect "/people/#{req.person.id}"
      else
        res.redirect '/teams/new'
  else if code = req.session.team
    Team.findOne code: code, (err, team) ->
      return next err if err
      if team
        res.redirect '/teams/' + team.id
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
    return next err if err && err.name != 'ValidationError'
    if req.person.errors
      res.render2 'people/edit', person: req.person
    else
      res.redirect "/people/#{req.person.id}"
