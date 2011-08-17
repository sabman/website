load = ->
  # countdown
  $('time:first').each ->
    parts = $(this).attr('datetime').split(/[-:TZ]/)
    parts[1]--; # js dates :( js dates are hot dates.
    start = Date.UTC.apply null, parts

    $('#countdown').each ->
      $this = $(this)

      pluralize = (str, count) ->
        str + (if parseInt(count) != 1 then 's' else '')

      do tick = ->
        names = ['day', 'hour', 'minute', 'second']
        secs = (start - (new Date)) / 1000
        if secs > 0
          left = $.map([secs / 86400, secs % 86400 / 3600, secs % 3600 / 60, secs % 60], (num, i) -> [Math.floor(num), pluralize(names[i], num)]).join(' ')
          $this.text left + ' from now'
          setTimeout tick, 800
        else
          $this.html $('<h1>GOGOGOGOGOGO</h1>')

$(load)
$(document).bind 'end.pjax', load
