Wmsb.Collections.Buses = Backbone.Collection.extend
  model: Wmsb.Models.Bus

  getByBusNo: (bus_no) ->
    _.find @models, (bus) -> bus.get('bus_no') is bus_no
