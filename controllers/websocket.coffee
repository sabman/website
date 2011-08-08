util = require 'util'
app = require '../config/app'

app.ws?.sockets.on 'connection', (client) ->
  client.on 'message', (data) ->
    return if client.lastMessageAt && Date.now() - client.lastMessageAt < 200
    #console.log client.id, data.length, Date.now() - (client.lastMessageAt || 0)
    client.lastMessageAt = Date.now()
    data = JSON.parse(data)
    data.id = client.id
    client.broadcast.send JSON.stringify(data)
  client.on 'disconnect', ->
    client.broadcast.send JSON.stringify(id: client.id, disconnect: true)
