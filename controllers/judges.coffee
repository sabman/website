app = require '../config/app'
Person = app.db.model 'Person'

# index
app.get '/judges', (req, res, next) ->
  Person.find { role: 'judge' }, (err, judges) ->
    return next err if err
    res.render2 'judges', judges: judges

app.get '/judges/nominations', (req, res, next) ->
  Person.find { role: 'nomination' }, (err, judges) ->
    return next err if err
    res.render2 'judges/nominations', judges: judges

# new
app.get '/judges/new', (req, res, next) ->
  res.render2 'judges/new', person: new Person

# create
app.post '/judges', (req, res) ->
  # sanitize the body
  delete req.body[attr] for attr in ['admin', 'technical']
  req.body.role = 'nomination'

  judge = new Person req.body
  judge.save (err) ->
    if err
      res.render2 'judges/new', person: judge
    else
      req.flash 'info', """
        Thanks for nominating #{judge.name} as a judge.
        We will review and process him/her shortly."""
      res.redirect "people/#{judge.id}"
