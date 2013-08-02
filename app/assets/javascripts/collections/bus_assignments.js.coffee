Wmsb.Collections.BusAssignments = Backbone.Collection.extend
  url: '/buses'
  model: Wmsb.Models.BusAssignment

  current: ->
    @find (assignment) ->
      assignment.get('token') is window.location.hash.substring(1)
