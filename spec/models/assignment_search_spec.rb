require 'spec_helper'

describe AssignmentSearch do
  describe '.find_assignments' do
    let(:sample_bus_assignments_response) do
      bus_assignment = bus_assignments_response(
        parentfirstname: 'Ned',
        parentlastname: 'Stark',
        studentfirstname: 'Arya',
        studentlastname: 'Stark'
      )

      [bus_assignment.stringify_keys].to_json
    end

    it 'returns the assignments belonging to the family identified by the credentials provided' do
      stub_assignments_api [200, {}, sample_bus_assignments_response]

      search = AssignmentSearch.find(123)

      search.assignments.should be_instance_of Array

      assignment = search.assignments.first

      assignment.parent_first_name.should eq 'Ned'
      assignment.parent_last_name.should eq 'Stark'
      assignment.student_first_name.should eq 'Arya'
      assignment.student_last_name.should eq 'Stark'
    end

    it 'handles errors retreiving assignments' do
      stub_assignments_api [500, {}, '']

      search = AssignmentSearch.find(123)

      search.assignments.should be_blank
      search.errors.should have_key :assignments

      # Ensure cache miss
      Rails.cache.fetch(search.send(:cache_key)).should be_nil
    end

    it 'caches the response body for 1 week' do
      stub_assignments_api [200, {}, sample_bus_assignments_response]

      AssignmentSearch.connection.should_receive(:get).twice.and_call_original

      AssignmentSearch.find(123)
      AssignmentSearch.find(123)

      Timecop.travel(12.hours.from_now)

      AssignmentSearch.find(123)
    end
  end
end
