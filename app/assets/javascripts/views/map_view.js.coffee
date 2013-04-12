Wmsb.Views.MapView = Backbone.View.extend
  initialize: (options) ->
    @listenTo @collection, 'reset', @updateMarker

  render: ->
    center = new google.maps.LatLng 42, -71
    @map = new google.maps.Map this.el, {
      center: center
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }

    @updateMarker()

  updateMarker: ->
    selected = @collection.selected()

    if @marker?
      @marker.setMap null

    @marker = new google.maps.Marker
      position: selected.get('latLng')
      map: @map
      title: selected.get('student_name')

    @timeout = setTimeout((=>
      @collection.fetch
        reset: true
    ), 20000)
