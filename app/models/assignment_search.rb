class AssignmentSearch
  extend ActiveModel::Naming

  class_attribute :connection, instance_writer: false
  self.connection = Faraday.new(ENV['BPS_API'])

  attr_reader :assignments, :errors

  def self.find(aspen_contact_id)
    new(aspen_contact_id).find
  end

  def initialize(aspen_contact_id)
    @aspen_contact_id = aspen_contact_id
    @errors           = ActiveModel::Errors.new(self)
  end

  def find
    response_body =  Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      response = connection.get(
        '/bpswstr/Connect.svc/bus_assignments',
        aspen_contact_id: @aspen_contact_id,
        TripFlag: trip_flag,
        ForThisDate: current_date,
        UserName: username,
        Password: password
      )

      if !response.success?
        @errors.add(:assignments, "could not be retreived (#{response.status})")
      end

      response.success? ? response.body : nil
    end

    if !response_body.nil?
      @assignments = JSON.parse(response_body).map do |assignment|
        BusAssignment.new(assignment)
      end
    end

    return self
  end

  private

  def cache_key
    "bps.assignments.#{@aspen_contact_id}.#{trip_flag}"
  end

  def trip_flag
    time_of_request.hour >= 11 ? 'departure' : 'arrival'
  end

  def current_date
    time_of_request.strftime('%D')
  end

  def time_of_request
    @time_of_request ||= Time.zone.now
  end

  def username
    ENV['BPS_USERNAME']
  end

  def password
    ENV['BPS_PASSWORD']
  end
end
