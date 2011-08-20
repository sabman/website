db.people.find({ role: 'contestant' }).forEach(function(person) {
  print(person.email);
});
