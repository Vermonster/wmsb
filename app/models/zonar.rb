module Zonar
  class << self
    attr_accessor :connection
    attr_accessor :default_params
  end

  self.connection = Faraday.new(ENV['ZONAR_API'])
  self.default_params = {
    username: ENV['ZONAR_USERNAME'],
    password: ENV['ZONAR_PASSWORD'],
  }

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

    response_body = cached_response(:locations, bus_id, params)

    if !response_body.nil?
      response_attributes = Hash.from_xml(response_body)
      attributes = response_attributes['currentlocations']['asset']

      if attributes.present?
        BusLocation.new(attributes)
      end
    end
  end

  def self.bus_history(bus_id)
    params = default_params.merge(
      action: :showposition,
      type: :Standard,
      version: 2,
      logvers: 3,
      operation: :path,
      format: :json,
      reqtype: :fleet,
      target: bus_id,
      starttime: 5.minutes.ago.to_i,
      endtime: Time.zone.now.to_i
    )

    response_body = cached_response(:history, bus_id, params)

    if response_body.present?
      response_attributes = JSON.parse(response_body)
      assets = response_attributes['pathevents']['assets']
      assets.nil? ? [] : assets[0]['events'].map { |event| BusPathPoint.new(event) }
    else
      []
    end
  end

  def self.cached_response(endpoint, bus_id, params)
    key = cache_key(endpoint, bus_id)

    Rails.cache.fetch(key, expires_in: 45, race_condition_ttl: 2) do
      response = connection.get('interface.php', params)
      response.success? ? response.body : nil
    end
  end

  def self.cache_key(namespace, bus_id)
    "zonar.#{namespace}.#{bus_id}"
  end

  private_class_method :default_params, :cache_key, :cached_response
end
