module ApiStubbing
  def stub_contact_id_api(&block)
    stubs, test_connection = stub_connection(&block)

    ContactId.connection = test_connection
    stubs
  end

  def stub_assignments_api(&block)
    stubs, test_connection = stub_connection(&block)

    AssignmentSearch.connection = test_connection
    stubs
  end

  def stub_zonar_api(&block)
    stubs, test_connection = stub_connection(&block)

    Zonar.stub(connection: test_connection)
    stubs
  end

  def stub_connection
    stubs = Faraday::Adapter::Test::Stubs.new do |request|
      yield request
    end

    test_connection = Faraday.new do |builder|
      builder.adapter :test, stubs
    end

    return [stubs, test_connection]
  end
end
