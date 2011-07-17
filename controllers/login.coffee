app = require '../config/app'

app.get '/login', (req, res, next) ->
  req.session.returnTo = req.header('referer')
  res.redirect '/auth/github'
