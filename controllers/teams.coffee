_ = require 'underscore'
app = require '../config/app'
m = require './middleware'
[Person, Team, Vote] = (app.db.model s for s in ['Person', 'Team', 'Vote'])

# index
app.get /^\/teams(\/pending)?\/?$/, (req, res, next) ->
  page = (req.param('page') or 1) - 1
  query = if req.params[0] then { peopleIds: { $size: 0 } } else {}
  options = { sort: [['updatedAt', -1]], limit: 50, skip: 50 * page }
  # TODO move this join-thing into the Team model (see Vote <-> Person)
  Team.find query, {}, options, (err, teams) ->
    return next err if err
    ids = _.reduce teams, ((r, t) -> r.concat(t.peopleIds)), []
    only =
      email: 1
      imageURL: 1
      'github.gravatarId': 1
      'github.login': 1
      'location': 1
      'twit.screenName': 1
    Person.find _id: { $in: ids }, only, (err, people) ->
      return next err if err
      people = _.reduce people, ((h, p) -> h[p.id] = p; h), {}
      Team.count query, (err, count) ->
        return next err if err
        teams.count = count
        layout = req.header('x-pjax')? || !req.xhr
        res.render2 'teams', teams: teams, people: people, layout: layout

# new
app.get '/teams/new', (req, res, next) ->
  Team.canRegister (err, yeah) ->
    return next err if err
    if yeah
      team = new Team
      team.emails = [ req.user.github.email ] if req.loggedIn
      res.render2 'teams/new', team: team
    else
      res.render2 'teams/max'

# create
app.post '/teams', (req, res, next) ->
  team = new Team req.body
  team.save (err) ->
    return next err if err and err.name != 'ValidationError'
    if team.errors
      res.render2 'teams/new', team: team
    else
      req.session.team = team.code
      res.redirect "/teams/#{team.id}"

# show (join)
app.get '/teams/:id', [m.loadTeam, m.loadTeamPeople, m.loadTeamDeploys, m.loadTeamVotes, m.loadMyVote], (req, res) ->
  req.session.invite = req.param('invite') if req.param('invite')
  res.render2 'teams/show'
    team: req.team
    people: req.people
    deploys: req.deploys
    votes: req.votes
    vote: req.vote

# resend invitation
app.all '/teams/:id/invites/:inviteId', [m.loadTeam, m.ensureAccess], (req, res) ->
  req.team.invites.id(req.param('inviteId')).send(true)
  res.redirect "/teams/#{req.team.id}"

# edit
app.get '/teams/:id/edit', [m.loadTeam, m.ensureAccess, m.loadTeamPeople], (req, res) ->
  res.render2 'teams/edit', team: req.team, people: req.people

# update
app.put '/teams/:id', [m.loadTeam, m.ensureAccess], (req, res, next) ->
  _.extend req.team, req.body
  req.team.save (err) ->
    return next err if err and err.name != 'ValidationError'
    if req.team.errors
      req.team.people (err, people) ->
        return next err if err
        res.render2 'teams/edit', team: req.team, people: people
    else
      res.redirect "/teams/#{req.team.id}"
  null

# delete
app.delete '/teams/:id', [m.loadTeam, m.ensureAccess], (req, res, next) ->
  req.team.remove (err) ->
    return next err if err
    res.redirect '/teams'
