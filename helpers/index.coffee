inspect = require('util').inspect
crypto = require 'crypto'
markdown = require('markdown').parse

md5 = (str) ->
  hash = crypto.createHash 'md5'
  hash.update str
  hash.digest 'hex'

gravatar_url = (md5, size) ->
  "http://gravatar.com/avatar/#{md5}?s=#{size}&d=retro"

shuffle = (obj) ->
  shuffled = []
  obj.forEach (value, index, list) ->
    if index == 0
      shuffled[0] = value
    else
      rand = Math.floor(Math.random() * (index + 1))
      shuffled[index] = shuffled[rand]
      shuffled[rand] = value
  shuffled

sponsors = [
  [ 'adobe.png', 'http://www.adobe.com/' ]
  [ 'bislr.png', 'http://www.bislr.com/' ]
  [ 'github.png', 'https://github.com/' ]
  [ 'heroku.png', 'http://www.heroku.com/' ]
  [ 'joyent.png', 'http://www.joyent.com/' ]
  [ 'linode.png', 'http://www.linode.com/index.cfm' ]
  [ 'mongohq.png', 'https://mongohq.com/home' ]
  [ 'nodejitsu.png', 'http://www.nodejitsu.com/' ]
  [ 'nodesocket.png', 'http://www.nodesocket.com/' ]
  [ 'pusher.png', 'http://pusher.com/' ]
  [ 'spreecast.png', 'http://spreecast.com/' ]
  [ 'summercamp.gif', 'http://www.nodeconf.com/summercamp.html' ]
]

module.exports = (app) ->
  app.helpers
    avatar_url: (person, size = 30) ->
      if person.image_url?
        person.image_url
      else if person.github?.gravatarId?
        id = person.github.gravatarId # HACK getter bugs
        gravatar_url id, size
      else if person.email?
        gravatar_url md5(person.email.trim().toLowerCase()), size
      else
        '/images/gravatar_fallback.png'
    inspect: inspect
    markdown: (str) -> if str? then markdown(str) else ''
    sponsors: (fn) -> shuffle(sponsors).forEach fn

  app.dynamicHelpers
    session: (req, res) -> req.session
    req: (req, res) -> req
    title: (req, res) ->
      (title) ->
        req.pageTitle = title if title
        req.pageTitle
    admin: (req, res) -> req.user?.admin
    flash: (req, res) -> req.flash()
