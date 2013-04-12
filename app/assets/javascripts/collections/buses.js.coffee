Wmsb.Collections.Buses = Backbone.Collection.extend
  url: '/buses'
  model: Wmsb.Models.Bus

  selected: ->
    @find (bus) ->
      bus.get('selected')

  getByBusNo: (bus_no) ->
    @find (bus) -> bus.get('bus_no') is bus_no
