class ContactId
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  class_attribute :connection, instance_writer: false
  self.connection = Faraday.new ENV['BPS_API'], ssl: {
    ca_file: Rails.root.join('lib', 'certs', 'SVRIntlG3.crt').to_s
  }

  attr_reader :contact_id, :errors, :family_name, :student_number

  validates :family_name, :student_number, :date_of_birth, presence: true

  def initialize(attributes = {})
    @attributes = attributes

    @family_name    = @attributes['family_name']
    @student_number = @attributes['student_number']

    @errors = ActiveModel::Errors.new(self)
  end

  def authenticate!
    response = connection.get(
      '/bpswstr/Connect.svc/aspen_contact_id',
      last_name: family_name,
      student_no: student_number,
      dob: formatted_date_of_birth,
      UserName: username,
      Password: password
    )

    if response.success?
      # The response is not a proper JSON object so JSON.parse('"000"') will
      # choke. Remove the quotes.
      @contact_id = response.body.gsub('"', '')
    else
      @errors.add(:aspen_contact_id, "could not be retreived (#{response.status})")
      @contact_id = ''
    end

    @contact_id.present?
  end

  def date_of_birth
    @date_of_birth ||= Time.zone.local(
      @attributes['date_of_birth(1i)'].to_i,
      @attributes['date_of_birth(2i)'].to_i,
      @attributes['date_of_birth(3i)'].to_i
    )
  rescue
    nil
  end

  def formatted_date_of_birth
    date_of_birth.strftime('%m/%d/%Y')
  end

  def persisted?
    false
  end

  private

  def username
    ENV['BPS_USERNAME']
  end

  def password
    ENV['BPS_PASSWORD']
  end
end
