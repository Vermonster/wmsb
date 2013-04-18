templates =
  studentList: _.template """
<div id="bus-view">
  <div class="student">
    <h4>Change student:</h4>
    <div class="selected-student">
      <%= currentStudentName %>
      <span class="icon-down-dir"></span>
    </div>
    <ul class="student-names closed">
      <% collection.each(function(assignment) { %>
        <li class="student-name"><%= assignment.get("student_name") %></li>
      <% }) %>
    </ul>
  </div>
  <div class="time">
    <h4>Last updated:</h4>
    <h2><%= lastUpdatedAt %></h2>
  </div>
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
    @header = @$('#header')
    @mapEl  = document.getElementById 'map-canvas'

    @updateCurrentAssignment()

    @map = new google.maps.Map @mapEl, {
      center: @currentAssignment.get('latLng')
      zoom: 14
      mapTypeControlOptions:
        mapTypeIds: ['map_style']
    }
    @map.mapTypes.set 'map_style', @styledMap()
    @map.setMapTypeId 'map_style'

    @listenTo @collection, 'reset', @rerender

    _.bindAll this

  updateCurrentAssignment: ->
    @currentAssignment = @collection.find (assignment) ->
      assignment.get('token') is cookie.get('current_assignment')

  render: ->
    @renderHeader()
    @renderMarker()

    unless @intervalID?
      @intervalID = setInterval @refreshLocations, 60000

  rerender: ->
    @updateCurrentAssignment()

    @renderHeader()

    @renderMarker()

  renderHeader: ->
    markup = templates.studentList
      lastUpdatedAt: @currentAssignment.get('last_updated_at')
      currentStudentName: @currentAssignment.get('student_name')
      collection: @collection
    @header.append markup

  renderMarker: ->
    if @marker?
      @marker.setMap null

    center = @currentAssignment.get 'latLng'
    @marker = new google.maps.Marker
      position: center
      map: @map
      title: @currentAssignment.get 'student_name'

    @map.setCenter center

  toggleStudentList: ->
    @$('.student-names').toggleClass 'closed'

  refreshLocations: ->
    @collection.fetch reset: true

  updateCurrentStudent: (event) ->
    @currentAssignment = @collection.find (assignment) ->
      assignment.get('student_name') is event.target.innerHTML

    cookie.set 'current_assignment', @currentAssignment.get('token')

    @render()
