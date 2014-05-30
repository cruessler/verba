initBootstrap: ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

$ ->
  initBootstrap()

window.bind 'page:change', ->
  initBootstrap()
