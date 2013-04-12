Wmsb.Collections.BusAssignments = Backbone.Collection.extend
  url: '/buses'
  model: Wmsb.Models.BusAssignment

  getByBusNo: (bus_no) ->
    @find (bus) -> bus.get('bus_no') is bus_no
