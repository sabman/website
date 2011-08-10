$ ->
  # ensure csrf token is included in all ajax requests
  # from https://github.com/rails/jquery-ujs/blob/master/src/rails.js
  $.ajaxPrefilter (options, originalOptions, xhr) ->
    token = $('meta[name="_csrf"]').attr('content')
    xhr.setRequestHeader 'X-CSRF-Token', token

  $(':text:first').focus() # focus first input

  $('#page.teams-edit, #page.people-edit').each ->
    $('a.remove', this).click ->
      $this = $(this)
      pos = $this.position()
      form = $('form.delete')
      form
        .fadeIn('fast')
        .css
          left: pos.left + ($this.width() - form.outerWidth())/2
          top: pos.top + ($this.height() - form.outerHeight())/2
      false

    $('form.delete a', this).click ->
      $(this).closest('form').fadeOut('fast')
      false
