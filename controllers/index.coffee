app = require '../config/app'

app.get '/', (req, res) ->
  res.render2('index/index')

['about', 'how-to-win', 'sponsors'].forEach (p) ->
  app.get '/' + p, (req, res) ->
    res.render2('index/' +p)
