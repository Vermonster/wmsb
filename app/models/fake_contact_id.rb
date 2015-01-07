class FakeContactId
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
end
