app = require '../config/app'
Person = app.db.model 'Person'
Team = app.db.model 'Team'

# index
app.get '/people', (req, res) ->
  Person.find (err, people) ->
    app.te err
    res.render2 'people', people: people

app.get '/people/me', (req, res) ->
  Person.findById req.user.id, (err, person) ->
    app.te err
    return next '404' unless person
    person.team (err, team) ->
      app.te err
      if team
        res.redirect "/people/#{person.id}"
      else if invite = req.session.invite
        Team.findOne 'invites.code': invite, (err, team) ->
          if team
            req.user.join team, invite
            req.user.save (err) ->
              team.save (err) ->
                req.session.invite = null
                res.redirect "/people/#{person.id}"
          else
            res.redirect '/teams/new'
      else
        res.redirect '/teams/new'

# show
app.get '/people/:id', (req, res, next) ->
  Person.findById req.param('id'), (err, person) ->
    app.te err
    return next '404' unless person
    person.team (err, team) ->
      app.te err
      res.render2 'people/show', person: person, team: team

# edit
app.get '/people/:id/edit', (req, res, next) ->
  Person.findById req.param('id'), (err, person) ->
    app.te err
    return next '404' unless person
    res.render2 'people/edit', person: person

# update
app.put '/people/:id', (req, res) ->
  Person.findById req.param('id'), (err, person) ->
    app.te err
    _.extend person, req.body
    person.save (err) ->
      if err
        res.render2 'people/edit', person: person, errors: err.errors
      else
        res.redirect "/people/#{person.id}"
