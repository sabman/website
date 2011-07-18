$('#page.teams-show .invites a').live 'click', (e) ->
  e.preventDefault()
  $t = $(this).hide()
  $n = $t.next().show().html 'sending&hellip;'
  $.post @href, ->
    $n.text('done').delay(500).fadeOut 'slow', -> $t.show()

$('#page.teams-show').each ->
  $('.heart').toggle ->
      $(this).addClass('loved')
    , ->
      $(this).removeClass('loved')

$('#page.teams-edit').each ->
  $('a.scary').click ->
    $this = $(this)
    pos = $this.position()
    form = $('form.delete')
    form
      .fadeIn('fast')
      .css
        left: pos.left + ($this.width() - form.outerWidth())/2
        top: pos.top + ($this.height() - form.outerHeight())/2
    false
  $('form.delete a').click ->
    $(this).closest('form').fadeOut('fast')
    false
