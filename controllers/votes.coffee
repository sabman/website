app = require '../config/app'
m = require './middleware'
Vote = app.db.model 'Vote'

# upvote
app.post '/teams/:id/love', [m.loadTeam, m.ensureAuth], (req, res) ->
  teamId = req.team.id
  personId = req.user.id
  console.log( 'team'.cyan, teamId, 'voter'.cyan, personId, 'love'.red )
  Vote.findOne { type:'upvote', teamId: teamId, personId: personId }, (err, vote) ->
    console.log arguments
    return res.send 400 if err
    if not vote
      vote = new Vote
      vote.type = 'upvote'
      vote.personId = personId
      vote.teamId = teamId
    vote.love()
    vote.save (err) ->
      return res.send 400 if err
      res.send 'love'

# un-upvote
app.delete '/teams/:id/love', [m.loadTeam, m.ensureAuth], (req, res) ->
  console.log( 'team'.cyan, req.team.id, 'voter'.cyan, req.user.id, 'nolove'.red )
  Vote.findOne { type:'upvote', teamId: req.team.id, personId: req.user.id }, (err, vote) ->
    return res.send 400 if err
    vote.nolove()
    vote.save (err) ->
      return res.send 400 if err
      res.send 'nolove'
