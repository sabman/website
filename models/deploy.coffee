mongoose = require 'mongoose'
ObjectId = mongoose.Schema.ObjectId

DeploySchema = module.exports = new mongoose.Schema
  teamId:
    type: ObjectId
    index: true
    required: true
  hostname: String
  os: String
  remoteAddress: String
  platform: String

# associations
DeploySchema.method 'team', (callback) ->
  Team = mongoose.model 'Team'
  Team.findById @teamId, callback

# validations
DeploySchema.path('remoteAddress').validate (v) ->
  @platform =
    if inNetwork v, '72.2.126.0/23'
      'joyent'
    else if inNetwork v, '50.19.126.0/24' # TODO
      'heroku'
    else if inNetwork v, '96.126.12.0/24', '74.207.251.0/24'
      'linode'
  @platform?
, 'not production'

# callbacks
DeploySchema.post 'save', ->
  @team (err, team) =>
    throw err if err
    team.lastDeploy = @toObject()
    team.save()

Deploy = mongoose.model 'Deploy', DeploySchema

toBytes = (ip) ->
  [ a, b, c, d ] = ip.split '.'
  (a << 24 | b << 16 | c << 8 | d)

inNetwork = (ip, networks...) ->
  for network in networks
    [ network, netmask ] = network.split '/'
    netmask = 0x100000000 - (1 << 32 - netmask)
    return true if (toBytes(ip) & netmask) == (toBytes(network) & netmask)
  false
