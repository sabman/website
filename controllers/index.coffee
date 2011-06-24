app = require '../config/app'

app.get '/', (req, res) ->
  res.render('index');

for p in ['about', 'how-to-win', 'sponsors']
  app.get '/' + p, (req, res) ->
    res.render(p)
