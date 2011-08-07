app = require '../config/app'
_ = require 'underscore'
m = require './middleware'
Vote = app.db.model 'Vote'

ensureVoting = (req, res, next) ->
  if app.enabled 'voting' then next() else next 401

# create
app.post '/teams/:teamId/votes', [ensureVoting, m.ensureAuth], (req, res, next) ->
  attr = _.clone req.body
  _.extend attr,
    personId: req.user.id
    teamId: req.params.teamId
    type: req.user.role
  vote = new Vote attr
  vote.save (err) ->
    return next err if err
    res.redirect '/teams/' + req.params.teamId

# update
app.put '/votes/:id', [ensureVoting, m.loadVote, m.ensureAccess], (req, res, next) ->
  delete req.body[attr] for attr in ['personId', 'teamId', 'type']
  _.extend req.vote, req.body
  req.vote.save (err) ->
    return next err if err
    res.redirect '/teams/' + req.vote.teamId

# delete
app.delete '/votes/:id', [ensureVoting, m.loadVote, m.ensureAccess], (req, res, next) ->
  req.vote.remove (err) ->
    return next err if err
    res.send 'ok'
