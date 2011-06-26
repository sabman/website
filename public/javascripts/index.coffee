$('#page.index-index #register').live 'click', (e) ->
  e.preventDefault()
  w = 600
  h = 420
  x = event.screenX - w / 2
  y = event.screenY - h / 2
  popup = window.open('/auth/github', 'login',
    "height=#{h},width=#{w},left=#{x},top=#{y}")
  popup.focus?()
