$ ->
  $('#page.teams').each ->
    $('ul.teams').infinitescroll
      navSelector: '.more'
      nextSelector: '.more a'
      itemSelector: 'ul.teams > li'
      loading:
        img: '/images/spinner.gif'
        msgText: ''
        speed: 50
        finished: (opts) -> opts.loading.msg.hide()
        finishedMsg: 'No more teams. :('

  $('#page.teams-show').each ->
    $(this).delegate '.invites a', 'click', (e) ->
      e.preventDefault()
      $t = $(this).hide()
      $n = $t.next().show().html 'sending&hellip;'
      $.post @href, ->
        $n.text('done').delay(500).fadeOut 'slow', -> $t.show()

    # initially disable any vote edit form
    $('form.vote[action^="/votes"]').each ->
      $('input, textarea', this).prop 'disabled', true
      $('.disabled', this).show()
      $('.enabled', this).hide()
      $('a.edit, a.cancel', this).click (e) ->
        e.preventDefault()
        $('.disabled, .enabled').toggle()
        $form = $(this).closest('form')
        $('input, textarea', $form).prop 'disabled', (i, d) -> !d
        $form[0].reset()

  $('#page.teams-edit').each ->
    $('a.pull', this).click ->
      li = $(this).closest('li')
      i = li.prevAll('li').length + 1
      li.html $('<input>',
        class: 'email'
        type: 'email'
        name: 'emails[]'
        placeholder: 'member' + i + '@example.com')
      false
