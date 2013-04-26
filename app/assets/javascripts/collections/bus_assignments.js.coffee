Wmsb.Collections.BusAssignments = Backbone.Collection.extend
  url: '/buses'
  model: Wmsb.Models.BusAssignment

  current: ->
    @_current ||= @find (assignment) ->
      assignment.get('token') is cookie.get('current_assignment')
