require 'colors'
inspect = require('util').inspect

module.exports = (mongo) ->
  executeCommand = mongo.Db.prototype.executeCommand

  commandName = (command) ->
    switch command.constructor
      when mongo.BaseCommand        then 'base'
      when mongo.DbCommand          then 'db'
      when mongo.DeleteCommand      then 'delete'
      when mongo.GetMoreCommand     then 'get_more'
      when mongo.InsertCommand      then 'insert'
      when mongo.KillCursorCommand  then 'kill_cursor'
      when mongo.QueryCommand       then 'query'
      when mongo.UpdateCommand      then 'update'

  mongo.Db.prototype.executeCommand = (db_command, options, callback) ->
    output = collection: db_command.collectionName
    output.query = db_command.query if db_command.query
    output.documents = db_command.documents if db_command.documents
    output.spec = db_command.spec if db_command.spec
    output.document = db_command.document if db_command.document
    output.selector = db_command.selector if db_command.selector
    output.skip = db_command.numberToSkip if db_command.numberToSkip
    output.limit = db_command.numberToReturn if db_command.numberToReturn
    console.log "#{commandName(db_command).underline}: #{inspect(output, null, 8)}".grey

    executeCommand.apply this, arguments

    ###
    ms = Date.now()
    executeCommand.call this, db_command, options, ->
      took = Date.now() - ms
      console.log inspect(output, null, 8) + ' ' + took + ' ms'
      callback = options if !callback && typeof(options) == 'function'
      callback.apply this, arguments if callback
    ###
