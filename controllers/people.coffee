app = require '../config/app'
Person = app.db.model 'Person'

# index
app.get '/people', (req, res) ->
  Person.find (err, people) ->
    res.render2 'people', people: people

# show
app.get '/people/:id', (req, res, next) ->
  Person.findById req.params.id, (err, person) ->
    return next '404' unless person
    res.render2 'people/show', person: person

# edit
app.get '/people/:id/edit', (req, res, next) ->
  Person.findById req.params.id, (err, person) ->
    return next '404' unless person
    res.render2 'people/edit', person: person

# update
app.put '/people/:id', (req, res) ->
  Person.findById req.params.id, (err, person) ->
    _.extend person, req.body
    person.save (err) ->
      if err
        res.render2 'people/edit', person: person, errors: err.errors
      else
        res.redirect "/people/#{person.id}"
