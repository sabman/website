inspect = require('util').inspect
crypto = require 'crypto'
markdown = require('markdown').parse

md5 = (str) ->
  hash = crypto.createHash 'md5'
  hash.update str
  hash.digest 'hex'

gravatar_url = (md5, size) ->
  "http://gravatar.com/avatar/#{md5}?s=#{size}&d=retro"

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

  app.dynamicHelpers
    session: (req, res) -> req.session
    req: (req, res) -> req
    title: (req, res) ->
      (title) ->
        req.pageTitle = title if title
        req.pageTitle
