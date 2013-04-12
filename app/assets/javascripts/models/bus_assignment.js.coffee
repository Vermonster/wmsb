Wmsb.Models.BusAssignment = Backbone.Model.extend
  initialize: (attributes) ->
    @set 'latLng', new google.maps.LatLng(@get('latitude'), @get('longitude'))
