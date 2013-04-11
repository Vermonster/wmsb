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

    response = connection.get('interface.php', params)

    if response.success?
      response_attributes = Hash.from_xml(response.body)
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
  private_class_method :default_params
end
