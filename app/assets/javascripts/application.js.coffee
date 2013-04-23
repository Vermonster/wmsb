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

  if $canvas.length
    $(window).on 'resize', updateMapHeight
    updateMapHeight()
