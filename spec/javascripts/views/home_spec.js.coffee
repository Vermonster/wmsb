describe 'Wmsb.Views.Home', ->
  beforeEach ->
    Wmsb.buses = new Wmsb.Collections.Buses

  afterEach ->
    delete Wmsb.buses

  describe '#render', ->
    beforeEach ->
      @bus = new Backbone.Model
      @view = new Wmsb.Views.BusMap bus: @bus

    it 'returns the view', ->
      expect(@view.render()).toBe @view

    it 'sets the html from template'



