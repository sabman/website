$('#page.people-new form .role select, #page.people-edit form .role select')
  .live('change', ->
    $this = $ this
    $this.next('.technical').toggle($this.val() is 'judge'))
  .change()
