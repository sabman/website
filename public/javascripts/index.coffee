$ ->
  $('#page.index-index').each ->
    new nko.Thing name: 'livetree', pos: new nko.Vector(-60, 870)
    new nko.Thing name: 'deadtree', pos: new nko.Vector(0, 900)
    new nko.Thing name: 'portopotty', pos: new nko.Vector(80, 900)

  $('#page.how-to-win').each ->
    # slide-0 rules
    new nko.Thing name: 'streetlamp', pos: new nko.Vector(1900, 200)
    new nko.Thing name: 'livetree', pos: new nko.Vector(1800, 180)
    new nko.Thing name: 'livetree', pos: new nko.Vector(1700, 250)
    new nko.Thing name: 'livetree', pos: new nko.Vector(1850, 750)
    new nko.Thing name: 'arrowright', pos: new nko.Vector(2800, 100)

    # slide-1 audience
    new nko.Thing name: 'livetree', pos: new nko.Vector(2800, 780)
    new nko.Thing name: 'deadtree', pos: new nko.Vector(2900, 800)
    new nko.Thing name: 'chair', pos: new nko.Vector(3700, 220)
    new nko.Thing name: 'livetree', pos: new nko.Vector(3780, 190)
    new nko.Thing name: 'livetree', pos: new nko.Vector(3880, 290)
    new nko.Thing name: 'livetree', pos: new nko.Vector(3880, 1000)

    # slide-2 popularity
    new nko.Thing name: 'portopotty', pos: new nko.Vector(3200, 1600)
    new nko.Thing name: 'portopotty', pos: new nko.Vector(3260, 1600)
    new nko.Thing name: 'portopotty', pos: new nko.Vector(3340, 1600)
    new nko.Thing name: 'portopotty', pos: new nko.Vector(3410, 1600)
    new nko.Thing name: 'portopotty', pos: new nko.Vector(3470, 1610)
    new nko.Thing name: 'portopotty', pos: new nko.Vector(3600, 1600)
    new nko.Thing name: 'portopotty', pos: new nko.Vector(3700, 1600)
    new nko.Thing name: 'portopotty', pos: new nko.Vector(3780, 1600)
    new nko.Thing name: 'livetree', pos: new nko.Vector(3850, 1620)
    new nko.Thing name: 'arrowleft', pos: new nko.Vector(3100, 1580)

    # slide-3 plan
    new nko.Thing name: 'desk', pos: new nko.Vector(2371, 1115)
    new nko.Thing name: 'livetree', pos: new nko.Vector(2400, 1100)

    # slide-4 team
    new nko.Thing name: 'deadtree', pos: new nko.Vector(880, 900)
    new nko.Thing name: 'livetree', pos: new nko.Vector(800, 950)
    new nko.Thing name: 'livetree', pos: new nko.Vector(900, 1000)
    new nko.Thing name: 'hachiko', pos: new nko.Vector(840, 1080)
    new nko.Thing name: 'livetree', pos: new nko.Vector(750, 1500)

    # slide-5 no tests
    new nko.Thing name: 'obelisk', pos: new nko.Vector(890, 2100)
    new nko.Thing name: 'livetree', pos: new nko.Vector(1790, 2100)
    new nko.Thing name: 'livetree', pos: new nko.Vector(1700, 2300)
    new nko.Thing name: 'livetree', pos: new nko.Vector(1800, 2500)

    # slide-6 polish
    new nko.Thing name: 'deadtree', pos: new nko.Vector(800, 3200)
    new nko.Thing name: 'baretree', pos: new nko.Vector(900, 3500)
    new nko.Thing name: 'deadtree', pos: new nko.Vector(850, 3550)
    new nko.Thing name: 'livetree', pos: new nko.Vector(1900, 3800)

    # silde-7 chill
    new nko.Thing name: 'livetree', pos: new nko.Vector(1850, 2800)
    new nko.Thing name: 'tent', pos: new nko.Vector(2500, 3600)
    new nko.Thing name: 'livetree', pos: new nko.Vector(2850, 3500)
    new nko.Thing name: 'livetree', pos: new nko.Vector(2890, 3600)
    new nko.Dude name: 'fire', pos: new nko.Vector(2700, 3620)

    # slide-9 thanks
    new nko.Thing name: 'banner', pos: new nko.Vector(3610, 2060)
    new nko.Thing name: 'livetree', pos: new nko.Vector(3850, 2050)
    new nko.Thing name: 'americanflag', pos: new nko.Vector(3810, 2100)

    ###
    var slide = parseInt(location.hash.replace('#slide-', '')) || 0
    $(document).keylisten(function(e) {
      switch (e.keyName) {
        case 'alt+left':
          return nko.goTo('#slide-' + --slide)
        case 'alt+right':
          return nko.goTo('#slide-' + ++slide)
      }
    })
    ###

    $(window).load -> # center it
      nko.warpTo location.hash || '.slide'

    $('.slide').live 'click', ->
      $this = $(this)
      id = $(this).attr('id')
      $this.removeAttr('id')
      location.hash = '#' + id
      $this.attr('id', id)
