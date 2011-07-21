db.people.update(
  { twitter: { $ne: null }},
  { $rename: { twitter: 'twitter_name' }},
false, true);
