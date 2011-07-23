_ = module.exports = require 'underscore'

_.mixin
  shuffle: (array) ->
    shuffled = []
    _.each array, (value, index, list) ->
      if index == 0
        shuffled[0] = value
      else
        rand = Math.floor(Math.random() * (index + 1))
        shuffled[index] = shuffled[rand]
        shuffled[rand] = value
    shuffled
