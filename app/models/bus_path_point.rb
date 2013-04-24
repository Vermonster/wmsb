class BusPathPoint
  attr_accessor :lat,
                :lng,
                :time,
                :heading

  alias :latitude :lat
  alias :longitude :lng

  def initialize(attributes)
    attributes.each do |attr, value|
      send("#{attr}=", value) if respond_to?(attr)
    end
  end

  def last_updated_at
    @last_updated_at ||= Time.zone.parse(time)
  end
end
