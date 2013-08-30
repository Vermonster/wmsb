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

    response_body = Rails.cache.fetch(cache_key(:locations, bus_id), expires_in: 45, race_condition_ttl: 2) do
      response = connection.get('interface.php', params)
      response.success? ? response.body : nil
    end

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

    response_body = Rails.cache.fetch(cache_key(:history, bus_id), expires_in: 45, race_condition_ttl: 2) do
      response = connection.get('interface.php', params)
      response.success? ? response.body : nil
    end

    if !response_body.nil?
      response_attributes = JSON.parse(response_body)
      assets = response_attributes['pathevents']['assets']
      assets.nil? ? [] : assets[0]['events'].map { |event| BusPathPoint.new(event) }
    end
  end

  def self.default_params
    @default_params ||= {
      username: ENV['ZONAR_USERNAME'],
      password: ENV['ZONAR_PASSWORD'],
    }
  end

  def self.cache_key(namespace, bus_id)
    "zonar.#{namespace}.#{bus_id}"
  end

  private_class_method :default_params, :cache_key
end
