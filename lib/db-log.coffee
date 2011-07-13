inspect = require('util').inspect

module.exports = (Db) ->
  executeCommand = Db.prototype.executeCommand

  Db.prototype.executeCommand = (db_command, options, callback) ->
    output = { collection: db_command.collectionName }
    output.query = db_command.query if db_command.query
    output.spec = db_command.spec if db_command.spec
    output.document = db_command.document if db_command.document
    output.skip = db_command.numberToSkip if db_command.numberToSkip
    output.limit = db_command.numberToReturn if db_command.numberToReturn
    console.log inspect(output, null, 8)

    executeCommand.apply this, arguments
