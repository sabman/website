Backbone = require '../middleware/backbone-mongo'

class Team extends Backbone.Model
  emails: -> []

module.exports = Team
