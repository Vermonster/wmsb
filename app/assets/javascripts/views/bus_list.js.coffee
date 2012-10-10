Wmsb.Views.BusList = Backbone.View.extend
  tagName: 'ul'

  initialize: (options) ->
    @children = []
    @buses = options.buses

  renderChild: (child) ->
    @children.push child
    @$el.append child.render().$el

  renderItem: (bus) ->
    @renderChild new Wmsb.Views.BusItem bus: bus

  render: ->
    @buses.forEach ((bus) -> @renderItem(bus)), @

    @

  leave: ->
    _.each @children, (child) -> child.remove()
    delete @children
    @remove()

