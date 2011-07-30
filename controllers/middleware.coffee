app = require '../config/app'
[Person, Team, Vote] = (app.db.model m for m in ['Person', 'Team', 'Vote'])

ensureAuth = (req, res, next) ->
  return res.redirect "/login?returnTo=#{encodeURIComponent(req.url)}" unless req.loggedIn
  next()

module.exports =
  ensureAuth: ensureAuth

  ensureAccess: (req, res, next) ->
    ensureAuth req, res, ->
      unless req.user.admin
        return next 401 if req.person? and req.person.id isnt req.user.id
        return next 401 if req.team? and not req.team.includes(req.user, req.session.team)
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

  loadTeam: (req, res, next) ->
    if id = req.params.id
      try
        Team.findById id, (err, team) ->
          return next err if err
          return next 404 unless team
          req.team = team
          next()
      catch error
        throw error unless error.message == 'Id cannot be longer than 12 bytes'
        return next 404
    else if code = req.params.code
      code = qs.unescape(code)
      Team.findOne code: code, (err, team) ->
        return next err if err
        return next 404 unless team
        req.team = team
        next()
    else
      next()

  loadTeamPeople: (req, res, next) ->
    req.team.people (err, people) ->
      return next err if err
      req.people = people
      next()

  loadVotes: (req, res, next) ->
    if (!app.enabled('voting') || !req.user)
      return next()
    Vote.findOne { type:'upvote', teamId: req.team.id, personId: req.user.id }, (err, vote) ->
      return next err if err
      req.user.upvote = vote.upvote if vote
      next()
