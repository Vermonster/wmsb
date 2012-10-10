describe 'Wmsb.Views.BusList', ->
  describe '#render', ->
    beforeEach ->
      @bus = new Backbone.Model
      @buses = new Wmsb.Collections.Buses [@bus]
      @view = new Wmsb.Views.BusList buses: @buses

    it 'returns the view', ->
      expect(@view.render()).toBe @view

    it 'sets the html from template'

