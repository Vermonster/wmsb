Wmsb.Views.MapView = Backbone.View.extend
  events:
    'click a.student-name': 'updateCurrentStudent'

  initialize: (options) ->
    @currentStudent = @collection.selected()
    @mapEl    = document.getElementById('map-canvas')

    @listenTo @collection, 'reset', @updateMarker

    _.bindAll this

  render: ->
    center = new google.maps.LatLng 42, -71
    @map = new google.maps.Map @mapEl, {
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
    if @marker?
      @marker.setMap null

    @marker = new google.maps.Marker
      position: @currentStudent.get('latLng')
      map: @map
      title: @currentStudent.get('student_name')

  updateCurrentStudent: (event) ->
    @currentStudent.set 'selected', false
    @currentStudent = @collection.find (bus) ->
      bus.get('student_name') is event.target.text

    @currentStudent.set 'selected', true

    @updateMarker()
