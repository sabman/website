app = require '../config/app'

app.ws?.sockets.on 'connection', (client) ->
  client
    .on('message', (data) ->
      data = JSON.parse(data)
      data.id = client.id
      client.broadcast.send(JSON.stringify(data))
    ).on('disconnect', ->
      client.broadcast.send(
        JSON.stringify(id: client.id, disconnect: true))
    )
