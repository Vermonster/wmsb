require 'spec_helper'

describe Zonar do
  describe '.bus_location' do
    it 'parses xml response' do
      sample_bus_location = bus_location_response(
        bus_id: 'BUS1',
        latitude: 1,
        longitude: 2
      )

      stub_zonar_api [200, {}, sample_bus_location]

      location = Zonar.bus_location('BUSID')

      location.bus_id.should eq 'BUS1'
      location.latitude.should eq '1'
      location.longitude.should eq '2'
    end

    it 'returns nil if failed' do
      stub_zonar_api [400, {}, "{}"]

      Zonar.bus_location('BUSID').should be_nil
    end
  end
end
