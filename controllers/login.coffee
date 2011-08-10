app = require '../config/app'
{ ensureAuth, loadPerson, loadPersonTeam } = require './middleware'
Team = app.db.model 'Team'

app.get '/login', (req, res) ->
  req.session.returnTo = req.param('returnTo') or req.header('referrer')
  res.render2 'login'

app.get '/login/done', [ensureAuth, loadPerson, loadPersonTeam], (req, res, next) ->
  if invite = req.session.invite
    Team.findOne 'invites.code': invite, (err, team) ->
      return next err if err
      if team
        req.person.join team, invite
        req.person.save (err) ->
          return next err if err
          team.save (err) ->
            return next err if err
            delete req.session.invite
            res.redirect "/people/#{req.person.id}"
      else
        res.redirect '/teams/new'
  else if code = req.session.team
    Team.findOne code: code, (err, team) ->
      return next err if err
      if team
        res.redirect '/teams/' + team.id
      else
        delete req.session.team
        res.redirect '/teams/new'
  else if returnTo = req.session.returnTo
    delete req.session.returnTo
    res.redirect returnTo
  else if req.user.judge or req.user.nomination or req.team
    res.redirect returnTo or "/people/#{req.person.id}"
  else
    res.redirect '/teams/new'

# order matters
app.get '/login/:service?', (req, res, next) ->
  req.session.returnTo or= req.param('returnTo') or req.header('referrer')
  res.redirect "/auth/#{req.param('service') or 'github'}"
