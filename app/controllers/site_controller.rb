class SiteController < ApplicationController
  def index
    @buses = [
      {
        name: 'Alice',
        bus_no: '1'
      },
      {
        name: 'Bob',
        bus_no: '2'
      }
    ]
  end
end
