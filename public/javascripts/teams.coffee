load = ->
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
    # re-send invites
    $(this).delegate '.invites a', 'click', (e) ->
      e.preventDefault()
      e.stopImmediatePropagation()
      $t = $(this).hide()
      $n = $t.next().show().html 'sending&hellip;'
      $.post @href, ->
        $n.text('done').delay(500).fadeOut 'slow', -> $t.show()

    # deploy instructions
    $('.platform')
      .addClass(-> $(this).attr('id'))
      .removeProp('id')
    $(window).hashchange (e) ->
      hash = location.hash
      hash = '#joyent' if not location.hash and $('.deploy-status.pending').length > 0
      $('.platform')
        .hide()
        .filter(hash.replace('#', '.'))
          .show()
      $('ul.platforms a')
        .removeClass('selected')
        .filter('a[href="' + hash + '"]')
          .addClass('selected')
    .hashchange()

    # initially disable any vote edit form
    $('form.vote[action^="/votes"]').each ->
      $(':input', this).prop 'disabled', true
      $('a.edit, a.cancel', this).click (e) ->
        e.preventDefault()
        $('.disabled, .enabled').toggle()
        $form = $(this).closest('form')
        $form[0].reset()
        $('input, textarea', $form).prop 'disabled', (i, d) -> !d

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

$(load)
$(document).bind 'end.pjax', load
