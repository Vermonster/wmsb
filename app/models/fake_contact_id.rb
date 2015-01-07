class FakeContactId
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  def initialize(params = {})
  end

  def valid?
    true
  end

  def authenticate!
    true
  end

  def contact_id
    'my_contact_id'
  end

  def student_number
    '1234567890'
  end

  def persisted?
    false
  end

  def family_name
    'Soprano'
  end

  def date_of_birth
    Time.now
  end
end
