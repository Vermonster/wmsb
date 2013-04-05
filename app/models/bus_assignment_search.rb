class BusAssignmentSearch
  extend ActiveModel::Naming

  class_attribute :connection, instance_writer: false
  self.connection = Faraday.new(ENV['BPS_API'])

  attr_reader :assignments, :errors

  def self.find_assignments(credentials)
    new(credentials).find_assignments
  end

  def initialize(credentials)
    credentials.assert_valid_keys(:family_name, :student_number, :date_of_birth)

    @family_name    = credentials.fetch(:family_name)
    @student_number = credentials.fetch(:student_number)
    @date_of_birth  = credentials.fetch(:date_of_birth)

    @errors         = ActiveModel::Errors.new(self)
  end

  def find_assignments
    fetch_aspen_contact_id!

    if @aspen_contact_id.present?
      response = connection.get(
        '/bpswstr/Connect.svc/bus_assignments',
        aspen_contact_id: @aspen_contact_id,
        TripFlag: trip_flag,
        ForThisDate: current_date,
        UserName: username,
        Password: password
      )

      if response.success?
        @assignments = JSON.parse(response.body)
      else
        @errors.add(:assignments, "could not be retreived (#{response.status})")
      end
    end

    return self
  end

  private

  def fetch_aspen_contact_id!
    response = connection.get(
      '/bpswstr/Connect.svc/aspen_contact_id',
      last_name: @family_name,
      student_no: @student_number,
      dob: @date_of_birth,
      UserName: username,
      Password: password
    )

    if !response.success?
      @errors.add(:aspen_contact_id, "could not be retreived (#{response.status})")
      @aspen_contact_id = ''
    elsif response.body !~ /\A"\d+"\z/
      # Verify the response is a number since we cannot validate it is proper
      # JSON
      @errors.add(:aspen_contact_id, "is not an integer (#{@aspen_contact_id})")
      @aspen_contact_id = ''
    else
      # The response is not a proper JSON object so JSON.parse('"000"') will
      # choke. Remove the quotes.
      @aspen_contact_id = response.body.gsub('"', '')
    end
  end

  def trip_flag
    # FIXME: This needs to be conditionalized based on time of day?
    'arival'
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
