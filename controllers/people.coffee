_ = require 'underscore'
app = require '../config/app'
m = require './middleware'
Person = app.db.model 'Person'
Team = app.db.model 'Team'

# index
app.get '/people', (req, res, next) ->
  Person.find (err, people) ->
    return next err if err
    res.render2 'people', people: people

app.get '/people/me', [m.ensureAuth], (req, res, next) ->
  res.redirect "/people/#{req.user.id}"

# new
app.get '/people/new', [m.ensureAdmin], (req, res, next) ->
  res.render2 'people/new', person: new Person

# create
app.post '/people', [m.ensureAdmin], (req, res) ->
  person = new Person req.body
  person.save (err) ->
    if err
      res.render2 'people/new', person: person
    else
      res.redirect "people/#{person.id}"

# show
app.get '/people/:id', [m.loadPerson, m.loadPersonTeam], (req, res, next) ->
  res.render2 'people/show', person: req.person, team: req.team

# edit
app.get '/people/:id/edit', [m.loadPerson, m.ensureAccess], (req, res, next) ->
  res.render2 'people/edit', person: req.person

# update
app.put '/people/:id', [m.loadPerson, m.ensureAccess], (req, res) ->
  unless req.user.admin
    delete req.body[attr] for attr in ['role', 'admin', 'technical']
  else # FIXME
    req.body.admin = !!req.body.admin
    req.body.technical = !!req.body.technical
  _.extend req.person, req.body
  req.person.save (err) ->
    return next err if err && err.name != 'ValidationError'
    if req.person.errors
      res.render2 'people/edit', person: req.person
    else
      res.redirect "/people/#{req.person.id}"
