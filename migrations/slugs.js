db.teams.find({}, {name: 1}).forEach(function(t) {
  var name = t.name
    , slug = generateSlug(name);
  if (slug === '' || slug.match(/^-+$/))
    print(slug, slug === '' ? '!!!' : '', name);
});

function generateSlug(s) {
  return s
    .toLowerCase()
    .replace(/[^-a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
    .substring(0, 63);
}
