Wmsb.Views.BusItem = Backbone.View.extend
  tagName: 'li'

  initialize: (options) ->
    @bus = options.bus

  render: ->
    @$el.append JST['bus_link']
      bus: @bus

    this


