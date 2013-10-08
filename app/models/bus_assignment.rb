class BusAssignment
  include ActiveModel::SerializerSupport

  FAKE_ASSIGNMENT_REGEX = /^9\d{3}$/

  attr_accessor :BusNumber,
                :StudentNo,
                :parentfirstname,
                :parentlastname,
                :studentfirstname,
                :studentlastname,
                :days,
                :trip_flag

  alias :bus_number :BusNumber
  alias :student_number :StudentNo
  alias :parent_first_name :parentfirstname
  alias :parent_last_name :parentlastname
  alias :student_first_name :studentfirstname
  alias :student_last_name :studentlastname

  attr_reader :location, :history

  delegate :longitude, :latitude, :last_updated_at, to: :location

  def initialize(attributes, trip_flag)
    attributes.each do |attr, value|
      send("#{attr}=", value) if respond_to?(attr)
    end

    self.trip_flag = trip_flag

    if real_assignment?
      @history = Zonar.bus_history(bus_number)
      @location = @history.first || Zonar.bus_location(bus_number)
    end
  end

  def student_name
    "#{student_first_name} #{student_last_name}"
  end

  def real_assignment?
    !FAKE_ASSIGNMENT_REGEX.match(bus_number)
  end

  def gps_available?
    @location.present?
  end
end
