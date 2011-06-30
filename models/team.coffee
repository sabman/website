Backbone ?= require '../lib/backbone-mongo'
out = (exports ? this)

class out.Teams extends Backbone.Model
  name: 'teams' # for mongo
  url: -> @name

class out.Team extends Backbone.Model
  collection: out.Teams

  defaults:
    name: null
    invites: []
    member_ids: []

  initialize: ->
    @errors = []

  validate: (attrs) ->
    @errors.length = 0

    if ('name' of attrs) and not attrs.name
      @errors.push "Team name can't be blank"

    if 'emails' of attrs
      if attrs.emails.length
        @errors.push "At most 4 members allowed on a team" if attrs.emails.length > 4
      else
        @errors.push "Team must have at least one member"

    @errors.length

  emails: -> []
