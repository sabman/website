crypto = require 'crypto'
_ = require 'underscore'
markdown = require('markdown').parse

md5 = (str) ->
  hash = crypto.createHash 'md5'
  hash.update str
  hash.digest 'hex'

gravatar_url = (md5, size) ->
  "http://gravatar.com/avatar/#{md5}?s=#{size}&d=retro"

module.exports = (app) ->
  app.helpers
    inspect: require('util').inspect
    _: _
    markdown: (str) -> if str? then markdown(str) else ''
    avatar_url: (person, size = 30) ->
      if person.github?.gravatarId
        id = person.github.gravatarId # HACK getter bugs
        gravatar_url id, size
      else if person.imageURL
        person.imageURL
      else if person.email
        gravatar_url md5(person.email.trim().toLowerCase()), size
      else
        '/images/gravatar_fallback.png'
    sponsors: (fn) -> _.shuffle(sponsors).forEach fn
    locations: (people) ->
      _(people).chain()
        .pluck('location')
        .reduce((r, p) ->
          if p
            k = p.toLowerCase().replace(/\W.*/, '')
            r[k] = p if (!r[k] || r[k].length > p.length)
          r
        , {})
        .values()
        .value().join '; '

  app.dynamicHelpers
    session: (req, res) -> req.session
    req: (req, res) -> req
    title: (req, res) ->
      (title) ->
        req.pageTitle = title if title
        req.pageTitle
    admin: (req, res) -> req.user?.admin
    flash: (req, res) -> req.flash()
    canEdit: (req, res) ->
      (thing) ->
        if u = req.user
          u.admin or (u.id is thing.id)

sponsors = [
  [ 'adobe.png', 'http://www.adobe.com/' ]
  [ 'bislr.png', 'http://www.bislr.com/' ]
  [ 'geeklist.png', 'http://geekli.st/' ]
  [ 'github.png', 'https://github.com/' ]
  [ 'heroku.png', 'http://www.heroku.com/' ]
  [ 'joyent.png', 'http://www.joyent.com/' ]
  [ 'linode.png', 'http://www.linode.com/index.cfm' ]
  [ 'meebo.png', 'http://www.meebo.com/' ]
  [ 'mongohq.png', 'https://mongohq.com/home' ]
  [ 'nodejitsu.png', 'http://www.nodejitsu.com/' ]
  [ 'nodesocket.png', 'http://www.nodesocket.com/' ]
  [ 'postageapp.png', 'http://postageapp.com/' ]
  [ 'pubnub.png', 'http://www.pubnub.com/' ]
  [ 'pusher.png', 'http://pusher.com/' ]
  [ 'spreecast.png', 'http://spreecast.com/' ]
  [ 'summercamp.gif', 'http://www.nodeconf.com/summercamp.html' ]
  [ 'tradeking.png', 'http://www.tradeking.com/' ]
  [ 'twilio.png', 'http://www.twilio.com/' ]
]
