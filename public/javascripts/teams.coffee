$ ->
  $('#page.teams').each ->
    $('ul.teams').infinitescroll
      navSelector: '.more'
      nextSelector: '.more a'
      itemSelector: 'ul.teams > li'
      debug: true
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
        $.post '/teams/'+team+'/nolove', ->
          $this.removeClass('loved')
      else
        $.post '/teams/'+team+'/love', ->
          $this.addClass('loved')

  $('#page.teams-edit').each ->
    $('a.scary', this).click ->
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
