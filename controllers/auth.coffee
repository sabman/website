app = require '../config/app'

app.get '/auth/github', (req, res) ->
  req.authenticate ['github'], (error, authenticated) ->
    app.te error

    if authenticated
      res.render2 'auth/accepted', user: require('sys').inspect(req.getAuthDetails().user)
    else
      res.render2 'auth/denied'
