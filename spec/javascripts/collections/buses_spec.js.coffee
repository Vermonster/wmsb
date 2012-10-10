describe 'Wmsb.Collections.Buses', ->
  describe '#getByBusNo', ->
    beforeEach ->
      @bus = new Backbone.Model bus_no: 1
      @buses = new Wmsb.Collections.Buses [@bus]

    it 'is the member with the bus number', ->
      expect(@buses.getByBusNo 1).toBe @bus

    it 'is undefined if no member has the bus number', ->
      expect(@buses.getByBusNo 2).toBe undefined
