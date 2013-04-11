Wmsb.Views.MapView = Backbone.View.extend
  initialize: (options) ->
    @timeElapsed = 0
    @listenTo @collection, 'reset', @updateLocations

  render: ->
    center = new google.maps.LatLng 42, -71
    @map = new google.maps.Map this.el, {
      center: center
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }

    @insertMarkers()

  updateLocations: ->
    @markers.forEach (marker) =>
      marker.setMap null

    @markers.length = 0

    @insertMarkers()

  insertMarkers: ->

    @markers = @collection.map (location) =>
      position = new google.maps.LatLng location.get('latitude'), location.get('longitude')

      new google.maps.Marker
        position: position
        map: @map
        title: location.get('student_name')

    @timeout = setTimeout((=>
      @collection.fetch
        reset: true
    ), 20000)
