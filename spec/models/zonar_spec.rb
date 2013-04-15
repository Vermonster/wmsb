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

      # Ensure cache miss
      Rails.cache.fetch(Zonar.send(:cache_key, 'BUSID')).should be_nil
    end

    it 'caches bus locations for 60 seconds' do
      location = bus_location_response(
        bus_id: 'cacheme',
        latitude: 42,
        longitude: -71
      )

      stub_zonar_api [200, {}, location]
      Zonar.connection.should_receive(:get).twice.and_call_original

      Zonar.bus_location('cacheme')
      Zonar.bus_location('cacheme')

      Timecop.travel(60.seconds.from_now)

      Zonar.bus_location('cacheme')
    end
  end
end
