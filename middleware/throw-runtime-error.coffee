util = require 'util'

class RuntimeError
  constructor: (@obj) ->
    @inspected = util.inspect obj
    Error.call this, @inspected
    @captureStackTrace arguments.callee

  log: ->
    util.debug "ERROR: #{@inspected}"
    console.trace()
    this
util.inherits RuntimeError, Error

throwRuntimeError = (obj) ->
  return unless obj?
  throw (new RuntimeError(obj)).log()

module.exports = throwRuntimeError
