app = require '../config/app'

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
