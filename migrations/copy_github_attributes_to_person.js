db.people.find({ github: { $ne: null }}).forEach(function(doc) {
  doc.name || (doc.name = doc.github.name);
  doc.email || (doc.email = doc.github.email);
  doc.role || (doc.role = 'contestant');
  doc.company || (doc.company = doc.github.company);
  doc.location || (doc.location = doc.github.location);

  db.people.save(doc);
});
