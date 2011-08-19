# unbind infinite scrolling on pjax
$(document).bind 'start.pjax', ->
  $('#page.teams ul.teams').data('infinitescroll')?.unbind()

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
    $('a[href="#instructions"]').click ->
      $('.instructions').slideToggle()
      false
    $('.platform')
      .addClass(-> $(this).attr('id'))
      .removeProp('id')
    $(window).hashchange (e) ->
      hash = location.hash || '#joyent'
      $('.platform')
        .hide()
        .filter(hash.replace('#', '.'))
          .show()
      $('ul.platforms a')
        .removeClass('selected')
        .filter('a[href="' + hash + '"]')
          .addClass('selected')
    .hashchange()

    $('input[type=range]').each ->
      $this = $(this)
      max = parseInt($this.attr('max'))
      $stars = $('<div class=stars>')
        .css(position: 'relative', display: 'inline-block')
      $empty = $('<div class=empty>').appendTo($stars)
      $filled = $('<div class=filled>').appendTo($stars)
      for [1..max]
        $empty.append('<img src="/images/star-empty.png">')
        $filled.append('<img src="/images/star-filled.png">')
      fill = (val=$this.val()) ->
        $filled.width($empty.width() * val / max)

      $stars.find('img')
        .css(cursor: 'pointer')
        .hover (e) ->
          return if $this.attr('disabled')
          if e.type is 'mouseenter'
            fill($(this).prevAll('img').length + 1)
          else fill()
        .click (e) ->
          return if $this.attr('disabled')
          $this.val($(this).prevAll('img').length + 1)
          fill()

      $this.hide().after($stars)
      $filled.css(position: 'absolute', top: 0, left: 0, overflow: 'hidden')
        .height($empty.height())
      fill()

    # initially disable any vote edit form
    $('form.vote[action^="/votes"]').each ->
      $(':input', this).prop 'disabled', true
      $('a.edit, a.cancel', this).click (e) ->
        e.preventDefault()
        $form = $(this).closest('form')
        $('.disabled, .enabled', $form).toggle()
        $form[0].reset()
        $('input, textarea', $form).prop 'disabled', (i, d) -> !d

  $('#page.teams-edit').each ->

    # show the delete box on load if the hash is delete
    if window.location.hash is '#delete'
      window.location.hash = ''
      $form = $('#inner form:first')
      pos = $form.position()
      $delete = $('form.delete').show()
      $delete.css
        left: pos.left + ($form.width() - $delete.outerWidth()) / 2
        top: pos.top

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
