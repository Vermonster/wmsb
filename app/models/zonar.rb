module Zonar
  class << self
    attr_accessor :connection
  end

  self.connection = Faraday.new(ENV['ZONAR_API'])

  def self.bus_location(bus_id)
    params = default_params.merge(
      action: :showposition,
      type: :Standard,
      logvers: 3,
      operation: :current,
      format: :xml,
      reqtype: :fleet,
      target: bus_id
    )

    response_body = Rails.cache.fetch(cache_key(bus_id), expires_in: 45, race_condition_ttl: 2) do
      response = connection.get('interface.php', params)
      response.success? ? response.body : nil
    end

    if !response_body.nil?
      response_attributes = Hash.from_xml(response_body)
      attributes = response_attributes['currentlocations']['asset']
      BusLocation.new(attributes)
    end
  end

  def self.default_params
    @default_params ||= {
      username: ENV['ZONAR_USERNAME'],
      password: ENV['ZONAR_PASSWORD'],
    }
  end

  def self.cache_key(bus_id)
    "zonar.locations.#{bus_id}"
  end

  private_class_method :default_params, :cache_key
end
