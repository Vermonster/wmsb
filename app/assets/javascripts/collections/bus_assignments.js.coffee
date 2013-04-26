Wmsb.Collections.BusAssignments = Backbone.Collection.extend
  url: '/buses'
  model: Wmsb.Models.BusAssignment

  current: ->
    @find (assignment) ->
      assignment.get('token') is cookie.get('current_assignment')
