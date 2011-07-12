module.exports = (app) ->
  app.helpers
    gravatar_url: (person, size = 30) ->
      "http://gravatar.com/avatar/#{person.github.gravatarId}?s=#{size}"
