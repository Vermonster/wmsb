class FakeAssignmentSearch
  def self.find(contact_id)
    new(contact_id).find
  end

  def initialize(contact_id)
    @contact_id = contact_id
  end

  def find
    FakeSearchResult.new
  end
end
