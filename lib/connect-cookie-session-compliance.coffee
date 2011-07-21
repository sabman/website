noop = (fn) -> fn()

module.exports = (req, res, next) ->
  req.session.save = noop
  next()
