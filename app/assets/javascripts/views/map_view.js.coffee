templates =
  studentList: _.template """
<div class="header-info header-info-first student">
  <h4 class="small-text">Student:</h4>
  <div class="selected-student">
    <span class="name"><h2><%= currentStudentName %></h2></span>
    <span class="icon-down-dir"></span>
  </div>
  <ul class="student-names closed">
    <% collection.each(function(assignment) { %>
      <li class="student-name"><%= assignment.get("student_name") %></li>
    <% }) %>
  </ul>
</div>
<div class="header-info time">
  <h4 class="small-text">Last updated:</h4>
  <h2><%= lastUpdatedAt %></h2>
</div>
<div class="header-info bus-number">
  <h4 class="small-text">Bus number:</h4>
  <h2><%= busNumber %></h2>
</div>
<div class="header-info bus-destination">
  <h4 class="small-text">Destination:</h4>
  <h2><%= destination %></h2>
</div>
  """

Wmsb.Views.MapView = Backbone.View.extend
  events:
    'click .selected-student': 'toggleStudentList'
    'click .student-name': 'updateCurrentStudent'

  styles: [
    stylers: [
      { "saturation": -30 }
      { "lightness": 31 }
      { "weight": 0.4 }
      { "gamma": 0.78 }
      { "hue": "#3b97d3" }
    ]
  ]

  styledMap: ->
    new google.maps.StyledMapType @styles, name: 'Boston Public Schools'

  initialize: (options) ->
    @busView = @$('#bus-view')
    @mapEl  = document.getElementById 'map-canvas'

    @updateCurrentAssignment()

    @map = new google.maps.Map @mapEl, {
      center: @currentAssignment.get('latLng')
      zoom: 14
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      panControl: true
      zoomControl: true
    }
    @map.mapTypes.set 'wmsb', @styledMap()

    @listenTo @collection, 'reset', @rerender

    _.bindAll this

  updateCurrentAssignment: ->
    @currentAssignment = @collection.find (assignment) ->
      assignment.get('token') is cookie.get('current_assignment')

  render: ->
    @renderHeader()
    @renderMarker()

    unless @intervalID?
      @intervalID = setInterval @refreshLocations, 30000

  rerender: ->
    @updateCurrentAssignment()

    @renderHeader()

    @renderMarker()

  renderHeader: ->
    markup = templates.studentList
      lastUpdatedAt: @currentAssignment.get 'last_updated_at'
      busNumber: @currentAssignment.get 'bus_number'
      currentStudentName: @currentAssignment.get 'student_name'
      collection: @collection
      destination: @currentAssignment.get 'destination'
    @busView.html markup

  renderMarker: ->
    if @marker?
      @marker.setMap null

    center = @currentAssignment.get 'latLng'
    @marker = new google.maps.Marker
      position: center
      map: @map
      title: @currentAssignment.get 'student_name'
      icon: '/assets/bus-marker.png'

    @map.setCenter center

  toggleStudentList: ->
    @$('.student-names').toggleClass 'closed'
    @$('.icon-down-dir').toggleClass 'rotate'

  refreshLocations: ->
    @collection.fetch reset: true, cache: false

  updateCurrentStudent: (event) ->
    @currentAssignment = @collection.find (assignment) ->
      assignment.get('student_name') is event.target.innerHTML

    cookie.set 'current_assignment', @currentAssignment.get('token')

    @render()
