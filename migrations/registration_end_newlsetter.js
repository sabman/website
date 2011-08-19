db.teams.find({}).forEach(function(team) {
  db.people.find(
      { _id: { $in: team.peopleIds }
      , email: { $ne: null }}).forEach(function(person) {

    print([person.email, team._id].join(','));
  });
});
