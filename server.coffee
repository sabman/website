app = require './app'

# routes
app.get '/', (req, res) ->
  res.render('index');

for p in ['about', 'how-to-win', 'sponsors']
  app.get '/' + p, (req, res) ->
    res.render(p)

app.get '/auth/github', (req, res) ->
  req.authenticate ['github'], (error, authenticated) ->
    throw console.inspect(error) if error?

    if authenticated?
      res.end """
        <html>
          <h1>
            Hello github user:
            #{JSON.stringify(req.getAuthDetails().user)}
          </h1>
        </html>"""
    else
      res.end """
        <html>
          <h1>Github authentication failed :(</h1>
        </html>"""

# let 2010 routes redirect for a while
app.get /\/(.*)\//, (req, res, next) ->
  path = req.params[0]
  if /^(stylesheets|javascripts|images|fonts)/.test(path)
    next() # don't redirect for stylesheets and the like
  else
    res.redirect('http://2010.nodeknockout.com' + req.url, 301)

# websockets
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
