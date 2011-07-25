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
    $('.invites a', this).live 'click', (e) ->
      e.preventDefault()
      $t = $(this).hide()
      $n = $t.next().show().html 'sending&hellip;'
      $.post @href, ->
        $n.text('done').delay(500).fadeOut 'slow', -> $t.show()

    $('.heart', this).live 'click', (e) ->
      e.preventDefault()
      $this = $(this)
      team = $this.attr('data-team')
      if $this.hasClass('loved')
        $.ajax
          url: '/teams/'+team+'/love'
          type: 'DELETE'
          success: -> $this.removeClass('loved')
      else
        $.post '/teams/'+team+'/love', ->
          $this.addClass('loved')

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
