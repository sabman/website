db.teams.update({}, { $rename: { people_ids: 'peopleIds' } }, false, true);
db.votes.update({}, { $rename: { person_id: 'personId', team_id: 'teamId' } }, false, true);
db.people.update({}, { $rename: { twitter_name: 'twitterScreenName', image_url: 'imageURL' } }, false, true);
