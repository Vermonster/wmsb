module ApiStubbing
  class << self
    attr_reader :zonar_stubs, :contact_id_stubs, :assignment_search_stubs
  end

  def stub_zonar_api(response_body)
    stub_api(@zonar_stubs, '/interface.php', response_body)
  end

  def stub_contact_id_api(response_body)
    stub_api(@contact_id_stubs, '/bpswstr/Connect.svc/aspen_contact_id', response_body)
  end

  def stub_assignments_api(response_body)
    stub_api(@assignment_search_stubs, '/bpswstr/Connect.svc/bus_assignments', response_body)
  end

  def stub_api(stubs, url, response_body)
    stubs.get(url) { response_body }
  end

  def setup_api_stubs!
    @zonar_stubs             = Faraday::Adapter::Test::Stubs.new
    @contact_id_stubs        = Faraday::Adapter::Test::Stubs.new
    @assignment_search_stubs = Faraday::Adapter::Test::Stubs.new

    stub_connection(Zonar, @zonar_stubs)
    stub_connection(AssignmentSearch, @assignment_search_stubs)
    stub_connection(ContactId, @contact_id_stubs)
  end

  def stub_connection(klass, stubs)
    test_connection = Faraday.new do |builder|
      builder.adapter :test, stubs
    end

    klass.connection = test_connection
  end

  def teardown_api_stubs!
    Zonar.connection = AssignmentSearch.connection = ContactId.connection = nil
  end

  def bus_location_response(attributes = {})
    attributes.reverse_merge(
      bus_id: 'BUS',
      latitude: 42,
      longitude: -71
    )

    ERB.new(File.read('spec/support/templates/zonar_bus_location.erb')).result(binding)
  end
end
