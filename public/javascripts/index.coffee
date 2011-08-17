load = ->
  # countdown
  $('time:first').each ->
    parts = $(this).attr('datetime').split(/[-:TZ]/)
    parts[1]--; # js dates :( js dates are hot dates.
    start = Date.UTC.apply null, parts

    $('#countdown').each ->
      $this = $(this)

      pluralize = (count, str) ->
        count + ' ' + str + (if parseInt(count) != 1 then 's ' else ' ')

      names = ['day', 'hour', 'minute', 'second']
      do tick = ->
        secs = (start - (new Date)) / 1000
        if secs > 0
          parts = [secs / 86400, secs % 86400 / 3600, secs % 3600 / 60, secs % 60]
          $this.html null
          $.each parts, (i, num) ->
            $this.append pluralize(Math.floor(num), names[i])
          $this.append 'from now'
          setTimeout tick, 800
        else
          $this.html $('<h1>GOGOGOGOGOGO</h1>')

$(load)
$(document).bind 'end.pjax', load
