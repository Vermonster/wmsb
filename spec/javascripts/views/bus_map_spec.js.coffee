describe 'Wmsb.Views.BusMap', ->
  describe '#render', ->
    beforeEach ->
      @bus = new Backbone.Model
      @view = new Wmsb.Views.BusMap bus: @bus

    it 'returns the view', ->
      expect(@view.render()).toBe @view

    it 'sets the html from template'


