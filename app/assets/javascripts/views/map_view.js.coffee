assignmentList = _.template """
<div class="header-info student">
  <h4 class="small-text">Student:</h4>
  <div class="selected-student">
    <h2 class="name"><%= current.escape("student_name") %></h2>
    <span class="icon-down-dir"></span>
  </div>
  <ul class="student-names closed">
    <% collection.each(function(assignment) { %>
      <li class="student-name"><%= assignment.get("student_name") %></li>
    <% }) %>
  </ul>
</div>
<div class="header-details">
  <div class="header-info time">
    <h4 class="small-text">Last updated:</h4>
    <h2><%= current.escape("last_updated_at") %></h2>
  </div>
  <div class="header-info bus-number">
    <h4 class="small-text">Bus number:</h4>
    <h2><%= current.escape("bus_number") %></h2>
  </div>
  <div class="header-info bus-destination">
    <h4 class="small-text">Destination:</h4>
    <h2><%= current.escape("destination") %></h2>
  </div>
</div>
  """

Wmsb.Views.MapView = Backbone.View.extend
  events:
    'click .selected-student': 'toggleAssignmentList'
    'click .student-name': 'changeSelectedAssignment'

  styles: [
    stylers: [
      { "saturation": -30 }
      { "lightness": 31 }
      { "weight": 0.4 }
      { "gamma": 0.78 }
      { "hue": "#3b97d3" }
    ]
  ]

  points: []

  styledMap: ->
    new google.maps.StyledMapType @styles, name: 'Boston Public Schools'

  initialize: (options) ->
    _.bindAll this

    @busView    = @$('#bus-view')
    @mapEl      = document.getElementById 'map-canvas'

    @listenTo @collection, 'reset', @render

  render: ->
    @renderMap() unless @map?

    @renderHeader()
    @renderMarker()

    @intervalID ||= setInterval @refreshAssignments, 30000

  renderMap: ->
    @map = new google.maps.Map @mapEl, {
      center: @collection.current().get('latLng')
      zoom: 14
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      panControl: true
      zoomControl: true
    }
    @map.mapTypes.set 'wmsb', @styledMap()

  renderHeader: ->
    markup = assignmentList
      current: @collection.current()
      collection: @collection
    @busView.html markup

  renderMarker: ->
    @marker?.setMap null

    if @points.length != 0
      _.each @points, (point) ->
        point.setMap null

      @points.length = 0

    _.each @collection.current().get('history'), (point) =>
      latLng = new google.maps.LatLng point.lat, point.lng

      point = new google.maps.Marker
        position: latLng
        icon: '/assets/dot.png'

      point.setMap @map
      @points.push point

    center = @collection.current().get 'latLng'
    @marker = new google.maps.Marker
      position: center
      map: @map
      title: @collection.current().get 'student_name'
      icon: '/assets/bus-marker.svg'
      zIndex: google.maps.Marker.MAX_ZINDEX

    @map.setCenter center

  toggleAssignmentList: ->
    @$('.student-names').toggleClass 'closed'
    @$('.icon-down-dir').toggleClass 'rotate'

  refreshAssignments: ->
    @collection.fetch
      reset: true
      cache: false
      error: (collection, response, options) ->
        if response.status == 401
          Wmsb.notice 'Your session has expired. You will be signed out shortly.'
          setTimeout (-> window.location.pathname = ''), 5000
        else if response.status != 0 # 0 is from a user-generated page refresh
          Wmsb.notice 'There was a problem updating the bus location. Refresh the page or sign in again.'

  changeSelectedAssignment: (event) ->
    assignment = @collection.find (assignment) ->
      assignment.get('student_name') is event.target.innerHTML

    cookie.set 'current_assignment', assignment.get('token')

    @render()
