mongoose = require 'mongoose'
rbytes = require 'rbytes'
util = require 'util'
env = require '../config/env'
postageapp = require('postageapp')(env.secrets.postageapp)
qs = require 'querystring'

InviteSchema = module.exports = new mongoose.Schema
  email: String
  sent:
    type: Boolean
    default: no
  code:
    type: String
    default: -> rbytes.randomBytes(12).toString('base64')

InviteSchema.method 'send', (force) ->
  if not @sent or force
    util.log "Sending 'teams_new' to '#{@email}'"
    team = @parentArray._parent
    postageapp.apiCall @email, 'teams_new', null, 'all@nodeknockout.com',
      team_id: team.id
      team_name: team.name
      invite_code: qs.escape @code
    @sent = yes

mongoose.model 'Invite', InviteSchema
