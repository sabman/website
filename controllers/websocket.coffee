app = require '../config/app'

app.ws.on 'connection', (client) ->
  client
    .on('message', (data) ->
      data = JSON.parse(data)
      data.sessionId = client.sessionId

      app.ws.broadcast(JSON.stringify(data), client.sessionId)
    ).on('disconnect', ->
      app.ws.broadcast(
        JSON.stringify(sessionId: client.sessionId, disconnect: true))
    )
