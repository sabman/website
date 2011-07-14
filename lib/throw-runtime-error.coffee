util = require 'util'

throwRuntimeError = (obj) ->
  return unless obj?
  if obj instanceof Error
    e = obj
  else
    e = new Error util.inspect obj
    Error.captureStackTrace e, arguments.callee
  throw e

module.exports = throwRuntimeError
