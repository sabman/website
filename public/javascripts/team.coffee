$('#page.teams-show .invites a').live 'click', (e) ->
  e.preventDefault()
  $t = $(this).hide()
  $n = $t.next().show().html 'sending&hellip;'
  $.post @href, ->
  	$n.text('done').delay(500).fadeOut 'slow', -> $t.show()