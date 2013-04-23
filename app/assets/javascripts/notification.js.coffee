$ ->
  $notifications = $ '.notifications'
  $message = $notifications.find '.message'

  $notifications.on 'click', '.icon-cancel-circle', ->
    $notifications.addClass 'closed'

  Wmsb.notice = (message) ->
    $message.text message
    $notifications.removeClass 'closed'
