#= require_self

#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views

window.Wmsb =
  Collections: {}
  Models: {}
  Views: {}

$ ->
  $canvas = $ '#map-canvas'
  $header = $ '#header'
  $footer = $ '.footer'

  parsePadding = ($el, side) ->
    parseInt($el.css("padding-#{side}"), 10)

  updateMapHeight = ->
    # 20px padding on the top and bottom of the footer is not taken into
    # account when using box-sizing: border-box
    $canvas.height $(window).height() - $header.height() - $footer.height() - parsePadding($header, 'top') - parsePadding($header, 'bottom') - parsePadding($footer, 'top') - parsePadding($footer, 'bottom')

  initialize = ->
    tmp = document.createElement 'div'
    text = document.getElementById('locations').innerHTML
    tmp.innerHTML = text

    assignments = new Wmsb.Collections.BusAssignments JSON.parse(tmp.innerHTML)
    view = new Wmsb.Views.MapView
      collection: assignments
      el: $ 'body'
    console.log assignments
    console.log 'after render it'

    if view.collection.current()?
      view.render()
    else
      view.renderMap()

  if $canvas.length
    $(window).on 'resize', updateMapHeight
    initialize()
    updateMapHeight()
