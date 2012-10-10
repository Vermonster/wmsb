Wmsb.Views.Home = Backbone.View.extend
  events:
    'click a.bus' : 'busItemClicked'
    'click a.back': 'backClicked'

  backClicked: (event) ->
    @renderHome()
    false

  busItemClicked: (event) ->
    @renderMap "#{$(event.target).data 'bus-no'}"
    false

  swapChild: (child) ->
    @childView?.leave()
    @childView = child
    @$el.append child.render().$el

  renderMap: (bus_no) ->
    bus = Wmsb.buses.getByBusNo bus_no

    @$el.html ''
    @swapChild new Wmsb.Views.BusMap bus: bus

  renderHome: ->
    @$el.html JST['home']
    @swapChild new Wmsb.Views.BusList buses: Wmsb.buses

  render: ->
    @renderHome()
    
    @
