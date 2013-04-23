#= require jquery
#= require jquery_ujs
#
#= require cookie
#= require json2
#
#= require underscore
#= require backbone
#
#= require wmsb

$ ->
  $canvas = $ '#map-canvas'
  $header = $ '#header'
  $footer = $ '.footer'

  $('.icon-cancel-circle').on 'click', ->
    $(this).parents('.notifications').hide()

  updateMapHeight = ->
    $canvas.height $(window).height() - $header.height() - $footer.height()

  initialize = ->
    tmp = document.createElement 'div'
    text = document.getElementById('locations').innerHTML
    tmp.innerHTML = text

    assignments = new Wmsb.Collections.BusAssignments JSON.parse(tmp.innerHTML)
    view = new Wmsb.Views.MapView
      collection: assignments
      el: $ 'body'

    view.render()

  if $canvas.length
    $(window).on 'resize', updateMapHeight
    initialize()
    updateMapHeight()
