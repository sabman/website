if (typeof(_) === 'undefined')
  throw new Error('precede this with node_modules/underscore/underscore.js');

// grab all members
var members = db.teams.find({}, {peopleIds: 1});
members = members.map(function(t) { return t.peopleIds; });
members = _.flatten(members);
members = _.map(members, function(i) { return i.toString(); });

// find ones that don't exist anymore
var existing = db.people.distinct('_id');
existing = _.map(existing, function(i) { return i.toString(); });
var orphans = _.difference(members, existing);
orphans = _.map(orphans, function(s) { return ObjectId(s); });
print(orphans);

// remove them from their teams
db.teams.update({}, {$pullAll: {peopleIds: orphans}}, false, true);

// clean up empty teams
var empty = db.teams.find({peopleIds: {$size: 0}, invites: {$size: 0}});
empty.forEach(function(t) {
  db.teams.remove(t);
});
