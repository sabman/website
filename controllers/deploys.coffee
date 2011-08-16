_ = require 'underscore'
app = require '../config/app'
m = require './middleware'
util = require 'util'

Deploy = app.db.model 'Deploy'

# create (if anyone finds the team by code, they're authorized)
app.all '/teams/:code/deploys', [m.loadTeam], (req, res) ->
  util.log "#{'DEPLOY'.magenta} #{req.team.name} (#{req.team.id})"
  req.session.destroy()
  res.end 'ok'

  attr = _.clone req.body || {}
  attr.teamId = req.team.id
  attr.remoteAddress = req.socket.remoteAddress

  deploy = new Deploy attr
  deploy.save()
