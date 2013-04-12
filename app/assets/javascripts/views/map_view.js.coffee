Wmsb.Views.MapView = Backbone.View.extend
  events:
    'click a.student-name': 'updateCurrentStudent'

  initialize: (options) ->
    @mapEl             = document.getElementById 'map-canvas'
    @currentAssignment = @collection.find (assignment) ->
      assignment.get('token') is cookie.get('current_assignment')

    @listenTo @collection, 'reset', @updateMarker

    _.bindAll this

  render: ->
    @map = new google.maps.Map @mapEl, {
      center: @currentAssignment.get('latLng')
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }

    @updateMarker()

    @intervalID = setInterval @refreshLocations, 60000

  refreshLocations: ->
    @collection.fetch
      reset: true

  updateMarker: ->
    if @marker?
      @marker.setMap null

    center = @currentAssignment.get 'latLng'
    @marker = new google.maps.Marker
      position: center
      map: @map
      title: @currentAssignment.get 'student_name'

    @map.setCenter center

  updateCurrentStudent: (event) ->
    @currentAssignment = @collection.find (assignment) ->
      assignment.get('student_name') is event.target.text

    cookie.set 'current_assignment', @currentAssignment.get('token')

    @updateMarker()
