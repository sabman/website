inspect = require('util').inspect

module.exports = (app) ->
  app.helpers
    gravatar_url: (person, size = 30) ->
      "http://gravatar.com/avatar/#{person.github.gravatarId}?s=#{size}"
    inspect: (obj) ->
      inspect obj

  app.dynamicHelpers
    session: (req, res) -> req.session
    req: (req, res) -> req
    title: (req, res) ->
      (title) ->
        req.pageTitle = title if title
        req.pageTitle
