_ = require 'underscore'
app = require '../config/app'
m = require './middleware'
util = require 'util'

Deploy = app.db.model 'Deploy'

return if app.disabled('deploys')

# create (if anyone finds the team by code, they're authorized)
app.all '/teams/:code/deploys', [m.loadTeam], (req, res, next) ->
  util.log "#{'DEPLOY'.green} #{req.team.name} (#{req.team.id})"
  req.session.destroy()

  attr = _.clone(req.body || {})
  attr.isProduction = false # TODO check where the request came from
  attr.teamId = req.team.id
  attr.remoteAddress = req.socket.remoteAddress
  delete attr.code

  deploy = new Deploy attr
  deploy.save -> res.send 'ok'
