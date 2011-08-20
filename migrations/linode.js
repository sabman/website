// list for linode
var teams =
  db.teams.find({}, {name: 1, slug: 1, peopleIds: 1}).map(function(t) {
    t.emails = db.people.distinct('email', {_id: {$in: t.peopleIds}});
    delete t.peopleIds;
    return t;
  });

printjson(teams);
