app = require '../config/app'
Person = app.db.model 'Person'
Team = app.db.model 'Team'

ensureAuth = (req, res, next) ->
  return res.redirect '/login' unless req.loggedIn
  next()

module.exports =
  ensureAuth: ensureAuth

  ensureAccess: (req, res, next) ->
    ensureAuth req, res, ->
      return next 401 unless (req.user.id is req.person.id) or req.user.admin
      next()

  ensureAdmin: (req, res, next) ->
    ensureAuth req, res, ->
      return next 401 unless req.user.admin
      next()

  loadPerson: (req, res, next) ->
    if id = req.param('id')
      Person.findById id, (err, person) ->
        return next err if err
        return next 404 unless person
        req.person = person
        next()
    else
      req.person = req.user
      next()

  loadPersonTeam: (req, res, next) ->
    req.person.team (err, team) ->
      return next err if err
      req.team = team
      next()
