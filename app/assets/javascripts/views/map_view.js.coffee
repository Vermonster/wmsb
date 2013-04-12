Wmsb.Views.MapView = Backbone.View.extend
  initialize: (options) ->
    @listenTo @collection, 'reset', @updateMarker
    _.bindAll this

  render: ->
    center = new google.maps.LatLng 42, -71
    @map = new google.maps.Map this.el, {
      center: center
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }

    @updateMarker()

    @intervalID = setInterval @refreshLocations, 20000

  refreshLocations: ->
    @collection.fetch
      reset: true

  updateMarker: ->
    selected = @collection.selected()

    if @marker?
      @marker.setMap null

    @marker = new google.maps.Marker
      position: selected.get('latLng')
      map: @map
      title: selected.get('student_name')
