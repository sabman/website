inspect = require('util').inspect

module.exports = (mongo) ->
  executeCommand = mongo.Db.prototype.executeCommand
  BaseCommand = mongo.BaseCommand

  commandName = (command) ->
    switch command.getOpCode()
      when BaseCommand.OP_REPLY then 'reply'
      when BaseCommand.OP_MSG then 'msg'
      when BaseCommand.OP_UPDATE then 'update'
      when BaseCommand.OP_INSERT then 'insert'
      when BaseCommand.OP_GET_BY_OID then 'get_by_oid'
      when BaseCommand.OP_QUERY then 'query'
      when BaseCommand.OP_GET_MORE then 'get_more'
      when BaseCommand.OP_DELETE then 'delete'
      when BaseCommand.OP_KILL_CURSORS then 'kill_cursors'

  mongo.Db.prototype.executeCommand = (db_command, options, callback) ->
    output =
      collection: db_command.collectionName
      command: commandName db_command
    output.query = db_command.query if db_command.query
    output.documents = db_command.documents if db_command.documents
    output.spec = db_command.spec if db_command.spec
    output.document = db_command.document if db_command.document
    output.selector = db_command.selector if db_command.selector
    output.skip = db_command.numberToSkip if db_command.numberToSkip
    output.limit = db_command.numberToReturn if db_command.numberToReturn
    console.log inspect(output, null, 8)

    executeCommand.apply this, arguments

    ###
    ms = Date.now()
    executeCommand.call this, db_command, options, ->
      took = Date.now() - ms
      console.log inspect(output, null, 8) + ' ' + took + ' ms'
      callback = options if !callback && typeof(options) == 'function'
      callback.apply this, arguments if callback
    ###
