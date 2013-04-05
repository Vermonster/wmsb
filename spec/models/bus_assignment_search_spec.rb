require 'spec_helper'

describe BusAssignmentSearch do
  describe '.find_assignments' do
    it 'returns the assignments belonging to the family identified by the credentials provided' do
      sample_bus_assignments_response = attributes_for(:bus_assignment_response).stringify_keys

      stubs = Faraday::Adapter::Test::Stubs.new do |request|
        request.get('/bpswstr/Connect.svc/aspen_contact_id') { [200, {}, '"758294"'] }
        request.get('/bpswstr/Connect.svc/bus_assignments') { [200, {}, sample_bus_assignments_response.to_json] }
      end

      test_connection = Faraday.new do |builder|
        builder.adapter :test, stubs
      end

      BusAssignmentSearch.connection = test_connection

      search = BusAssignmentSearch.find_assignments(family_name: 'Stark', student_number: 1, date_of_birth: '10/30/2010')

      search.assignments.should eq sample_bus_assignments_response
    end

    it 'validates all the required keys are supplied' do
      expect { BusAssignmentSearch.find_assignments(last_name: 'Stark', dob: '10/30/2010') }.to raise_error
      expect { BusAssignmentSearch.find_assignments(family_name: 'Stark') }.to raise_error
    end

    it 'handles errors obtaining aspen_contact_id' do
      stubs = Faraday::Adapter::Test::Stubs.new do |request|
        request.get('/bpswstr/Connect.svc/aspen_contact_id') { [400, {}, '"758294"'] }
      end

      test_connection = Faraday.new do |builder|
        builder.adapter :test, stubs
      end

      BusAssignmentSearch.connection = test_connection

      search = BusAssignmentSearch.find_assignments(family_name: 'Stark', student_number: 1, date_of_birth: '10/30/2010')

      search.assignments.should be_blank
      search.errors.should have_key :aspen_contact_id
    end

    it 'handles errors retreiving assignments' do
      stubs = Faraday::Adapter::Test::Stubs.new do |request|
        request.get('/bpswstr/Connect.svc/aspen_contact_id') { [200, {}, '"758294"'] }
        request.get('/bpswstr/Connect.svc/bus_assignments') { [500, {}, ''] }
      end

      test_connection = Faraday.new do |builder|
        builder.adapter :test, stubs
      end

      BusAssignmentSearch.connection = test_connection

      search = BusAssignmentSearch.find_assignments(family_name: 'Stark', student_number: 1, date_of_birth: '10/30/2010')

      search.assignments.should be_blank
      search.errors.should have_key :assignments
    end

    it 'handles invalid (non-numeric) aspen_contact_ids' do
      stubs = Faraday::Adapter::Test::Stubs.new do |request|
        request.get('/bpswstr/Connect.svc/aspen_contact_id') { [200, {}, '"758a94"'] }
      end

      test_connection = Faraday.new do |builder|
        builder.adapter :test, stubs
      end

      BusAssignmentSearch.connection = test_connection

      search = BusAssignmentSearch.find_assignments(family_name: 'Stark', student_number: 1, date_of_birth: '10/30/2010')

      search.assignments.should be_blank
      search.errors.should have_key :aspen_contact_id
    end
  end
end
