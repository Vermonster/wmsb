class ContactId
  extend ActiveModel::Naming

  class_attribute :connection, instance_writer: false
  self.connection = Faraday.new(ENV['BPS_API'])

  attr_reader :contact_id, :errors

  def self.find(credentials)
    new(credentials).find
  end

  def initialize(credentials)
    credentials.assert_valid_keys(:family_name, :student_number, :date_of_birth)

    @family_name    = credentials.fetch(:family_name)
    @student_number = credentials.fetch(:student_number)
    @date_of_birth  = credentials.fetch(:date_of_birth)

    @errors = ActiveModel::Errors.new(self)
  end

  def find
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
      @contact_id = ''
    elsif response.body !~ /\A"\d+"\z/
      # Verify the response is a number since we cannot validate it is proper
      # JSON
      @errors.add(:aspen_contact_id, "is not an integer (#{response.body})")
      @contact_id = ''
    else
      # The response is not a proper JSON object so JSON.parse('"000"') will
      # choke. Remove the quotes.
      @contact_id = response.body.gsub('"', '')
    end

    self
  end

  private

  def username
    ENV['BPS_USERNAME']
  end

  def password
    ENV['BPS_PASSWORD']
  end
end
