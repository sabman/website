db.teams.find().forEach(function(t) {
  var locations = db.people.distinct('location', {_id: {'$in': t.peopleIds}})
    , logins = db.people.distinct('github.login', {_id: {'$in': t.peopleIds}})
    , s = t.name + '\n' +
         (t.description || '') + '\n' +
          logins.join(';') + '\n' +
          locations.join(';');
  print(t._id);
  db.teams.update({_id: t._id}, {$set: {search: s}});
});
