Wmsb.Views.BusMap = Backbone.View.extend
  initialize: (options) ->
    @bus = options.bus

  render: ->
    @$el.html JST['bus_map'] bus: @bus

    this

  leave: -> @remove()
